library(testthat)
library(dplyr)
library(tidyr)
library(tibble)
library(magrittr)
library(umap)
library(dynamicTreeCut)
library(randomcoloR)

# Mock unit test for the generate_themes function
test_that("generate_themes function works with mock PAVER_result", {
  # Mock input data
  mock_input <- data.frame(
    GOID = paste0("GO:", sprintf("%07d", 1:250)),
    GroupA = rnorm(250),
    GroupB = rnorm(250),
    GroupC = rnorm(250)
  )

  # Mock embeddings data
  mock_embeddings <- matrix(rnorm(250 * 10), 250, 10)
  rownames(mock_embeddings) <- paste0("GO:", sprintf("%07d", 1:250))

  # Mock term2name data
  mock_term2name <- data.frame(
    GOID = paste0("GO:", sprintf("%07d", 1:250)),
    TermName = paste0("Term ", 1:250)
  )

  # Generate the mock PAVER_result using the prepare_data function
  mock_PAVER_result <- prepare_data(mock_input, mock_embeddings, mock_term2name)

  # Run the generate_themes function with the mock PAVER_result
  result <- generate_themes(mock_PAVER_result)

  # Test that result is a list
  expect_true(is.list(result))

  # Test that the result contains expected elements
  expect_true("clustering" %in% names(result))
  expect_true("avg_cluster_embeddings" %in% names(result))
  expect_true("mds" %in% names(result))
  expect_true("colors" %in% names(result))
})
