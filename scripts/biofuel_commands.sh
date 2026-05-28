mkdir -p import denoise decontam rarefaction tree taxonomy final_tables

export PYTHONWARNINGS="ignore:pkg_resources is deprecated as an API:UserWarning"

# Run DADA2 on the seqs and visualize the data

qiime dada2 denoise-paired \
  --i-demultiplexed-seqs import/revb_revm_demux.qza \
  --p-trunc-len-f 240 \
  --p-trunc-len-r 240 \
  --p-n-threads 24 \
  --o-table denoise/dada2_table.qza \
  --o-representative-sequences denoise/dada2_rep_seqs.qza \
  --o-denoising-stats denoise/dada2_stats.qza \
  --o-base-transition-stats denoise/base-transition-stats.qza
  
qiime metadata tabulate \
  --m-input-file denoise/dada2_stats.qza  \
  --o-visualization denoise/dada2_stats.qzv

qiime feature-table summarize \
  --i-table denoise/dada2_table.qza \
  --o-feature-frequencies denoise/feature_frequencies.qza \
  --o-sample-frequencies denoise/sample_frequencies.qza \
  --o-summary denoise/table_summary.qzv

# Run decontam and remove features with a decontam score of 0.2 or higher and filter the rep seqs to match

qiime quality-control decontam-identify \
    --i-table denoise/dada2_table.qza \
    --m-metadata-file metadata.txt \
    --p-method prevalence \
    --p-prev-control-column control \
    --p-prev-control-indicator extraction \
    --o-decontam-scores decontam/decontam_scores.qza

qiime quality-control decontam-score-viz \
    --i-decontam-scores decontam/decontam_scores.qza \
    --i-table denoise/dada2_table.qza \
    --i-rep-seqs denoise/dada2_rep_seqs.qza \
    --p-threshold 0.2 \
    --p-bin-size 0.02 \
    --o-visualization decontam/decontam_scores.qzv

qiime feature-table filter-features \
    --i-table denoise/dada2_table.qza \
    --m-metadata-file decontam/decontam_scores.qza \
    --p-where '[p] >0.2 OR [p] IS NULL' \
    --o-filtered-table decontam/filtered_decontam_table.qza

qiime feature-table summarize \
  --i-table decontam/filtered_decontam_table.qza \
  --o-feature-frequencies decontam/feature_frequencies.qza \
  --o-sample-frequencies decontam/sample_frequencies.qza \
  --o-summary decontam/filtered_decontam_table_summary.qzv

qiime feature-table filter-seqs \
    --i-data denoise/dada2_rep_seqs.qza \
    --i-table decontam/filtered_decontam_table.qza \
    --o-filtered-data decontam/filtered_decontam_rep_seqs.qza

# Download the SILVA 128 database

wget -O "tree/sepp-refs-silva-128.qza" "https://data.qiime2.org/classifiers/sepp-ref-dbs/sepp-refs-silva-128.qza"

# Generate phylogenetic tree
qiime fragment-insertion sepp \
  --i-representative-sequences decontam/filtered_decontam_rep_seqs.qza \
  --i-reference-database tree/sepp-refs-silva-128.qza \
  --o-tree tree/tree.qza \
  --o-placements tree/tree_placements.qza \
  --p-threads 24

# Download the GreenGenes2 classifier

wget -O "taxonomy/2024.09.backbone.v4.nb.sklearn-1.4.2.qza" "https://data.qiime2.org/classifiers/sklearn-1.4.2/greengenes2/2024.09.backbone.v4.nb.sklearn-1.4.2.qza"

# Classify sequences
qiime feature-classifier classify-sklearn \
  --i-reads decontam/filtered_decontam_rep_seqs.qza \
  --i-classifier taxonomy/2024.09.backbone.v4.nb.sklearn-1.4.2.qza \
  --p-n-jobs 24 \
  --o-classification taxonomy/taxonomy.qza

qiime metadata tabulate \
  --m-input-file taxonomy/taxonomy.qza \
  --o-visualization taxonomy/taxonomy.qzv
  
qiime taxa barplot \
  --i-table decontam/filtered_decontam_table.qza \
  --i-taxonomy taxonomy/taxonomy.qza \
  --m-metadata-file metadata.txt \
  --o-visualization taxonomy/taxa-bar-plots.qzv

# Filter based on taxonomy
qiime taxa filter-table \
  --i-table decontam/filtered_decontam_table.qza \
  --i-taxonomy taxonomy/taxonomy.qza \
  --p-exclude mitochondria,chloroplast \
  --o-filtered-table taxonomy/tax_filtered_decontam_table.qza

qiime taxa barplot \
  --i-table taxonomy/tax_filtered_decontam_table.qza \
  --i-taxonomy taxonomy/taxonomy.qza \
  --m-metadata-file metadata.txt \
  --o-visualization taxonomy/taxa-bar-plots-no-mitochloro.qzv

qiime feature-table summarize \
  --i-table taxonomy/tax_filtered_decontam_table.qza \
  --o-feature-frequencies taxonomy/feature_frequencies.qza \
  --o-sample-frequencies taxonomy/sample_frequencies.qza \
  --o-summary taxonomy/tax_filtered_decontam_table_summary.qzv

# Generate a rarefaction curve at various depths

qiime diversity alpha-rarefaction \
  --i-table taxonomy/tax_filtered_decontam_table.qza \
  --m-metadata-file metadata.txt \
  --p-min-depth 10 \
  --p-max-depth 200000 \
  --o-visualization rarefaction/alpha_rarefaction_curves_200k.qzv

qiime diversity alpha-rarefaction \
  --i-table taxonomy/tax_filtered_decontam_table.qza \
  --m-metadata-file metadata.txt \
  --p-min-depth 10 \
  --p-max-depth 100000 \
  --o-visualization rarefaction/alpha_rarefaction_curves_100k.qzv

qiime diversity alpha-rarefaction \
  --i-table taxonomy/tax_filtered_decontam_table.qza \
  --m-metadata-file metadata.txt \
  --p-min-depth 10 \
  --p-max-depth 50000 \
  --o-visualization rarefaction/alpha_rarefaction_curves_50k.qzv

qiime feature-table filter-samples \
  --i-table taxonomy/tax_filtered_decontam_table.qza \
  --m-metadata-file metadata.txt \
  --p-where "[control]='no'" \
  --o-filtered-table final_tables/filtered_nocon_decontam_table.qza

qiime feature-table summarize \
  --i-table final_tables/filtered_nocon_decontam_table.qza \
  --o-feature-frequencies final_tables/feature_frequencies.qza \
  --o-sample-frequencies final_tables/sample_frequencies.qza \
  --o-summary final_tables/filtered_nocon_decontam_table.qzv

# Core metrics at 34k
qiime diversity core-metrics-phylogenetic \
    --i-table final_tables/filtered_nocon_decontam_table.qza \
    --i-phylogeny tree/tree.qza \
    --m-metadata-file metadata.txt \
    --p-sampling-depth 34000 \
    --output-dir core_metrics_34k

# Filter out neonate samples
qiime feature-table filter-samples \
  --i-table final_tables/filtered_nocon_decontam_table.qza \
  --m-metadata-file metadata.txt \
  --p-where "[diet]!='initial'" \
  --o-filtered-table final_tables/filtered_nocon_noinitial_decontam_table.qza

# core metrics at 34k with no neonate samples
qiime diversity core-metrics-phylogenetic \
    --i-table final_tables/filtered_nocon_noinitial_decontam_table.qza \
    --i-phylogeny tree/tree.qza \
    --m-metadata-file metadata.txt \
    --p-sampling-depth 34000 \
    --output-dir core_metrics_noinit_34k

# Custom axis for days
qiime emperor plot \
  --i-pcoa core_metrics_noinit_34k/unweighted_unifrac_pcoa_results.qza \
  --m-metadata-file metadata_noinit.txt \
  --p-custom-axes biocon_days_num \
  --o-visualization core_metrics_noinit_34k/unweighted_unifrac_emperor_by_day.qzv

qiime emperor plot \
  --i-pcoa core_metrics_noinit_34k/weighted_unifrac_pcoa_results.qza \
  --m-metadata-file metadata_noinit.txt \
  --p-custom-axes biocon_days_num \
  --o-visualization core_metrics_noinit_34k/weighted_unifrac_emperor_by_day.qzv

## Longitudinal tests
mkdir core_metrics_noinit_34k/longitudinal

## Pairwise difference comparisons at day 7
# Shannon
qiime longitudinal pairwise-differences \
  --m-metadata-file metadata.txt \
  --m-metadata-file core_metrics_noinit_34k/shannon_vector.qza \
  --p-metric shannon_entropy \
  --p-group-column diet \
  --p-state-column biocon_days_cat \
  --p-state-1 0 \
  --p-state-2 7 \
  --p-individual-id-column bin_rep \
  --p-replicate-handling random \
  --o-visualization core_metrics_noinit_34k/longitudinal/d7_shannon_pairwise_differences.qzv

# Richness
qiime longitudinal pairwise-differences \
  --m-metadata-file metadata.txt \
  --m-metadata-file core_metrics_noinit_34k/observed_features_vector.qza \
  --p-metric observed_features \
  --p-group-column diet \
  --p-state-column biocon_days_cat \
  --p-state-1 0 \
  --p-state-2 7 \
  --p-individual-id-column bin_rep \
  --p-replicate-handling random \
  --o-visualization core_metrics_noinit_34k/longitudinal/d7_observed_features_pairwise_differences.qzv

# Evenness
qiime longitudinal pairwise-differences \
  --m-metadata-file metadata.txt \
  --m-metadata-file core_metrics_noinit_34k/evenness_vector.qza \
  --p-metric pielou_evenness \
  --p-group-column diet \
  --p-state-column biocon_days_cat \
  --p-state-1 0 \
  --p-state-2 7 \
  --p-individual-id-column bin_rep \
  --p-replicate-handling random \
  --o-visualization core_metrics_noinit_34k/longitudinal/d7_evenness_pairwise_differences.qzv

# Faiths
qiime longitudinal pairwise-differences \
  --m-metadata-file metadata.txt \
  --m-metadata-file core_metrics_noinit_34k/faith_pd_vector.qza \
  --p-metric faith_pd \
  --p-group-column diet \
  --p-state-column biocon_days_cat \
  --p-state-1 0 \
  --p-state-2 7 \
  --p-individual-id-column bin_rep \
  --p-replicate-handling random \
  --o-visualization core_metrics_noinit_34k/longitudinal/d7_faith_pd_pairwise_differences.qzv

## Pairwise difference comparisons at day 2
# Shannon
qiime longitudinal pairwise-differences \
  --m-metadata-file metadata.txt \
  --m-metadata-file core_metrics_noinit_34k/shannon_vector.qza \
  --p-metric shannon_entropy \
  --p-group-column diet \
  --p-state-column biocon_days_cat \
  --p-state-1 0 \
  --p-state-2 2 \
  --p-individual-id-column bin_rep \
  --p-replicate-handling random \
  --o-visualization core_metrics_noinit_34k/longitudinal/d2_shannon_pairwise_differences.qzv

# Richness
qiime longitudinal pairwise-differences \
  --m-metadata-file metadata.txt \
  --m-metadata-file core_metrics_noinit_34k/observed_features_vector.qza \
  --p-metric observed_features \
  --p-group-column diet \
  --p-state-column biocon_days_cat \
  --p-state-1 0 \
  --p-state-2 2 \
  --p-individual-id-column bin_rep \
  --p-replicate-handling random \
  --o-visualization core_metrics_noinit_34k/longitudinal/d2_observed_features_pairwise_differences.qzv

# Evenness
qiime longitudinal pairwise-differences \
  --m-metadata-file metadata.txt \
  --m-metadata-file core_metrics_noinit_34k/evenness_vector.qza \
  --p-metric pielou_evenness \
  --p-group-column diet \
  --p-state-column biocon_days_cat \
  --p-state-1 0 \
  --p-state-2 2 \
  --p-individual-id-column bin_rep \
  --p-replicate-handling random \
  --o-visualization core_metrics_noinit_34k/longitudinal/d2_evenness_pairwise_differences.qzv

# Faiths
qiime longitudinal pairwise-differences \
  --m-metadata-file metadata.txt \
  --m-metadata-file core_metrics_noinit_34k/faith_pd_vector.qza \
  --p-metric faith_pd \
  --p-group-column diet \
  --p-state-column biocon_days_cat \
  --p-state-1 0 \
  --p-state-2 2 \
  --p-individual-id-column bin_rep \
  --p-replicate-handling random \
  --o-visualization core_metrics_noinit_34k/longitudinal/d2_faith_pd_pairwise_differences.qzv

## LME
# Richness
qiime longitudinal linear-mixed-effects \
  --m-metadata-file metadata.txt \
  --m-metadata-file core_metrics_noinit_34k/observed_features_vector.qza \
  --p-metric observed_features \
  --p-group-columns diet \
  --p-state-column biocon_days_num \
  --p-individual-id-column bin_rep \
  --o-visualization core_metrics_noinit_34k/longitudinal/observed_features-linear-mixed-effects.qzv

# Shannon
qiime longitudinal linear-mixed-effects \
  --m-metadata-file metadata.txt \
  --m-metadata-file core_metrics_noinit_34k/shannon_vector.qza \
  --p-metric shannon_entropy \
  --p-group-columns diet \
  --p-state-column biocon_days_num \
  --p-individual-id-column bin_rep \
  --o-visualization core_metrics_noinit_34k/longitudinal/shannon-linear-mixed-effects.qzv

# Evenness
qiime longitudinal linear-mixed-effects \
  --m-metadata-file metadata.txt \
  --m-metadata-file core_metrics_noinit_34k/evenness_vector.qza \
  --p-metric pielou_evenness \
  --p-group-columns diet \
  --p-state-column biocon_days_num \
  --p-individual-id-column bin_rep \
  --o-visualization core_metrics_noinit_34k/longitudinal/evenness-linear-mixed-effects.qzv

# Faith
qiime longitudinal linear-mixed-effects \
  --m-metadata-file metadata.txt \
  --m-metadata-file core_metrics_noinit_34k/faith_pd_vector.qza \
  --p-metric faith_pd \
  --p-group-columns diet \
  --p-state-column biocon_days_num \
  --p-individual-id-column bin_rep \
  --o-visualization core_metrics_noinit_34k/longitudinal/faith_pd-linear-mixed-effects.qzv

## Volatiity
# Faith
qiime longitudinal volatility \
  --m-metadata-file metadata.txt \
  --m-metadata-file core_metrics_noinit_34k/faith_pd_vector.qza \
  --p-default-metric faith_pd \
  --p-default-group-column diet \
  --p-state-column biocon_days_num \
  --p-individual-id-column bin_rep \
  --o-visualization core_metrics_noinit_34k/longitudinal/faith_pd-volatility.qzv

# Evenness
qiime longitudinal volatility \
  --m-metadata-file metadata.txt \
  --m-metadata-file core_metrics_noinit_34k/evenness_vector.qza \
  --p-default-metric pielou_evenness \
  --p-default-group-column diet \
  --p-state-column biocon_days_num \
  --p-individual-id-column bin_rep \
  --o-visualization core_metrics_noinit_34k/longitudinal/evenness-volatility.qzv

# Richness
qiime longitudinal volatility \
  --m-metadata-file metadata.txt \
  --m-metadata-file core_metrics_noinit_34k/observed_features_vector.qza \
  --p-default-metric observed_features \
  --p-default-group-column diet \
  --p-state-column biocon_days_num \
  --p-individual-id-column bin_rep \
  --o-visualization core_metrics_noinit_34k/longitudinal/observed_features-volatility.qzv

# Shannon
qiime longitudinal volatility \
  --m-metadata-file metadata.txt \
  --m-metadata-file core_metrics_noinit_34k/shannon_vector.qza \
  --p-default-metric shannon_entropy \
  --p-default-group-column diet \
  --p-state-column biocon_days_num \
  --p-individual-id-column bin_rep \
  --o-visualization core_metrics_noinit_34k/longitudinal/shannon-volatility.qzv

## Pairwise distances comparisons at day 7
# Unweighted
qiime longitudinal pairwise-distances \
  --i-distance-matrix core_metrics_noinit_34k/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file metadata_noinit.txt \
  --p-group-column diet \
  --p-state-column biocon_days_cat \
  --p-state-1 0 \
  --p-state-2 7 \
  --p-individual-id-column bin_rep \
  --p-replicate-handling random \
  --o-visualization core_metrics_noinit_34k/longitudinal/d7_unweighted-pairwise-distances.qzv

# Weighted
qiime longitudinal pairwise-distances \
  --i-distance-matrix core_metrics_noinit_34k/weighted_unifrac_distance_matrix.qza \
  --m-metadata-file metadata_noinit.txt \
  --p-group-column diet \
  --p-state-column biocon_days_cat \
  --p-state-1 0 \
  --p-state-2 7 \
  --p-individual-id-column bin_rep \
  --p-replicate-handling random \
  --o-visualization core_metrics_noinit_34k/longitudinal/d7_weighted-pairwise-distances.qzv

## Pairwise distances comparisons at day 2
# Unweighted
qiime longitudinal pairwise-distances \
  --i-distance-matrix core_metrics_noinit_34k/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file metadata_noinit.txt \
  --p-group-column diet \
  --p-state-column biocon_days_cat \
  --p-state-1 0 \
  --p-state-2 2 \
  --p-individual-id-column bin_rep \
  --p-replicate-handling random \
  --o-visualization core_metrics_noinit_34k/longitudinal/d2_unweighted-pairwise-distances.qzv

# Weighted
qiime longitudinal pairwise-distances \
  --i-distance-matrix core_metrics_noinit_34k/weighted_unifrac_distance_matrix.qza \
  --m-metadata-file metadata_noinit.txt \
  --p-group-column diet \
  --p-state-column biocon_days_cat \
  --p-state-1 0 \
  --p-state-2 2 \
  --p-individual-id-column bin_rep \
  --p-replicate-handling random \
  --o-visualization core_metrics_noinit_34k/longitudinal/d2_weighted-pairwise-distances.qzv

##Split alpha divs and dist mats by day
mkdir -p core_metrics_noinit_34k/d0 core_metrics_noinit_34k/d2 core_metrics_noinit_34k/d7

# Faith
qiime diversity filter-alpha-diversity \
  --i-alpha-diversity core_metrics_noinit_34k/faith_pd_vector.qza \
  --m-metadata-file metadata_noinit.txt \
  --p-where "[biocon_days_cat]=='0'" \
  --o-filtered-alpha-diversity core_metrics_noinit_34k/d0/faith_pd_vector.qza 

qiime diversity filter-alpha-diversity \
  --i-alpha-diversity core_metrics_noinit_34k/faith_pd_vector.qza \
  --m-metadata-file metadata_noinit.txt \
  --p-where "[biocon_days_cat]=='2'" \
  --o-filtered-alpha-diversity core_metrics_noinit_34k/d2/faith_pd_vector.qza

qiime diversity filter-alpha-diversity \
  --i-alpha-diversity core_metrics_noinit_34k/faith_pd_vector.qza \
  --m-metadata-file metadata_noinit.txt \
  --p-where "[biocon_days_cat]=='7'" \
  --o-filtered-alpha-diversity core_metrics_noinit_34k/d7/faith_pd_vector.qza

# Shannon
qiime diversity filter-alpha-diversity \
  --i-alpha-diversity core_metrics_noinit_34k/shannon_vector.qza \
  --m-metadata-file metadata_noinit.txt \
  --p-where "[biocon_days_cat]=='0'" \
  --o-filtered-alpha-diversity core_metrics_noinit_34k/d0/shannon_vector.qza 

qiime diversity filter-alpha-diversity \
  --i-alpha-diversity core_metrics_noinit_34k/shannon_vector.qza \
  --m-metadata-file metadata_noinit.txt \
  --p-where "[biocon_days_cat]=='2'" \
  --o-filtered-alpha-diversity core_metrics_noinit_34k/d2/shannon_vector.qza

qiime diversity filter-alpha-diversity \
  --i-alpha-diversity core_metrics_noinit_34k/shannon_vector.qza \
  --m-metadata-file metadata_noinit.txt \
  --p-where "[biocon_days_cat]=='7'" \
  --o-filtered-alpha-diversity core_metrics_noinit_34k/d7/shannon_vector.qza

# Observed_features
qiime diversity filter-alpha-diversity \
  --i-alpha-diversity core_metrics_noinit_34k/observed_features_vector.qza \
  --m-metadata-file metadata_noinit.txt \
  --p-where "[biocon_days_cat]=='0'" \
  --o-filtered-alpha-diversity core_metrics_noinit_34k/d0/observed_features_vector.qza 

qiime diversity filter-alpha-diversity \
  --i-alpha-diversity core_metrics_noinit_34k/observed_features_vector.qza \
  --m-metadata-file metadata_noinit.txt \
  --p-where "[biocon_days_cat]=='2'" \
  --o-filtered-alpha-diversity core_metrics_noinit_34k/d2/observed_features_vector.qza

qiime diversity filter-alpha-diversity \
  --i-alpha-diversity core_metrics_noinit_34k/observed_features_vector.qza \
  --m-metadata-file metadata_noinit.txt \
  --p-where "[biocon_days_cat]=='7'" \
  --o-filtered-alpha-diversity core_metrics_noinit_34k/d7/observed_features_vector.qza

# Evenness
qiime diversity filter-alpha-diversity \
  --i-alpha-diversity core_metrics_noinit_34k/evenness_vector.qza \
  --m-metadata-file metadata_noinit.txt \
  --p-where "[biocon_days_cat]=='0'" \
  --o-filtered-alpha-diversity core_metrics_noinit_34k/d0/evenness_vector.qza 

qiime diversity filter-alpha-diversity \
  --i-alpha-diversity core_metrics_noinit_34k/evenness_vector.qza \
  --m-metadata-file metadata_noinit.txt \
  --p-where "[biocon_days_cat]=='2'" \
  --o-filtered-alpha-diversity core_metrics_noinit_34k/d2/evenness_vector.qza

qiime diversity filter-alpha-diversity \
  --i-alpha-diversity core_metrics_noinit_34k/evenness_vector.qza \
  --m-metadata-file metadata_noinit.txt \
  --p-where "[biocon_days_cat]=='7'" \
  --o-filtered-alpha-diversity core_metrics_noinit_34k/d7/evenness_vector.qza

# Unweighted
qiime diversity filter-distance-matrix \
  --i-distance-matrix core_metrics_noinit_34k/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file metadata_noinit.txt \
  --p-where "[biocon_days_cat]=='0'" \
  --o-filtered-distance-matrix core_metrics_noinit_34k/d0/unweighted_unifrac_distance_matrix.qza

qiime diversity filter-distance-matrix \
  --i-distance-matrix core_metrics_noinit_34k/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file metadata_noinit.txt \
  --p-where "[biocon_days_cat]=='2'" \
  --o-filtered-distance-matrix core_metrics_noinit_34k/d2/unweighted_unifrac_distance_matrix.qza

qiime diversity filter-distance-matrix \
  --i-distance-matrix core_metrics_noinit_34k/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file metadata_noinit.txt \
  --p-where "[biocon_days_cat]=='7'" \
  --o-filtered-distance-matrix core_metrics_noinit_34k/d7/unweighted_unifrac_distance_matrix.qza

# Weighted
qiime diversity filter-distance-matrix \
  --i-distance-matrix core_metrics_noinit_34k/weighted_unifrac_distance_matrix.qza \
  --m-metadata-file metadata_noinit.txt \
  --p-where "[biocon_days_cat]=='0'" \
  --o-filtered-distance-matrix core_metrics_noinit_34k/d0/weighted_unifrac_distance_matrix.qza

qiime diversity filter-distance-matrix \
  --i-distance-matrix core_metrics_noinit_34k/weighted_unifrac_distance_matrix.qza \
  --m-metadata-file metadata_noinit.txt \
  --p-where "[biocon_days_cat]=='2'" \
  --o-filtered-distance-matrix core_metrics_noinit_34k/d2/weighted_unifrac_distance_matrix.qza

qiime diversity filter-distance-matrix \
  --i-distance-matrix core_metrics_noinit_34k/weighted_unifrac_distance_matrix.qza \
  --m-metadata-file metadata_noinit.txt \
  --p-where "[biocon_days_cat]=='7'" \
  --o-filtered-distance-matrix core_metrics_noinit_34k/d7/weighted_unifrac_distance_matrix.qza

## Alpha group significance
# d0
qiime diversity alpha-group-significance \
  --i-alpha-diversity core_metrics_noinit_34k/d0/faith_pd_vector.qza \
  --m-metadata-file metadata_noinit.txt \
  --o-visualization core_metrics_noinit_34k/d0/faith_pd_vector.qzv

qiime diversity alpha-group-significance \
  --i-alpha-diversity core_metrics_noinit_34k/d0/shannon_vector.qza \
  --m-metadata-file metadata_noinit.txt \
  --o-visualization core_metrics_noinit_34k/d0/shannon_vector.qzv

qiime diversity alpha-group-significance \
  --i-alpha-diversity core_metrics_noinit_34k/d0/observed_features_vector.qza \
  --m-metadata-file metadata_noinit.txt \
  --o-visualization core_metrics_noinit_34k/d0/observed_features_vector.qzv

qiime diversity alpha-group-significance \
  --i-alpha-diversity core_metrics_noinit_34k/d0/evenness_vector.qza \
  --m-metadata-file metadata_noinit.txt \
  --o-visualization core_metrics_noinit_34k/d0/evenness_vector.qzv

# d2
qiime diversity alpha-group-significance \
  --i-alpha-diversity core_metrics_noinit_34k/d2/faith_pd_vector.qza \
  --m-metadata-file metadata_noinit.txt \
  --o-visualization core_metrics_noinit_34k/d2/faith_pd_vector.qzv

qiime diversity alpha-group-significance \
  --i-alpha-diversity core_metrics_noinit_34k/d2/shannon_vector.qza \
  --m-metadata-file metadata_noinit.txt \
  --o-visualization core_metrics_noinit_34k/d2/shannon_vector.qzv

qiime diversity alpha-group-significance \
  --i-alpha-diversity core_metrics_noinit_34k/d2/observed_features_vector.qza \
  --m-metadata-file metadata_noinit.txt \
  --o-visualization core_metrics_noinit_34k/d2/observed_features_vector.qzv

qiime diversity alpha-group-significance \
  --i-alpha-diversity core_metrics_noinit_34k/d2/evenness_vector.qza \
  --m-metadata-file metadata_noinit.txt \
  --o-visualization core_metrics_noinit_34k/d2/evenness_vector.qzv

# d7
qiime diversity alpha-group-significance \
  --i-alpha-diversity core_metrics_noinit_34k/d7/faith_pd_vector.qza \
  --m-metadata-file metadata_noinit.txt \
  --o-visualization core_metrics_noinit_34k/d7/faith_pd_vector.qzv

qiime diversity alpha-group-significance \
  --i-alpha-diversity core_metrics_noinit_34k/d7/shannon_vector.qza \
  --m-metadata-file metadata_noinit.txt \
  --o-visualization core_metrics_noinit_34k/d7/shannon_vector.qzv

qiime diversity alpha-group-significance \
  --i-alpha-diversity core_metrics_noinit_34k/d7/observed_features_vector.qza \
  --m-metadata-file metadata_noinit.txt \
  --o-visualization core_metrics_noinit_34k/d7/observed_features_vector.qzv

qiime diversity alpha-group-significance \
  --i-alpha-diversity core_metrics_noinit_34k/d7/evenness_vector.qza \
  --m-metadata-file metadata_noinit.txt \
  --o-visualization core_metrics_noinit_34k/d7/evenness_vector.qzv

## Beta group significance
# d0
qiime diversity beta-group-significance \
  --i-distance-matrix core_metrics_noinit_34k/d0/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file metadata_noinit.txt \
  --m-metadata-column diet \
  --p-pairwise \
  --o-visualization core_metrics_noinit_34k/d0/unweighted_diet_stats.qzv

qiime diversity beta-group-significance \
  --i-distance-matrix core_metrics_noinit_34k/d0/weighted_unifrac_distance_matrix.qza \
  --m-metadata-file metadata_noinit.txt \
  --m-metadata-column diet \
  --p-pairwise \
  --o-visualization core_metrics_noinit_34k/d0/weighted_diet_stats.qzv

# d2
qiime diversity beta-group-significance \
  --i-distance-matrix core_metrics_noinit_34k/d2/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file metadata_noinit.txt \
  --m-metadata-column diet \
  --p-pairwise \
  --o-visualization core_metrics_noinit_34k/d2/unweighted_diet_stats.qzv

qiime diversity beta-group-significance \
  --i-distance-matrix core_metrics_noinit_34k/d2/weighted_unifrac_distance_matrix.qza \
  --m-metadata-file metadata_noinit.txt \
  --m-metadata-column diet \
  --p-pairwise \
  --o-visualization core_metrics_noinit_34k/d2/weighted_diet_stats.qzv

# d7
qiime diversity beta-group-significance \
  --i-distance-matrix core_metrics_noinit_34k/d7/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file metadata_noinit.txt \
  --m-metadata-column diet \
  --p-pairwise \
  --o-visualization core_metrics_noinit_34k/d7/unweighted_diet_stats.qzv

qiime diversity beta-group-significance \
  --i-distance-matrix core_metrics_noinit_34k/d7/weighted_unifrac_distance_matrix.qza \
  --m-metadata-file metadata_noinit.txt \
  --m-metadata-column diet \
  --p-pairwise \
  --o-visualization core_metrics_noinit_34k/d7/weighted_diet_stats.qzv

## Per day pcoas and emperor plots
# d0
qiime diversity pcoa \
  --i-distance-matrix core_metrics_noinit_34k/d0/unweighted_unifrac_distance_matrix.qza \
  --o-pcoa core_metrics_noinit_34k/d0/unweighted_unifrac_pcoa.qza

qiime emperor plot \
  --i-pcoa core_metrics_noinit_34k/d0/unweighted_unifrac_pcoa.qza \
  --m-metadata-file metadata_noinit.txt \
  --o-visualization core_metrics_noinit_34k/d0/unweighted_unifrac_emperor.qzv

qiime diversity pcoa \
  --i-distance-matrix core_metrics_noinit_34k/d0/weighted_unifrac_distance_matrix.qza \
  --o-pcoa core_metrics_noinit_34k/d0/weighted_unifrac_pcoa.qza

qiime emperor plot \
  --i-pcoa core_metrics_noinit_34k/d0/weighted_unifrac_pcoa.qza \
  --m-metadata-file metadata_noinit.txt \
  --o-visualization core_metrics_noinit_34k/d0/weighted_unifrac_emperor.qzv

# d2
qiime diversity pcoa \
  --i-distance-matrix core_metrics_noinit_34k/d2/unweighted_unifrac_distance_matrix.qza \
  --o-pcoa core_metrics_noinit_34k/d2/unweighted_unifrac_pcoa.qza

qiime emperor plot \
  --i-pcoa core_metrics_noinit_34k/d2/unweighted_unifrac_pcoa.qza \
  --m-metadata-file metadata_noinit.txt \
  --o-visualization core_metrics_noinit_34k/d2/unweighted_unifrac_emperor.qzv

qiime diversity pcoa \
  --i-distance-matrix core_metrics_noinit_34k/d2/weighted_unifrac_distance_matrix.qza \
  --o-pcoa core_metrics_noinit_34k/d2/weighted_unifrac_pcoa.qza

qiime emperor plot \
  --i-pcoa core_metrics_noinit_34k/d2/weighted_unifrac_pcoa.qza \
  --m-metadata-file metadata_noinit.txt \
  --o-visualization core_metrics_noinit_34k/d2/weighted_unifrac_emperor.qzv

# d7
qiime diversity pcoa \
  --i-distance-matrix core_metrics_noinit_34k/d7/unweighted_unifrac_distance_matrix.qza \
  --o-pcoa core_metrics_noinit_34k/d7/unweighted_unifrac_pcoa.qza

qiime emperor plot \
  --i-pcoa core_metrics_noinit_34k/d7/unweighted_unifrac_pcoa.qza \
  --m-metadata-file metadata_noinit.txt \
  --o-visualization core_metrics_noinit_34k/d7/unweighted_unifrac_emperor.qzv

qiime diversity pcoa \
  --i-distance-matrix core_metrics_noinit_34k/d7/weighted_unifrac_distance_matrix.qza \
  --o-pcoa core_metrics_noinit_34k/d7/weighted_unifrac_pcoa.qza

qiime emperor plot \
  --i-pcoa core_metrics_noinit_34k/d7/weighted_unifrac_pcoa.qza \
  --m-metadata-file metadata_noinit.txt \
  --o-visualization core_metrics_noinit_34k/d7/weighted_unifrac_emperor.qzv


### only the additive model seems to work so need to go to R for interaction model
# we don't really have the sample size for this, going to have to just split the data
qiime composition ancombc2 \
    --i-table final_tables/filtered_nocon_noinitial_decontam_table.qza \
    --m-metadata-file metadata.txt \
    --p-fixed-effects-formula "biocon_days_cat + diet" \
    --p-random-effects-formula "(biocon_days_cat | bin_rep)" \
    --p-reference-levels biocon_days_cat::0 diet::chicken_feed \
    --p-group diet \
    --p-structural-zeros \
    --p-num-processes 12 \
    --o-ancombc2-output ancombc2/days_diet_int_randslope_randint.qza 

qiime composition ancombc2 \
    --i-table final_tables/filtered_nocon_noinitial_decontam_table.qza \
    --m-metadata-file metadata.txt \
    --p-fixed-effects-formula "biocon_days_cat + diet" \
    --p-random-effects-formula "(1 | bin_rep)" \
    --p-reference-levels biocon_days_cat::0 diet::chicken_feed \
    --p-group diet \
    --p-structural-zeros \
    --p-num-processes 12 \
    --o-ancombc2-output ancombc2/days_diet_int_randint.qza

qiime composition ancombc2-visualizer \
    --i-data ancombc2/days_diet_int_randslope_randint.qza  \
    --i-taxonomy taxonomy/taxonomy.qza \
    --o-visualization ancombc2/days_diet_int_randslope_randint.qzv 

qiime composition ancombc2-visualizer \
    --i-data ancombc2/days_diet_int_randint.qza \
    --i-taxonomy taxonomy/taxonomy.qza \
    --o-visualization ancombc2/days_diet_int_randint.qzv

mkdir -p r_import

qiime tools export \
  --input-path final_tables/filtered_nocon_noinitial_decontam_table.qza \
  --output-path r_import/table_export

qiime tools export \
  --input-path tree/tree.qza \
  --output-path r_import/tree_export

qiime tools export \
  --input-path taxonomy/taxonomy.qza \
  --output-path r_import/tax_export

biom convert \
  -i r_import/table_export/feature-table.biom \
  -o r_import/table_export/feature-table.tsv \
  --to-tsv

# lets split into 0, 2, 7 bioconversion days and compare between diets
qiime feature-table filter-samples \
  --i-table final_tables/filtered_nocon_noinitial_decontam_table.qza \
  --m-metadata-file metadata.txt \
  --p-where "[biocon_days_cat]='0'" \
  --o-filtered-table final_tables/day0_table.qza

qiime feature-table filter-samples \
  --i-table final_tables/filtered_nocon_noinitial_decontam_table.qza \
  --m-metadata-file metadata.txt \
  --p-where "[biocon_days_cat]='2'" \
  --o-filtered-table final_tables/day2_table.qza

qiime feature-table filter-samples \
  --i-table final_tables/filtered_nocon_noinitial_decontam_table.qza \
  --m-metadata-file metadata.txt \
  --p-where "[biocon_days_cat]='7'" \
  --o-filtered-table final_tables/day7_table.qza

# lets split into 0 bioconversion days and intitial
qiime feature-table filter-samples \
  --i-table final_tables/filtered_nocon_decontam_table.qza \
  --m-metadata-file metadata.txt \
  --p-where "[biocon_days_cat]='0' OR [biocon_days_cat]='initial'"\
  --o-filtered-table final_tables/initial_day0_table.qza

#ancombc2 by day
mkdir ancombc2/day_split

# day 0 ancombc2
qiime composition ancombc2 \
    --i-table final_tables/day0_table.qza \
    --m-metadata-file metadata.txt \
    --p-fixed-effects-formula "diet" \
    --p-reference-levels diet::chicken_feed \
    --p-group diet \
    --p-structural-zeros \
    --p-num-processes 4 \
    --o-ancombc2-output ancombc2/day_split/day0_diet_ancombc2_results.qza

qiime composition ancombc2-visualizer \
    --i-data ancombc2/day_split/day0_diet_ancombc2_results.qza  \
    --i-taxonomy taxonomy/taxonomy.qza \
    --o-visualization ancombc2/day_split/day0_diet_ancombc2_results.qzv

# day 2 ancombc2
qiime composition ancombc2 \
    --i-table final_tables/day2_table.qza \
    --m-metadata-file metadata.txt \
    --p-fixed-effects-formula "diet" \
    --p-reference-levels diet::chicken_feed \
    --p-group diet \
    --p-structural-zeros \
    --p-num-processes 4 \
    --o-ancombc2-output ancombc2/day_split/day2_diet_ancombc2_results.qza

qiime composition ancombc2-visualizer \
    --i-data ancombc2/day_split/day2_diet_ancombc2_results.qza  \
    --i-taxonomy taxonomy/taxonomy.qza \
    --o-visualization ancombc2/day_split/day2_diet_ancombc2_results.qzv

# day 7 ancombc2
qiime composition ancombc2 \
    --i-table final_tables/day7_table.qza \
    --m-metadata-file metadata.txt \
    --p-fixed-effects-formula "diet" \
    --p-reference-levels diet::chicken_feed \
    --p-group diet \
    --p-structural-zeros \
    --p-num-processes 4 \
    --o-ancombc2-output ancombc2/day_split/day7_diet_ancombc2_results.qza

qiime composition ancombc2-visualizer \
    --i-data ancombc2/day_split/day7_diet_ancombc2_results.qza  \
    --i-taxonomy taxonomy/taxonomy.qza \
    --o-visualization ancombc2/day_split/day7_diet_ancombc2_results.qzv

# day 0 and initial ancombc2
qiime composition ancombc2 \
    --i-table final_tables/initial_day0_table.qza \
    --m-metadata-file metadata.txt \
    --p-fixed-effects-formula "diet" \
    --p-reference-levels diet::initial \
    --p-group diet \
    --p-structural-zeros \
    --p-num-processes 4 \
    --o-ancombc2-output ancombc2/day_split/initial_day0_diet_ancombc2_results.qza

qiime composition ancombc2-visualizer \
    --i-data ancombc2/day_split/initial_day0_diet_ancombc2_results.qza  \
    --i-taxonomy taxonomy/taxonomy.qza \
    --o-visualization ancombc2/day_split/initial_day0_diet_ancombc2_results.qzv

qiime composition ancombc2 \
    --i-table final_tables/initial_day0_table.qza \
    --m-metadata-file metadata.txt \
    --p-fixed-effects-formula "diet" \
    --p-reference-levels diet::initial \
    --p-group diet \
    --p-num-processes 4 \
    --o-ancombc2-output ancombc2/day_split/initial_day0_diet_ancombc2_results_nosz.qza

qiime composition ancombc2-visualizer \
    --i-data ancombc2/day_split/initial_day0_diet_ancombc2_results_nosz.qza  \
    --i-taxonomy taxonomy/taxonomy.qza \
    --o-visualization ancombc2/day_split/initial_day0_diet_ancombc2_results_nosz.qzv

# Collapse tables to genus
qiime taxa collapse \
  --i-table final_tables/day0_table.qza \
  --i-taxonomy taxonomy/taxonomy.qza \
  --p-level 6 \
  --o-collapsed-table final_tables/day0_genus_table.qza

qiime taxa collapse \
  --i-table final_tables/day2_table.qza \
  --i-taxonomy taxonomy/taxonomy.qza \
  --p-level 6 \
  --o-collapsed-table final_tables/day2_genus_table.qza

qiime taxa collapse \
  --i-table final_tables/day7_table.qza \
  --i-taxonomy taxonomy/taxonomy.qza \
  --p-level 6 \
  --o-collapsed-table final_tables/day7_genus_table.qza

qiime taxa collapse \
  --i-table final_tables/initial_day0_table.qza \
  --i-taxonomy taxonomy/taxonomy.qza \
  --p-level 6 \
  --o-collapsed-table final_tables/initial_day0_genus_table.qza

# day 0 genus ancombc2
qiime composition ancombc2 \
    --i-table final_tables/day0_genus_table.qza \
    --m-metadata-file metadata.txt \
    --p-fixed-effects-formula "diet" \
    --p-reference-levels diet::chicken_feed \
    --p-group diet \
    --p-structural-zeros \
    --p-num-processes 4 \
    --o-ancombc2-output ancombc2/day_split/day0_genus_diet_ancombc2_results.qza

qiime composition ancombc2-visualizer \
    --i-data ancombc2/day_split/day0_genus_diet_ancombc2_results.qza  \
    --o-visualization ancombc2/day_split/day0_genus_diet_ancombc2_results.qzv

# day 2 genus ancombc2
qiime composition ancombc2 \
    --i-table final_tables/day2_genus_table.qza \
    --m-metadata-file metadata.txt \
    --p-fixed-effects-formula "diet" \
    --p-reference-levels diet::chicken_feed \
    --p-group diet \
    --p-structural-zeros \
    --p-num-processes 4 \
    --o-ancombc2-output ancombc2/day_split/day2_genus_diet_ancombc2_results.qza

qiime composition ancombc2-visualizer \
    --i-data ancombc2/day_split/day2_genus_diet_ancombc2_results.qza  \
    --o-visualization ancombc2/day_split/day2_genus_diet_ancombc2_results.qzv

# day 7 genus ancombc2
qiime composition ancombc2 \
    --i-table final_tables/day7_genus_table.qza \
    --m-metadata-file metadata.txt \
    --p-fixed-effects-formula "diet" \
    --p-reference-levels diet::chicken_feed \
    --p-group diet \
    --p-structural-zeros \
    --p-num-processes 4 \
    --o-ancombc2-output ancombc2/day_split/day7_genus_diet_ancombc2_results.qza

qiime composition ancombc2-visualizer \
    --i-data ancombc2/day_split/day7_genus_diet_ancombc2_results.qza  \
    --o-visualization ancombc2/day_split/day7_genus_diet_ancombc2_results.qzv

# day 0 and initial genus ancombc2
qiime composition ancombc2 \
    --i-table final_tables/initial_day0_genus_table.qza \
    --m-metadata-file metadata.txt \
    --p-fixed-effects-formula "diet" \
    --p-reference-levels diet::initial \
    --p-group diet \
    --p-structural-zeros \
    --p-num-processes 4 \
    --o-ancombc2-output ancombc2/day_split/initial_day0_genus_diet_ancombc2_results.qza

qiime composition ancombc2-visualizer \
    --i-data ancombc2/day_split/initial_day0_genus_diet_ancombc2_results.qza  \
    --o-visualization ancombc2/day_split/initial_day0_genus_diet_ancombc2_results.qzv