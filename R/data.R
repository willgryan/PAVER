#' An example of GSEA results
#'
#' A wide data frame with Normalized Enrichment Scores from
#' Gene-Set Enrichment Analysis of three different comparisons.
#'
#' @format A data frame with 1080 rows and 4 columns:
#' \describe{
#' \item{GOID}{Gene Ontology Term IDs}
#' \item{SCZvsCtrl}{NES of GO terms}
#' \item{SCZvsCtrlD}{NES of GO terms}
#' \item{SCZvsCtrlS}{NES of GO terms}
#' }
#'
#' @source <https://doi.org/10.1038/s41380-021-01205-y>
"gsea_example"

#' An example of KEGG results
#'
#' A wide data frame with enrichment scores (log10 FDR) from
#' MetaboAnalyst of one comparison.
#'
#' @format A data frame with 183 rows and 2 columns:
#' \describe{
#' \item{MAP}{KEGG Pathway IDS}
#' \item{MA}{Enrichment Scores of KEGG pathways}
#' }
#'
#' @source <https://doi.org/10.1101/2023.10.13.562226>
"kegg_example"
