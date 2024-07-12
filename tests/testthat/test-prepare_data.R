library(testthat)
library(dplyr)
library(tidyr)
library(tibble)
library(magrittr)
library(umap)

test_that("prepare_data function works with mock data", {
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

  result <- prepare_data(mock_input, mock_embeddings, mock_term2name)

  # Test that result is a list
  expect_true(is.list(result))

  # Test that the result contains the expected elements
  expect_true("prepared_data" %in% names(result))
  expect_true("embedding_mat" %in% names(result))
  expect_true("umap" %in% names(result))
  expect_true("goterms_df" %in% names(result))

  # Test the dimensions and data of the prepared_data dataframe
  expect_equal(nrow(result$prepared_data), nrow(mock_input) * 3) # assuming all mock input values are non-zero
  expect_equal(ncol(result$prepared_data), 5) # Columns: GOID, Group, value, Direction, UniqueID

  # Test the dimensions of the embedding matrix
  expect_equal(nrow(result$embedding_mat), nrow(mock_input) * (ncol(mock_input) - 1))
  expect_equal(ncol(result$embedding_mat), 11) # As mock_embeddings has 10 columns

  # Test the goterms_df dataframe
  expect_equal(nrow(result$goterms_df), nrow(mock_input))
  expect_equal(ncol(result$goterms_df), 2) # Columns: GOID and TermName
})
