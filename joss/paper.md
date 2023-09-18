---
title: 'PAVER: Pathway Analysis Visualization with Embedding Representations'
tags:
- R
- bioinformatics
- pathway analysis
date: "3 September 2023"
output: pdf_document
authors:
- name: "William George Ryan V"
  orcid: "0000-0003-4868-4002"
  corresponding: yes
  affiliation: 1
bibliography: paper.bib
affiliations:
- name: The University of Toledo College of Medicine and Life Sciences Department of Neurosciences, USA
  index: 1
---

# Summary

The terminal outputs of many omics experiments are long lists of genes, proteins, or metabolites. These lists are often analyzed using pathway analysis tools, which identify pathways that are enriched for the list of genes. However, these tools often return long lists of pathways themselves, which can be difficult to interpret. PAVER is an R package that automatically curates long lists of pathways into groups of most representative terms (MRTs) and provides publication-ready intuitive visualizations. It makes it easy to integrate multiple pathway analyses, identify relevant biological insights and is designed to work with any pathway database.

# Statement of Need

The surge in high-throughput multiomics technologies has revolutionized biological research but simultaneously introduced a significant data interpretation challenge. Current tools, predominantly built around the Gene Ontology (GO), provide exhaustive pathway analysis results that are cumbersome and time-intensive to manually curate. Moreover, there's a notable limitation in harnessing insights from non-GO pathway databases like KEGG and Reactome. There's a pressing need for a comprehensive solution that not only integrates pathway analyses from multiple pathway analyses but also distills the vast results into interpretable insights for researchers. PAVER clusters pathways to identify the most representative terms using embedding representations, streamlining the interpretation process. Moreover, it is designed for compatibility with any pathway database, offering researchers a versatile and efficient tool to navigate the complexities of multiomics data interpretation.

PAVER was designed to be easy to use by researchers and students with minimal coding experience. It has already been using in a number of scientific publications to aid in the intepretation of pathway analyses [@RN78].

# Overview

![Caption for example figure.](figures/overview.png)

# Example

# Licensing and Availability

The PAVER R package is licensed under the GNU General Public License v3.0. It is available on GitHub, and can be installed using remotes::install_github("willgryan/PAVER"). All code is open-source and hosted on GitHub, and bugs can be reported using the issue tracker at https://github.com/willgryan/PAVER/issues/.

# Acknowledgements

We acknowledge...

# References
