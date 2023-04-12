#' PAVER_combined_plot
#'
#' This function takes a PAVER result object and generates a combined ggplot2
#' figure consisting of the PAVER_cluster_plot, PAVER_regulation_plot,
#' PAVER_interpretation_plot, and PAVER_hunter_plot.
#'
#' @param PAVER_result a list containing the output of PAVER analysis
#'
#' @return A combined ggplot2 figure consisting of the PAVER_cluster_plot, PAVER_regulation_plot,
#' PAVER_interpretation_plot, and PAVER_hunter_plot.
#'
#' @examples
#' TRUE
#'
#' @export
PAVER_combined_plot <- function(PAVER_result) {
  plot = ggpubr::ggarrange(
    PAVER_theme_plot(PAVER_result),
    PAVER_regulation_plot(PAVER_result),
    PAVER_interpretation_plot(PAVER_result),
    grid::grid.grabExpr(plot(PAVER_hunter_plot(PAVER_result))),
    ncol= 2,
    nrow = 2,
    labels = "AUTO")
  plot
}
