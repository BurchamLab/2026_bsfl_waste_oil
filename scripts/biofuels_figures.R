# Made by Reese Saho for making figures from the biofuels BSFL project

invisible(gc()) # clear memory
rm(list = ls()) #clear environment

options(repos = c(CRAN = "https://cloud.r-project.org"))

packages = c("devtools",
             "dplyr",
             "tidyplots",
             "tidyverse",
             "ggplot2", 
             "tidyr",
             "ggpubr",
             "ggrepel",
             "ggtext",
             "glue",
             "patchwork",
             "cowplot",
             "car",
             "multcompView",
             "dunn.test",
             "vegan",
             "jsonlite",
             "purrr",
             "RColorBrewer",
             "shadowtext")

for (pkg in packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg, dependencies = TRUE) }
  
  library(pkg, character.only = TRUE)
}

devtools::install_github("jbisanz/qiime2R")
library(qiime2R)

# Load in UniFracs ----

uw_unifrac = read_qza("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/core_metrics/unweighted_unifrac_pcoa_results.qza")
w_unifrac = read_qza("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/core_metrics/weighted_unifrac_pcoa_results.qza")

uw_d0_unifrac = read_qza("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/d0/unweighted_unifrac_pcoa.qza")
w_d0_unifrac = read_qza("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/d0/weighted_unifrac_pcoa.qza")

uw_d2_unifrac = read_qza("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/d2/unweighted_unifrac_pcoa.qza")
w_d2_unifrac = read_qza("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/d2/weighted_unifrac_pcoa.qza")

uw_d7_unifrac = read_qza("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/d7/unweighted_unifrac_pcoa.qza")
w_d7_unifrac = read_qza("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/d7/weighted_unifrac_pcoa.qza")

# Loading in ANCOMBC2 data. Make sure you unzip the ANCOMBC2 .qza file before trying to load these ----

d0_ancom_lfc = stream_in(file("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/d0/f0022a3f-3944-4e04-94a4-f9b28a8220e4/data/lfc.jsonl"))
d0_ancom_q = stream_in(file("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/d0/f0022a3f-3944-4e04-94a4-f9b28a8220e4/data/q.jsonl"))

d2_ancom_lfc = stream_in(file("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/d2/0ec9ee3b-4a7d-4c5e-9981-b6f4ae9db800/data/lfc.jsonl"))
d2_ancom_q = stream_in(file("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/d2/0ec9ee3b-4a7d-4c5e-9981-b6f4ae9db800/data/q.jsonl"))

d7_ancom_lfc = stream_in(file("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/d7/7ba4b364-4bf7-4bfe-9425-feaf46075f6e/data/lfc.jsonl"))
d7_ancom_q = stream_in(file("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/d7/7ba4b364-4bf7-4bfe-9425-feaf46075f6e/data/q.jsonl"))

# Load in feature tables ----

d0_qza = read_qza("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/d0/day0_table.qza")

d2_qza = read_qza("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/d2/day2_table.qza")

d7_qza = read_qza("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/d7/day7_table.qza")

full_table = read_qza("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/filtered_nocon_decontam_table.qza")

feature_table = full_table$data

# Load in alpha diversity metrics ----

faith_qza = read_qza("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/core_metrics/faith_pd_vector.qza")

evenness_qza = read_qza("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/core_metrics/evenness_vector.qza")

shannon_qza = read_qza("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/core_metrics/shannon_vector.qza")

d0_faith_qza = read_qza("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/d0/faith_pd_vector.qza")

d0_evenness_qza = read_qza("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/d0/evenness_vector.qza")

d2_faith_qza = read_qza("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/d2/faith_pd_vector.qza")

d2_evenness_qza = read_qza("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/d2/evenness_vector.qza")

d7_faith_qza = read_qza("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/d7/faith_pd_vector.qza")

d7_evenness_qza = read_qza("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/d7/evenness_vector.qza")

# Load in metadata and taxonomy ----

q2_metadata = read_q2metadata("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/metadata.txt")

taxonomy = read.table("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/core_metrics/effb17af-e7a5-49df-baac-f0aa74c73136/data/taxonomy.tsv", header = TRUE, sep = "\t")

# Separate the taxonomy table

sep.table = separate(taxonomy, Taxon, into = c("Domain", "Phylum", "Class", "Order", "Family", "Genus", "Species"), sep = ";", remove = FALSE)

taxonomy_cols = c("Domain", "Phylum", "Class", "Order", "Family", "Genus", "Species")

for (col in taxonomy_cols) {
  sep.table[[col]] <- sub("^.*__", "", sep.table[[col]])
}

## Make legend labels ----

diet_labels = c("initial" = "Neonates", "chicken_feed" = "CF", "vegetable_oil" = "AVO", "pig_grease" = "PG", "cooking_oil" = "UCO")

diet_levels = names(diet_labels)

viridis_colors = c("initial" = "#440154",
                   "chicken_feed" = "#3B528B",
                   "vegetable_oil" = "#21918C",
                   "pig_grease" = "#5DC863",
                   "cooking_oil" = "#FDE725")

biocon_day_labels = c("initial" = "Neonates", "0" = "0", "2" = "2", "7" = "7")

biocon_day_levels = names(biocon_day_labels)

plasma_colors = c("initial" = "#0D0887",
                  "0" = "#7E03A8",
                  "2" = "#CC4778",
                  "7" = "#F89540")

bin_rep_labels = c("chicken_feed_0_1" = "CF Bin 1",
                  "chicken_feed_0_2" = "CF Bin 2",
                  "chicken_feed_0_3" = "CF Bin 3",
                  "vegetable_oil_0_1" = "AVO Bin 1",
                  "vegetable_oil_0_2" = "AVO Bin 2",
                  "vegetable_oil_0_3" = "AVO Bin 3",
                  "pig_grease_0_1" = "PG Bin 1",
                  "pig_grease_0_2" = "PG Bin 2",
                  "pig_grease_0_3" = "PG Bin 3",
                  "cooking_oil_0_1" = "UCO Bin 1",
                  "cooking_oil_0_2" = "UCO Bin 2",
                  "cooking_oil_0_3" = "UCO Bin 3")

bin_rep_levels = names(bin_rep_labels)

bin_rep_colors = c(
                  "chicken_feed_0_1" = "#1F2A44",
                  "chicken_feed_0_2" = "#3B528B",
                  "chicken_feed_0_3" = "#7FA6D9",
                  "vegetable_oil_0_1" = "#1A736F",
                  "vegetable_oil_0_2" = "#21918C",
                  "vegetable_oil_0_3" = "#4FB3AE",
                  "pig_grease_0_1" = "#2F7A3E",
                  "pig_grease_0_2" = "#5DC863",
                  "pig_grease_0_3" = "#A6E3A1",
                  "cooking_oil_0_1" = "#B89B00",
                  "cooking_oil_0_2" = "#FDE725",
                  "cooking_oil_0_3" = "#FFF59D"
)

q2_metadata = q2_metadata %>%
  mutate(diet = factor(diet, levels = diet_levels)) %>%
  mutate(biocon_days_cat = factor(biocon_days_cat, levels = biocon_day_levels)) %>%
  mutate(diet_bcd_bin_rep_group = factor(diet_bcd_bin_rep, levels = bin_rep_levels))

## Unweighted PCoA ----

# Assign percent of variance to each PC

uw_var_explained = uw_unifrac$data$ProportionExplained

x_lab <- paste0("PC1 (", round(uw_var_explained[1] * 100, 1), "%)")
y_lab <- paste0("PC2 (", round(uw_var_explained[2] * 100, 1), "%)")


unweighted_pcoa = uw_unifrac$data$Vectors %>%
  dplyr::select(SampleID, PC1, PC2) %>% 
  left_join(q2_metadata) %>% 
  filter(biocon_days_cat != "initial") %>%
  ggplot(aes(x = PC1, y = PC2, fill = diet)) +
  geom_point(
    shape = 21,
    color = "black",   # black border
    size = 5,
    alpha = 1
  ) +  coord_fixed() +
  theme_q2r() +
  scale_fill_manual(
    values = viridis_colors,
    labels = diet_labels,
    name = "Diet") +
  guides(color = guide_legend(title = "Diet")) +
  labs(
    title = "Diet (Unweighted)",
    x = x_lab,
    y = y_lab
  ) +
  theme(
    axis.title.x = element_text(size = 26),
    axis.title.y = element_text(size = 26),
    plot.title  = element_text(hjust = 0.5, size = 28),
    legend.text = element_text(size = 24),
    legend.title = element_text(size = 26),
    axis.text.y = element_text(size = 26),
    axis.text.x = element_text(size = 26)
  )
ggsave("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/core_metrics/unweighted_unifrac.pdf", unweighted_pcoa, device = "pdf", units = "in", width = 13, height = 8)

unweighted_pcoa = uw_unifrac$data$Vectors %>%
  dplyr::select(SampleID, PC1, PC2) %>% 
  left_join(q2_metadata) %>% 
  filter(biocon_days_cat != "initial") %>%
  ggplot(aes(x = PC1, y = PC2, fill = biocon_days_cat)) +
  geom_point(
    shape = 21,
    color = "black",   # black border
    size = 5,
    alpha = 1
  ) +  
  coord_fixed() +
  theme_q2r() +
  scale_fill_manual(
    values = plasma_colors,
    labels = biocon_day_labels,
    name = "Bioconversion Days") +
  guides(fill = guide_legend(title = "Bioconversion\nDays")) +
  labs(
    title = "Bioconversion Days (Unweighted)",
    x = x_lab,
    y = y_lab
  ) +
  theme(
    axis.title.x = element_text(size = 26),
    axis.title.y = element_text(size = 26),
    plot.title  = element_text(hjust = 0.5, size = 28),
    legend.text = element_text(size = 24),
    legend.title = element_text(size = 26),
    #legend.position = c(0.85, 0.75),
    axis.text.y = element_text(size = 26),
    axis.text.x = element_text(size = 26)
  )
ggsave("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/core_metrics/biocon_days_unweighted_unifrac.pdf", unweighted_pcoa, device = "pdf", units = "in", width = 13, height = 8)

## Weighted PCoA ----

# Assign percent of variance to each PC

w_var_explained = w_unifrac$data$ProportionExplained

x_lab <- paste0("PC1 (", round(w_var_explained[1] * 100, 1), "%)")
y_lab <- paste0("PC2 (", round(w_var_explained[2] * 100, 1), "%)")


weighted_pcoa = w_unifrac$data$Vectors %>%
  dplyr::select(SampleID, PC1, PC2) %>% 
  left_join(q2_metadata) %>% 
  filter(biocon_days_cat != "initial") %>%
  ggplot(aes(x = PC1, y = PC2, fill = diet)) +
  geom_point(
    shape = 21,
    color = "black",   # black border
    size = 5,
    alpha = 1
  ) +  coord_fixed() +
  theme_q2r() +
  scale_fill_manual(
    values = viridis_colors,
    labels = diet_labels,
    name = "Diet") +
  guides(color = guide_legend(title = "Diet")) +
  labs(
    title = "Diet (Weighted)",
    x = x_lab,
    y = y_lab
  ) +
  theme(
    axis.title.x = element_text(size = 26),
    axis.title.y = element_text(size = 26),
    plot.title  = element_text(hjust = 0.5, size = 28),
    legend.text = element_text(size = 24),
    legend.title = element_text(size = 26),
    axis.text.y = element_text(size = 26),
    axis.text.x = element_text(size = 26)
  )
ggsave("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/core_metrics/weighted_unifrac.pdf", weighted_pcoa, device = "pdf", units = "in", width = 13, height = 8)

weighted_pcoa = w_unifrac$data$Vectors %>%
  dplyr::select(SampleID, PC1, PC2) %>% 
  left_join(q2_metadata) %>% 
  filter(biocon_days_cat != "initial") %>%
  ggplot(aes(x = PC1, y = PC2, fill = biocon_days_cat)) +
  geom_point(
    shape = 21,
    color = "black",   # black border
    size = 5,
    alpha = 1
  ) +  
  coord_fixed() +
  theme_q2r() +
  scale_fill_manual(
    values = plasma_colors,
    labels = biocon_day_labels,
    name = "Bioconversion\nDays") +
  guides(color = guide_legend(title = "Bioconversion\nDays")) +
  labs(
    title = "Bioconversion Days (Weighted)",
    x = x_lab,
    y = y_lab
  ) +
  theme(
    axis.title.x = element_text(size = 26),
    axis.title.y = element_text(size = 26),
    plot.title  = element_text(hjust = 0.5, size = 28),
    legend.text = element_text(size = 24),
    legend.title = element_text(size = 26),
    #legend.position = c(0.85, 0.75),
    axis.text.y = element_text(size = 26),
    axis.text.x = element_text(size = 26)
  )
ggsave("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/core_metrics/biocon_days_weighted_unifrac.pdf", weighted_pcoa, device = "pdf", units = "in", width = 13, height = 8)

## UniFrac - Day 0 ----

# Assign percent of variance to each PC

uw_var_explained = uw_d0_unifrac$data$ProportionExplained

x_lab <- paste0("PC1 (", round(uw_var_explained[1] * 100, 1), "%)")
y_lab <- paste0("PC2 (", round(uw_var_explained[2] * 100, 1), "%)")


unweighted_pcoa = uw_d0_unifrac$data$Vectors %>%
  dplyr::select(SampleID, PC1, PC2) %>% 
  left_join(q2_metadata) %>% 
  ggplot(aes(x = PC1, y = PC2, fill = diet)) +
  geom_point(
    shape = 21,
    color = "black",   # black border
    size = 10,
    alpha = 1
  ) +  
  coord_fixed(xlim = c(-0.4, 0.25), ylim = c(-0.35, 0.35)) +
  theme_q2r() +
  scale_fill_manual(
    values = viridis_colors,
    labels = diet_labels,
    name = "Diet") +
  guides(color = guide_legend(title = "Diet")) +
  labs(
    title = "Diet at Bioconversion\nDay 0 (Unweighted)",
    x = x_lab,
    y = y_lab
  ) +
  theme(
    axis.title.x = element_text(size = 30),
    axis.title.y = element_text(size = 30),
    plot.title  = element_text(hjust = 0.5, size = 34),
    legend.text = element_text(size = 28),
    legend.title = element_text(size = 30),
    legend.position = c(0.08, 0.89),
    axis.text.y = element_text(size = 28),
    axis.text.x = element_text(size = 28)
  )
ggsave("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/d0/unweighted_unifrac.pdf", unweighted_pcoa, device = "pdf", units = "in", width = 12, height = 12)

w_var_explained = w_d0_unifrac$data$ProportionExplained

x_lab <- paste0("PC1 (", round(w_var_explained[1] * 100, 1), "%)")
y_lab <- paste0("PC2 (", round(w_var_explained[2] * 100, 1), "%)")


weighted_pcoa = w_d0_unifrac$data$Vectors %>%
  dplyr::select(SampleID, PC1, PC2) %>% 
  left_join(q2_metadata) %>% 
  ggplot(aes(x = PC1, y = PC2, fill = diet)) +
  geom_point(
    shape = 21,
    color = "black",   # black border
    size = 5,
    alpha = 1
  ) +  
  coord_fixed(xlim = c(-1.25, 1), ylim = c(-1.25, 0.8)) +
  theme_q2r() +
  scale_fill_manual(
    values = viridis_colors,
    labels = diet_labels,
    name = "Diet") +
  guides(color = guide_legend(title = "Diet")) +
  labs(
    title = "Diet at Bioconversion Day 0 (Weighted)",
    x = x_lab,
    y = y_lab
  ) +
  theme(
    axis.title.x = element_text(size = 26),
    axis.title.y = element_text(size = 26),
    plot.title  = element_text(hjust = 0.5, size = 28),
    legend.text = element_text(size = 24),
    legend.title = element_text(size = 26),
    legend.position = c(0.12, 0.16),
    axis.text.y = element_text(size = 26),
    axis.text.x = element_text(size = 26)
  )
ggsave("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/d0/weighted_unifrac.pdf", weighted_pcoa, device = "pdf", units = "in", width = 13, height = 8)

## UniFrac - Day 2 ----

# Assign percent of variance to each PC

uw_var_explained = uw_d2_unifrac$data$ProportionExplained

x_lab <- paste0("PC1 (", round(uw_var_explained[1] * 100, 1), "%)")
y_lab <- paste0("PC2 (", round(uw_var_explained[2] * 100, 1), "%)")


unweighted_pcoa = uw_d2_unifrac$data$Vectors %>%
  dplyr::select(SampleID, PC1, PC2) %>% 
  left_join(q2_metadata) %>% 
  ggplot(aes(x = PC1, y = PC2, fill = diet)) +
  geom_point(
    shape = 21,
    color = "black",   # black border
    size = 10,
    alpha = 1
  ) +  
  coord_fixed(xlim = c(-0.4, 0.25), ylim = c(-0.35, 0.35)) +
  theme_q2r() +
  scale_fill_manual(
    values = viridis_colors,
    labels = diet_labels,
    name = "Diet") +
  guides(color = guide_legend(title = "Diet")) +
  labs(
    title = "Diet at Bioconversion\nDay 2 (Unweighted)",
    x = x_lab,
    y = y_lab
  ) +
  theme(
    axis.title.x = element_text(size = 30),
    axis.title.y = element_text(size = 30),
    plot.title  = element_text(hjust = 0.5, size = 34),
    legend.text = element_text(size = 28),
    legend.title = element_text(size = 30),
    legend.position = c(0.08, 0.89),
    axis.text.y = element_text(size = 28),
    axis.text.x = element_text(size = 28)
  )
ggsave("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/d2/unweighted_unifrac.pdf", unweighted_pcoa, device = "pdf", units = "in", width = 12, height = 12)

w_var_explained = w_d2_unifrac$data$ProportionExplained

x_lab <- paste0("PC1 (", round(w_var_explained[1] * 100, 1), "%)")
y_lab <- paste0("PC2 (", round(w_var_explained[2] * 100, 1), "%)")


weighted_pcoa = w_d2_unifrac$data$Vectors %>%
  dplyr::select(SampleID, PC1, PC2) %>% 
  left_join(q2_metadata) %>% 
  ggplot(aes(x = PC1, y = PC2, fill = diet)) +
  geom_point(
    shape = 21,
    color = "black",   # black border
    size = 5,
    alpha = 1
  ) +  
  coord_fixed(xlim = c(-1.25, 1), ylim = c(-1.25, 0.8)) +
  theme_q2r() +
  scale_fill_manual(
    values = viridis_colors,
    labels = diet_labels,
    name = "Diet") +
  guides(color = guide_legend(title = "Diet")) +
  labs(
    title = "Diet at Bioconversion Day 2 (Weighted)",
    x = x_lab,
    y = y_lab
  ) +
  theme(
    axis.title.x = element_text(size = 26),
    axis.title.y = element_text(size = 26),
    plot.title  = element_text(hjust = 0.5, size = 28),
    legend.text = element_text(size = 24),
    legend.title = element_text(size = 26),
    legend.position = c(0.12, 0.16),
    axis.text.y = element_text(size = 26),
    axis.text.x = element_text(size = 26)
  )
ggsave("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/d2/weighted_unifrac.pdf", weighted_pcoa, device = "pdf", units = "in", width = 13, height = 8)


## UniFrac - Day 7 ----

# Assign percent of variance to each PC

uw_var_explained = uw_d7_unifrac$data$ProportionExplained

x_lab <- paste0("PC1 (", round(uw_var_explained[1] * 100, 1), "%)")
y_lab <- paste0("PC2 (", round(uw_var_explained[2] * 100, 1), "%)")


unweighted_pcoa = uw_d7_unifrac$data$Vectors %>%
  dplyr::select(SampleID, PC1, PC2) %>% 
  left_join(q2_metadata) %>% 
  ggplot(aes(x = PC1, y = PC2, fill = diet)) +
  geom_point(
    shape = 21,
    color = "black",   # black border
    size = 10,
    alpha = 1
  ) +  
  coord_fixed(xlim = c(-0.4, 0.25), ylim = c(-0.35, 0.35)) +
  theme_q2r() +
  scale_fill_manual(
    values = viridis_colors,
    labels = diet_labels,
    name = "Diet") +
  guides(color = guide_legend(title = "Diet")) +
  labs(
    title = "Diet at Bioconversion\nDay 7 (Unweighted)",
    x = x_lab,
    y = y_lab
  ) +
  theme(
    axis.title.x = element_text(size = 30),
    axis.title.y = element_text(size = 30),
    plot.title  = element_text(hjust = 0.5, size = 34),
    legend.text = element_text(size = 28),
    legend.title = element_text(size = 30),
    legend.position = c(0.08, 0.89),
    axis.text.y = element_text(size = 28),
    axis.text.x = element_text(size = 28)
  )
ggsave("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/d7/unweighted_unifrac.pdf", unweighted_pcoa, device = "pdf", units = "in", width = 12, height = 12)

w_var_explained = w_d7_unifrac$data$ProportionExplained

x_lab <- paste0("PC1 (", round(w_var_explained[1] * 100, 1), "%)")
y_lab <- paste0("PC2 (", round(w_var_explained[2] * 100, 1), "%)")


weighted_pcoa = w_d7_unifrac$data$Vectors %>%
  dplyr::select(SampleID, PC1, PC2) %>% 
  left_join(q2_metadata) %>% 
  ggplot(aes(x = PC1, y = PC2, fill = diet)) +
  geom_point(
    shape = 21,
    color = "black",   # black border
    size = 5,
    alpha = 1
  ) +  
  coord_fixed(xlim = c(-1.25, 1), ylim = c(-1.25, 0.8)) +
  theme_q2r() +
  scale_fill_manual(
    values = viridis_colors,
    labels = diet_labels,
    name = "Diet") +
  guides(color = guide_legend(title = "Diet")) +
  labs(
    title = "Diet at Bioconversion Day 7 (Weighted)",
    x = x_lab,
    y = y_lab
  ) +
  theme(
    axis.title.x = element_text(size = 26),
    axis.title.y = element_text(size = 26),
    plot.title  = element_text(hjust = 0.5, size = 28),
    legend.text = element_text(size = 24),
    legend.title = element_text(size = 26),
    legend.position = c(0.12, 0.16),
    axis.text.y = element_text(size = 26),
    axis.text.x = element_text(size = 26)
  )
ggsave("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/d7/weighted_unifrac.pdf", weighted_pcoa, device = "pdf", units = "in", width = 13, height = 8)

## UniFrac - Batch Effects

# uw_var_explained = uw_unifrac$data$ProportionExplained
# 
# x_lab <- paste0("PC1 (", round(uw_var_explained[1] * 100, 1), "%)")
# y_lab <- paste0("PC2 (", round(uw_var_explained[2] * 100, 1), "%)")
# 
# 
# unweighted_pcoa = uw_unifrac$data$Vectors %>%
#   dplyr::select(SampleID, PC1, PC2) %>% 
#   left_join(q2_metadata) %>% 
#   ggplot(aes(x = PC1, y = PC2, color = diet)) +
#   geom_point(alpha = 1.0, size = 5) + 
#   coord_fixed() +
#   theme_q2r() +
#   scale_color_manual(
#     values = viridis_colors,
#     labels = diet_labels,
#     name = "Diet") +
#   guides(color = guide_legend(title = "Diet")) +
#   labs(
#     title = "Bioconversion Bin by Diet\nat Day 0 (Unweighted)",
#     x = x_lab,
#     y = y_lab
#   ) +
#   theme(
#     axis.title.x = element_text(size = 26),
#     axis.title.y = element_text(size = 26),
#     plot.title  = element_text(hjust = 0.5, size = 28),
#     legend.text = element_text(size = 24),
#     legend.title = element_text(size = 26),
#     axis.text.y = element_text(size = 26),
#     axis.text.x = element_text(size = 26)
#   )
# ggsave("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/core_metrics/unweighted_unifrac.pdf", unweighted_pcoa, device = "pdf", units = "in", width = 13, height = 8)
# 
# unweighted_pcoa = uw_unifrac$data$Vectors %>%
#   dplyr::select(SampleID, PC1, PC2) %>% 
#   left_join(q2_metadata) %>% 
#   ggplot(aes(x = PC1, y = PC2, color = biocon_days_cat)) +
#   geom_point(alpha = 1.0, size = 5) + 
#   coord_fixed() +
#   theme_q2r() +
#   scale_color_manual(
#     values = plasma_colors,
#     labels = biocon_day_labels,
#     name = "Bioconversion Days") +
#   guides(color = guide_legend(title = "Bioconversion Days")) +
#   labs(
#     title = "Unweighted UniFrac",
#     x = x_lab,
#     y = y_lab
#   ) +
#   theme(
#     axis.title.x = element_text(size = 26),
#     axis.title.y = element_text(size = 26),
#     plot.title  = element_text(hjust = 0.5, size = 28),
#     legend.text = element_text(size = 24),
#     legend.title = element_text(size = 26),
#     axis.text.y = element_text(size = 26),
#     axis.text.x = element_text(size = 26)
#   )
# ggsave("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/core_metrics/biocon_days_unweighted_unifrac.pdf", unweighted_pcoa, device = "pdf", units = "in", width = 13, height = 8)


## UniFrac - Bin Reps ----

# Make a list for the bin labels

# Assign percent of variance to each PC

uw_var_d0_explained = uw_d0_unifrac$data$ProportionExplained

x_lab <- paste0("PC1 (", round(uw_var_d0_explained[1] * 100, 1), "%)")
y_lab <- paste0("PC2 (", round(uw_var_d0_explained[2] * 100, 1), "%)")


unweighted_pcoa = uw_d0_unifrac$data$Vectors %>%
  dplyr::select(SampleID, PC1, PC2) %>% 
  left_join(q2_metadata) %>% 
  ggplot(aes(x = PC1, y = PC2, fill = diet_bcd_bin_rep_group)) +
  geom_point(
    shape = 21,
    color = "black",   # black border
    size = 5,
    alpha = 1
  ) +
  coord_fixed() +
  theme_q2r() +
  scale_fill_manual(
    values = bin_rep_colors,
    labels = bin_rep_labels,
    name = "Bin"
  ) +
  guides(fill = guide_legend(title = "Bin")) +
  labs(
    title = "Bioconversion Bin by\nDiet at Day 0 (Unweighted)",
    x = x_lab,
    y = y_lab
  ) +
  theme(
    axis.title.x = element_text(size = 26),
    axis.title.y = element_text(size = 26),
    plot.title  = element_text(hjust = 0.5, size = 28),
    legend.text = element_text(size = 24),
    legend.title = element_text(size = 26),
    axis.text.y = element_text(size = 26),
    axis.text.x = element_text(size = 26)
  )
ggsave("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/d0/bin_reps_unweighted_unifrac.pdf", unweighted_pcoa, device = "pdf", units = "in", width = 13, height = 8)

w_var_d0_explained = w_d0_unifrac$data$ProportionExplained

x_lab <- paste0("PC1 (", round(w_var_d0_explained[1] * 100, 1), "%)")
y_lab <- paste0("PC2 (", round(w_var_d0_explained[2] * 100, 1), "%)")


weighted_pcoa = w_d0_unifrac$data$Vectors %>%
  dplyr::select(SampleID, PC1, PC2) %>% 
  left_join(q2_metadata) %>% 
  ggplot(aes(x = PC1, y = PC2, fill = diet_bcd_bin_rep_group)) +
  geom_point(
    shape = 21,
    color = "black",   # black border
    size = 5,
    alpha = 1
  ) +
  coord_fixed() +
  theme_q2r() +
  scale_fill_manual(
    values = bin_rep_colors,
    labels = bin_rep_labels,
    name = "Bin"
  ) +
  guides(fill = guide_legend(title = "Bin")) +
  labs(
    title = "Bioconversion Bin by\nDiet at Day 0 (Weighted)",
    x = x_lab,
    y = y_lab
  ) +
  theme(
    axis.title.x = element_text(size = 26),
    axis.title.y = element_text(size = 26),
    plot.title  = element_text(hjust = 0.5, size = 28),
    legend.text = element_text(size = 24),
    legend.title = element_text(size = 26),
    axis.text.y = element_text(size = 26),
    axis.text.x = element_text(size = 26)
  )
ggsave("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/d0/bin_rep_weighted_unifrac.pdf", weighted_pcoa, device = "pdf", units = "in", width = 13, height = 8)

## Differential Abundance Heatmap ----

# Remove the unneccesary columns from each file
da_filter = function(lfc_json, q_json) {
  
  ancom_list = list(
    lfc_json = lfc_json,
    q_json   = q_json
  )
  
  ancom_list = ancom_list %>%
    map(~ .x %>%
          slice(-1) %>% # Drop the first row
          select(9:13) # Keep the important columns
    )
  return(ancom_list)
}

d0_ancom_results = da_filter(lfc_json = d0_ancom_lfc, q_json = d0_ancom_q)
d2_ancom_results = da_filter(lfc_json = d2_ancom_lfc, q_json = d2_ancom_q)
d7_ancom_results = da_filter(lfc_json = d7_ancom_lfc, q_json = d7_ancom_q)


d0_ancom_lfc = d0_ancom_results$lfc_json
d0_ancom_q = d0_ancom_results$q_json
d0_ancom_lfc$day = 0
d0_ancom_q$day = 0

d2_ancom_lfc = d2_ancom_results$lfc_json
d2_ancom_q = d2_ancom_results$q_json
d2_ancom_lfc$day = 2
d2_ancom_q$day = 2

d7_ancom_lfc = d7_ancom_results$lfc_json
d7_ancom_q = d7_ancom_results$q_json
d7_ancom_lfc$day = 7
d7_ancom_q$day = 7

# Make long versions of the q files and merge them together

q_list = list(
  d0 = d0_ancom_q,
  d2 = d2_ancom_q,
  d7 = d7_ancom_q
)

q_results = list()

for (name in names(q_list)) {

  # Remove Intercept and convert to longer forms of the file
  
  file = q_list[[name]]
  
  file_long = file %>%
    select(-"(Intercept)") %>%
    pivot_longer(
      cols = -c(taxon, day),
      names_to = "diet",
      values_to = "q"
    )
  
  # Dynamic naming of the files based on the list in a BASH/Python format
  
  long_file_name = glue("{name}_long")
  
  # Store the results of the file in a new list
  
  q_results[[long_file_name]] = file_long
  
}

merged_q = bind_rows(q_results)

# Add a label that determines if something is significant or not

merged_q$stat <- ifelse(merged_q$q < 0.05,
                        "Significant",
                        "Not Significant")

# Not all taxa were detected at every time point, so fill in the blanks
merged_q <- merged_q %>%
  complete(taxon, day, diet)

# Remove ASVs from the list that were never detected as significant

filtered_q <- merged_q %>%
  group_by(taxon) %>%
  filter(any(stat == "Significant", na.rm = TRUE)) %>%
  ungroup()

# Repeat the process with the lfc files

lfc_list = list(
  d0 = d0_ancom_lfc,
  d2 = d2_ancom_lfc,
  d7 = d7_ancom_lfc
)

lfc_results = list()

for (name in names(lfc_list)) {
  
  # Remove Intercept and convert to longer forms of the file
  
  file = lfc_list[[name]]
  
  file_long = file %>%
    select(-"(Intercept)") %>%
    pivot_longer(
      cols = -c(taxon, day),
      names_to = "diet",
      values_to = "lfc"
    )
  
  # Dynamic naming of the files based on the list in a BASH/Python format
  
  long_file_name = glue("{name}_long")
  
  # Store the results of the file in a new list
  
  lfc_results[[long_file_name]] = file_long
  
}

merged_lfc = bind_rows(lfc_results)

merged_lfc <- merged_lfc %>%
  complete(taxon, day, diet)


# Add a label that determines if something is significant or not

merged_lfc$stat <- ifelse(merged_q$q < 0.05,
                        "Significant",
                        "Not Significant")

# Not all taxa were detected at every time point, so fill in the blanks
merged_lfc <- merged_lfc %>%
  complete(taxon, day, diet)

filtered_lfc = merged_lfc %>%
  filter(taxon %in% filtered_q$taxon) %>% # Remove ASVs from the list that were never detected as significant
  mutate(sig_label = case_when( 
    filtered_q$q < 0.001 ~ "***",
    filtered_q$q < 0.01 ~ "**",
    filtered_q$q < 0.05 ~ "*",
    TRUE ~ ""
  )) %>% # Add a column for significance labels
  left_join(sep.table, by = c("taxon" = "Feature.ID")) %>%
  mutate(taxon_label = paste0( # Add taxonomy labels for family- and genus-level
    ifelse(is.na(Family) | Family == "", "Unknown", Family),
    "; ",
    ifelse(is.na(Genus) | Genus == "", "Unknown", Genus),
    " (",
    substr(taxon, 1, 3),
    ")"
  ))

filtered_lfc$taxon_label[181:189] = "Bacteroidales; Unknown (d14)"
filtered_lfc$taxon_label[37:45] = "Bacilli_A; Unknown (21a)"

taxon_levels <- filtered_lfc %>%
  distinct(taxon_label) %>%
  arrange(taxon_label) %>%
  pull(taxon_label)

filtered_lfc <- filtered_lfc %>%
  mutate(taxon_label = factor(taxon_label, levels = sort(unique(filtered_lfc$taxon_label), decreasing = TRUE)))
  
filtered_lfc$diet = factor(filtered_lfc$diet, levels = c("diet::vegetable_oil", "diet::pig_grease", "diet::cooking_oil"))

plot = ggplot(filtered_lfc, aes(x = factor(day), y = taxon_label, fill = lfc)) +
    geom_tile() +
  geom_shadowtext(
    aes(label = sig_label),
    colour = "white", bg.colour = "black", bg.r = 0.05,  # bg.r = thickness
    size = 5, vjust = 0.8, hjust = 0.5
  ) +
  facet_wrap(~ diet, labeller = as_labeller(c(
      "diet::cooking_oil" = "UCO",
      "diet::pig_grease" = "PG",
      "diet::vegetable_oil" = "AVO"
    ))) +
  scale_fill_viridis_c(option = "viridis") +
  theme_minimal() +
    theme(strip.text.x = element_text(size = 14),
          axis.text.y = element_text(size = 10)
          ) +
    labs(x = "# Bioconversion Days",
         y = "Family/Genus (ASV hash)",
         fill = "LFC Relative\nto CF"
         )

ggsave("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/da_heatmap.pdf", plot, device = "pdf", units = "in", width = 12, height = 8)



## Relative Abundance Plots ----

# Extract the data from the .qza files

d0_feature_table = as.data.frame(d0_qza$data)

d2_feature_table = as.data.frame(d2_qza$data)

d7_feature_table = as.data.frame(d7_qza$data)

# Merge the feature tables together

full_ft = bind_rows( 
  d0_feature_table %>% rownames_to_column("Feature.ID"),
  d2_feature_table %>% rownames_to_column("Feature.ID"),
  d7_feature_table %>% rownames_to_column("Feature.ID")
) %>%
  group_by(Feature.ID) %>%
  summarise(
    across(where(is.numeric), ~ sum(.x, na.rm = TRUE)),
    .groups = "drop"
  ) %>%
  left_join(sep.table, by = "Feature.ID")

# Make the relab table

relab_table = full_ft %>%
  mutate(across(where(is.numeric), ~ .x / sum(.x, na.rm = TRUE)))

relab_long <- relab_table %>%
  pivot_longer(
    cols = matches("^(cf|co|pg|vo)-\\d"),
    names_to = "Sample",
    values_to = "Abundance"
  ) %>%
  mutate(
    Group = sub("^([^-]+)-.*$", "\\1", Sample),
    Day   = as.integer(sub("^[^-]+-(\\d+)-.*$", "\\1", Sample))
  )

class_comp <- relab_long %>%
  mutate(
    Rep = sub("^[^-]+-\\d+-(.*)$", "\\1", Sample),
    Sample = factor(Sample, levels = unique(Sample[order(Group, Day, Rep)]))
  )

top10_classes <- class_comp %>%
  group_by(Class) %>%
  summarise(total_abund = sum(Abundance, na.rm = TRUE), .groups = "drop") %>%
  slice_max(total_abund, n = 10, with_ties = FALSE) %>%
  pull(Class) %>%
  as.character()

class_comp_top10_other <- class_comp %>%
  mutate(
    Class = as.character(Class),
    Class = if_else(is.na(Class) | !(Class %in% top10_classes), "Other", Class)
  ) %>%
  group_by(Group, Sample, Class, Day) %>%
  summarise(Abundance = sum(Abundance, na.rm = TRUE), .groups = "drop") %>%
  mutate(Class = factor(Class, levels = c(top10_classes, "Other")))

class_comp_top10_other$Group <- factor(
  class_comp_top10_other$Group,
  levels = c("cf", "vo", "pg", "co")
)

cls <- sort(unique(class_comp$Class))
set2 <- brewer.pal(10, "Set3")

pal <- setNames(rep(set2, length.out = length(cls)), cls)
pal = c(pal, Other = "#9E9E9E")

sample_labels = c("cf-0-1-1" = "Bin 1-1",
                  "cf-0-1-2" = "Bin 1-2",
                  "cf-0-1-3" = "Bin 1-3",
                  "co-0-1-1" = "Bin 1-1",
                  "co-0-1-2" = "Bin 1-2",
                  "co-0-1-3" = "Bin 1-3",
                  "vo-0-1-1" = "Bin 1-1",
                  "vo-0-1-2" = "Bin 1-2",
                  "vo-0-1-3" = "Bin 1-3",
                  "pg-0-1-1" = "Bin 1-1",
                  "pg-0-1-2" = "Bin 1-2",
                  "pg-0-1-3" = "Bin 1-3",
                  "cf-2-1-1" = "Bin 1-1",
                  "cf-2-1-2" = "Bin 1-2",
                  "cf-2-1-3" = "Bin 1-3",
                  "co-2-1-1" = "Bin 1-1",
                  "co-2-1-2" = "Bin 1-2",
                  "co-2-1-3" = "Bin 1-3",
                  "vo-2-1-1" = "Bin 1-1",
                  "vo-2-1-2" = "Bin 1-2",
                  "vo-2-1-3" = "Bin 1-3",
                  "pg-2-1-1" = "Bin 1-1",
                  "pg-2-1-2" = "Bin 1-2",
                  "pg-2-1-3" = "Bin 1-3",
                  "cf-7-1-1" = "Bin 1-1",
                  "cf-7-1-2" = "Bin 1-2",
                  "cf-7-1-3" = "Bin 1-3",
                  "co-7-1-1" = "Bin 1-1",
                  "co-7-1-2" = "Bin 1-2",
                  "co-7-1-3" = "Bin 1-3",
                  "vo-7-1-1" = "Bin 1-1",
                  "vo-7-1-2" = "Bin 1-2",
                  "vo-7-1-3" = "Bin 1-3",
                  "pg-7-1-1" = "Bin 1-1",
                  "pg-7-1-2" = "Bin 1-2",
                  "pg-7-1-3" = "Bin 1-3",
                  "cf-0-2-1" = "Bin 2-1",
                  "cf-0-2-2" = "Bin 2-2",
                  "cf-0-2-3" = "Bin 2-3",
                  "co-0-2-1" = "Bin 2-1",
                  "co-0-2-2" = "Bin 2-2",
                  "co-0-2-3" = "Bin 2-3",
                  "vo-0-2-1" = "Bin 2-1",
                  "vo-0-2-2" = "Bin 2-2",
                  "vo-0-2-3" = "Bin 2-3",
                  "pg-0-2-1" = "Bin 2-1",
                  "pg-0-2-2" = "Bin 2-2",
                  "pg-0-2-3" = "Bin 2-3",
                  "cf-2-2-1" = "Bin 2-1",
                  "cf-2-2-2" = "Bin 2-2",
                  "cf-2-2-3" = "Bin 2-3",
                  "co-2-2-1" = "Bin 2-1",
                  "co-2-2-2" = "Bin 2-2",
                  "co-2-2-3" = "Bin 2-3",
                  "vo-2-2-1" = "Bin 2-1",
                  "vo-2-2-2" = "Bin 2-2",
                  "vo-2-2-3" = "Bin 2-3",
                  "pg-2-2-1" = "Bin 2-1",
                  "pg-2-2-2" = "Bin 2-2",
                  "pg-2-2-3" = "Bin 2-3",
                  "cf-7-2-1" = "Bin 2-1",
                  "cf-7-2-2" = "Bin 2-2",
                  "cf-7-2-3" = "Bin 2-3",
                  "co-7-2-1" = "Bin 2-1",
                  "co-7-2-2" = "Bin 2-2",
                  "co-7-2-3" = "Bin 2-3",
                  "vo-7-2-1" = "Bin 2-1",
                  "vo-7-2-2" = "Bin 2-2",
                  "vo-7-2-3" = "Bin 2-3",
                  "pg-7-2-1" = "Bin 2-1",
                  "pg-7-2-2" = "Bin 2-2",
                  "pg-7-2-3" = "Bin 2-3",
                  "cf-0-3-1" = "Bin 3-1",
                  "cf-0-3-2" = "Bin 3-2",
                  "cf-0-3-3" = "Bin 3-3",
                  "co-0-3-1" = "Bin 3-1",
                  "co-0-3-2" = "Bin 3-2",
                  "co-0-3-3" = "Bin 3-3",
                  "vo-0-3-1" = "Bin 3-1",
                  "vo-0-3-2" = "Bin 3-2",
                  "vo-0-3-3" = "Bin 3-3",
                  "pg-0-3-1" = "Bin 3-1",
                  "pg-0-3-2" = "Bin 3-2",
                  "pg-0-3-3" = "Bin 3-3",
                  "cf-2-3-1" = "Bin 3-1",
                  "cf-2-3-2" = "Bin 3-2",
                  "cf-2-3-3" = "Bin 3-3",
                  "co-2-3-1" = "Bin 3-1",
                  "co-2-3-2" = "Bin 3-2",
                  "co-2-3-3" = "Bin 3-3",
                  "vo-2-3-1" = "Bin 3-1",
                  "vo-2-3-2" = "Bin 3-2",
                  "vo-2-3-3" = "Bin 3-3",
                  "pg-2-3-1" = "Bin 3-1",
                  "pg-2-3-2" = "Bin 3-2",
                  "pg-2-3-3" = "Bin 3-3",
                  "cf-7-3-1" = "Bin 3-1",
                  "cf-7-3-2" = "Bin 3-2",
                  "cf-7-3-3" = "Bin 3-3",
                  "co-7-3-1" = "Bin 3-1",
                  "co-7-3-2" = "Bin 3-2",
                  "co-7-3-3" = "Bin 3-3",
                  "vo-7-3-1" = "Bin 3-1",
                  "vo-7-3-2" = "Bin 3-2",
                  "vo-7-3-3" = "Bin 3-3",
                  "pg-7-3-1" = "Bin 3-1",
                  "pg-7-3-2" = "Bin 3-2",
                  "pg-7-3-3" = "Bin 3-3")

day_labs <- class_comp_top10_other %>%
  distinct(Group, Sample, Day)

ggplot(class_comp_top10_other, aes(x = Sample, y = Abundance, fill = Class)) +
  geom_col(width = 0.9) +
  geom_vline(xintercept = 9.5, linewidth = 0.8, color = "grey20") +
  geom_vline(xintercept = 18.5, linewidth = 0.8, color = "grey20") +
  geom_text(
    data = day_labs,
    aes(x = Sample, y = Inf, label = Day),
    inherit.aes = FALSE,
    vjust = -0.4, size = 3.5, color = "grey10"
  ) +
  facet_wrap(~ Group,
             scales = "free_x",
             labeller = as_labeller(c(
               "cf" = "Chicken Feed",
               "co" = "Used Cooking Oil",
               "vo" = "Acidulated Vegetable Oil",
               "pg" = "Pork Grease")
             ),
             nrow = 1) +
  scale_x_discrete(labels = sample_labels) +
  labs(x = "Bioconversion Bin - Larval Sample", y = "Relative Abundance", fill = "Class  ") +
  scale_fill_manual(values = pal, drop = FALSE) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.02))) +
  theme_minimal(base_size = 12) +
  theme(
    panel.grid.major.x = element_blank(),
    axis.text.x = element_text(angle = 60, hjust = 1, vjust = 1, size = 14),
    strip.text.x = element_text(size = 24),
    axis.title.x = element_text(size = 24),
    axis.title.y = element_text(size = 24),
    axis.text.y = element_text(size = 20),
    legend.position = "bottom",
    legend.direction = "horizontal",
    legend.text = element_text(size = 20),
    legend.title = element_text(size = 20),
  ) +
  guides(fill = guide_legend(nrow = 1))

ggsave("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/relabun.pdf", device = "pdf", units = "in", width = 25, height = 12)

## Alpha Diversity by Day ----

# Make the Faith table match the metadata for merging

faith = faith_qza$data %>% rownames_to_column("SampleID")

# Discard samples that aren't present in the Faith file

faith_metadata = q2_metadata %>%
  left_join(faith) %>%
  filter(!is.na(faith_pd)) %>%
  filter(!str_detect(SampleID, "Initial"))

faith_metadata_il_0d = faith_metadata %>%
  filter(biocon_days_cat %in% c("initial","0"))

faith_metadata_no_il = faith_metadata %>%
  filter(biocon_days_cat %in% c("2","0", "7"))


# Run an ANOVA

faith_anova = aov(formula = faith_pd ~ diet, faith_metadata_il_0d)

faith_anova = aov(formula = faith_pd ~ biocon_days_cat, faith_metadata_no_il)

# Run the Kruskal-Wallis test
kruskal.test(faith_pd ~ diet, faith_metadata_il_0d)

kruskal.test(faith_pd ~ diet, faith_metadata_no_il)

kruskal.test(faith_pd ~ biocon_days_cat, faith_metadata_no_il)

# Significant difference between groups - continue with Dunn to see where differences are

faith_dunn = dunn.test(x = faith_metadata_il_0d$faith_pd, faith_metadata_il_0d$diet, method = "bonferroni", list = TRUE, table = TRUE)

faith_dunn = dunn.test(x = faith_metadata_no_il$faith_pd, faith_metadata_no_il$biocon_days_cat, method = "bonferroni", list = TRUE, table = TRUE)

faith_dunn_df = as.data.frame(faith_dunn$P.adjusted)

faith_dunn_df$comparison = faith_dunn$comparisons

faith_dunn_df = faith_dunn_df %>%
  rename(p.value = 'faith_dunn$P.adjusted') %>%
  mutate(
    group1 = str_trim(sapply(strsplit(comparison, " - "), `[`, 1)),
    group2 = str_trim(sapply(strsplit(comparison, " - "), `[`, 2))
  )

faith_pvals <- faith_dunn_df$p.value
names(faith_pvals) <- paste(faith_dunn_df$group1, faith_dunn_df$group2, sep = "-")

faith_letters <- multcompLetters(faith_pvals, threshold = 0.05)
faith_letters_df <- data.frame(biocon_days_cat = names(faith_letters$Letters), letter = faith_letters$Letters)
faith_letters_df

# Add letters to no_pro_faith_metadata

faith_letters_metadata = faith_metadata_no_il %>%
  group_by(biocon_days_cat) %>%
  left_join(faith_letters_df, by = "biocon_days_cat")

# Reorder to put initial first

faith_letters_metadata$biocon_days_cat = faith_letters_metadata$biocon_days_cat %>%
  factor(levels = c("0", "2", "7"))

# Make the Faith figure - Kruskal-Wallis and Dunn's Test
faith_figure = faith_letters_metadata %>%
  ggplot(aes(x = biocon_days_cat, y = faith_pd, fill = biocon_days_cat)) +
  geom_boxplot(alpha = 0.3, outlier.shape = NA) +
  geom_point(
    size = 3, alpha = 0.4,
    position = position_jitter(width = 0.15, height = 0)
  ) +
  geom_text(
    data = faith_letters_df,
    aes(x = biocon_days_cat,
        y = max(faith_letters_metadata$faith_pd) * 1.05,
        label = letter),
    size = 5,
    vjust = 0.4
  ) +
  scale_x_discrete(labels = biocon_day_labels) +
  scale_fill_manual(values = plasma_colors) +
  theme_q2r() + # There are other themes like theme_bw() or theme_classic()
  theme(axis.text.x = element_text(size = 18),
        axis.title.x = element_text(size = 20),
        axis.title.y = element_text(size = 20),
        plot.title = element_text(hjust = 0.5, size = 20),
        axis.text.y = element_text(size = 18),
        legend.position = "none"
  ) +
  labs(title = "Faith's Phylogenetic Diversity", x = "# Bioconversion Days", y = "Phylogenetic Diversity") 

ggsave("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/core_metrics/faith_figure.pdf", faith_figure, device = "pdf", units = "in", width = 5, height = 5)

# Make the evenness table match the metadata for merging

evenness = evenness_qza$data %>% rownames_to_column("SampleID")

# Discard samples that aren't present in the evenness file

evenness_metadata = q2_metadata %>%
  left_join(evenness) %>%
  filter(!is.na(pielou_evenness)) %>%
  filter(!str_detect(SampleID, "Initial"))

evenness_metadata_il_0d = evenness_metadata %>%
  filter(biocon_days_cat %in% c("initial","0"))

evenness_metadata_no_il = evenness_metadata %>%
  filter(biocon_days_cat %in% c("2","0", "7"))

# Run an ANOVA

evenness_anova = aov(formula = pielou_evenness ~ biocon_days_cat, evenness_metadata_no_il)

# Run the Kruskal-Wallis test

kruskal.test(pielou_evenness ~ diet, evenness_metadata_no_il)

kruskal.test(pielou_evenness ~ biocon_days_cat, evenness_metadata_no_il)

# Significant difference between groups - continue with Dunn to see where differences are

evenness_dunn = dunn.test(x = evenness_metadata_no_il$pielou_evenness, evenness_metadata_no_il$biocon_days_cat, method = "bonferroni", list = TRUE, table = TRUE)

evenness_dunn_df = as.data.frame(evenness_dunn$P.adjusted)

evenness_dunn_df$comparison = evenness_dunn$comparisons

evenness_dunn_df = evenness_dunn_df %>%
  rename(p.value = 'evenness_dunn$P.adjusted') %>%
  mutate(
    group1 = str_trim(sapply(strsplit(comparison, " - "), `[`, 1)),
    group2 = str_trim(sapply(strsplit(comparison, " - "), `[`, 2))
  )

evenness_pvals <- evenness_dunn_df$p.value
names(evenness_pvals) <- paste(evenness_dunn_df$group1, evenness_dunn_df$group2, sep = "-")

evenness_letters <- multcompLetters(evenness_pvals, threshold = 0.05)
evenness_letters_df <- data.frame(biocon_days_cat = names(evenness_letters$Letters), letter = evenness_letters$Letters)
evenness_letters_df

# Add letters to no_pro_evenness_metadata

evenness_letters_metadata = evenness_metadata_no_il %>%
  group_by(biocon_days_cat) %>%
  left_join(evenness_letters_df, by = "biocon_days_cat")

# Reorder to put the initials first

evenness_letters_metadata$biocon_days_cat = evenness_letters_metadata$biocon_days_cat %>%
  factor(levels = c("0", "2", "7"))

# Make the evenness figure - Kruskal-Wallis and Dunn's Test
evenness_figure = evenness_letters_metadata %>%
  ggplot(aes(x = biocon_days_cat, y = pielou_evenness, fill = biocon_days_cat)) +
  geom_boxplot(alpha = 0.3, outlier.shape = NA) +
  geom_point(
    size = 3, alpha = 0.4,
    position = position_jitter(width = 0.15, height = 0)
  ) +
  geom_text(
    data = evenness_letters_df,
    aes(x = biocon_days_cat,
        y = max(evenness_letters_metadata$pielou_evenness) * 1.05,
        label = letter),
    size = 5,
    vjust = 0.4
  ) +
  scale_x_discrete(labels = biocon_day_labels) +
  scale_fill_manual(values = plasma_colors) +
  theme_q2r() + # There are other themes like theme_bw() or theme_classic()
  theme(axis.text.x = element_text(size = 16),
        axis.title.x = element_text(size = 18),
        axis.title.y = element_text(size = 18),
        plot.title = element_text(hjust = 0.5, size = 20),
        axis.text.y = element_text(size = 16),
        legend.position = "none"
  ) +
  labs(title = "Pielou's Evenness", x = "Bioconversion Days", y = "Evenness") 

ggsave("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/core_metrics/evenness_figure.pdf", evenness_figure, device = "pdf", units = "in", width = 5, height = 5)

# Make the Shannon table match the metadata for merging

shannon = shannon_qza$data %>% rownames_to_column("SampleID")

# Discard samples that aren't present in the Shannon file

shannon_metadata = q2_metadata %>%
  left_join(shannon) %>%
  filter(!is.na(shannon_entropy)) %>%
  filter(!str_detect(SampleID, "Initial"))

shannon_metadata_il_0d = shannon_metadata %>%
  filter(biocon_days_cat %in% c("initial","0"))

shannon_metadata_no_il = shannon_metadata %>%
  filter(biocon_days_cat %in% c("2","0", "7"))

# Run an ANOVA

shannon_anova = aov(formula = shannon_entropy ~ biocon_days_cat, shannon_metadata_no_il)

# Run the Kruskal-Wallis test

kruskal.test(shannon_entropy ~ diet, shannon_metadata_no_il)

kruskal.test(shannon_entropy ~ biocon_days_cat, shannon_metadata_no_il)

# Significant difference between groups - continue with Dunn to see where differences are

shannon_dunn = dunn.test(x = shannon_metadata_no_il$shannon_entropy, shannon_metadata_no_il$biocon_days_cat, method = "bonferroni", list = TRUE, table = TRUE)

shannon_dunn_df = as.data.frame(shannon_dunn$P.adjusted)

shannon_dunn_df$comparison = shannon_dunn$comparisons

shannon_dunn_df = shannon_dunn_df %>%
  rename(p.value = 'shannon_dunn$P.adjusted') %>%
  mutate(
    group1 = str_trim(sapply(strsplit(comparison, " - "), `[`, 1)),
    group2 = str_trim(sapply(strsplit(comparison, " - "), `[`, 2))
  )

shannon_pvals <- shannon_dunn_df$p.value
names(shannon_pvals) <- paste(shannon_dunn_df$group1, shannon_dunn_df$group2, sep = "-")

shannon_letters <- multcompLetters(shannon_pvals, threshold = 0.05)
shannon_letters_df <- data.frame(biocon_days_cat = names(shannon_letters$Letters), letter = shannon_letters$Letters)
shannon_letters_df

# Add letters to no_pro_shannon_metadata

shannon_letters_metadata = shannon_metadata_no_il %>%
  group_by(biocon_days_cat) %>%
  left_join(shannon_letters_df, by = "biocon_days_cat")

# Reorder to put initial first

shannon_letters_metadata$biocon_days_cat = shannon_letters_metadata$biocon_days_cat %>%
  factor(levels = c("0", "2", "7"))

# Make the Shannon figure - Kruskal-Wallis and Dunn's Test
shannon_figure = shannon_letters_metadata %>%
  ggplot(aes(x = biocon_days_cat, y = shannon_entropy, fill = biocon_days_cat)) +
  geom_boxplot(alpha = 0.3, outlier.shape = NA) +
  geom_point(
    size = 3, alpha = 0.4,
    position = position_jitter(width = 0.15, height = 0)
  ) +
  geom_text(
    data = shannon_letters_df,
    aes(x = biocon_days_cat,
        y = max(shannon_letters_metadata$shannon_entropy) * 1.05,
        label = letter),
    size = 5,
    vjust = 0.4
  ) +
  scale_x_discrete(labels = biocon_day_labels) +
  scale_fill_manual(values = plasma_colors) +
  theme_q2r() + # There are other themes like theme_bw() or theme_classic()
  theme(axis.text.x = element_text(size = 16),
        axis.title.x = element_text(size = 18),
        axis.title.y = element_text(size = 18),
        plot.title = element_text(hjust = 0.5, size = 20),
        axis.text.y = element_text(size = 16),
        legend.position = "none"
  ) +
  labs(title = "Shannon's Entropy", x = "Bioconversion Days", y = "Entropy") 

ggsave("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/core_metrics/shannon_figure.pdf", shannon_figure, device = "pdf", units = "in", width = 5, height = 5)

 ## Day Comparison Alpha Diversity ----
# Make the Faith table match the metadata for merging

# Discard initial samples

faith_metadata = q2_metadata %>%
  left_join(faith) %>%
  filter(!is.na(faith_pd)) %>%
  filter(diet != "initial")

# Run an ANOVA

faith_anova = aov(formula = faith_pd ~ diet + biocon_days_cat, faith_metadata)

# Run the Kruskal-Wallis test
kruskal.test(faith_pd ~ diet, faith_metadata)

# Significant difference between groups - continue with Dunn to see where differences are

faith_dunn = dunn.test(x = faith_metadata$faith_pd, faith_metadata$diet, method = "bonferroni", list = TRUE, table = TRUE)

faith_dunn_df = as.data.frame(faith_dunn$P.adjusted)

faith_dunn_df$comparison = faith_dunn$comparisons

faith_dunn_df = faith_dunn_df %>%
  rename(p.value = 'faith_dunn$P.adjusted') %>%
  mutate(
    group1 = str_trim(sapply(strsplit(comparison, " - "), `[`, 1)),
    group2 = str_trim(sapply(strsplit(comparison, " - "), `[`, 2))
  )

faith_pvals <- faith_dunn_df$p.value
names(faith_pvals) <- paste(faith_dunn_df$group1, faith_dunn_df$group2, sep = "-")

faith_letters <- multcompLetters(faith_pvals, threshold = 0.05)
faith_letters_df <- data.frame(diet = names(faith_letters$Letters), letter = faith_letters$Letters)
faith_letters_df

# Add letters to no_pro_evenness_metadata

faith_letters_metadata = faith_metadata %>%
  group_by(diet) %>%
  left_join(faith_letters_df, by = "diet")

# Biocon Days by Diet

faith_dunn <- faith_letters_metadata %>%
  mutate(
    diet = factor(diet),
    biocon_days_cat = factor(biocon_days_cat)
  ) %>%
  split(.$diet) %>%
  map(~ dunn.test(
    x     = .x$faith_pd,
    g     = .x$biocon_days_cat,
    method = "bonferroni",
    list  = TRUE,
    table = TRUE
  ))

# Reorder the diets for the figure

faith_letters_metadata$diet <- factor(
  faith_letters_metadata$diet,
  levels = c("chicken_feed", "vegetable_oil", "pig_grease", "cooking_oil")
)

# Make the evenness figure - Kruskal-Wallis and Dunn's Test
faith_figure = faith_letters_metadata %>%
  ggplot(aes(x = biocon_days_cat, y = faith_pd, fill = diet)) +
  geom_boxplot(alpha = 0.3, outlier.shape = NA) +
  geom_point(
    size = 3, alpha = 1.0,
    position = position_jitter(width = 0.15, height = 0)
  ) +
  facet_wrap(~ diet, nrow = 1, 
             scales = "free_x", 
             labeller = as_labeller(c(
               "chicken_feed" = "CF",
               "cooking_oil" = "UCO",
               "vegetable_oil" = "AVO",
               "pig_grease" = "PG")
             ),) +
  scale_fill_manual(values = viridis_colors) +
  theme_q2r() +
  theme(
    axis.text.x  = element_text(hjust = 1, size = 20),
    axis.title.x = element_text(size = 22),
    axis.title.y = element_text(size = 22),
    plot.title   = element_text(hjust = 0.5, size = 24),
    axis.text.y  = element_text(size = 20),
    legend.position = "none",
    strip.text.x = element_text(size = 20)
  ) +
  labs(
    title = "Faith's Phylogenetic Diversity",
    x = "# Bioconversion Days",
    y = "Phylogenetic Diversity"
  ) +
  ylim(12, 39)

ggsave("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/d0/faith_figure.pdf", faith_figure, device = "pdf", units = "in", width = 8, height = 6)

# Make the evenness table match the metadata for merging

# Discard initial samples

evenness_metadata = q2_metadata %>%
  left_join(evenness) %>%
  filter(!is.na(pielou_evenness)) %>%
  filter(diet != "initial")

# Run an ANOVA

evenness_anova = aov(formula = pielou_evenness ~ diet + biocon_days_cat, evenness_metadata)

# Run the Kruskal-Wallis test
kruskal.test(pielou_evenness ~ diet, evenness_metadata)

# Significant difference between groups - continue with Dunn to see where differences are

evenness_dunn = dunn.test(x = evenness_metadata$pielou_evenness, evenness_metadata$diet, method = "bonferroni", list = TRUE, table = TRUE)

evenness_dunn_df = as.data.frame(evenness_dunn$P.adjusted)

evenness_dunn_df$comparison = evenness_dunn$comparisons

evenness_dunn_df = evenness_dunn_df %>%
  rename(p.value = 'evenness_dunn$P.adjusted') %>%
  mutate(
    group1 = str_trim(sapply(strsplit(comparison, " - "), `[`, 1)),
    group2 = str_trim(sapply(strsplit(comparison, " - "), `[`, 2))
  )

evenness_pvals <- evenness_dunn_df$p.value
names(evenness_pvals) <- paste(evenness_dunn_df$group1, evenness_dunn_df$group2, sep = "-")

evenness_letters <- multcompLetters(evenness_pvals, threshold = 0.05)
evenness_letters_df <- data.frame(diet = names(evenness_letters$Letters), letter = evenness_letters$Letters)
evenness_letters_df

# Add letters to no_pro_evenness_metadata

evenness_letters_metadata = evenness_metadata %>%
  group_by(diet) %>%
  left_join(evenness_letters_df, by = "diet")

# Biocon Days by Diet

evenness_dunn <- evenness_letters_metadata %>%
  mutate(
    diet = factor(diet),
    biocon_days_cat = factor(biocon_days_cat)
  ) %>%
  split(.$diet) %>%
  map(~ dunn.test(
    x     = .x$pielou_evenness,
    g     = .x$biocon_days_cat,
    method = "bonferroni",
    list  = TRUE,
    table = TRUE
  ))

# Reorder the diets for the figure

evenness_letters_metadata$diet <- factor(
  evenness_letters_metadata$diet,
  levels = c("chicken_feed", "vegetable_oil", "pig_grease", "cooking_oil")
)

# Make the evenness figure - Kruskal-Wallis and Dunn's Test
evenness_figure = evenness_letters_metadata %>%
  ggplot(aes(x = biocon_days_cat, y = pielou_evenness, fill = diet)) +
  geom_boxplot(alpha = 0.3, outlier.shape = NA) +
  geom_point(
    size = 3, alpha = 1.0,
    position = position_jitter(width = 0.15, height = 0)
  ) +
  facet_wrap(~ diet, nrow = 1, 
             scales = "free_x", 
             labeller = as_labeller(c(
               "chicken_feed" = "CF",
               "cooking_oil" = "UCO",
               "vegetable_oil" = "AVO",
               "pig_grease" = "PG")
             ),) +
  scale_fill_manual(values = viridis_colors) +
  theme_q2r() +
  theme(
    axis.text.x  = element_text(hjust = 1, size = 20),
    axis.title.x = element_text(size = 22),
    axis.title.y = element_text(size = 22),
    plot.title   = element_text(hjust = 0.5, size = 24),
    axis.text.y  = element_text(size = 20),
    legend.position = "none",
    strip.text.x = element_text(size = 20)
  ) +
  labs(
    title = "Pielou's Evenness",
    x = "# Bioconversion Days",
    y = "Evenness"
  ) +
  ylim(0.35, 0.8)

ggsave("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/d0/evenness_figure.pdf", evenness_figure, device = "pdf", units = "in", width = 8, height = 6)

# Make the Shannon table match the metadata for merging

# Discard initial samples

shannon_metadata = q2_metadata %>%
  left_join(shannon) %>%
  filter(!is.na(shannon_entropy)) %>%
  filter(diet != "initial")

# Run an ANOVA

shannon_anova = aov(formula = shannon_entropy ~ diet + biocon_days_cat, shannon_metadata)

# Run the Kruskal-Wallis test
kruskal.test(shannon_entropy ~ diet, shannon_metadata)

# Significant difference between groups - continue with Dunn to see where differences are

shannon_dunn = dunn.test(x = shannon_metadata$shannon_entropy, shannon_metadata$diet, method = "bonferroni", list = TRUE, table = TRUE)

shannon_dunn_df = as.data.frame(shannon_dunn$P.adjusted)

shannon_dunn_df$comparison = shannon_dunn$comparisons

shannon_dunn_df = shannon_dunn_df %>%
  rename(p.value = 'shannon_dunn$P.adjusted') %>%
  mutate(
    group1 = str_trim(sapply(strsplit(comparison, " - "), `[`, 1)),
    group2 = str_trim(sapply(strsplit(comparison, " - "), `[`, 2))
  )

shannon_pvals <- shannon_dunn_df$p.value
names(shannon_pvals) <- paste(shannon_dunn_df$group1, shannon_dunn_df$group2, sep = "-")

shannon_letters <- multcompLetters(shannon_pvals, threshold = 0.05)
shannon_letters_df <- data.frame(diet = names(shannon_letters$Letters), letter = shannon_letters$Letters)
shannon_letters_df

# Biocon Days by Diet

shannon_dunn <- shannon_metadata %>%
  mutate(
    diet = factor(diet),
    biocon_days_cat = factor(biocon_days_cat)
  ) %>%
  split(.$diet) %>%
  map(~ dunn.test(
    x     = .x$shannon_entropy,
    g     = .x$biocon_days_cat,
    method = "bonferroni",
    list  = TRUE,
    table = TRUE
  ))


# Add letters to no_pro_shannon_metadata

shannon_letters_metadata = shannon_metadata %>%
  group_by(diet) %>%
  left_join(shannon_letters_df, by = "diet")

# Reorder the diets for the figure

shannon_letters_metadata$diet <- factor(
  shannon_letters_metadata$diet,
  levels = c("chicken_feed", "vegetable_oil", "pig_grease", "cooking_oil")
)


# Make the Shannon figure - Kruskal-Wallis and Dunn's Test
shannon_figure = shannon_metadata %>%
  ggplot(aes(x = biocon_days_cat, y = shannon_entropy, fill = diet)) +
  geom_boxplot(alpha = 0.3, outlier.shape = NA) +
  geom_point(
    size = 3, alpha = 1.0,
    position = position_jitter(width = 0.15, height = 0)
  ) +
  facet_wrap(~ diet, nrow = 1, 
             scales = "free_x", 
             labeller = as_labeller(c(
               "chicken_feed" = "CF",
               "cooking_oil" = "UCO",
               "vegetable_oil" = "AVO",
               "pig_grease" = "PG")
             ),) +
  scale_fill_manual(values = viridis_colors) +
  theme_q2r() +
  theme(
    axis.text.x  = element_text(hjust = 1, size = 20),
    axis.title.x = element_text(size = 22),
    axis.title.y = element_text(size = 22),
    plot.title   = element_text(hjust = 0.5, size = 24),
    axis.text.y  = element_text(size = 20),
    legend.position = "none",
    strip.text.x = element_text(size = 20)
  ) +
  labs(
    title = "Shannon's Entropy",
    x = "# Bioconversion Days",
    y = "Entropy"
  ) +
  ylim(2, 5)

ggsave("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/d0/shannon_figure.pdf", shannon_figure, device = "pdf", units = "in", width = 8, height = 6)

## ADONIS Testing ----

overall_dm = read_qza("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/core_metrics/unweighted_unifrac_distance_matrix.qza")

dm_mat <- as.matrix(overall_dm$data)
dm_ids <- rownames(dm_mat)

meta <- q2_metadata %>%
  dplyr::filter(SampleID %in% dm_ids) %>%
  dplyr::slice(match(dm_ids, SampleID)) %>%
  tibble::column_to_rownames("SampleID")

dm <- as.dist(dm_mat[dm_ids, dm_ids])

adonis2(dm ~ diet, data = meta, by = "margin")
adonis2(dm ~ biocon_days_cat, data = meta, by = "margin")
adonis2(dm ~ diet_bin_rep, data = meta, by = "margin")

adonis2(dm ~ diet + diet_bin_rep, data = meta, by = "margin")
adonis2(dm ~ biocon_days_cat + diet, data = meta, by = "margin")
adonis2(dm ~ biocon_days_cat + diet_bin_rep, data = meta, by = "margin")

adonis2(dm ~ biocon_days_cat + diet_bin_rep + diet, data = meta, by = "margin")

## ADONIS Day 0 ----

dm = read_qza("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/d0/unweighted_unifrac_distance_matrix.qza")

dm_mat <- as.matrix(dm$data)
dm_ids <- rownames(dm_mat)

meta <- q2_metadata %>%
  dplyr::filter(SampleID %in% dm_ids) %>%
  dplyr::slice(match(dm_ids, SampleID)) %>%
  tibble::column_to_rownames("SampleID")

dm <- as.dist(dm_mat[dm_ids, dm_ids])

adonis2(dm ~ diet, data = meta, by = "margin")
adonis2(dm ~ diet_bin_rep, data = meta, by = "margin")

adonis2(dm ~ diet + diet_bin_rep, data = meta, by = "margin")

## ADONIS Day 2 ----

dm = read_qza("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/d2/unweighted_unifrac_distance_matrix.qza")

dm_mat <- as.matrix(dm$data)
dm_ids <- rownames(dm_mat)

meta <- q2_metadata %>%
  dplyr::filter(SampleID %in% dm_ids) %>%
  dplyr::slice(match(dm_ids, SampleID)) %>%
  tibble::column_to_rownames("SampleID")

dm <- as.dist(dm_mat[dm_ids, dm_ids])

adonis2(dm ~ diet, data = meta, by = "margin")
adonis2(dm ~ diet_bin_rep, data = meta, by = "margin")

adonis2(dm ~ diet + diet_bin_rep, data = meta, by = "margin")

## ADONIS Day 7 ----

dm = read_qza("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/d7/unweighted_unifrac_distance_matrix.qza")

dm_mat <- as.matrix(dm$data)
dm_ids <- rownames(dm_mat)

meta <- q2_metadata %>%
  dplyr::filter(SampleID %in% dm_ids) %>%
  dplyr::slice(match(dm_ids, SampleID)) %>%
  tibble::column_to_rownames("SampleID")

dm <- as.dist(dm_mat[dm_ids, dm_ids])

adonis2(dm ~ diet, data = meta, by = "margin")
adonis2(dm ~ diet_bin_rep, data = meta, by = "margin")

adonis2(dm ~ diet + diet_bin_rep, data = meta, by = "margin")

## Life History Data ----

life_history<-read.table("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/life_history/BSF_Commercial_Traits_Oil Exp.csv", sep=",", header=TRUE)
life_history$Replicate <- as.factor(life_history$Replicate)

##NURSERY PHASE
aov1<-aov(life_history$LarvalMass_N~life_history$Treatment, life_historya=life_history); summary(aov1) ##ns
aov2<-aov(life_history$DietMass_N~life_history$Treatment, life_historya=life_history); summary(aov2) ##ns
aov3<-aov(life_history$BCR_N~life_history$Treatment, life_historya=life_history); summary(aov3) ##ns
aov4<-aov(life_history$DietMassLoss_N~life_history$Treatment, life_historya=life_history); summary(aov4) ##ns
aov5<-aov(life_history$NetLarvalGain_N~life_history$Treatment, life_historya=life_history); summary(aov5) ##ns

##BIOCONVERSION PHASE
aov6<-aov(life_history$LarvalMass_B~life_history$Treatment, life_historya=life_history); summary(aov6) ##SIG
aov7<-aov(life_history$DietMass_B~life_history$Treatment, life_historya=life_history); summary(aov7) ##ns
aov8<-aov(life_history$BCR_B~life_history$Treatment, life_historya=life_history); summary(aov8) ##SIG
aov9<-aov(life_history$DietMassLoss_B~life_history$Treatment, life_historya=life_history); summary(aov9) ##ns
aov10<-aov(life_history$NetLarvalGain_B~life_history$Treatment, life_historya=life_history); summary(aov10) ##ns



larval_mass_n_tukey = TukeyHSD(aov1)
diet_mass_n_tukey = TukeyHSD(aov2)
bcr_n_tukey = TukeyHSD(aov3)
diet_mass_loss_n_tukey = TukeyHSD(aov4)
net_larval_gain_n_tukey = TukeyHSD(aov5)

larval_mass_tukey = TukeyHSD(aov6) ##VO-CO (0.016), VO-NC (0.012), VO-PG (0.008)
diet_mass_b_tukey = TukeyHSD(aov7)
bcr_tukey = TukeyHSD(aov8) ##VO-CO (0.016), VO-NC (0.012), VO-PG (0.008)
diet_mass_loss_b_tukey = TukeyHSD(aov9)
net_larval_gain_b_tukey = TukeyHSD(aov10)

##OVERALL
aov11<-aov(life_history$NetLarvalGain_Overall~life_history$Treatment, life_historya=life_history); summary(aov11) ##SIG
larval_gain_tukey = TukeyHSD(aov11) ##VO-CO (0.014), VO-NC (0.012), VO-PG (0.007)

##BOXPLOTS

life_history$Treatment<-factor(life_history$Treatment, levels = c("NC", "VO", "PG", "CO"))

lh_diet_labels = c("NC" = "CF",
                   "VO" = "AVO",
                   "PG" = "PG",
                   "CO" = "UCO")

lh_diet_levels = names(lh_diet_labels)

viridis_colors_lh = c("initial" = "#440154",
                   "NC" = "#3B528B",
                   "VO" = "#21918C",
                   "PG" = "#5DC863",
                   "CO" = "#FDE725")


## Larval Mass Graph ----

# Significant difference between groups - continue with Dunn to see where differences are

larval_mass_tukey_df = as.data.frame(larval_mass_tukey$`life_history$Treatment`)

larval_mass_pvals <- larval_mass_tukey_df$`p adj`
names(larval_mass_pvals) <- row.names(larval_mass_tukey_df)

larval_mass_letters <- multcompLetters(larval_mass_pvals, threshold = 0.05)
larval_mass_letters_df <- data.frame(Treatment = names(larval_mass_letters$Letters), letter = larval_mass_letters$Letters)
larval_mass_letters_df

# Add letters to no_pro_larval_mass_metadata

larval_mass_letters_metadata = life_history %>%
  group_by(Treatment) %>%
  left_join(larval_mass_letters_df, by = "Treatment")

# Reorder the diets for the figure

larval_mass_letters_metadata$Treatment <- factor(
  larval_mass_letters_metadata$Treatment,
  levels = c("NC", "VO", "PG", "CO")
)


larval_mass_graph <- ggplot(life_history, aes(x=Treatment, y=LarvalMass_B, fill = Treatment)) + 
  geom_boxplot(outlier.colour="red", outlier.shape=8, outlier.size=4, alpha = 0.3) +
  geom_point(
    size = 3, alpha = 1.0,
    position = position_jitter(width = 0.15, height = 0)
  ) +
  geom_text(
    data = larval_mass_letters_df,
    aes(x = Treatment,
        y = max(larval_mass_letters_metadata$LarvalMass_B) * 1.18,
        label = letter),
    size = 5,
    vjust = 0.4
  ) +
  labs(title = "Bioconversion Phase\nLarval Mass",
       x="Treatment", 
       y="Mass (g)")+
  scale_fill_manual(values = viridis_colors_lh,
                    labels = lh_diet_labels) +
  scale_x_discrete(labels = lh_diet_labels) +
  theme_q2r() +
  theme(
    axis.text.x  = element_text(size = 16),
    axis.title.x = element_text(size = 18),
    axis.title.y = element_text(size = 18),
    plot.title   = element_text(hjust = 0.5, size = 20),
    axis.text.y  = element_text(size = 16),
    legend.position = "none",
    strip.text.x = element_text(size = 16)
  ) +
  ylim(150,650)

ggsave("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/larval_mass_graph.pdf", larval_mass_graph, device = "pdf", units = "in", width = 4, height = 6)

## BCR Graph ----

# Significant difference between groups - continue with Dunn to see where differences are

bcr_tukey_df = as.data.frame(bcr_tukey$`life_history$Treatment`)

bcr_pvals <- bcr_tukey_df$`p adj`
names(bcr_pvals) <- row.names(bcr_tukey_df)

bcr_letters <- multcompLetters(bcr_pvals, threshold = 0.05)
bcr_letters_df <- data.frame(Treatment = names(bcr_letters$Letters), letter = bcr_letters$Letters)
bcr_letters_df

# Add letters to no_pro_bcr_metadata

bcr_letters_metadata = life_history %>%
  group_by(Treatment) %>%
  left_join(bcr_letters_df, by = "Treatment")

# Reorder the diets for the figure

bcr_letters_metadata$Treatment <- factor(
  bcr_letters_metadata$Treatment,
  levels = c("NC", "VO", "PG", "CO")
)


BCR_graph <- ggplot(life_history, aes(x=Treatment, y=BCR_B, fill = Treatment)) + 
  geom_boxplot(outlier.colour="red", outlier.shape=8, outlier.size=4, alpha = 0.3) +
  geom_point(size = 3, alpha = 1.0,
             position = position_jitter(width = 0.15, height = 0)) +
  geom_text(
    data = bcr_letters_df,
    aes(x = Treatment,
        y = max(bcr_letters_metadata$BCR_B) * 1.09,
        label = letter),
    size = 5,
    vjust = 0.4
  ) +
  labs(title = "Bioconversion Phase\nBioconversion Rate",
       x="Treatment", 
       y="Bioconversion Rate"
       )+
    scale_fill_manual(values = viridis_colors_lh,
                      labels = lh_diet_labels) +
  scale_x_discrete(labels = lh_diet_labels) +
    theme_q2r() +
    theme(
      axis.text.x  = element_text(size = 16),
      axis.title.x = element_text(size = 18),
      axis.title.y = element_text(size = 18),
      plot.title   = element_text(hjust = 0.5, size = 20),
      axis.text.y  = element_text(size = 16),
      legend.position = "none",
      strip.text.x = element_text(size = 16)
    ) +
    ylim(50,150)

ggsave("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/BCR_graph.pdf", BCR_graph, device = "pdf", units = "in", width = 4, height = 6)

## Larval Net Gain Graph ----

# Significant difference between groups - continue with Dunn to see where differences are

larval_gain_tukey_df = as.data.frame(larval_gain_tukey$`life_history$Treatment`)

larval_gain_pvals <- larval_gain_tukey_df$`p adj`
names(larval_gain_pvals) <- row.names(larval_gain_tukey_df)

larval_gain_letters <- multcompLetters(larval_gain_pvals, threshold = 0.05)
larval_gain_letters_df <- data.frame(Treatment = names(larval_gain_letters$Letters), letter = larval_gain_letters$Letters)
larval_gain_letters_df

# Add letters to no_pro_larval_gain_metadata

larval_gain_letters_metadata = life_history %>%
  group_by(Treatment) %>%
  left_join(larval_gain_letters_df, by = "Treatment")

# Reorder the diets for the figure

larval_gain_letters_metadata$Treatment <- factor(
  larval_gain_letters_metadata$Treatment,
  levels = c("NC", "VO", "PG", "CO")
)


larval_gain_graph <- ggplot(life_history, aes(x=Treatment, y=NetLarvalGain_Overall, fill = Treatment)) + 
  geom_boxplot(outlier.colour="red", outlier.shape=8, outlier.size=4, alpha = 0.3) +
  geom_point(size = 3, alpha = 1.0,
             position = position_jitter(width = 0.15, height = 0)) +
  geom_text(
    data = bcr_letters_df,
    aes(x = Treatment,
        y = max(larval_gain_letters_metadata$NetLarvalGain_Overall) * 1.15,
        label = letter),
    size = 5,
    vjust = 0.4
  ) +
  labs(title = "Net Larval Gain\n",
       x="Treatment", 
       y="Overall Net Larval Gain (g)")+
  scale_fill_manual(values = viridis_colors_lh,
                    labels = lh_diet_labels) +
  scale_x_discrete(labels = lh_diet_labels) +
  theme_q2r() +
  theme(
    axis.text.x  = element_text(size = 16),
    axis.title.x = element_text(size = 18),
    axis.title.y = element_text(size = 18),
    plot.title   = element_text(hjust = 0.5, size = 20),
    axis.text.y  = element_text(size = 16),
    legend.position = "none",
    strip.text.x = element_text(size = 16)
  ) +
  ylim(150,600)

ggsave("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/larval_gain_graph.pdf", larval_gain_graph, device = "pdf", units = "in", width = 4, height = 6)

# Larval Mass N Graph ----

# Significant difference between groups - continue with Dunn to see where differences are

larval_mass_n_tukey_df = as.data.frame(larval_mass_n_tukey$`life_history$Treatment`)

larval_mass_n_pvals <- larval_mass_n_tukey_df$`p adj`
names(larval_mass_n_pvals) <- row.names(larval_mass_n_tukey_df)

larval_mass_n_letters <- multcompLetters(larval_mass_n_pvals, threshold = 0.05)
larval_mass_n_letters_df <- data.frame(Treatment = names(larval_mass_n_letters$Letters), letter = larval_mass_n_letters$Letters)
larval_mass_n_letters_df

# Add letters to no_pro_larval_mass_n_metadata

larval_mass_n_letters_metadata = life_history %>%
  group_by(Treatment) %>%
  left_join(larval_mass_n_letters_df, by = "Treatment")

# Reorder the diets for the figure

life_history$Treatment <- factor(
  life_history$Treatment,
  levels = c("NC", "VO", "PG", "CO")
)


larval_mass_n_graph <- ggplot(life_history, aes(x=Treatment, y=LarvalMass_N, fill = Treatment)) + 
  geom_boxplot(outlier.colour="red", outlier.shape=8, outlier.size=4, alpha = 0.3) +
  geom_point(size = 3, alpha = 1.0,
             position = position_jitter(width = 0.15, height = 0)) +
  geom_text(
    data = larval_mass_n_letters_df,
    aes(x = Treatment,
        y = max(larval_mass_n_letters_metadata$LarvalMass_N) * 1.15,
        label = letter),
    size = 5,
    vjust = 0.4
  ) +
  labs(title = "Nursery Phase\nLarval Mass",
       x="Treatment", 
       y="Mass (g)")+
  scale_fill_manual(values = viridis_colors_lh,
                    labels = lh_diet_labels) +
  scale_x_discrete(labels = lh_diet_labels) +
  theme_q2r() +
  theme(
    axis.text.x  = element_text(size = 16),
    axis.title.x = element_text(size = 18),
    axis.title.y = element_text(size = 18),
    plot.title   = element_text(hjust = 0.5, size = 20),
    axis.text.y  = element_text(size = 16),
    legend.position = "none",
    strip.text.x = element_text(size = 16)
  ) #+
  #ylim(150,600)

ggsave("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/larval_mass_n_graph.pdf", larval_mass_n_graph, device = "pdf", units = "in", width = 4, height = 6)

##

# Diet Mass N Graph ----

# Significant difference between groups - continue with Dunn to see where differences are

diet_mass_n_tukey_df = as.data.frame(diet_mass_n_tukey$`life_history$Treatment`)

diet_mass_n_pvals <- diet_mass_n_tukey_df$`p adj`
names(diet_mass_n_pvals) <- row.names(diet_mass_n_tukey_df)

diet_mass_n_letters <- multcompLetters(diet_mass_n_pvals, threshold = 0.05)
diet_mass_n_letters_df <- data.frame(Treatment = names(diet_mass_n_letters$Letters), letter = diet_mass_n_letters$Letters)
diet_mass_n_letters_df

# Add letters to no_pro_diet_mass_n_metadata

diet_mass_n_letters_metadata = life_history %>%
  group_by(Treatment) %>%
  left_join(diet_mass_n_letters_df, by = "Treatment")

# Reorder the diets for the figure

life_history$Treatment <- factor(
  life_history$Treatment,
  levels = c("NC", "VO", "PG", "CO")
)


diet_mass_n_graph <- ggplot(life_history, aes(x=Treatment, y=DietMass_N, fill = Treatment)) + 
  geom_boxplot(outlier.colour="red", outlier.shape=8, outlier.size=4, alpha = 0.3) +
  geom_point(size = 3, alpha = 1.0,
             position = position_jitter(width = 0.15, height = 0)) +
  geom_text(
    data = diet_mass_n_letters_df,
    aes(x = Treatment,
        y = max(diet_mass_n_letters_metadata$DietMass_N) * 1.15,
        label = letter),
    size = 5,
    vjust = 0.4
  ) +
  labs(title = "Nursery Phase\nDiet Mass",
       x="Treatment", 
       y="Mass (g)")+
  scale_fill_manual(values = viridis_colors_lh,
                    labels = lh_diet_labels) +
  scale_x_discrete(labels = lh_diet_labels) +
  theme_q2r() +
  theme(
    axis.text.x  = element_text(size = 16),
    axis.title.x = element_text(size = 18),
    axis.title.y = element_text(size = 18),
    plot.title   = element_text(hjust = 0.5, size = 20),
    axis.text.y  = element_text(size = 16),
    legend.position = "none",
    strip.text.x = element_text(size = 16)
  ) #+
#ylim(150,600)

ggsave("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/diet_mass_n_graph.pdf", diet_mass_n_graph, device = "pdf", units = "in", width = 4, height = 6)

# BCR N Graph ----

# Significant difference between groups - continue with Dunn to see where differences are

bcr_n_tukey_df = as.data.frame(bcr_n_tukey$`life_history$Treatment`)

bcr_n_pvals <- bcr_n_tukey_df$`p adj`
names(bcr_n_pvals) <- row.names(bcr_n_tukey_df)

bcr_n_letters <- multcompLetters(bcr_n_pvals, threshold = 0.05)
bcr_n_letters_df <- data.frame(Treatment = names(bcr_n_letters$Letters), letter = bcr_n_letters$Letters)
bcr_n_letters_df

# Add letters to no_pro_bcr_n_metadata

bcr_n_letters_metadata = life_history %>%
  group_by(Treatment) %>%
  left_join(bcr_n_letters_df, by = "Treatment")

# Reorder the diets for the figure

life_history$Treatment <- factor(
  life_history$Treatment,
  levels = c("NC", "VO", "PG", "CO")
)


bcr_n_graph <- ggplot(life_history, aes(x=Treatment, y=BCR_N, fill = Treatment)) + 
  geom_boxplot(outlier.colour="red", outlier.shape=8, outlier.size=4, alpha = 0.3) +
  geom_point(size = 3, alpha = 1.0,
             position = position_jitter(width = 0.15, height = 0)) +
  geom_text(
    data = bcr_n_letters_df,
    aes(x = Treatment,
        y = max(bcr_n_letters_metadata$BCR_N) * 1.15,
        label = letter),
    size = 5,
    vjust = 0.4
  ) +
  labs(title = "Nursery Phase\nBioconversion Rate",
       x="Treatment", 
       y="Bioconversion Rate")+
  scale_fill_manual(values = viridis_colors_lh,
                    labels = lh_diet_labels) +
  scale_x_discrete(labels = lh_diet_labels) +
  theme_q2r() +
  theme(
    axis.text.x  = element_text(size = 16),
    axis.title.x = element_text(size = 18),
    axis.title.y = element_text(size = 18),
    plot.title   = element_text(hjust = 0.5, size = 20),
    axis.text.y  = element_text(size = 16),
    legend.position = "none",
    strip.text.x = element_text(size = 16)
  ) #+
#ylim(150,600)

ggsave("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/bcr_n_graph.pdf", bcr_n_graph, device = "pdf", units = "in", width = 4, height = 6)

# Diet Mass Loss N Graph ----

# Significant difference between groups - continue with Dunn to see where differences are

diet_mass_loss_n_tukey_df = as.data.frame(diet_mass_loss_n_tukey$`life_history$Treatment`)

diet_mass_loss_n_pvals <- diet_mass_loss_n_tukey_df$`p adj`
names(diet_mass_loss_n_pvals) <- row.names(diet_mass_loss_n_tukey_df)

diet_mass_loss_n_letters <- multcompLetters(diet_mass_loss_n_pvals, threshold = 0.05)
diet_mass_loss_n_letters_df <- data.frame(Treatment = names(diet_mass_loss_n_letters$Letters), letter = diet_mass_loss_n_letters$Letters)
diet_mass_loss_n_letters_df

# Add letters to no_pro_diet_mass_loss_n_metadata

diet_mass_loss_n_letters_metadata = life_history %>%
  group_by(Treatment) %>%
  left_join(diet_mass_loss_n_letters_df, by = "Treatment")

# Reorder the diets for the figure

life_history$Treatment <- factor(
  life_history$Treatment,
  levels = c("NC", "VO", "PG", "CO")
)


diet_mass_loss_n_graph <- ggplot(life_history, aes(x = Treatment, y = DietMassLoss_N, fill = Treatment)) + 
  geom_boxplot(outlier.colour="red", outlier.shape=8, outlier.size=4, alpha = 0.3) +
  geom_point(size = 3, alpha = 1.0,
             position = position_jitter(width = 0.15, height = 0)) +
  geom_text(
    data = diet_mass_loss_n_letters_df,
    aes(x = Treatment,
        y = max(diet_mass_loss_n_letters_metadata$DietMassLoss_N) * 1.15,
        label = letter),
    size = 5,
    vjust = 0.4
  ) +
  labs(title = "Nursery Phase\nDiet Mass Loss",
       x="Treatment", 
       y="Mass (g)")+
  scale_fill_manual(values = viridis_colors_lh,
                    labels = lh_diet_labels) +
  scale_x_discrete(labels = lh_diet_labels) +
  theme_q2r() +
  theme(
    axis.text.x  = element_text(size = 16),
    axis.title.x = element_text(size = 18),
    axis.title.y = element_text(size = 18),
    plot.title   = element_text(hjust = 0.5, size = 20),
    axis.text.y  = element_text(size = 16),
    legend.position = "none",
    strip.text.x = element_text(size = 16)
  ) #+
#ylim(150,600)

ggsave("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/diet_mass_loss_n_graph.pdf", diet_mass_loss_n_graph, device = "pdf", units = "in", width = 4, height = 6)

# Net Larval Gain N Graph ----

# Significant difference between groups - continue with Dunn to see where differences are

net_larval_gain_n_tukey_df = as.data.frame(net_larval_gain_n_tukey$`life_history$Treatment`)

net_larval_gain_n_pvals <- net_larval_gain_n_tukey_df$`p adj`
names(net_larval_gain_n_pvals) <- row.names(net_larval_gain_n_tukey_df)

net_larval_gain_n_letters <- multcompLetters(net_larval_gain_n_pvals, threshold = 0.05)
net_larval_gain_n_letters_df <- data.frame(Treatment = names(net_larval_gain_n_letters$Letters), letter = net_larval_gain_n_letters$Letters)
net_larval_gain_n_letters_df

# Add letters to no_pro_net_larval_gain_n_metadata

net_larval_gain_n_letters_metadata = life_history %>%
  group_by(Treatment) %>%
  left_join(net_larval_gain_n_letters_df, by = "Treatment")

# Reorder the diets for the figure

life_history$Treatment <- factor(
  life_history$Treatment,
  levels = c("NC", "VO", "PG", "CO")
)


net_larval_gain_n_graph <- ggplot(life_history, aes(x = Treatment, y = NetLarvalGain_N, fill = Treatment)) + 
  geom_boxplot(outlier.colour="red", outlier.shape=8, outlier.size=4, alpha = 0.3) +
  geom_point(size = 3, alpha = 1.0,
             position = position_jitter(width = 0.15, height = 0)) +
  geom_text(
    data = net_larval_gain_n_letters_df,
    aes(x = Treatment,
        y = max(net_larval_gain_n_letters_metadata$NetLarvalGain_N) * 1.15,
        label = letter),
    size = 5,
    vjust = 0.4
  ) +
  labs(title = "Nursery Phase\nLarval Gain",
       x="Treatment", 
       y="Mass (g)")+
  scale_fill_manual(values = viridis_colors_lh,
                    labels = lh_diet_labels) +
  scale_x_discrete(labels = lh_diet_labels) +
  theme_q2r() +
  theme(
    axis.text.x  = element_text(size = 16),
    axis.title.x = element_text(size = 18),
    axis.title.y = element_text(size = 18),
    plot.title   = element_text(hjust = 0.5, size = 20),
    axis.text.y  = element_text(size = 16),
    legend.position = "none",
    strip.text.x = element_text(size = 16)
  ) #+
#ylim(150,600)

ggsave("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/net_larval_gain_n_graph.pdf", net_larval_gain_n_graph, device = "pdf", units = "in", width = 4, height = 6)
# Diet Mass B Graph ----

# Significant difference between groups - continue with Dunn to see where differences are

diet_mass_b_tukey_df = as.data.frame(diet_mass_b_tukey$`life_history$Treatment`)

diet_mass_b_pvals <- diet_mass_b_tukey_df$`p adj`
names(diet_mass_b_pvals) <- row.names(diet_mass_b_tukey_df)

diet_mass_b_letters <- multcompLetters(diet_mass_b_pvals, threshold = 0.05)
diet_mass_b_letters_df <- data.frame(Treatment = names(diet_mass_b_letters$Letters), letter = diet_mass_b_letters$Letters)
diet_mass_b_letters_df

# Add letters to no_pro_diet_mass_b_metadata

diet_mass_b_letters_metadata = life_history %>%
  group_by(Treatment) %>%
  left_join(diet_mass_b_letters_df, by = "Treatment")

# Reorder the diets for the figure

life_history$Treatment <- factor(
  life_history$Treatment,
  levels = c("NC", "VO", "PG", "CO")
)


diet_mass_b_graph <- ggplot(life_history, aes(x = Treatment, y = DietMass_B, fill = Treatment)) + 
  geom_boxplot(outlier.colour="red", outlier.shape=8, outlier.size=4, alpha = 0.3) +
  geom_point(size = 3, alpha = 1.0,
             position = position_jitter(width = 0.15, height = 0)) +
  geom_text(
    data = diet_mass_b_letters_df,
    aes(x = Treatment,
        y = max(diet_mass_b_letters_metadata$DietMass_B) * 1.15,
        label = letter),
    size = 5,
    vjust = 0.4
  ) +
  labs(title = "Bioconversion Phase\nDiet Mass Loss",
       x="Treatment", 
       y="Mass (g)")+
  scale_fill_manual(values = viridis_colors_lh,
                    labels = lh_diet_labels) +
  scale_x_discrete(labels = lh_diet_labels) +
  theme_q2r() +
  theme(
    axis.text.x  = element_text(size = 16),
    axis.title.x = element_text(size = 18),
    axis.title.y = element_text(size = 18),
    plot.title   = element_text(hjust = 0.5, size = 20),
    axis.text.y  = element_text(size = 16),
    legend.position = "none",
    strip.text.x = element_text(size = 16)
  ) #+
#ylim(150,600)

ggsave("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/diet_mass_b_graph.pdf", diet_mass_b_graph, device = "pdf", units = "in", width = 4, height = 6)

# Diet Mass Loss B Graph ----

# Significant difference between groups - continue with Dunn to see where differences are

diet_mass_loss_b_tukey_df = as.data.frame(diet_mass_loss_b_tukey$`life_history$Treatment`)

diet_mass_loss_b_pvals <- diet_mass_loss_b_tukey_df$`p adj`
names(diet_mass_loss_b_pvals) <- row.names(diet_mass_loss_b_tukey_df)

diet_mass_loss_b_letters <- multcompLetters(diet_mass_loss_b_pvals, threshold = 0.05)
diet_mass_loss_b_letters_df <- data.frame(Treatment = names(diet_mass_loss_b_letters$Letters), letter = diet_mass_loss_b_letters$Letters)
diet_mass_loss_b_letters_df

# Add letters to no_pro_diet_mass_loss_b_metadata

diet_mass_loss_b_letters_metadata = life_history %>%
  group_by(Treatment) %>%
  left_join(diet_mass_loss_b_letters_df, by = "Treatment")

# Reorder the diets for the figure

life_history$Treatment <- factor(
  life_history$Treatment,
  levels = c("NC", "VO", "PG", "CO")
)


diet_mass_loss_b_graph <- ggplot(life_history, aes(x = Treatment, y = DietMassLoss_B, fill = Treatment)) + 
  geom_boxplot(outlier.colour="red", outlier.shape=8, outlier.size=4, alpha = 0.3) +
  geom_point(size = 3, alpha = 1.0,
             position = position_jitter(width = 0.15, height = 0)) +
  geom_text(
    data = diet_mass_loss_b_letters_df,
    aes(x = Treatment,
        y = max(diet_mass_loss_b_letters_metadata$DietMassLoss_B) * 1.15,
        label = letter),
    size = 5,
    vjust = 0.4
  ) +
  labs(title = "Bioconversion Phase\nDiet Mass Loss",
       x="Treatment", 
       y="Mass (g)")+
  scale_fill_manual(values = viridis_colors_lh,
                    labels = lh_diet_labels) +
  scale_x_discrete(labels = lh_diet_labels) +
  theme_q2r() +
  theme(
    axis.text.x  = element_text(size = 16),
    axis.title.x = element_text(size = 18),
    axis.title.y = element_text(size = 18),
    plot.title   = element_text(hjust = 0.5, size = 20),
    axis.text.y  = element_text(size = 16),
    legend.position = "none",
    strip.text.x = element_text(size = 16)
  ) #+
#ylim(150,600)

ggsave("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/diet_mass_loss_b_graph.pdf", diet_mass_loss_b_graph, device = "pdf", units = "in", width = 4, height = 6)

# Net Larval Gain B Graph ----

# Significant difference between groups - continue with Dunn to see where differences are

net_larval_gain_b_tukey_df = as.data.frame(net_larval_gain_b_tukey$`life_history$Treatment`)

net_larval_gain_b_pvals <- net_larval_gain_b_tukey_df$`p adj`
names(net_larval_gain_b_pvals) <- row.names(net_larval_gain_b_tukey_df)

net_larval_gain_b_letters <- multcompLetters(net_larval_gain_b_pvals, threshold = 0.05)
net_larval_gain_b_letters_df <- data.frame(Treatment = names(net_larval_gain_b_letters$Letters), letter = net_larval_gain_b_letters$Letters)
net_larval_gain_b_letters_df

# Add letters to no_pro_net_larval_gain_b_metadata

net_larval_gain_b_letters_metadata = life_history %>%
  group_by(Treatment) %>%
  left_join(net_larval_gain_b_letters_df, by = "Treatment")

# Reorder the diets for the figure

life_history$Treatment <- factor(
  life_history$Treatment,
  levels = c("NC", "VO", "PG", "CO")
)


net_larval_gain_b_graph <- ggplot(life_history, aes(x = Treatment, y = NetLarvalGain_B, fill = Treatment)) + 
  geom_boxplot(outlier.colour="red", outlier.shape=8, outlier.size=4, alpha = 0.3) +
  geom_point(size = 3, alpha = 1.0,
             position = position_jitter(width = 0.15, height = 0)) +
  geom_text(
    data = net_larval_gain_b_letters_df,
    aes(x = Treatment,
        y = max(net_larval_gain_b_letters_metadata$NetLarvalGain_B) * 1.15,
        label = letter),
    size = 5,
    vjust = 0.4
  ) +
  labs(title = "Bioconversion Phase\nLarval Gain",
       x="Treatment", 
       y="Mass (g)")+
  scale_fill_manual(values = viridis_colors_lh,
                    labels = lh_diet_labels) +
  scale_x_discrete(labels = lh_diet_labels) +
  theme_q2r() +
  theme(
    axis.text.x  = element_text(size = 16),
    axis.title.x = element_text(size = 18),
    axis.title.y = element_text(size = 18),
    plot.title   = element_text(hjust = 0.5, size = 20),
    axis.text.y  = element_text(size = 16),
    legend.position = "none",
    strip.text.x = element_text(size = 16)
  ) #+
#ylim(150,600)

ggsave("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/net_larval_gain_b_graph.pdf", net_larval_gain_b_graph, device = "pdf", units = "in", width = 4, height = 6)

# Percent larval mass gain - B ----

aov12 = aov(life_history$pct_larval_mass_b ~ life_history$Treatment); summary(aov12)
pct_larval_mass_gain_b_tukey = TukeyHSD(aov12)

# Significant difference between groups - continue with Dunn to see where differences are

pct_larval_mass_gain_b_tukey_df = as.data.frame(pct_larval_mass_gain_b_tukey$`life_history$Treatment`)

pct_larval_mass_gain_b_pvals <- pct_larval_mass_gain_b_tukey_df$`p adj`
names(pct_larval_mass_gain_b_pvals) <- row.names(pct_larval_mass_gain_b_tukey_df)

pct_larval_mass_gain_b_letters <- multcompLetters(pct_larval_mass_gain_b_pvals, threshold = 0.05)
pct_larval_mass_gain_b_letters_df <- data.frame(Treatment = names(pct_larval_mass_gain_b_letters$Letters), letter = pct_larval_mass_gain_b_letters$Letters)
pct_larval_mass_gain_b_letters_df

# Add letters to no_pro_pct_larval_mass_gain_b_metadata

pct_larval_mass_gain_b_letters_metadata = life_history %>%
  group_by(Treatment) %>%
  left_join(pct_larval_mass_gain_b_letters_df, by = "Treatment")

# Reorder the diets for the figure

life_history$Treatment <- factor(
  life_history$Treatment,
  levels = c("NC", "VO", "PG", "CO")
)


pct_larval_mass_gain_b_graph = ggplot(life_history, aes(x = Treatment, y = pct_larval_mass_b, fill = Treatment)) + 
  geom_boxplot(outlier.colour="red", outlier.shape=8, outlier.size=4, alpha = 0.3) +
  geom_point(size = 3, alpha = 1.0,
             position = position_jitter(width = 0.15, height = 0)) +
  geom_text(
    data = pct_larval_mass_gain_b_letters_df,
    aes(x = Treatment,
        y = max(pct_larval_mass_gain_b_letters_metadata$pct_larval_mass_b) * 1.15,
        label = letter),
    size = 5,
    vjust = 0.4
  ) +
  labs(title = "Bioconversion Phase\nLarval Mass Gain",
       x="Treatment", 
       y="% Change in Larval Mass")+
  scale_fill_manual(values = viridis_colors_lh,
                    labels = lh_diet_labels) +
  scale_x_discrete(labels = lh_diet_labels) +
  theme_q2r() +
  theme(
    axis.text.x  = element_text(size = 16),
    axis.title.x = element_text(size = 18),
    axis.title.y = element_text(size = 18),
    plot.title   = element_text(hjust = 0.5, size = 20),
    axis.text.y  = element_text(size = 16),
    legend.position = "none",
    strip.text.x = element_text(size = 16)
  ) #+
#ylim(150,600)

ggsave("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/pct_larval_mass_gain_b_graph.pdf", pct_larval_mass_gain_b_graph, device = "pdf", units = "in", width = 4, height = 6)

# Percent diet mass loss - B ----

aov13 = aov(life_history$pct_diet_mass_loss_b ~ life_history$Treatment); summary(aov13)
pct_diet_mass_loss_b_tukey = TukeyHSD(aov13)

# Significant difference between groups - continue with Dunn to see where differences are

pct_diet_mass_loss_b_tukey_df = as.data.frame(pct_diet_mass_loss_b_tukey$`life_history$Treatment`)

pct_diet_mass_loss_b_pvals <- pct_diet_mass_loss_b_tukey_df$`p adj`
names(pct_diet_mass_loss_b_pvals) <- row.names(pct_diet_mass_loss_b_tukey_df)

pct_diet_mass_loss_b_letters <- multcompLetters(pct_diet_mass_loss_b_pvals, threshold = 0.05)
pct_diet_mass_loss_b_letters_df <- data.frame(Treatment = names(pct_diet_mass_loss_b_letters$Letters), letter = pct_diet_mass_loss_b_letters$Letters)
pct_diet_mass_loss_b_letters_df

# Add letters to no_pro_pct_diet_mass_loss_b_metadata

pct_diet_mass_loss_b_letters_metadata = life_history %>%
  group_by(Treatment) %>%
  left_join(pct_diet_mass_loss_b_letters_df, by = "Treatment")

# Reorder the diets for the figure

life_history$Treatment <- factor(
  life_history$Treatment,
  levels = c("NC", "VO", "PG", "CO")
)


pct_diet_mass_loss_b_graph = ggplot(life_history, aes(x = Treatment, y = pct_diet_mass_loss_b, fill = Treatment)) + 
  geom_boxplot(outlier.colour="red", outlier.shape=8, outlier.size=4, alpha = 0.3) +
  geom_point(size = 3, alpha = 1.0,
             position = position_jitter(width = 0.15, height = 0)) +
  geom_text(
    data = pct_diet_mass_loss_b_letters_df,
    aes(x = Treatment,
        y = 5,
        label = letter),
    size = 5,
    vjust = 0.4
  ) +
  labs(title = "Bioconversion Phase\nDiet Mass Loss",
       x="Treatment", 
       y="% Change in Diet Mass")+
  scale_fill_manual(values = viridis_colors_lh,
                    labels = lh_diet_labels) +
  scale_x_discrete(labels = lh_diet_labels) +
  theme_q2r() +
  theme(
    axis.text.x  = element_text(size = 16),
    axis.title.x = element_text(size = 18),
    axis.title.y = element_text(size = 18),
    plot.title   = element_text(hjust = 0.5, size = 20),
    axis.text.y  = element_text(size = 16),
    legend.position = "none",
    strip.text.x = element_text(size = 16)
  ) #+
#ylim(150,600)

ggsave("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/pct_diet_mass_loss_b_graph.pdf", pct_diet_mass_loss_b_graph, device = "pdf", units = "in", width = 4, height = 6)

# Percent larval mass change - N ----

aov14 = aov(life_history$pct_larval_mass_n ~ life_history$Treatment); summary(aov14)
pct_larval_mass_gain_n_tukey = TukeyHSD(aov14)

# Significant difference between groups - continue with Dunn to see where differences are

pct_larval_mass_gain_n_tukey_df = as.data.frame(pct_larval_mass_gain_n_tukey$`life_history$Treatment`)

pct_larval_mass_gain_n_pvals <- pct_larval_mass_gain_n_tukey_df$`p adj`
names(pct_larval_mass_gain_n_pvals) <- row.names(pct_larval_mass_gain_n_tukey_df)

pct_larval_mass_gain_n_letters <- multcompLetters(pct_larval_mass_gain_n_pvals, threshold = 0.05)
pct_larval_mass_gain_n_letters_df <- data.frame(Treatment = names(pct_larval_mass_gain_n_letters$Letters), letter = pct_larval_mass_gain_n_letters$Letters)
pct_larval_mass_gain_n_letters_df

# Add letters to no_pro_pct_larval_mass_gain_n_metadata

pct_larval_mass_gain_n_letters_metadata = life_history %>%
  group_by(Treatment) %>%
  left_join(pct_larval_mass_gain_n_letters_df, by = "Treatment")

# Reorder the diets for the figure

life_history$Treatment <- factor(
  life_history$Treatment,
  levels = c("NC", "VO", "PG", "CO")
)


pct_larval_mass_gain_n_graph = ggplot(life_history, aes(x = Treatment, y = pct_larval_mass_b, fill = Treatment)) + 
  geom_boxplot(outlier.colour="red", outlier.shape=8, outlier.size=4, alpha = 0.3) +
  geom_point(size = 3, alpha = 1.0,
             position = position_jitter(width = 0.15, height = 0)) +
  geom_text(
    data = pct_larval_mass_gain_n_letters_df,
    aes(x = Treatment,
        y = max(pct_larval_mass_gain_n_letters_metadata$pct_larval_mass_b) * 1.15,
        label = letter),
    size = 5,
    vjust = 0.4
  ) +
  labs(title = "Nursery Phase\nLarval Mass Gain",
       x="Treatment", 
       y="% Change in Larval Mass")+
  scale_fill_manual(values = viridis_colors_lh,
                    labels = lh_diet_labels) +
  scale_x_discrete(labels = lh_diet_labels) +
  theme_q2r() +
  theme(
    axis.text.x  = element_text(size = 16),
    axis.title.x = element_text(size = 18),
    axis.title.y = element_text(size = 18),
    plot.title   = element_text(hjust = 0.5, size = 20),
    axis.text.y  = element_text(size = 16),
    legend.position = "none",
    strip.text.x = element_text(size = 16)
  ) #+
#ylim(150,600)

ggsave("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/pct_larval_mass_gain_n_graph.pdf", pct_larval_mass_gain_n_graph, device = "pdf", units = "in", width = 4, height = 6)


# Percent diet mass loss - N ----

aov15 = aov(life_history$pct_diet_mass_loss_n ~ life_history$Treatment); summary(aov15)
pct_diet_mass_loss_n_tukey = TukeyHSD(aov15)

# Significant difference between groups - continue with Dunn to see where differences are

pct_diet_mass_loss_n_tukey_df = as.data.frame(pct_diet_mass_loss_n_tukey$`life_history$Treatment`)

pct_diet_mass_loss_n_pvals <- pct_diet_mass_loss_n_tukey_df$`p adj`
names(pct_diet_mass_loss_n_pvals) <- row.names(pct_diet_mass_loss_n_tukey_df)

pct_diet_mass_loss_n_letters <- multcompLetters(pct_diet_mass_loss_n_pvals, threshold = 0.05)
pct_diet_mass_loss_n_letters_df <- data.frame(Treatment = names(pct_diet_mass_loss_n_letters$Letters), letter = pct_diet_mass_loss_n_letters$Letters)
pct_diet_mass_loss_n_letters_df

# Add letters to no_pro_pct_diet_mass_loss_n_metadata

pct_diet_mass_loss_n_letters_metadata = life_history %>%
  group_by(Treatment) %>%
  left_join(pct_diet_mass_loss_n_letters_df, by = "Treatment")

# Reorder the diets for the figure

life_history$Treatment <- factor(
  life_history$Treatment,
  levels = c("NC", "VO", "PG", "CO")
)


pct_diet_mass_loss_n_graph = ggplot(life_history, aes(x = Treatment, y = pct_diet_mass_loss_n, fill = Treatment)) + 
  geom_boxplot(outlier.colour="red", outlier.shape=8, outlier.size=4, alpha = 0.3) +
  geom_point(size = 3, alpha = 1.0,
             position = position_jitter(width = 0.15, height = 0)) +
  geom_text(
    data = pct_diet_mass_loss_n_letters_df,
    aes(x = Treatment,
        y = -62,
        label = letter),
    size = 5,
    vjust = 0.4
  ) +
  labs(title = "Nursery Phase\nDiet Mass Loss",
       x="Treatment", 
       y="% Change in Diet Mass")+
  scale_fill_manual(values = viridis_colors_lh,
                    labels = lh_diet_labels) +
  scale_x_discrete(labels = lh_diet_labels) +
  theme_q2r() +
  theme(
    axis.text.x  = element_text(size = 16),
    axis.title.x = element_text(size = 18),
    axis.title.y = element_text(size = 18),
    plot.title   = element_text(hjust = 0.5, size = 20),
    axis.text.y  = element_text(size = 16),
    legend.position = "none",
    strip.text.x = element_text(size = 16)
  ) #+
#ylim(150,600)

ggsave("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/pct_diet_mass_loss_n_graph.pdf", pct_diet_mass_loss_n_graph, device = "pdf", units = "in", width = 4, height = 6)


# Lipid Profile Data ----

oil_diet_labels = c("NC-Diet" = "CF", "AO-Diet" = "AVO", "PG-Diet" = "PG", "CO-Diet" = "UCO")

oil_diet_levels = names(oil_diet_labels)

viridis_colors_od = c("initial" = "#440154",
                      "NC" = "#3B528B",
                      "VO" = "#21918C",
                      "PG" = "#5DC863",
                      "CO" = "#FDE725")


sample_oil_diet_labels = c("NC" = "CF", "AO" = "AVO", "PG" = "PG", "CO" = "UCO")

sample_oil_diet_levels = names(sample_oil_diet_labels)

viridis_colors_sod = c("initial" = "#440154",
                      "NC" = "#3B528B",
                      "AO" = "#21918C",
                      "PG" = "#5DC863",
                      "CO" = "#FDE725")


fatty_acid_profile  = read.table("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/lipids_and_proteins/Fatty Acid Composition.csv", sep = ",", header = TRUE)

fa_profile_samples = fatty_acid_profile %>%
  filter(Treatment %in% c("AO", "CO", "PG", "NC")) %>%
  mutate(Treatment = factor(Treatment, levels = sample_oil_diet_levels)) 
  
fa_sample_means = fa_profile_samples %>%
  group_by(Treatment, Fatty.acid) %>%
  summarise(
    mean_pct = mean(Percentage....),
    sd = sd(Percentage....),
    se = sd(Percentage....) / sqrt(n()),
    .groups = "drop"
  )

fa_profile_diet = fatty_acid_profile %>%
  filter(Treatment %in% c("AO-Diet", "CO-Diet", "PG-Diet", "NC-Diet")) %>%
  mutate(Treatment = factor(Treatment, levels = oil_diet_levels))

fa_diet_means = fa_profile_diet %>%
  group_by(Treatment, Fatty.acid) %>%
  summarise(
    mean_pct = mean(Percentage....),
    se = sd(Percentage....) / sqrt(n()),
    .groups = "drop"
  )

sample_plot = ggplot(fa_sample_means, aes(x = Fatty.acid, y = mean_pct, fill = Fatty.acid)) +
  geom_col(alpha = 0.3, color = "black", linewidth = 0.4) +
  geom_errorbar(aes(ymin = mean_pct - se, ymax = mean_pct + se), width = 0.2) +
  facet_wrap(~ Treatment, nrow = 1, labeller = as_labeller(c(
    "NC" = "CF",
    "CO" = "UCO",
    "AO" = "AVO",
    "PG" = "PG")
  ),) +
  theme_bw() +
  theme(plot.title = element_text(size = 26, hjust = 0.5),
        axis.title.x = element_text(size = 24),
        axis.title.y = element_text(size = 24),
        axis.text.x = element_text(size = 20, angle = 45, hjust = 1),
        axis.text.y = element_text(size = 20),
        strip.text = element_text(size = 24),
        legend.position = "bottom",
        legend.direction = "horizontal",
        legend.text = element_text(size = 20),
        legend.title = element_text(size = 24),
        panel.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank()) +
  guides(fill = guide_legend(nrow = 1)) +
  labs(x = "Fatty Acid Composition", y = "Fatty Acid Content (%)", title = "Larval Fatty Acid Profile by Diet", fill = "Fatty Acid")


ggsave("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/sample_fa_profile.pdf", sample_plot, device = "pdf", units = "in", width = 22, height = 8)

diet_plot = ggplot(fa_diet_means, aes(x = Fatty.acid, y = mean_pct, fill = Fatty.acid)) +
  geom_col(alpha = 0.3, color = "black", linewidth = 0.4) +
  facet_wrap(~ Treatment, labeller = as_labeller(c(
                    "CO-Diet" = "UCO",
                    "AO-Diet" = "AVO",
                    "PG-Diet" = "PG")
                  ),) +
  theme_bw() +
  theme(plot.title = element_text(size = 26, hjust = 0.5),
        axis.title.x = element_text(size = 24),
        axis.title.y = element_text(size = 24),
        axis.text.x = element_text(size = 20, angle = 45, hjust = 1),
        axis.text.y = element_text(size = 20),
        strip.text = element_text(size = 24),
        legend.position = "bottom",
        legend.direction = "horizontal",
        legend.text = element_text(size = 20),
        legend.title = element_text(size = 24),
        panel.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank()) +
  guides(fill = guide_legend(nrow = 1)) +
  labs(x = "Fatty Acid Composition", y = "Fatty Acid Content (%)", title = "Fatty Acid Profile by Oil Feedstock", fill = "Fatty Acid")

ggsave("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/diet_fa_profile.pdf", diet_plot, device = "pdf", units = "in", width = 16, height = 8)

# Convert the fatty acid profile table into a feature table for Bray-Curtis analysis

fa_feature_table_meta = fatty_acid_profile %>%
  pivot_wider(
    names_from = Fatty.acid,
    values_from = Percentage....
  )

# Convert the feature table into Bray-Curtis format

fa_feature_table = fa_feature_table_meta %>%
  select(!Treatment) %>%
  as.data.frame()

rownames(fa_feature_table) = fa_feature_table$SampleID

fa_feature_table$SampleID = NULL

fa_feature_table_larv_only = fa_feature_table %>%
  filter(rownames(fa_feature_table) != c("PG-oil", "AVO-oil", "UCO-oil"))

fa_feature_table_meta_larv_only = fa_feature_table_meta %>%
  filter(SampleID != c("PG-oil", "AVO-oil", "UCO-oil"))

fa_bray_curtis = vegdist(fa_feature_table_larv_only, method = "bray")

fa_adonis = adonis2(fa_bray_curtis ~ Treatment, data = fa_feature_table_meta_larv_only)

# Extract the first two axes for the PCoA

fa_pcoa = cmdscale(
  fa_bray_curtis,
  eig = TRUE,
  k = 2
)

fa_plot_df = data.frame(
  SampleID = rownames(fa_feature_table),
  Treatment = fa_feature_table_meta$Treatment,
  Axis1 = fa_pcoa$points[,1],
  Axis2 = fa_pcoa$points[,2]
)

# Determine the proportion explained by the first two PCs

variance_explained = fa_pcoa$eig / sum(fa_pcoa$eig)

x_lab <- paste0("PC1 (", round(variance_explained[1] * 100, 1), "%)")
y_lab <- paste0("PC2 (", round(variance_explained[2] * 100, 1), "%)")

# Create a color palette

fa_pcoa_labels = c("NC" = "CF (Larvae)", "AO" = "AVO (Larvae)", "PG" = "PG (Larvae)", "CO" = "UCO (Larvae)", "AO-Diet" = "AVO (Oil)",  "PG-Diet" = "PG (Oil)", "CO-Diet" = "UCO (Oil)")

fa_pcoa_levels = names(fa_pcoa_labels)

fa_pcoa_colors = c("NC" = "#3B528B",
                   "AO" = "#21918C",
                   "PG" = "#5DC863",
                   "CO" = "#FDE725",
                   "AO-Diet" = "#21918C",
                   "PG-Diet" = "#5DC863",
                   "CO-Diet" = "#FDE725")


# Reorder the levels

fa_plot_df = fa_plot_df %>%
  mutate(Treatment = factor(Treatment, levels = fa_pcoa_levels))

# Make a sample type column

fa_plot_df$Type = ifelse(grepl("-Diet", fa_plot_df$Treatment),
                          "Oil",
                          "Larvae")

# Make the plot

fa_bray_curtis_pcoa = ggplot(fa_plot_df, aes(x = Axis1, y = Axis2, fill = Treatment, shape = Treatment)) +
  geom_point(size = 5, color = "black") +
  scale_fill_manual(
    values = fa_pcoa_colors,
    labels = fa_pcoa_labels,
    name = "Sample") +
  guides(
    fill = guide_legend(
      override.aes = list(
        shape = c(21,21,21,21,22,22,22),
        fill = fa_pcoa_colors
      )
    ), shape = "none"
  ) +
  labs(
    title = "Fatty Acid Profiles (Bray-Curtis)",
    x = x_lab,
    y = y_lab
  ) +
  scale_shape_manual(
    values = c(
      "NC" = 21,
      "AO" = 21,
      "PG" = 21,
      "CO" = 21,
      "AO-Diet" = 22,
      "CO-Diet" = 22,
      "PG-Diet" = 22
    )
  ) +
  theme_q2r() +
  theme(
    axis.title.x = element_text(size = 22),
    axis.title.y = element_text(size = 22),
    plot.title  = element_text(hjust = 0.5, size = 24),
    legend.text = element_text(size = 20),
    legend.title = element_text(size = 22),
    legend.position = c(0.17, 0.825),
    axis.text.y = element_text(size = 20),
    axis.text.x = element_text(size = 20)  )
ggsave("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/lipids_and_proteins/bray_curtis.pdf", fa_bray_curtis_pcoa, device = "pdf", units = "in", width = 8, height = 8)

# Make a biplot out of this data

# Pull out PCoA scores

pcoa_scores = fa_pcoa$points

biplot_table = fa_feature_table_larv_only
biplot_table = biplot_table[match(rownames(pcoa_scores), rownames(biplot_table)), ]

# Select fatty acids of interest

biplot_table_filt = biplot_table %>%
  select(`C12:0`, `C18:2`, `C18:1`, `C16:0`)

# Run envfit to make vector arrows

fa_fit = envfit(pcoa_scores, biplot_table_filt)

# Save the vectors as a data frame

vector = scores(fa_fit, display = "vectors") %>%
  as.data.frame()

vector$FattyAcid = rownames(vector)

# Scale the arrows

arrow_mul = 0.35 
vector = vector %>%
  mutate(x0 = 0, y0 = 0,
         x1 = Dim1 * arrow_mul,
         y1 = Dim2 * arrow_mul)

vector = vector %>%
  mutate(
    nudge_x = 0,
    nudge_y = 0,
    nudge_x = ifelse(FattyAcid == "C16:0", 0.035, nudge_x),
    nudge_y = ifelse(FattyAcid == "C18:1", 0.01, nudge_y)
  )

# Make the biplot

fa_bray_curtis_biplot = fa_bray_curtis_pcoa +
  geom_segment(data = vector, aes(x = x0, xend = x1, y = y0, yend = y1), inherit.aes = FALSE, linewidth = 0.8, color = "black", arrow = arrow(length = unit(0.25, "cm"))) +
  geom_text(data = vector, aes(x = x1 + nudge_x, y = y1 + nudge_y, label = FattyAcid), inherit.aes = FALSE, size = 5, color = "black", vjust = -0.8)

ggsave("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/lipids_and_proteins/bc_biplot.pdf", fa_bray_curtis_biplot, device = "pdf", units = "in", width = 8, height = 8)


## Fat and Protein Content ----

fat_protein_table = read.table("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/lipids_and_proteins/Fat and Protein Content.txt", header = TRUE, sep = "\t")

fat_aov = aov(fat_protein_table$Fat.content..dwb.... ~ fat_protein_table$Treatment)
summary(fat_aov)

TukeyHSD(fat_aov)

fat_protein_table = fat_protein_table %>%
  mutate(Treatment = factor(Treatment, levels = sample_oil_diet_levels))

fat_means = fat_protein_table %>%
  group_by(Treatment) %>%
  summarise(
    mean_pct = mean(Fat.content..dwb...., na.rm = TRUE),
    se = sd(Fat.content..dwb...., na.rm = TRUE) / sqrt(sum(!is.na(Fat.content..dwb....))),
    sd = sd(Fat.content..dwb...., na.rm = TRUE),
    n = sum(!is.na(Fat.content..dwb....)),
    .groups = "drop"
  )


fat_plot = ggplot(fat_means, aes(x = Treatment, y = mean_pct, fill = Treatment)) +
  geom_col(alpha = 0.3, color = "black", linewidth = 0.4) +
  geom_errorbar(aes(ymin = mean_pct - se, ymax = mean_pct + se), width = 0.2) +
  theme_bw() +
  scale_fill_manual(values = viridis_colors_sod,
                    labels = sample_oil_diet_labels) +
  scale_x_discrete(labels = sample_oil_diet_labels) +
  theme(plot.title = element_text(size = 24, hjust = 0.5),
        axis.title.x = element_text(size = 22),
        axis.title.y = element_text(size = 22),
        axis.text.x = element_text(size = 20),
        axis.text.y = element_text(size = 20),
        legend.position = "none",
        panel.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank()) +
  labs(x = "Diet", y = "Fat Biomass (%)", title = "Fat Content by Diet", fill = "Diet") +
  ylim(c(0, 35))
ggsave("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/fat_dwb.pdf", fat_plot, device = "pdf", units = "in", width = 7, height = 8)

protein_means = fat_protein_table %>%
  group_by(Treatment) %>%
  summarise(
    mean_pct = mean(Protein.content..dwb....),
    se = sd(Protein.content..dwb....) / sqrt(n()),
    sd = sd(Protein.content..dwb....),
    .groups = "drop"
  )

protein_aov = aov(fat_protein_table$Protein.content..dwb.... ~ fat_protein_table$Treatment)
summary(protein_aov)

TukeyHSD(protein_aov)

protein_plot = ggplot(protein_means, aes(x = Treatment, y = mean_pct, fill = Treatment)) +
  geom_col(alpha = 0.3, color = "black", linewidth = 0.4) +
  geom_errorbar(aes(ymin = mean_pct - se, ymax = mean_pct + se), width = 0.2) +
  theme_bw() +
  scale_fill_manual(values = viridis_colors_sod,
                    labels = sample_oil_diet_labels) +
  scale_x_discrete(labels = sample_oil_diet_labels) +
  theme(plot.title = element_text(size = 24, hjust = 0.5),
        axis.title.x = element_text(size = 22),
        axis.title.y = element_text(size = 22),
        axis.text.x = element_text(size = 20),
        axis.text.y = element_text(size = 20),
        legend.position = "none",
        panel.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank()) +
  labs(x = "Diet", y = "Protein Biomass (%)", title = "Protein Content by Diet", fill = "Diet") +
  ylim(c(0, 55))
ggsave("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/protein_dwb.pdf", protein_plot, device = "pdf", units = "in", width = 7, height = 8)


# Core Features ----

core_features_80 = read.table("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/core_features/core-features-0.800_all_samples.tsv", sep = "\t", header = TRUE)

# Merge the core features data and the taxonomy data
cf_taxa_80 = merge(core_features_80, sep.table, by = "Feature.ID")
write.table(cf_taxa_80, "~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/core_features/core_feature_80_taxa.tsv", sep = "\t", row.names = FALSE)

# Make a list of the ASVs that are both core features and significantly differentially abundant

cf_da_asvs_80 = intersect(cf_taxa_80$Feature.ID, filtered_lfc$taxon)

# Filter out insignificantly DA taxa
cf_da_list_80 = cf_taxa_80 %>%
  filter(cf_taxa_80$Feature.ID %in% cf_da_asvs)

# Select columns of interest
cf_da_list_compact_80 = cf_da_list_80 %>%
  select(Feature.ID, Order, Family, Genus)

core_features_100 = read.table("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/core_features/core-features-1.000_all_samples.tsv", sep = "\t", header = TRUE)

# Merge the core features data and the taxonomy data
cf_taxa_100 = merge(core_features_100, sep.table, by = "Feature.ID")

# Make a list of the ASVs that are both core features and significantly differentially abundant

cf_da_asvs_100 = intersect(cf_taxa_100$Feature.ID, filtered_lfc$taxon)

# Filter out insignificantly DA taxa
cf_da_list_100 = cf_taxa_100 %>%
  filter(cf_taxa_100$Feature.ID %in% cf_da_asvs_100)

# Select columns of interest
cf_da_list_compact_100 = cf_da_list_100 %>%
  select(Feature.ID, Order, Family, Genus)

# Verify that core features are present in every diet

diet_groups = unique(q2_metadata$diet)

ft_cf_80 = full_ft %>%
  filter(Feature.ID %in% cf_da_asvs_80)

ft_cf_80_t = t(ft_cf_80)

cf_80_meta = merge(ft_cf_80_t, q2_metadata, by.x = 0, by.y = "SampleID")

cf_80_meta = cf_80_meta %>%
  mutate(across(starts_with("V"), as.numeric))

chicken_feed_80 = cf_80_meta %>%
  filter(diet == "chicken_feed") %>%
  summarise(across(starts_with("V"), ~ mean(.x, na.rm = TRUE)))

vegetable_oil_80 = cf_80_meta %>%
  filter(diet == "vegetable_oil") %>%
  summarise(across(starts_with("V"), ~ mean(.x, na.rm = TRUE)))

pig_grease_80 = cf_80_meta %>%
  filter(diet == "pig_grease") %>%
  summarise(across(starts_with("V"), ~ mean(.x, na.rm = TRUE)))

cooking_oil_80 = cf_80_meta %>%
  filter(diet == "cooking_oil") %>%
  summarise(across(starts_with("V"), ~ mean(.x, na.rm = TRUE)))

# Make a new column of sep.table for the levels of core

sep.table$Core = "not_core"
sep.table$Core[sep.table$Feature.ID %in% cf_da_asvs_80] = "core_shell"
sep.table$Core[sep.table$Feature.ID %in% cf_da_asvs_100] = "core_absolute"


# Merge the relative abundance table and taxonomy files together.

cf_ft_taxa = merge(sep.table, relab_table, by = "Feature.ID")

# Convert to long format

cf_df_long = relab_table %>%
  pivot_longer(
    cols = 2:109,
    names_to = "SampleID",
    values_to = "Relative_Abundance"
  )

# Add the core column to the end

cf_df_long <- cf_df_long %>%
  left_join(cf_ft_taxa %>% select(Feature.ID, Core),
            by = "Feature.ID", )

# Merge the metadata for grouping by sample type

cf_df_long <- cf_df_long %>%
  left_join(q2_metadata %>% select(SampleID, diet), by = "SampleID")

# Make the plot so that it goes numerically descending

cf_df_long$Core <- factor(cf_df_long$Core, levels = c("core_absolute", "core_shell", "not_core"))

# Make the plot

cf_plot = ggplot(cf_df_long, aes(x = SampleID, y = Relative_Abundance, fill = Core)) +
  geom_bar(stat = "identity") +
  geom_vline(xintercept = 9.5, linewidth = 0.8, color = "grey20") +
  geom_vline(xintercept = 18.5, linewidth = 0.8, color = "grey20") +
  theme_minimal() +
  theme(
    panel.grid.major.x = element_blank(),
    axis.text.x = element_text(angle = 60, hjust = 1, vjust = 1, size = 14),
    strip.text.x = element_text(size = 16),
    axis.title.x = element_text(size = 16),
    axis.title.y = element_text(size = 16),
    axis.text.y = element_text(size = 14),
    legend.position = "right",
    legend.text = element_text(size = 14),
    legend.title = element_text(size = 14),
  ) +
  scale_fill_discrete(
    name = "Core Type\n(Sample Prevalence)",
    labels = c(
      "core_absolute" = "Absolute Core (100%)",
      "core_shell"    = "Shell Core (80–99%)",
      "not_core"      = "Not Core (0–79%)"
    )) +
  facet_wrap(~ diet, 
             nrow = 1, 
             labeller = as_labeller(c(
                                      "chicken_feed" = "CF",
                                      "cooking_oil" = "UCO",
                                      "vegetable_oil" = "AVO",
                                      "pig_grease" = "PG")
                                    ),
              scales = "free_x")
ggsave("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/cf_rel_abun.pdf", device = "pdf", units = "in", width = 14, height = 8)


# Saving the image ----
save.image("~/Library/CloudStorage/OneDrive-UniversityofTennessee/UTK/Research/Projects/bsf_biofuels/figures.RData")
