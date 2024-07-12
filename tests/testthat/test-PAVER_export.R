library(testthat)
library(dplyr)
library(tidyr)
library(tibble)

test_that("PAVER_export works correctly", {
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

  # Test PAVER_export function
  export_result <- PAVER_export(result)

  # Verify the structure and content of the output
  expect_s3_class(export_result, "tbl_df")
  expect_gte(ncol(export_result), 3)
  expect_equal(names(export_result)[1:3], c("GOID", "Cluster", "Term"))
})
