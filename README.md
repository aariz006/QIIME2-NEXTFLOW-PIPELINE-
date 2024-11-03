
# QIIME2 Nextflow Pipeline

This repository contains a Nextflow pipeline for processing 16S rRNA paired-end sequencing data using QIIME2. The workflow includes data import, quality control, denoising, taxonomy classification, and visualization steps.

## Table of Contents
- [Installation](#installation)
- [Requirements](#requirements)
- [Usage](#usage)
- [Pipeline Structure](#pipeline-structure)
- [Parameters](#parameters)
- [Output](#output)
- [License](#license)

## Installation

1. Install [Nextflow](https://www.nextflow.io/docs/latest/getstarted.html).
2. Ensure [QIIME2](https://docs.qiime2.org) is installed and configured in your environment.

## Requirements

- Nextflow
- QIIME2
- A classifier trained on 16S rRNA sequences (e.g., Silva 138 99% classifier)

## Usage

To run the pipeline, clone the repository and execute the following command:

```bash
nextflow run main.nf --input "/path/to/fastq_directory" --classifier "/path/to/classifier.qza" --metadata "/path/to/metadata.tsv" --trunc_len_f <forward_read_length> --trunc_len_r <reverse_read_length>
