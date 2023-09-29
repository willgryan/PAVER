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
- name: "Ali Sajid Imami"
  orcid: "0000-0003-3684-3539"
  affiliation: 1
- name: "Hunter M. Eby"
  orcid: ""
  affiliation: 1
- name: "Xiaolu Zhang"
  orcid: ""
  affiliation: 2
- name: "Rammohan Shukla"
  orcid: "0000-0001-5776-2506"
  affiliation: 3
- name: "Robert McCullumsmith"
  orcid: "0000-0001-6921-7150"
  affiliation: 1
bibliography: paper.bib
affiliations:
- name: Department of Neurosciences, College of Medicine and Life Sciences, University of Toledo, Toledo, OH, USA
  index: 1
- name: LA, USA
  index: 2
- name: Department of Zoology & Physiology, College of Agriculture, Life Sciences and Natural Resources, University of Wyoming, Laramie, WY, USA
  index: 3
---

# Summary

Omics experiments are commonly used to predict changes in pathways underlying phenotypes. However, the results of these experiments are often long lists of pathways that are difficult to interpret. PAVER is an R package that automatically curates long lists of pathways into groups of most representative term and provides publication-ready intuitive visualizations. PAVER makes it easy to integrate multiple pathway analyses, identify relevant biological insights and can work with any pathway database.

# Statement of Need

Multiomics is used extensively in biological research today. However, the development of omics technologies has vastly outpaced the expertise of researchers in its analysis, and the resulting “data deluge” now overwhelms the capacity of human cognition [@RN16; @RN20; @RN19]. Analysis of omics data is therefore the major bottleneck in most research projects today and its use in precision medicine remains limited accordingly [@RN26; @RN63]. Pathway analysis has since become ubiquitous to help interpret omics data and elucidate mechanisms of biological phenomena under study [@RN6]. Despite the last decade bringing a host of different computational tools to perform pathway analysis, they each generally result in lists of results too long to manually inspect and extract relevant targets for wet lab validation without introducing biases [@RN5; @RN81]. Interpretation of results is thus the greatest expense in any omics project [@RN21]. The total volume of omics data continues to grow, highlighting the need for novel ways of data management [@RN22]. FAIR (Findable, Accessible, Interoperable, Reusable) scientific data principles necessitate automated interpretation of omics results.[@RN25].

# Overview

PAVER uses vector embeddings to help interpret pathway analyses. Embeddings are numerical representations of pathways that encode their meaning which can then be clustered and visualized \autoref{fig:overview}. The pathway most similar to a cluster's average embedding is deemed its most representative term.

PAVER was designed to be easy to use by researchers and students with minimal coding experience. It has already been using in a number of scientific publications to aid in the intepretation of pathway analyses [@RN78].

![PAVER uses numerical representations of pathways to find functionally related clusters.](figures/overview.png)

# Licensing and Availability

The PAVER R package is licensed under the GNU General Public License v3.0. It can be installed using remotes::install_github("willgryan/PAVER"). All code is open-source and hosted on GitHub. Report bugs using the issue tracker at https://github.com/willgryan/PAVER/issues/.

# Acknowledgements

This work was supported by NIH T32-G-RISE grant number 1T32GM144873-01.

# References
