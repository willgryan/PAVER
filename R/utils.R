#' Compute Cosine Dissimilarity Matrix
#'
#' This function computes the cosine dissimilarity matrix based on the input matrix.
#' The cosine dissimilarity between two vectors is defined as 1 minus the cosine similarity.
#'
#' @param mat A numeric matrix or data frame.
#' @param root A logical value indicating whether to take the square root of the cosine dissimilarity
#' matrix. Default is FALSE.
#'
#' @return A dissimilarity matrix of class "dist" containing the cosine dissimilarity between each pair of rows.
#'
#' @examples
#' TRUE
cosine_dissimilarity <- function(mat, root = FALSE) {
  sim = mat / sqrt(rowSums(mat * mat))
  sim = sim %*% t(sim)

  if(root == T) {
    D_sim = stats::as.dist(sqrt(1 - sim))
  } else {
    D_sim = stats::as.dist(1 - sim)
  }

  D_sim[D_sim < 0] = 0 #Precision errors can lead to negative or NA distances
  D_sim[is.na(D_sim)] = 0

  D_sim
}
