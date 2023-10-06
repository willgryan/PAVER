#' PAVER_theme_plot
#'
#' This function takes a PAVER result object and generates a ggplot2 scatterplot
#' of the UMAP layout colored by cluster assignments.
#'
#' @param PAVER_result a list containing the output of PAVER analysis
#'
#' @return A ggplot2 scatterplot of the UMAP layout colored by cluster assignments
#'
#' @examples
#' TRUE
#'
#' @export
PAVER_theme_plot <- function(PAVER_result) {

  plot = PAVER_result$umap$layout %>%
    tibble::as_tibble(rownames = NA, .name_repair = "universal") %>%
    tibble::rownames_to_column("UniqueID") %>%
    dplyr::rename_with(.cols = 2:3, ~ c("UMAP1", "UMAP2")) %>%
    dplyr::inner_join(PAVER_result$clustering %>%
                        dplyr::select(.data$UniqueID, .data$Group, .data$Cluster), by = "UniqueID") %>%
    ggplot2::ggplot(ggplot2::aes(x = .data$UMAP1,
                                 y = .data$UMAP2,
                                 colour = .data$Cluster)) +
    ggplot2::geom_point(ggplot2::aes(shape = .data$Group)) +
    ggplot2::scale_color_manual(values = PAVER_result$colors) +
    ggpubr::theme_pubr(legend = "right")

  plot
}
