library(testthat)
library(dplyr)
library(tidyr)
library(tibble)
library(magrittr)
library(umap)

test_that("prepare_data works correctly", {

  #Use vignette example data
  input = gsea_example

  embeddings = readRDS(url("https://github.com/willgryan/PAVER_embeddings/raw/main/2023-03-06/embeddings_2023-03-06.RDS"))

  ontology_index = readRDS(url("https://github.com/willgryan/PAVER_embeddings/raw/main/2023-03-06/ontology_2023-03-06.RDS"))

  # Test function
  result <- prepare_data(input, embeddings, ontology_index)

  # Verify output structure
  expect_type(result, "list")
  expect_named(result, c("prepared_data", "embedding_mat", "umap", "goterms_df"))
  expect_s3_class(result$prepared_data, "data.frame")
  expect_s3_class(result$embedding_mat, "tbl_df")
  expect_s3_class(result$umap, "umap")
  expect_s3_class(result$goterms_df, "tbl_df")

})

