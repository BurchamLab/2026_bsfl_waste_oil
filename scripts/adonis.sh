# Made by Reese Saho to run ADONIS testing on the PCoAs generated during the biofuels

source /opt/anaconda3/etc/profile.d/conda.sh
conda activate /home/shared/conda_envs/qiime2-amplicon-2026.1

# Make directory listing

home="/home/shared/working/Burcham_UTK_Illumina_Data_20260318/"
core_metrics="$home/core_metrics_noinit_34k"

mkdir "/home/rsaho/rsaho/projects/bsf/biofuels/permdisp/"

# Run ADONIS and permdisp on DMs with and without the initial larvae

for matrix in "/home/shared/working/Burcham_UTK_Illumina_Data_20260318/core_metrics_noinit_34k/unweighted_unifrac_distance_matrix.qza" "/home/shared/working/Burcham_UTK_Illumina_Data_20260318/core_metrics_noinit_34k/weighted_unifrac_distance_matrix.qza" "/home/shared/working/Burcham_UTK_Illumina_Data_20260318/core_metrics_34k/weighted_unifrac_distance_matrix.qza" "/home/shared/working/Burcham_UTK_Illumina_Data_20260318/core_metrics_34k/unweighted_unifrac_distance_matrix.qza"; do

    if [ "$matrix" = "/home/shared/working/Burcham_UTK_Illumina_Data_20260318/core_metrics_34k/weighted_unifrac_distance_matrix.qza" ] || [ $matrix = "/home/shared/working/Burcham_UTK_Illumina_Data_20260318/core_metrics_noinit_34k/weighted_unifrac_distance_matrix.qza" ] ; then
        mat_name="weighted"

    else
        mat_name="unweighted"

    fi

    if [ "$matrix" = "/home/shared/working/Burcham_UTK_Illumina_Data_20260318/core_metrics_34k/weighted_unifrac_distance_matrix.qza" ] || [ $matrix = "/home/shared/working/Burcham_UTK_Illumina_Data_20260318/core_metrics_34k/unweighted_unifrac_distance_matrix.qza" ] ; then
        sam_name="il"

    else
        sam_name="no_il"
 
    fi


    for formula in "diet" "biocon_days_cat"; do

        qiime diversity adonis \
        --i-distance-matrix $matrix \
        --m-metadata-file "/home/rsaho/rsaho/projects/bsf/biofuels/metadata.txt" \
        --p-formula $formula \
        --o-visualization "/home/rsaho/rsaho/projects/bsf/biofuels/adonis/${mat_name}_${formula}_adonis.qzv"

        qiime diversity beta-group-significance \
        --i-distance-matrix $matrix \
        --m-metadata-file "/home/rsaho/rsaho/projects/bsf/biofuels/metadata.txt" \
        --m-metadata-column $formula \
        --p-method "permdisp" \
        --p-pairwise TRUE \
        --o-visualization "/home/rsaho/rsaho/projects/bsf/biofuels/permdisp/${mat_name}_${formula}_${sam_name}_permdisp.qzv"

        qiime diversity beta-group-significance \
        --i-distance-matrix $matrix \
        --m-metadata-file "/home/rsaho/rsaho/projects/bsf/biofuels/metadata.txt" \
        --m-metadata-column $formula \
        --p-method "permanova" \
        --p-pairwise TRUE \
        --o-visualization "/home/rsaho/rsaho/projects/bsf/biofuels/permdisp/${mat_name}_${formula}_${sam_name}_permanova.qzv"

    done

done
Run ADONIS on the distance matrices separated by day

for matrix in $core_metrics/d0/unweighted_unifrac_distance_matrix.qza $core_metrics/d0/weighted_unifrac_distance_matrix.qza $core_metrics/d2/unweighted_unifrac_distance_matrix.qza $core_metrics/d2/weighted_unifrac_distance_matrix.qza $core_metrics/d7/unweighted_unifrac_distance_matrix.qza $core_metrics/d7/weighted_unifrac_distance_matrix.qza; do

    if [[ "$matrix" = $core_metrics/d0/* ]] ; then
        day_name="d0"

    elif [[ "$matrix" = $core_metrics/d2/* ]] ; then
        day_name="d2"

    else
        day_name="d7"

    fi

    if [[ "$matrix" = $core_metrics/*/unweighted_unifrac_distance_matrix.qza ]] ; then
        mat_name="unweighted"

    else
        mat_name="weighted"

    fi

    qiime diversity adonis \
    --i-distance-matrix "$matrix" \
    --m-metadata-file "/home/rsaho/rsaho/projects/bsf/biofuels/metadata.txt" \
    --p-formula "bin_rep_diet + diet" \
    --o-visualization "/home/rsaho/rsaho/projects/bsf/biofuels/adonis/${day_name}_bin_diet_${mat_name}_adonis.qzv"

    qiime diversity adonis \
    --i-distance-matrix "$matrix" \
    --m-metadata-file "/home/rsaho/rsaho/projects/bsf/biofuels/metadata.txt" \
    --p-formula "diet + bin_rep_diet" \
    --o-visualization "/home/rsaho/rsaho/projects/bsf/biofuels/adonis/${day_name}_diet_bin_${mat_name}_adonis.qzv"

    qiime diversity adonis \
    --i-distance-matrix "$matrix" \
    --m-metadata-file "/home/rsaho/rsaho/projects/bsf/biofuels/metadata.txt" \
    --p-formula "bin_rep_diet" \
    --o-visualization "/home/rsaho/rsaho/projects/bsf/biofuels/adonis/${day_name}_bin_${mat_name}_adonis.qzv"

    qiime diversity adonis \
    --i-distance-matrix "$matrix" \
    --m-metadata-file "/home/rsaho/rsaho/projects/bsf/biofuels/metadata.txt" \
    --p-formula "diet" \
    --o-visualization "/home/rsaho/rsaho/projects/bsf/biofuels/adonis/${day_name}_diet_${mat_name}_adonis.qzv"

done

