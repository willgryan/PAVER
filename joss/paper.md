---
title: 'PAVER: Pathway Analysis Visualization with Embedding Representations'
tags:
- R
- bioinformatics
- pathway analysis
date: "3 September 1997"
output: pdf_document
authors:
- firstname: "William G"
  family: "Ryan"
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
  affiliation: 3
- name: "Rammohan Shukla"
  orcid: "0000-0001-5776-2506"
  affiliation: 4
- name: "Robert McCullumsmith"
  orcid: "0000-0001-6921-7150"
  affiliation: "1, 2"
bibliography: paper.bib
affiliations:
- name: Department of Neurosciences, College of Medicine and Life Sciences, University of Toledo, Toledo, OH, USA
  index: 1
- name: Neurosciences Institute, ProMedica, Toledo, OH, USA 
  index: 2
- name: Department of Microbiology and Immunology, Louisiana State University Health Sciences Center, Shreveport, LA, USA
  index: 3
- name: Department of Zoology & Physiology, College of Agriculture, Life Sciences and Natural Resources, University of Wyoming, Laramie, WY, USA
  index: 4
---

# Summary

Omics studies look at large amounts of biological data to understand changes underlying different traits or conditions in living things. However, analyzing omics data often results in long, hard-to-understand lists of pathways. PAVER is an R package that automatically curates similar pathways into groups, identifies the most representative pathway of each group, and provides publication-ready intuitive visualizations. PAVER makes it easy to integrate multiple pathway analyses, discover relevant biological insights, and can work with any pathway database.

# Statement of Need

Omics is used extensively in biological research today. However, the development of omics technologies has vastly outpaced the expertise of researchers in its analysis, and the resulting “data deluge” now overwhelms the capacity of human cognition [@RN16; @RN20; @RN19]. Analysis of omics data is therefore a major bottleneck in most research projects today and its use in precision medicine remains limited for this reason[@RN26; @RN63]. Pathway analysis has become ubiquitous in helping interpret omics data and elucidate mechanisms of biological phenomena under study [@RN6]. Despite the last decade bringing a host of different computational tools to perform pathway analysis, they generally result in lists of results too long to manually inspect and extract relevant targets for downstream validation without introducing biases [@RN5; @RN81]. Interpretation of results is therefore the greatest time cost in any omics project [@RN21]. With the total volume of omics data continuing to grow, novel ways of data management are needed [@RN22]. FAIR (Findable, Accessible, Interoperable, Reusable) scientific data principles necessitate automated interpretation of omics results [@RN25].

# Overview

PAVER uses vector embeddings to help interpret pathway analyses. Embeddings encode the meaning of pathways into numerical representations which can then be hierarchically clustered and visualized (\autoref{fig:overview}). To identify which pathway is most representative of a cluster, PAVER first takes the average embedding of all pathways in a cluster to capture it's overall meaning into a single numerical representation [@RN49]. It then finds which pathway is most similar to the average embedding and labels the cluster with that pathway. This allows PAVER to automatically curate long lists of pathways into related groups and identify the pathway most representative of each group. PAVER assumes the pathway analysis was properly performed [@9tips].

![PAVER uses numerical representations of pathways to find functionally related clusters.\label{fig:overview}](figures/overview.png)

PAVER was designed to be easy to use by researchers with minimal programming experience. PAVER has already been used in a number of scientific publications to aid in the interpretation of pathway analyses [@william_ryan_2023_8156248; @RN78; @ODonovan_Ali_Deng_Patti_Wang_Eladawi_Imami_2024; @Hu_Sun_Tang_Ryan_Shrestha_Gautam_Lad_Huntley_Haller_Kennedy_2024]. We have pre-computed vector representations for Gene Ontology [@RN68] using the recent anc2vec model [@RN13], available here: [https://github.com/willgryan/PAVER_embeddings](https://github.com/willgryan/PAVER_embeddings). However, embeddings for any pathway database or ontology can be used with PAVER.

# Licensing, Availability and Usage

The PAVER R package is licensed under the GNU General Public License v3.0. All code, including installation instructions and an instructional vignette with example data, is open-source and hosted on [GitHub](https://github.com/willgryan/PAVER/). Bugs and feature requests can be made using the issue tracker at [https://github.com/willgryan/PAVER/issues/](https://github.com/willgryan/PAVER/issues/).

# Acknowledgements

This work was supported by NIH NIGMS T32-G-RISE grant number 1T32GM144873-01, NIH NIMH grant number R01MH107487, NIH NIMH grant number R01MH121102, and NIH NIA grant number R01AG057598.

# Disclosure

The authors declare no potential conflicts of interest related to the research in this manuscript, including financial, personal, or professional relationships that may affect their objectivity.

# References
