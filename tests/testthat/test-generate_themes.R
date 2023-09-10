library(testthat)
library(dplyr)
library(tidyr)
library(tibble)
library(magrittr)
library(umap)
library(dynamicTreeCut)
library(randomcoloR)

test_that("generate_themes works correctly", {

  #Use vignette example data
  input = gsea_example

  embeddings = readRDS(url("https://github.com/willgryan/PAVER_embeddings/raw/main/2023-03-06/embeddings_2023-03-06.RDS"))

  ontology_index = readRDS(url("https://github.com/willgryan/PAVER_embeddings/raw/main/2023-03-06/ontology_2023-03-06.RDS"))

  PAVER_result <- prepare_data(input, embeddings, ontology_index)

  # Test generate_themes function
  result <- generate_themes(PAVER_result, minClusterSize = 40)

  # Verify output structure
  expect_type(result, "list")
  expect_named(result, c("prepared_data", "embedding_mat", "umap", "goterms_df", "clustering", "avg_cluster_embeddings", "mds", "colors"))
  expect_s3_class(result$clustering, "tbl_df")
  expect_s3_class(result$avg_cluster_embeddings, "tbl_df")
  expect_s3_class(result$mds, "smacof")
  expect_type(result$colors, "character")

})

