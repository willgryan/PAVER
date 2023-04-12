#' Prepare Gene Ontology enrichment analysis results for downstream theme generation and summary visualization
#'
#' This function prepares the results of Gene Ontology enrichment analysis for downstream theme generation and visualization by using precomputed embeddings of the core Gene Ontology.
#
#' @param input A data frame in wide format containing the Gene Ontology enrichment analysis results. The first column is expected to be GO IDs, e.g., GO:0000001
#' @param embeddings A matrix containing the precomputed Gene Ontology embeddings
#' @param ontology_index An ontology_index object prepared from the core Gene Ontology used to compute embeddings
#' @param seed An integer setting the seed for UMAP
#' @param unit A character describing the unit of the enrichment analysis results
#'
#' @return A PAVER_result list with the prepared data, embedding matrix, GO Term ID to definition mappings, and computed UMAP
#'
#' @examples
#' TRUE
#'
#' @export
prepare_data <- function(input, embeddings, ontology_index, unit = "NES", seed = 123) {

  #Ensure first column is named GOID and NAs are 0.
  input = input %>%
    dplyr::rename(GOID = 1) %>%
    dplyr::mutate(dplyr::across(
      .cols = c(!.data$GOID),
      .fns = ~ tidyr::replace_na(.x, 0)))

  #Transform the named embedding matrix to a keyed wide format tibble
  embeddings = embeddings %>%
    tibble::as_tibble(rownames = NA, .name_repair = "unique") %>%
    tibble::rownames_to_column("GOID")

  #Transform wide format input to long form
  #Determine direction of enrichment from input value
  #Generates a unique ID for each pathway based on GOID and Group
  prepared_data = input %>%
    tidyr::pivot_longer(cols = -1, names_to = "Group") %>%
    dplyr::group_by(.data$Group) %>%
    dplyr::filter(.data$value != 0) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(Direction = ifelse(.data$value >= 0, "Up", NA_character_)) %>%
    dplyr::mutate(Direction = ifelse(.data$value < 0, "Down", .data$Direction)) %>%
    dplyr::mutate(Direction = as.factor(.data$Direction)) %>%
    dplyr::mutate(UniqueID = paste0(.data$GOID, "_", .data$Group)) %>%
    dplyr::distinct(.data$UniqueID, .keep_all = T)

  #Generate a named embedding matrix from the prepared data
  embedding_mat = prepared_data %>%
    dplyr::inner_join(embeddings, by = "GOID") %>%
    dplyr::select(-c("value", "Direction", "Group", "GOID")) %>%
    tibble::column_to_rownames("UniqueID") %>%
    as.matrix()

  #Compute the UMAP of the embedding matrix
  custom.config = umap::umap.defaults
  custom.config$random_state = seed
  custom.config$metric = "cosine"

  umap = umap::umap(embedding_mat, custom.config)

  #Generate a GO term ID to term definition mapping table
  goterms_df = ontology_index %>%
    purrr::pluck("name") %>%
    tibble::enframe() %>%
    dplyr::rename(GOID = 1, Term = 2)

  #Return list of data ready for theme generation
  PAVER_result = tibble::lst(prepared_data, embedding_mat, goterms_df, umap, unit)

  PAVER_result

}
