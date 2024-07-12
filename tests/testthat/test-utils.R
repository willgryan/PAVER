test_that("Cosine dissimilarity matrix is correctly computed", {
  # Test with simple matrix
  mat <- matrix(c(.5, -.5, -.5, .5), ncol = 2)
  expect_equal(as.numeric(cosine_dissimilarity(mat)), 2)

  # Test with square root
  expect_equal(as.numeric(cosine_dissimilarity(mat, root = TRUE)), sqrt(2))
})
