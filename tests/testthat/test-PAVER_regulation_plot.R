library(testthat)
library(ggplot2)
library(ggpubr)

test_that("PAVER_regulation_plot works correctly", {
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

  # Run the function and catch the result
  p <- PAVER_regulation_plot(result)

  # Verify the function runs and produces a ggplot object
  expect_s3_class(p, "gg")
})
