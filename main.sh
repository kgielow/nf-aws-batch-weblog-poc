#!/usr/bin/env bash

# Fail immediately, unset vars are errors
# https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
set -e
set -u

NXF_LOG_FILE="./logs/.nextflow.log" nextflow -C ./nextflow.config run -bucket-dir s3://nextflow-fargate-work/work -r v2.3 https://github.com/nextflow-io/rnaseq-nf
