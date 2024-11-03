# 16S rRNA Sequence Analysis Pipeline

This pipeline, built with [Nextflow](https://www.nextflow.io/), automates the analysis of 16S rRNA sequencing data using [QIIME 2](https://qiime2.org/). It performs a sequence import, quality control, taxonomic classification, and visualizations.

## Table of Contents

- [Requirements](#requirements)
- [Installation](#installation)
- [Pipeline Overview](#pipeline-overview)
- [Parameters](#parameters)
- [Usage](#usage)



---

## Requirements

- **Nextflow** (version 21.04 or later)
- **Docker** or **Singularity** (for containerized execution)
- **QIIME 2** (version 2024.5.0, pre-installed within containers)

## Installation

1. Clone this repository:
    ```bash
    git clone <repository-url>
    cd <repository-name>
    ```

2. Install [Nextflow](https://www.nextflow.io/docs/latest/getstarted.html) by running:
    ```bash
    curl -s https://get.nextflow.io | bash
    ```

3. Make sure Docker or Singularity is installed for running the QIIME 2 containers.

## Pipeline Overview

The pipeline performs the following steps:

1. **Import Casava-Formatted FASTQ**: Imports paired-end FASTQ files in the Casava format.
2. **Demultiplexing Summary**: Generates a summary of the demultiplexed data for quality assessment.
3. **DADA2 Denoising**: Removes noise, corrects sequencing errors, and generates feature tables.
4. **Feature Table Summarization**: Provides summaries for the feature table.
5. **Sequence Tabulation**: Lists all sequences found in the data.
6. **Taxonomy Classification**: Assigns taxonomy using a pre-trained classifier.
7. **Taxa Bar Plot**: Visualizes taxa composition across samples.

## Parameters

The parameters are set within the script or can be customized in the Nextflow command.

| Parameter       | Description                                     | Default |
|-----------------|-------------------------------------------------|---------|
| `casava_folder` | Path to Casava-formatted FASTQ data folder.     | Required |
| `metadata`      | Metadata file for samples                       | Required |
| `classifier`    | Path to the QIIME 2 trained classifier (.qza)   | Required |
| `trim_left_f`   | Bases to trim from the left of forward reads.   | 0       |
| `trim_left_r`   | Bases to trim from the left of reverse reads.   | 0       |
| `trunc_len_f`   | Length to truncate forward reads.               | 0       |
| `trunc_len_r`   | Length to truncate reverse reads.               | 0       |

## Usage

Run the pipeline using Nextflow as follows:

```bash
nextflow run main.nf \
    --casava_folder "/path/to/your/casava_folder" \
    --metadata "/path/to/metadata.tsv" \
    --classifier "/path/to/silva-138-99-nb-classifier.qza" \
    --trim_left_f 0 \
    --trim_left_r 0 \
    --trunc_len_f 0 \
    --trunc_len_r 0

