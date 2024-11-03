#!/usr/bin/env nextflow

nextflow.enable.dsl=2

params.input = '/home/aariz/nextflow/data/casava-18-paired-end-demultiplexed/'
params.classifier = '/home/aariz/nextflow/data/classifier/silva-138-99-nb-classifier.qza'
params.metadata = '/home/aariz/nextflow/data/metadata/metadata.tsv'
params.trunc_len_f = 0  // Truncation length for forward reads
params.trunc_len_r = 0  // Truncation length for reverse reads

process ImportData {
    input:
    path fastq_dir

    output:
    path 'demux-paired-end.qza', emit: demux

    script:
    """
    qiime tools import \
      --type 'SampleData[PairedEndSequencesWithQuality]' \
      --input-path $fastq_dir \
      --output-path demux-paired-end.qza \
      --input-format CasavaOneEightSingleLanePerSampleDirFmt
    """
}

process QualityControl {
    input:
    path demux

    output:
    path 'demuxed-seqs.qzv'

    script:
    """
    qiime demux summarize \
      --i-data $demux \
      --o-visualization demuxed-seqs.qzv
    """
}

process Denoise {
    input:
    path demux

    output:
    path 'table.qza', emit: table
    path 'rep-seqs.qza', emit: rep_seqs
    path 'denoising-stats.qza'

    script:
    """
    qiime dada2 denoise-paired \
      --i-demultiplexed-seqs $demux \
      --p-trunc-len-f ${params.trunc_len_f} \
      --p-trunc-len-r ${params.trunc_len_r} \
      --o-table table.qza \
      --o-representative-sequences rep-seqs.qza \
      --o-denoising-stats denoising-stats.qza
    """
}

process TaxonomyClassification {
    input:
    path rep_seqs
    path classifier

    output:
    path 'taxonomy.qza', emit: taxonomy

    script:
    """
    qiime feature-classifier classify-sklearn \
      --i-classifier $classifier \
      --i-reads $rep_seqs \
      --o-classification taxonomy.qza
    """
}

process TaxaBarplot {
    input:
    path table
    path taxonomy
    path metadata

    output:
    path 'taxa-barplot.qzv'

    script:
    """
    qiime taxa barplot \
      --i-table $table \
      --i-taxonomy $taxonomy \
      --m-metadata-file $metadata \
      --o-visualization taxa-barplot.qzv
    """
}

workflow {
    // Create channels from input files
    input_ch = Channel.fromPath(params.input)
    classifier_ch = Channel.fromPath(params.classifier)
    metadata_ch = Channel.fromPath(params.metadata)

    // Execute processes
    demux = ImportData(input_ch)
    quality_report = QualityControl(demux.demux)
    denoised_data = Denoise(demux.demux)
    taxonomy = TaxonomyClassification(denoised_data.rep_seqs, classifier_ch)
    barplot = TaxaBarplot(denoised_data.table, taxonomy.taxonomy, metadata_ch)
}
