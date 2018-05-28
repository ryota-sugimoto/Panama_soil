#!/usr/bin/env bash

work_dir=$(cd $(dirname $0)/../; pwd)

mkdir ${work_dir}/tools
pushd ${work_dir}/tools
wget https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/current/sratoolkit.current-ubuntu64.tar.gz
tar -zxf sratoolkit.current-ubuntu64.tar.gz
popd

mkdir -p ${work_dir}/plot_01/reads
pushd ${work_dir}/plot_01/reads
files=('SRR6942527' 'SRR6942529' 'SRR6942530' 'SRR6942531' 'SRR6942532')
for f in ${files[@]};
do
  ${work_dir}/tools/sratoolkit.2.9.0-ubuntu64/bin/fastq-dump ${f}
done
${work_dir}/tools/sratoolkit.2.9.0-ubuntu64/bin/fastq-dump \
  -I \
  --split-files \
  SRR6942528
popd

mkdir -p ${work_dir}/plot_36/reads
pushd ${work_dir}/plot_36/reads
files=('SRR6942476' 'SRR6942477' 'SRR6942478' 'SRR6942479' 'SRR6942480')
for f in ${files[@]};
do
  ${work_dir}/tools/sratoolkit.2.9.0-ubuntu64/bin/fastq-dump ${f}
done
${work_dir}/tools/sratoolkit.2.9.0-ubuntu64/bin/fastq-dump \
  -I \
  --split-files \
  SRR5215813
popd
