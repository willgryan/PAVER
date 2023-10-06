---
title: 'PAVER: Pathway Analysis Visualization with Embedding Representations'
tags:
- R
- bioinformatics
- pathway analysis
date: "3 September 1997"
output: pdf_document
authors:
- name: "William G Ryan"
  suffix: "V"
  orcid: "0000-0003-4868-4002"
  corresponding: yes
  affiliation: 1
- name: "Ali Sajid Imami"
  orcid: "0000-0003-3684-3539"
  affiliation: 1
- name: "Hunter Eby"
  orcid: "0000-0002-9029-9768"
  affiliation: 1
- name: "Xiaolu Zhang"
  orcid: "0000-0001-5595-7270"
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
- name: Department of Microbiology and Immunology, Louisiana State University Health Sciences Center, Shreveport, LA, USA
  index: 2
- name: Department of Zoology & Physiology, College of Agriculture, Life Sciences and Natural Resources, University of Wyoming, Laramie, WY, USA
  index: 3
---

# Summary

Omics studies are commonly used to predict changes in biological pathways underlying phenotypes. However, the results of omics experiments can be long lists of pathways that are difficult to interpret. PAVER is an R package that automatically curates long lists of pathways into groups, identifies which pathway is most representative of each group, and provides publication-ready intuitive visualizations. PAVER makes it easy to integrate multiple pathway analyses, identify relevant biological insights and can work with any pathway database.

# Statement of Need

Omics is used extensively in biological research today. However, the development of omics technologies has vastly outpaced the expertise of researchers in its analysis, and the resulting “data deluge” now overwhelms the capacity of human cognition [@RN16; @RN20; @RN19]. Analysis of omics data is therefore the major bottleneck in most research projects today and its use in precision medicine remains limited accordingly [@RN26; @RN63]. Pathway analysis has since become ubiquitous to help interpret omics data and elucidate mechanisms of biological phenomena under study [@RN6]. Despite the last decade bringing a host of different computational tools to perform pathway analysis, they each generally result in lists of results too long to manually inspect and extract relevant targets for downstream wet lab validation without introducing biases [@RN5; @RN81]. Interpretation of results is accordingly the greatest expense in any omics project [@RN21]. With the total volume of omics data continuing to grow, novel ways of data management are needed [@RN22]. FAIR (Findable, Accessible, Interoperable, Reusable) scientific data principles necessitate automated interpretation of omics results [@RN25].

# Overview

PAVER uses vector embeddings to help interpret pathway analyses. Embeddings encode the meaning of pathways into numerical representations which can then be hierarchically clustered and visualized (\autoref{fig:overview}). To identify which pathway is most representative of a cluster, PAVER first takes the average embedding of all pathways in a cluster to capture it's overall meaning into a single numerical representation [@RN49]. It then finds which pathway is most similar to the average embedding and labels the cluster with that pathway. This allows PAVER to automatically curate long lists of pathways into groups and identify which pathway is most representative of each group.

![PAVER uses numerical representations of pathways to find functionally related clusters.\label{fig:overview}](figures/overview.png)

PAVER was designed to be easy to use by researchers and students with minimal coding experience. PAVER has already been using in a number of scientific publications to aid in the intepretation of pathway analyses [@william_ryan_2023_8156248; @RN78]. We have pre-computed vector representations for Gene Ontology [@RN68] using the recent anc2vec model [@RN13], available here: https://github.com/willgryan/PAVER_embeddings. However, embeddings for any pathway database can be used with PAVER.

# Licensing, Availability and Usage

The PAVER R package is licensed under the GNU General Public License v3.0. It can be installed using remotes::install_github("willgryan/PAVER"). All code, including an instructional vignette with an example dataset, is open-source and hosted on GitHub. Report bugs using the issue tracker at https://github.com/willgryan/PAVER/issues/.

# Acknowledgements

This work was supported by NIH T32-G-RISE grant number 1T32GM144873-01.

# Disclosure

The authors declare no potential conflicts of interest with respect to the research, authorship, and/or publication of this article.

# References
