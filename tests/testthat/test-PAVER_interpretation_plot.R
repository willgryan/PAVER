library(testthat)
library(ggplot2)
library(ggpubr)

test_that("PAVER_interpretation_plot works correctly", {

  #Use vignette example data
  input = gsea_example

  embeddings = readRDS(url("https://github.com/willgryan/PAVER_embeddings/raw/main/2023-03-06/embeddings_2023-03-06.RDS"))

  ontology_index = readRDS(url("https://github.com/willgryan/PAVER_embeddings/raw/main/2023-03-06/ontology_2023-03-06.RDS"))

  PAVER_result <- prepare_data(input, embeddings, ontology_index)

  PAVER_result <- generate_themes(PAVER_result, minClusterSize = 40)

  # Run the function and catch the result
  p <- PAVER_interpretation_plot(PAVER_result)

  # Verify the function runs and produces a ggplot object
  expect_s3_class(p, "gg")
})
