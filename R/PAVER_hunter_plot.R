#' PAVER_hunter_plot
#'
#' This function takes a PAVER result object and generates a heatmap of the enrichment analysis
#' with clustering and color-coded values based on the direction of regulation.
#'
#' @param PAVER_result a list containing the output of PAVER analysis
#' @param unit optionally, the unit of enrichment analysis for the figure legend title.
#' @param show_row_titles a logical indicating whether to show row titles in the heatmap.
#'
#' @return A heatmap of the expression data with clustering and color-coded values based on the direction of regulation.
#'
#' @examples
#' TRUE
#'
#' @export
PAVER_hunter_plot <- function(PAVER_result, unit=NULL, show_row_titles=TRUE) {

  data = PAVER_result$prepared_data %>%
    tidyr::pivot_wider(
      names_from = "Group",
      values_from = c("value"),
      id_cols = "GOID"
    ) %>%
    dplyr::inner_join(PAVER_result$clustering %>%
                        dplyr::select(.data$GOID, .data$Cluster),
                      by = "GOID") %>%
    dplyr::mutate(Cluster = forcats::fct_drop(.data$Cluster)) %>%
    dplyr::mutate(dplyr::across(
      .cols = dplyr::where(is.numeric),
      .fns = ~ tidyr::replace_na(.x, 0)
    )) %>%
    dplyr::distinct(.data$GOID, .keep_all = TRUE)

  mat = data %>%
    dplyr::select(dplyr::where(is.numeric)) %>%
    as.matrix()

  min = min(mat, na.rm = T)
  max = max(mat, na.rm = T)

  if (nlevels(PAVER_result$prepared_data$Direction) != 1) {
    #If the data is signed, 0 is the middle
    col_fun = circlize::colorRamp2(c(min, 0, max), c("blue", "white", "red"))
    at = c(min, 0, max)
    labels = c(round(min, 2), 0, round(max, 2))
  } else {
    at = c(min, max)
    labels = c(round(min, 2), round(max, 2))
    if (levels(PAVER_result$prepared_data$Direction) == "+") {
      col_fun = circlize::colorRamp2(c(min, max), c("white", "red"))
    } else {
      col_fun = circlize::colorRamp2(c(min, max), c("white", "blue"))
    }
  }

  lgd = ComplexHeatmap::Legend(
    col_fun = col_fun,
    title = unit,
    at = at,
    labels = labels,
    direction = "horizontal",
    title_position = "lefttop",
    title_gp = grid::gpar(fontsize = 8, fontface =
                            "bold"),
    labels_gp = grid::gpar(fontsize = 8, fontface =
                             "bold"),
    legend_width = grid::unit(1, "cm"),
  )

  c_data = mat %>% t()

  #If there is only one column, we need to duplicate the data to get the clustering
  if (ncol(mat) >= 1) {
    c_data = rbind(c_data, c_data)
  }

  dend = ComplexHeatmap::cluster_within_group(c_data, data$Cluster)

  color_order = data[stats::order.dendrogram(dend),]$Cluster %>% forcats::fct_inorder() %>% levels()

  plot_colors = PAVER_result$colors %>%
    magrittr::set_names(levels(data$Cluster))

  plot_colors = plot_colors[color_order]

  cluster_annotation = ComplexHeatmap::rowAnnotation(Cluster = ComplexHeatmap::anno_block(gp = grid::gpar(fill = plot_colors)),
                                                     width = grid::unit(.25, "cm"))

  args = list(
    matrix = mat,
    col = col_fun,
    left_annotation = cluster_annotation,
    row_title_gp = grid::gpar(fontsize = 8, fontface = "bold"),
    column_names_gp = grid::gpar(fontsize = 8, fontface = "bold"),
    column_names_rot = 0,
    column_names_centered = TRUE,
    row_title_rot = 0,
    row_title_side = "right",
    row_gap = grid::unit(1, "mm"),
    show_row_dend = FALSE,
    show_column_dend = FALSE,
    cluster_rows = dend,
    cluster_columns = ncol(mat) >= 3,
    split = nlevels(data$Cluster),
    show_heatmap_legend = FALSE,
    border = TRUE,
    row_title = NULL
  )

  if (show_row_titles) {
    args$row_title = character()
  }

  ht = do.call(ComplexHeatmap::Heatmap, args)

  ht_draw = ComplexHeatmap::draw(
    ht,
    heatmap_legend_list = lgd,
    heatmap_legend_side = "bottom",
    padding = grid::unit(c(1, 1, 1, 1), "mm")
  )

  plot = grid::grid.grabExpr(ComplexHeatmap::draw(ht_draw)) %>%
    ggplotify::as.ggplot()

  plot
}
