library(testthat)
library(dplyr)
library(tidyr)
library(tibble)

test_that("PAVER_export works correctly", {

  #Use vignette example data
  input = gsea_example

  embeddings = readRDS(url("https://github.com/willgryan/PAVER_embeddings/raw/main/2023-03-06/embeddings_2023-03-06.RDS"))

  ontology_index = readRDS(url("https://github.com/willgryan/PAVER_embeddings/raw/main/2023-03-06/ontology_2023-03-06.RDS"))

  PAVER_result <- prepare_data(input, embeddings, ontology_index)

  PAVER_result <- generate_themes(PAVER_result, minClusterSize = 40)

  # Test PAVER_export function
  export_result <- PAVER_export(PAVER_result)

  # Verify the structure and content of the output
  expect_s3_class(export_result, "tbl_df")
  expect_gte(ncol(export_result), 3)
  expect_equal(names(export_result)[1:3], c("GOID", "Cluster", "Term"))

})
