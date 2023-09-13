![course-card](images/USD-course-card-2.png)

# University of South Dakota Dockerized Analysis of Microbial Community and Biofilms 


## Contents

- [Overview](#overview)
- [Learning Objectives](#learning-objectives)
- [Getting Started](#getting-started)
- [Software Requirements](#software-requirements)
- [Workflow Diagrams](#workflow-diagrams)
- [Submodule 0 Introduction](#submodule-0-introduction)
- [Submodule 1 Metagenome data preparation and QC](#submodule-1-metagenome-data-preparation-and-qc)
- [Submodule 2 Microbiome Analysis](#submodule-2-microbiome-analysis)
- [Submodule 3 Biomarker Discovery](#submodule-3-biomarker-discovery)
- [Submodule 4 Microbial Community Analysis](#submodule-4-microbial-community-analysis)
- [Submodule 5 Running workflows at scale with Google Batch](#submodule-5-running-workflows-at-scale-with-google-batch)
- [Data](#data)
- [Troubleshooting](#troubleshooting)
- [Funding](#funding)
- [License for Data](#license-for-data) 



![Biofilm website](images/Biofilm_Website_2.png)

## **Overview**
This README should walk the learner through the background and steps necessary to complete this training module. To use our module, clone this repo using `git clone https://github.com/NIGMS/Metagenomics-Analysis-of-Biofilm-Microbiome.git` and then navigate to the directory for this project. For more technical details of the cloud, see the [NIH Cloud Lab README](https://github.com/STRIDES/NIHCloudLabGCP).

A microbial community and biofilms are complex formations of microbials in collaborative groups, composed of different types of microorganisms such as bacteria, viruses and fungi. This tutorial aims to introduce the learner to microbiome analysis through a self-paced practical learning module that will aid in the understanding of the role of biofilms in human health and beyond. This will include the analysis of the microbial community composition (what microorganism is in my sample?), diversity, and function (what are they doing?). We will leverage quorum sensing protein signatures to provide insights into the microbial community and biofilm gene-phenotype response markers prediction.

This README describes the tutorials in our step-by-step analytic workflow. These submodules cover the end-to-end workflow of a standard metagenomics  bioinformatics analysis, starting at core dataset preparation (e.g., downloading raw sequence data) through microbial community gene/function marker prediction.

This module will cost about $8.00 to run, assuming you shut down and delete all resources when you are finished.


Tip: This module uses Docker. If you have any docker related issue, refer to our troubleshooting section below or contact us.





---
## **Learning Objectives:**
The biofilm metagenomics workflow self-learning module will serve for undergraduate through graduate level. The learning objectives vary slightly based on the audience. This Docker version will help users to achieve 2 learning objectives (LOs):

LO1. Concepts Inventory.  
The learner will learn fundamental concepts related to microbiome and biofilm analysis. Biofilms have great importance for public health because of their role in certain infectious diseases and importance in a variety of device-related infections.

LO2 - Dataset and Toolkits.  
The learner will be able to describe and manipulate datasets and toolkits relevant to microbiome analysis projects. Biofilm metagenomic analysis can be leveraged to aid in our understanding of microbial taxonomy, functions, interactions, ecology, and evolution.


The course consists of 5 learning submodules:

*Submodule #0: Introduction - Concept Inventory and Workflow Overview*  
*Submodule #1: Metagenome Data Preparation and QC*  
*Submodule #2: Microbiome Analysis*  
*Submodule #3: Biomarker Discovery*  
*Submodule #4: Microbiome Community Analysis*  
*Submodule #5: Running Workflows at Scale with Google Batch*  




## **Getting Started**
Follow the steps highlighted [here](https://github.com/STRIDES/NIHCloudLabGCP/blob/main/docs/vertexai.md) to create a new user-managed notebook in Vertex AI. Follow steps 1-8 and be especially careful to enable idle shutdown as highlighted in step 7. In step 5 click the **Environment** drop down menu, select **'Custom container'**. A new field will pop up that says 'Docker container image'. Type in the following Docker container `us-east4-docker.pkg.dev/nih-cl-shared-resources/nigms-sandbox/metagenomic-pipeline@sha256:2777ea8afbcd0f632ae7f04ebeb3a8ed21775fa3c6e9ba529046ba422bc8aaa7` then click **CONTINUE** at the bottom. In step 6 in the Machine type tab, select n1-standard-8 from the dropdown box. 

After creating your Vertex AI notebook from custom Docker image metagenomic-pipeline:
- Open Jupyter Lab
- Open the terminal: Ctrl + Shift + L -> Other -> Terminal
- Clone the our repo using the command `git clone https://github.com/NIGMS/Metagenomics-Analysis-of-Biofilm-Microbiome.git`

## **Software Requirements**

Our Workflow Analytic Toolkits includes the following tools: 
- Docker
- Jupyther Notebook
- Custom Scripts
- FastQC
- MultiQC
- Trimmomatic
- QIIME2
- Picrust2
- MicrobiomeAnalystR
- Google Big Query
- BLAST+

Each dependency will be loaded at the beginning of the module and will allow the user to understand the context in which the package is relevant to our analytic process. Some will be integrated into `requirements.yaml` available in this repository. Some notebooks will require access to the Google Cloud Platform Vertex AI environment. You can install all necessary requirements using the instructions. They will generally look like this:
```
# Code install instructions
!pip install ./q2-picrust2
```



## **Workflow Diagrams**

## Bioinformatics Workflow Diagrams

![USD workflow](images/USD_workflow.png)

Figure 1.5. Workflow.
The metagenomics workflow includes the analysis of the biofilm composition, diversity and function. The workflow consists of 5 submodules.


## Cloud Implementation Architecture of Our Workflow
The image below describes the cloud implementation of our analytic workflow. We will download sequence datasets and databases to our Vertex AI virtual machine, use custom kernels to run the analysis, then copy the outputs to a Cloud Storage bucket.

![technical infrastructure diagram](images/USD_TID.png)


## Submodule 0 Introduction  

Biofilms have great importance for public health because of their role in certain infectious diseases and importance in a variety of device-related infections.
This submodule will expose the learner to fundamental concepts of microbiome analysis.


## Submodule 1 Metagenome data preparation and QC   

**Step 1 - Core data Preparation:**   

The first step consists of identifying and downloading the project dataset and databases the rest of the submodules. 

**Step 2 - Raw data QC and improvement (FastQC, MultiQC):**  

Before analysis, we will check the dataset quality using FastQC and MultiQC.

## Submodule 2 Microbiome Analysis   

**Step 3 - Microbiome analysis (Qiime2):**  

One of the primary objectives of the workflow is to characterize the taxonomic diversity of biofilm communities from 16S data using Qiime2. This step helps provide insights into the microbial diversity by identifying and associating specific organisms or taxonomic groups with phenotypic/functional traits characterizing a given environment. Taxonomic classification is challenging because the volume of metagenomics data is large and puts high demands on bioinformatic infrastructure. Additionally, queried sequences of most microbes lack taxonomically related sequences in existing references databases. **Taxonomic binning**, the process of assigning taxonomic identifiers to sequence fragments based on sequence similarity and composition, is used in draft genome reconstruction. The outcome of the binning process can then be used not only for taxonomic diversity assessment, but also leveraged for genome assembly and evaluation of gene association with different taxonomy.


## Submodule 3 Biomarker Discovery   

**Step 4 - Biomarker Discovery (PICRUSt2, q2-Picrust): **  

Microbiome community gene prediction and functional annotation are critical steps in the biofilm metagenomics workflow. Functional annotation of metagenomic data has become an increasingly popular method for identifying the aggregate functional capacities encoded by the community’s biofilm. This analysis relies on comparisons of predicted genes with existing, previously annotated sequences. Functional profiling provides insights into what functions are carried out by a given biofilm community.


## Submodule 4 Microbial Community Analysis   

**Step 5 - Microbial Comminity and Biofilm analysis (BLAST+, Google BigQuery): **  

The microbial community analysis relies on comparisons of predicted genes, proteins, and functions with existing previously annotated sequences. Functional profiling provides insights into what functions are carried out by a given microbial community and biofilm. Quorum sensing (QS) is one of the key indicators of a bacterial community's behavior. QS is the regulation of gene expression in response to fluctuations in cell-population density. QS bacteria produce and release chemical signaling molecules called autoinducers that increase in concentration as a function of cell density. The presence of QS signaling does not always guarantee biofilm formation, but this phenomenon has proven to be a reliable marker in several phenotype analyses of biofilms, such as those involved in cancer, dental health, medical devices, corrosion, and environmental biofilms. Here we use the STRING Database and BLAST+ to search for biofilm signatures in our metagenomic samples.


## Submodule 5 Running workflows at scale with Google Batch   

This submodule shows how to encapsulate the core concepts of microbiome community analysis into an end-to-end automated workflow that runs on a remote cloud instance. By combining Nextflow with Google Batch, we show the user how to automate the entire pipeline. Resources are scheduled, launched, and shut down by the API so there is no need to keep track of running VMs. All output is stored in a cloud storage bucket specified in a config file. This submodule presents a great starting point for learning how to run microbiome analysis at scale with increasing data size and sample number.



## Data
This training module will use 2 datasets to cover the diversity of our problem. Most of the module will use the dataset featured in [Moving pictures of the human microbiome](https://pubmed.ncbi.nlm.nih.gov/21624126/) published by Caporaso et al in 2011. For our fifth submodule that demonstrates nf-core's ampliseq workflow, we use a fecal microbiome sample, [SRR24091844](https://trace.ncbi.nlm.nih.gov/Traces/?view=run_browser&acc=SRR24091844&display=metadata).



## Troubleshooting

Common errors encountered in this workflow include: 
1. Missing file. This error can have multiple causes:
    - Wrong file path: Find the correct file in notebook directories, then update the correct file path.
    - File does not exist: Find path in the provided bucket or notebook and update command.
    - File was not generated: Check previous steps make sure previous step run successfully.
2. Cannot create/remove file or folder: This error can appear when you rerun the pipeline. You must usually delete the directory or the files within the output directory from processes like Qiime2.
3. Please make sure that the PICRUSt2 directory is not moved as it contains scripts whose path have been hard-coded in the containers.


## Funding

Funded by the South Dakota INBRE Program NIH/NIGMS P20 GM103443.


## License for Data

All data and download files in STRING-DB are freely available under a 'Creative Commons BY 4.0' license.

Text and materials are licensed under a Creative Commons CC-BY-NC-SA license. The license allows you to copy, remix and redistribute any of our publicly available materials, under the condition that you attribute the work (details in the license) and do not make profits from it. More information is available [here](https://tilburgsciencehub.com/about/#license).

![Creative commons license](https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png)

This work is licensed under a [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License](http://creativecommons.org/licenses/by-nc-sa/4.0/)
