#' Prepare Gene Ontology enrichment analysis results for downstream theme generation and summary visualization
#'
#' This function prepares the results of Gene Ontology enrichment analysis for downstream theme generation and visualization by using precomputed embeddings of the core Gene Ontology.
#
#' @param input A data frame in wide format containing the Gene Ontology enrichment analysis results. The first column is expected to be GO IDs, e.g., GO:0000001
#' @param embeddings A matrix containing the precomputed Gene Ontology embeddings
#' @param ontology_index An ontology_index object prepared from the core Gene Ontology used to compute embeddings
#'
#' @return A PAVER_result list with the prepared data ready for theme generation
#'
#' @examples
#' TRUE
#'
#' @export
prepare_data <- function(input, embeddings, ontology_index) {

  #Transform wide format input to long form
  #Determine direction of enrichment from input value
  #Generates a unique ID for each pathway based on its GOID and Group
  prepared_data = input %>%
    dplyr::rename(GOID = 1) %>%
    dplyr::filter(.data$GOID %in% rownames(embeddings)) %>% #Input GOIDs must be present in the embedding matrix.
    dplyr::mutate(dplyr::across(!.data$GOID, ~ tidyr::replace_na(.x, 0))) %>%
    tidyr::pivot_longer(cols = c(!"GOID"), names_to = "Group") %>%
    dplyr::filter(.data$value != 0) %>%
    dplyr::mutate(
      Direction = factor(sign(.data$value), levels = c(-1, 1), labels = c("-", "+")),
      UniqueID = paste0(.data$GOID, "_", .data$Group)) %>%
    dplyr::distinct(.data$UniqueID, .keep_all = T)

  #Generate an embedding table keyed by unique pathway IDs
  embedding_mat = embeddings[prepared_data$GOID,] %>%
    magrittr::set_rownames(prepared_data$UniqueID) %>%
    tibble::as_tibble(rownames = "UniqueID")

  #Compute the UMAP of the embedding matrix
  custom.config = umap::umap.defaults
  custom.config$random_state = 123
  custom.config$metric = "cosine"
  custom.config$n_neighbors = 100

  umap = umap::umap(embedding_mat %>% tibble::column_to_rownames("UniqueID"), custom.config)

  #Generate a GO ID to GO Term mapping table
  goterms_df = ontology_index %>%
    purrr::pluck("name") %>%
    tibble::enframe() %>%
    dplyr::rename(GOID = 1, Term = 2) %>%
    dplyr::filter(.data$GOID %in% prepared_data$GOID)

  #Return list of data ready for theme generation
  PAVER_result = tibble::lst(prepared_data, embedding_mat, umap, goterms_df)

  PAVER_result

}
