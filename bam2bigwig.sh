#!/usr/bin/env bash 
input_folder=$1
output_folder=$2
mkdir ${output_folder}

output_log="${output_folder}/log.txt"
touch ${output_log}

mamba create --name bam2bigwig deeptools samtools --yes >> $output_log 2>&1
source $(dirname $(dirname $(which mamba)))/etc/profile.d/conda.sh
conda activate bam2bigwig

input_files=$(ls ${input_folder}/*.bam)
for file_path in $input_files
do
  echo "Converting $(basename ${file_path})..." >> $output_log
  output_file="${output_folder}/$(basename ${file_path}).bw"
  echo "Creating index..." >> $output_log
  nice samtools index -M ${file_path} >> $output_log 2>&1
  echo "Converting to bw..." >> $output_log
  nice bamCoverage -b ${file_path} -o ${output_file} >> $output_log 2>&1
done

rm ${input_folder}/*.bai
echo "idifazio"
