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
  file=$(basename ${file_path})
  echo "Converting ${file}..." >> $output_log
  output_bam="${output_folder}/${file}"
  output_bai="${output_folder}/${file}.bai"
  output_bw="${output_folder}/${file}.bw"
  echo "Copying bam file..." >> output_log
  cp $file_path $output_bam
  echo "Creating index..." >> $output_log
  nice samtools index -M ${output_bam} -o ${output_bai} >> $output_log 2>&1
  echo "Converting to bw..." >> $output_log
  nice bamCoverage -b ${output_bam} -o ${output_bw} >> $output_log 2>&1
done

rm ${output_folder}/*.bam
rm ${output_folder}/*.bai
echo "idifazio"
