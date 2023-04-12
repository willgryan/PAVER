#' PAVER_interpretation_plot
#'
#' This function takes a PAVER result object and generates a ggplot2 scatterplot
#' of the MDS layout with labeled points colored by group.
#'
#' @param PAVER_result a list containing the output of PAVER analysis
#'
#' @return A ggplot2 scatterplot of the MDS layout with labeled points colored by group.
#'
#' @examples
#' TRUE
#'
#' @export
PAVER_interpretation_plot <- function(PAVER_result) {

  plot = PAVER_result$mds$conf %>%
    tibble::as_tibble() %>%
    dplyr::rename(MDS1 = "D1", MDS2 = "D2") %>%
    ggplot2::ggplot(ggplot2::aes(
      x = .data$MDS1,
      y = .data$MDS2,
      label = rownames(PAVER_result$mds$conf),
      colour = rownames(PAVER_result$mds$conf)
    )) +
    ggplot2::geom_point() +
    ggplot2::scale_color_manual(guide = "none", values = PAVER_result$colors) +
    ggrepel::geom_label_repel(ggplot2::aes(fontface = "bold"), max.overlaps = 100) +
    ggpubr::theme_pubr(legend = "right")

  plot

}
