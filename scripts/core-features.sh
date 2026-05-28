# Made by Reese Saho to run a core features analysis on the day 0 BSFL biofuels samples. 05/12/2026

# Make the directory

mkdir -p /home/rsaho/rsaho/projects/bsf/biofuels/core_features

# Activate the conda environment

source /opt/anaconda3/etc/profile.d/conda.sh
conda activate /home/shared/conda_envs/qiime2-amplicon-2026.1

# Run the core features analysis

qiime feature-table core-features \
    --i-table /home/shared/working/Burcham_UTK_Illumina_Data_20260318/final_tables/day0_table.qza \
    --o-visualization /home/rsaho/rsaho/projects/bsf/biofuels/core_features/biofuels-core_features.qzv

qiime feature-table core-features \
    --i-table /home/shared/working/Burcham_UTK_Illumina_Data_20260318/final_tables/filtered_nocon_noinitial_decontam_table.qza \
    --o-visualization /home/rsaho/rsaho/projects/bsf/biofuels/core_features/biofuels-core_features_all_samples.qzv
