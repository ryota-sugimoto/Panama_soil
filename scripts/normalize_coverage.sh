#!/usr/bin/env bash
[ $# == 2 ] || { echo $0 '<fastq_1> <fastq_2>'; exit 1; }
[ -f ${1} ] || { echo "$1 not exist"; exit 1; }
[ -f ${2} ] || { echo "$2 not exist"; exit 1; }

bbmap_dir=/home/ryota/workspace/bbmap #TODO you must edit here

fastq_1=${1}
fastq_2=${2}

#adapter trim
trimmed_fastq_1=${1%.fastq}.trimmed.fastq
trimmed_fastq_2=${2%.fastq}.trimmed.fastq
trim_command=(${bbmap_dir}/bbduk.sh
               in1=${1}
               in2=${2}
               out1=${trimmed_fastq_1}
               out2=${trimmed_fastq_2}
               ftm=5
               ftl=10
               ref=${bbmap_dir}/resources/adapters.fa
               ktrim=r
               k=23
               mink=11
               hdist=1
               tpe
               tbo
               maq=10)
${trim_command[@]} || exit 1

#merge pair
merged_fastq=${1%_1.fastq}.merged.fastq
unmerged_fastq=${1%_1.fastq}.unmerged.fastq
insert_hist=${merged_fastq%.fastq}.hist.txt
merge_command=(${bbmap_dir}/bbmerge.sh
               in1=${trimmed_fastq_1}
               in2=${trimmed_fastq_2}
               out=${merged_fastq}
               outu=${unmerged_fastq}
               ihist=${insert_hist})
${merged_command[@]} || exit 1

#normalize coverage
normalized_fastq=${merged_fastq%.fastq}.normalized.fastq
normalize_command=(${bbmap_dir}/bbnorm.sh
                   in=${merged_fastq}
                   out=${normalized_fastq}
                   target=100
                   min=5)
${normalize_command[@]} || exit 1
