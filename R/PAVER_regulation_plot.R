#' PAVER_regulation_plot
#'
#' This function takes a PAVER result object and generates a ggplot2 scatterplot
#' of the UMAP layout colored by direction of regulation (up or down) for each group.
#'
#' @param PAVER_result a list containing the output of PAVER analysis
#'
#' @return A ggplot2 scatterplot of the UMAP layout colored by direction of regulation (up or down) and faceted for each group.
#'
#' @examples
#' TRUE
#'
#' @export
PAVER_regulation_plot <- function(PAVER_result) {

  plot_data = PAVER_result$umap$layout %>%
    tibble::as_tibble(rownames = NA) %>%
    tibble::rownames_to_column("UniqueID") %>%
    dplyr::rename(UMAP1 = "V1", UMAP2 = "V2") %>%
    dplyr::inner_join(PAVER_result$clustering %>%
                        dplyr::select(.data$UniqueID, .data$Group), by = "UniqueID") %>%
    dplyr::inner_join(PAVER_result$prepared_data %>%
                        dplyr::select(.data$UniqueID, .data$Direction), by = "UniqueID")

  if(nlevels(plot_data$Direction) != 1) {
    colors = c("blue", "red") #Ensure labels and colors of direction are consistent
  } else {
    if(levels(plot_data$Direction) == "Up") {
      colors = c("red")
    } else {
      colors = c("blue")
    }
  }

  plot = plot_data %>%
    ggplot2::ggplot(ggplot2::aes(x = .data$UMAP1,
                                 y = .data$UMAP2,
                                 colour = .data$Direction)) +
    ggplot2::geom_point() +
    ggplot2::facet_wrap(~ Group) +
    ggplot2::scale_color_manual(values = colors) +
    ggpubr::theme_pubr(legend = "right") +
    ggplot2::theme(strip.background = ggplot2::element_blank(),
                       strip.text.x = ggplot2::element_text(size=12))

  plot

}
