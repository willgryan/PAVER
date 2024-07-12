#' PAVER_theme_plot
#'
#' This function takes a PAVER result object and generates a ggplot2 scatterplot
#' of the UMAP layout colored by cluster assignments.
#'
#' @param PAVER_result a list containing the output of PAVER analysis
#' @param show_cluster_legend a logical indicating whether to show the cluster legend.
#'
#' @return A ggplot2 scatterplot of the UMAP layout colored by cluster assignments
#'
#' @examples
#' TRUE
#'
#' @export
PAVER_theme_plot <- function(PAVER_result, show_cluster_legend = TRUE) {
  plot <- PAVER_result$umap$layout %>%
    tibble::as_tibble(rownames = NA, .name_repair = "universal_quiet") %>%
    tibble::rownames_to_column("UniqueID") %>%
    dplyr::rename_with(.cols = 2:3, ~ c("UMAP1", "UMAP2")) %>%
    dplyr::inner_join(PAVER_result$clustering %>%
      dplyr::select(.data$UniqueID, .data$Group, .data$Cluster), by = "UniqueID") %>%
    ggplot2::ggplot(ggplot2::aes(
      x = .data$UMAP1,
      y = .data$UMAP2,
      colour = .data$Cluster
    )) +
    ggplot2::geom_point(ggplot2::aes(shape = .data$Group)) +
    ggplot2::scale_color_manual(values = PAVER_result$colors) +
    ggprism::theme_prism(base_size = 9) +
    ggplot2::theme(
      axis.title.y = ggplot2::element_text(margin = ggplot2::margin(t = 0, r = 0, b = 0, l = 0)),
      axis.title.x = ggplot2::element_text(margin = ggplot2::margin(t = 0, r = 0, b = 0, l = 0)),
      axis.text.x = ggplot2::element_blank(),
      axis.text.y = ggplot2::element_blank(),
      axis.ticks.x = ggplot2::element_blank(),
      axis.ticks.y = ggplot2::element_blank(),
      legend.position = "bottom",
      legend.direction = "horizontal",
      legend.spacing.y = grid::unit(-1, "mm"),
      legend.spacing.x = grid::unit(-1, "mm"),
      legend.box.spacing = grid::unit(-1, "mm"),
      legend.key.spacing.x = grid::unit(-1, "mm"),
      legend.key.spacing.y = grid::unit(-1, "mm"),
      legend.box.margin = ggplot2::margin(),
      legend.box = "vertical",
      panel.grid = ggplot2::element_blank(),
      panel.border = ggplot2::element_blank(),
      plot.margin = grid::unit(c(0, 0, 0, 0), "mm"),
      panel.spacing = grid::unit(c(0, 0, 0, 0), "mm"),
      legend.margin = ggplot2::margin(0),
      legend.text = ggplot2::element_text(face = "bold", size = 9, margin = ggplot2::margin(t = 0, r = 0, b = 0, l = 0))
    ) +
    ggplot2::guides(
      fill = ggplot2::guide_legend(
        byrow = T,
        override.aes = list(size = 2.5)
      ),
      shape = ggplot2::guide_legend(
        byrow = T,
        override.aes = list(size = 2.5)
      )
    ) +
    {
      if (show_cluster_legend) {
        ggplot2::guides(color = ggplot2::guide_legend(
          byrow = TRUE,
          ncol = 1,
          override.aes = list(shape = 15, size = 2.75)
        ))
      } else {
        ggplot2::guides(color = "none")
      }
    }

  plot
}
