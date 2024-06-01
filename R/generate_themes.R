#' Cluster pathway embeddings and generate themes
#'
#' This function clusters pathway embeddings using cosine similarity and generates themes for the clusters.
#'
#' @param PAVER_result A list containing the result of running prepare_data
#' @param hclust_method The agglomeration method to be used in hierarchical clustering. Default is "ward.D2".
#' @param ... Additional arguments to be passed to dynamicTreeCut
#'
#' @return A list containing the updated PAVER_result
#'
#' @examples
#' TRUE
#'
#' @export
generate_themes <-
  function(PAVER_result, hclust_method = "ward.D2", ...) {
    #Cluster pathway embeddings using cossine similarity and hierarchical clustering
    D_sim = cosine_dissimilarity(
      PAVER_result$embedding_mat %>%
        tibble::column_to_rownames("UniqueID") %>%
        as.matrix()
    )

    clust = stats::hclust(D_sim, method = hclust_method)

    #Dynamic tree cut to generate clusters
    clustering = dynamicTreeCut::cutreeDynamic(clust, distM = as.matrix(D_sim), verbose = 0, ...) %>%
      purrr::set_names(clust$labels) %>%
      tibble::enframe(name = "UniqueID", value = "Cluster") %>%
      dplyr::mutate(Cluster = as.factor(.data$Cluster)) %>%
      dplyr::inner_join(PAVER_result$embedding_mat, by = "UniqueID")

    #Average the embeddings within each cluster
    avg_cluster_embeddings = clustering %>%
      dplyr::group_by(.data$Cluster) %>%
      dplyr::summarise(dplyr::across(!.data$UniqueID, mean))

    #Identify pathways most similar to the average of each cluster i.e., it's "theme"
    nearestpathways = purrr::map_chr(1:nlevels(clustering$Cluster), function(i) {
      # Grab all embeddings within the cluster
      cluster_embeddings = clustering %>%
        dplyr::filter(.data$Cluster == i) %>%
        dplyr::select(-.data$Cluster) %>%
        tibble::column_to_rownames("UniqueID")

      # Grab the average embedding of the cluster
      avg_cluster_embedding = avg_cluster_embeddings %>%
        dplyr::filter(.data$Cluster == i) %>%
        dplyr::select(-.data$Cluster) %>%
        as.numeric()

      # Calculate cosine dissimilarity for each embedding in the cluster
      dissimilarities = cluster_embeddings %>%
        dplyr::group_nest(dplyr::row_number()) %>%
        dplyr::pull() %>%
        purrr::map_dbl( ~ cosine_dissimilarity(as.matrix(rbind(
          avg_cluster_embedding, .x
        ))))

      # Return the name of the embedding with smallest dissimilarity
      rownames(cluster_embeddings)[which.min(dissimilarities)]
    }) %>%
      tibble::enframe(name = "Cluster", value = "UniqueID") %>%
      dplyr::mutate(GOID = stringr::str_split_i(.data$UniqueID, "_", 1)) %>%
      dplyr::inner_join(PAVER_result$goterms_df, by = "GOID")

    #Set the cluster names to the identified themes
    levels(clustering$Cluster) = nearestpathways$Term
    levels(avg_cluster_embeddings$Cluster) = nearestpathways$Term

    #Reorder the clusters by similarity
    clust2 = avg_cluster_embeddings %>%
      tibble::column_to_rownames("Cluster") %>%
      as.matrix() %>%
      cosine_dissimilarity() %>%
      stats::hclust(method = hclust_method)

    clustering = clustering %>%
      dplyr::mutate(Cluster = factor(.data$Cluster, levels = clust2$labels[clust2$order])) %>%
      tidyr::separate(
        .data$UniqueID,
        into = c("GOID", "Group"),
        sep = "_",
        remove = F
      ) %>%
      dplyr::inner_join(PAVER_result$goterms_df, by = "GOID")

    avg_cluster_embeddings = avg_cluster_embeddings %>%
      dplyr::mutate(Cluster = factor(.data$Cluster, levels = clust2$labels[clust2$order]))

    #Compute the MDS of the average embedding matrix
    mds = avg_cluster_embeddings %>%
      tibble::column_to_rownames("Cluster") %>%
      as.matrix() %>%
      cosine_dissimilarity(root = TRUE) %>%
      smacof::mds(type = "ordinal")

    #Generate distinct categorical colors for plotting
    colors = randomcoloR::distinctColorPalette(k = nlevels(avg_cluster_embeddings$Cluster))

    c(PAVER_result,
      tibble::lst(clustering, avg_cluster_embeddings, mds, colors))

  }
