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
    #Cluster pathway embeddings using cossine similarity
    D_sim = cosine_dissimilarity(PAVER_result$embedding_mat)

    clust = stats::hclust(D_sim, method = hclust_method)

    #Dynamic tree to generate clusters
    clustering = dynamicTreeCut::cutreeDynamic(clust, distM = as.matrix(D_sim), ...) %>%
      purrr::set_names(clust$labels) %>%
      tibble::enframe() %>%
      dplyr::rename(UniqueID = 1, Cluster = 2) %>%
      dplyr::mutate(Cluster = forcats::as_factor(.data$Cluster)) %>%
      dplyr::inner_join(PAVER_result$embedding_mat %>%
                          tibble::as_tibble(rownames=NA) %>%
                          tibble::rownames_to_column("UniqueID"), by = "UniqueID")

    avg_cluster_embeddings = clustering %>%
      dplyr::group_by(.data$Cluster) %>%
      dplyr::summarise(dplyr::across(-.data$UniqueID, mean))

    #Iterate through each cluster to find the embedding closest to the cluster average
    nearestpathways = list()
    for (i in 1:nlevels(clustering$Cluster)) {
      top = ""
      sim = 2 #Worst case cosine distance

      #Grab all embeddings within the cluster
      cluster_embeddings = clustering %>%
        dplyr::filter(.data$Cluster == i) %>%
        dplyr::select(-.data$Cluster) %>%
        tibble::column_to_rownames("UniqueID")

      #Grab the average embedding of the cluster
      avg_cluster_embedding = avg_cluster_embeddings %>%
        dplyr::filter(.data$Cluster == i) %>%
        dplyr::select(-.data$Cluster) %>%
        as.numeric()

      #Iterate through every embedding within the cluster to see which is closest to the average cluster embedding
      for (pathway in 1:nrow(cluster_embeddings)) {
        embedding = cluster_embeddings[pathway,] %>% as.numeric()
        local_sim = cosine_dissimilarity(rbind(avg_cluster_embedding, embedding)) %>% as.numeric()
        if (local_sim <= sim) {
          top = rownames(cluster_embeddings)[pathway]
          sim = local_sim
        }
      }
      nearestpathways <- append(nearestpathways, top)
    }

    #Set the cluster names to the identified themes
    nearestpathwaysdf <- nearestpathways %>%
      tibble::enframe() %>%
      dplyr::rename(Cluster = .data$name, UniqueID = .data$value) %>%
      dplyr::mutate(UniqueID = unlist(.data$UniqueID)) %>%
      dplyr::mutate(GOID = stringr::str_split_i(.data$UniqueID, "_", 1)) %>%
      dplyr::inner_join(PAVER_result$goterms_df, by = "GOID")

    levels(clustering$Cluster) <- nearestpathwaysdf$Term
    levels(avg_cluster_embeddings$Cluster) <- nearestpathwaysdf$Term

    #Reorder the clusters by similarity
    clust2 = cosine_dissimilarity(avg_cluster_embeddings %>%
                                    tibble::column_to_rownames("Cluster") %>%
                                    as.matrix()) %>%
      stats::hclust(method = hclust_method)

    clustering <- clustering %>%
      dplyr::mutate(Cluster = factor(.data$Cluster, levels = clust2$labels[clust2$order])) %>%
      tidyr::separate(.data$UniqueID, into = c("GOID", "Group"), sep = "_", remove = F) %>%
      dplyr::inner_join(PAVER_result$goterms_df, by = "GOID")

    avg_cluster_embeddings <- avg_cluster_embeddings %>%
      dplyr::mutate(Cluster = factor(.data$Cluster, levels = clust2$labels[clust2$order]))

    #Compute MDS of average cluster embeddings
    #Compute the MDS of the average embedding matrix
    mds = avg_cluster_embeddings %>%
      tibble::column_to_rownames("Cluster") %>%
      as.matrix() %>%
      cosine_dissimilarity(root = T) %>%
      smacof::mds(type = "ordinal")

    #Generate distinct categorical colors for plotting
    colors = randomcoloR::distinctColorPalette(k = nlevels(avg_cluster_embeddings$Cluster))

    c(PAVER_result, tibble::lst(clustering, avg_cluster_embeddings, mds, colors))

  }
