#' PAVER_hunter_plot
#'
#' This function takes a PAVER result object and generates a heatmap of the enrichment analysis
#' with clustering and color-coded values based on the direction of regulation.
#'
#' @param PAVER_result a list containing the output of PAVER analysis
#' @param unit optionally, the unit of enrichment analysis for the figure legend title.
#'
#' @return A heatmap of the expression data with clustering and color-coded values based on the direction of regulation.
#'
#' @examples
#' TRUE
#'
#' @export
PAVER_hunter_plot <- function(PAVER_result, unit=NULL) {

  data = PAVER_result$prepared_data %>%
    dplyr::inner_join(PAVER_result$clustering %>%
                        dplyr::select(.data$UniqueID, .data$Cluster), by = "UniqueID") %>%
    dplyr::mutate(Cluster = forcats::fct_drop(.data$Cluster)) %>%
    tidyr::pivot_wider(names_from = "Group", values_from = "value") %>%
    dplyr::mutate(dplyr::across(
      .cols = dplyr::where(is.numeric),
      .fns = ~ tidyr::replace_na(.x, 0)))

  mat = data %>%
    dplyr::select(dplyr::where(is.numeric)) %>%
    as.matrix()

  min = min(mat, na.rm=T)
  max = max(mat, na.rm=T)

  if(nlevels(data$Direction) != 1) { #If the data is signed, 0 is the middle
    col_fun = circlize::colorRamp2(c(min, 0, max), c("blue", "white", "red"))
    at = c(min, 0, max)
    labels = c(round(min, 2), 0, round(max, 2))
  } else {
    at = c(min, max)
    labels = c(round(min, 2), round(max, 2))
    if(levels(data$Direction) == "Up") {
      col_fun = circlize::colorRamp2(c(min, max), c("white", "red"))
    } else {
      col_fun = circlize::colorRamp2(c(min, max), c("white", "blue"))
    }
  }

  lgd = ComplexHeatmap::Legend(col_fun = col_fun,
               title = unit,
               at = at,
               labels = labels,
               direction = "horizontal",
               title_position = "lefttop",
               title_gp = grid::gpar(fontsize = 8),
               labels_gp = grid::gpar(fontsize = 8))

  if(ncol(mat) >= 2) {
    dend = ComplexHeatmap::cluster_within_group(mat %>% t(), data$Cluster)
  }

  ht = ComplexHeatmap::Heatmap(mat,
                               col = col_fun,
               row_title_gp = grid::gpar(fontsize = 8),
               column_names_gp = grid::gpar(fontsize = 8),
               column_names_rot = 0,
               column_names_centered = TRUE,
               row_title_rot = 0,
               row_title_side = "right",
               row_gap = grid::unit(2, "mm"),
               show_row_dend = T,
               cluster_rows = if (ncol(mat) >= 2) dend else T,
               cluster_columns = ncol(mat) >= 2,
               split = if (ncol(mat) >= 2) nlevels(data$Cluster) else data$Cluster,
               show_heatmap_legend = FALSE)

  ComplexHeatmap::draw(ht,
       heatmap_legend_list = lgd,
       heatmap_legend_side="bottom")
}
