# University of South Dakota Metagenomics Dockerized Analysis of Microbial Community and Biofilm 
---------------------------------

## Contents

- [Overview](#OV)
- [Learning Objectives](#LOS)
- [Getting Started](#GS)
- [Software Requirements](#SOF)
- [Workflow Diagrams](#WORK)
    + [Submodule 0 (Python): Introduction - Concept Inventory and Workflow Overview](#LSM0)
    + [Submodule 1 (Python) - Metagenome data preparation and QC](#LSM1)
    + [Submodule 2 (Python, BASH) - Microbiome Analysis](#LSM2)
    + [Submodule 3 (Python, BASH, R) - Biomarker Discovery](#LSM3)
    + [Submodule 4 (Python, BASH) - Microbial Community Analysis](#LSM4)
    + [Submodule 5 (Python, BASH) - Running workflows at scale with Google Life Sciences API](#LSM5)
- [Data](#DATA)
- [Troubleshooting](#TR)
- [Funding](#FUND)
- [License for Data](#LIC) 

---

<img src="images/Biofilm Website 2.png" width="800" height="400">

## **Overview** <a name="OV"></a>
> INSTRUCTIONS: This README should walk the learner through the background and steps necessary to complete your teaching module. To use our module clone this repo using `git clone https://github.com/NIGMS/MetagenomicsUSD` and then navigate to the directory for this project. For more technical details of the cloud, you can rely on the the [NIH Cloud Lab README](https://github.com/STRIDES/NIHCloudLabGCP).  

A microbial community and biofilms are complex formations of microbials in collaborative groups, composed of different types of microorganisms such as bacteria, viruses and fungi. This tutorial aims to introduce the learner to Metagenomics Workflow Self-paced Practical Learning Module that will aid in the understanding of biofilms role in human health and beyond. This will include the analysis of the microbial community composition (what microorganism is in my sample?), diversity, and function (what are they doing?). We will leverage quorum sensing protein signatures to provide insights into the microbial community and biofilm gene-phenotype response markers prediction.

This README provides the tutorials to our step-by-step analytic workflow. These tutorials do this by going step-by-step through specific submodules in our workflow. These submodules cover the start to finish of basic bioinformatics analysis starting from core dataset preparation(e.g. downloading raw sequence data), to our microbial community gene/function marker prediction.

<div class="alert alert-block alert-info">
    <i class="fa fa-lightbulb-o" aria-hidden="true"></i>
    <b>Tip: </b> This version of the training module runs on Docker. If you have any docker related issue, refer to our troubleshooting section below or contact us. 
</div>



<font color = "red"> <b>[Intro_video] </b> </font>

---
## **Learning Objectives:** <a name="LOS"></a>
The Biofilm Metagenomics Workflow Self-Learning Module will serve for undergrad to graduate level. The learning objectives vary slightly based on the audience. It would also be our intention to offer additional technical learning objectives, such as deploying the learning module to alternate platforms and customizing the workflow, for interested students.
This Docker version will focus on a turn-key-run audience and help them to achieve 2 learning objectives(LOs):

LO1. Concepts Inventory
 > Statement 1: The learner will receive fundamental concepts related to microbiome and biofilm analysis. Biofilms have great importance for public health because of their role in certain infectious diseases and importance in a variety of device-related infections.

LO2 - Dataset and Toolkits 
> Statement 1: The learner will be able to describe and manipulate Dataset and Toolkits relevant to microbiome analysis project  - Biofilm Metagenomic analysis can be leveraged to aid in our understanding of microbial taxonomy, functions, interactions, ecology, and evolution.


The course consists of 5 learning submodules:

*Submodule #0: Introduction - Concept Inventory and Workflow Overview* <br>
*Submodule #1:  Metagenome data preparation and QC* <br>
*Submodule #2: Microbiome analysis* <br>
*Submodule #3: Biomarker Discovery* <br>
*Submodule #4: Microbiome Community Analysis* <br>
*Submodule #5: Running workflows at scale with Google Life Sciences API* <br> 

---


## **Getting Started** <a name="GS"></a> 
Before creating your notebook make sure you has access to and have enabled the tools Big Query and Life Sciences.
Once that is done go to Vertex AI by searching the name in the search bar, go to Workbench , USER-MANAGED NOTEBOOKS, +NEW NOTEBOOK, then click R 4.2 (or greater). 
<img src="images/notebook_setup.png" width="450" height="300"></img> <br>
Type in your notebooks name and click ADVANCE OPTIONS<br>
<img src="images/Notebook_setup2.png" width="450" height="300"></img> <br>
Go to the Environment tab and click the drop down menu where it says of Environment, select **'Custom container'**.
A new field will pop up that says 'Docker container image' type in the following docker container <mark> Ross or Kyle fill in `gcr.io/`</mark> then click CONTINUE at the bottom.
<img src="images/Notebook_setup4.png" width="450" height="300"></img> <br> <br>
The GCP Vertex AI notebook instance requires 8 vCPUs, 30 GB RAM so from the Machine Type field click the drop down menu and select machine-type **n1-standard-8**. Now you can click CREATE. <br>
<img src="images/Notebook_setup3.png" width="450" height="300"></img>

After creating your Vertex AI notebook from custom docker image metagenomic-pipeline.
- Open Jupyter Lab
- Open the terminal: Ctrl + Shift + L -> Other -> Terminal
- Clone the our repo using the command `git clone https://github.com/NIGMS/MetagenomicsUSD`



---

## **Software Requirements** <a name="SOF"></a>

Our Workflow Analytic Toolkits includes the following tools: 
- Docker
- Jupyther Notebook
- Custom Scripts
- FastQC
- MultiQC
- Trimmomatic
- QUIIME2
- Picrust2
- MicrobiomeAnalystR
- Google Big Query
- Blast+

Each dependency will be loaded at the beginning of the module and will allow the user to understand the context in which the package is relevant to our analytic process. Some will be integrated into `requirements.yaml` available in this repository. Some notebooks will require access to the Google Cloud Platform Vertex AI environment. You can install all necessary requirements using the instructions, but they will generally look like this:
```
# Code install instructions
!pip install ./q2-picrust2
```


---
## **Workflow Diagrams** <a name="WORK"></a>

### Bioinformatics Workflow Diagrams

<img src="images/USD_workflow.png" width="450" height="300"></img>

Figure 1.5. Bioinformatics Workflow
The metagenomics workflow includes the analysis of the biofilm composition, diversity and function. The workflow consist into 5 steps with Microbiome Analyst acting as an alternative tool to PICRUSt2. 


### Cloud Implementation Architecture of Our Workflow
The image below describes the cloud implementation of our analytic workflow, we will download sequence datasets and databases to our Vertex AI virtual machine, use a custom made kernels to run the analysis, then copy the outputs to a Cloud Storage bucket. 

<img src="images/USD_TID.png" width="700" height="700">


### [Submodule 0 (Python)](./SubModule00.ipynb) - Introduction - Concept Inventory and Workflow Overview <a name="LSM0"></a>

Biofilms have great importance for public health because of their role in certain infectious diseases and importance in a variety of device-related infections.
This module will expose the learner in fundamental concepts for microbiome analysis.


### [Submodule 1 (Python)](./SubModule01.ipynb) - Metagenome data preparation and QC <a name= "LSM1"> </a>

<b> Step 1 - Core data Preparation:</b> 
The first step consist in identifying and annotating the project dataset with relevant database for machine learning prediction Blast alignment. 

<b> Step 2 - Raw data QC and improvement (FastQC, MultiQC):</b> 
Before analysis, we will check the dataset quality using ** FastQC ** and ** MultiQC **. Poor quality reads wil be trimmed using ** Trimmomatic **. 

### [Submodule 2 (Python, BASH)](./SubModule02.ipynb) - Microbiome Analysis <a name= "LSM2"> </a>

<b> Step 3 - Microbiome analysis (Qiime2):</b>
One of the primary objectives of the workflow is characterizing the taxonomic diversity of biofilm communities from 16S data using Qiime2. This step helps provide insights into the microbial diversity by identifying and associating specific organisms or taxonomic groups with phenotypic/functional traits characterizing a given environment. Taxonomic classification is challenging because the volume of metagenomics data is large and provides a high demands of bioinformatic tools. Additionally, queried sequences of most microbes lack taxonomically related sequences in existing references databases. **Taxonomic binning**, the process of assigning taxonomic identifiers to sequence fragments based on sequence similarity and composition, is used to draft genome reconstruction. The outcome of the binning process can then be used not only for taxonomic diversity assessment, but also leveraged for genome assembly and evaluation of gene association with different taxonomy. 


### [Submodule 3 (Python, BASH, R)](./SubModule03.ipynb) - Biomarker Discovery <a name= "LSM3"> </a>

<b> Step 4 - Biomarker Discovery (PICRUSt2, q2-Picrust, MicrobeAnalystR): </b> 
Microbiome Community Gene prediction and the functional annotation are also critical steps in the biofilm metagenomics workflow. Functional annotation of shotgun metagenomic data has become an increasingly popular method for identifying the aggregate functional capacities encoded by the community’s biofilm. This analysis relies on comparisons of predicted genes with existing, previously annotated sequences. Functional profiling provides insights into what functions are carried out by a given biofilm community.


### [Submodule 4 (Python, BASH)](./SubModule04.ipynb) - Microbial Community Analysis <a name= "LSM4"> </a>

<b> Step 5 - Microbial Comminity and Bioofilm analysis (BLAST+, Google Big Query): </b>  

The microbial community analysis relies on comparisons of predicted genes, protein and functions with existing, previously annotated sequences. Functional profiling provides insights into what functions are carried out by a given microbial community and biofilm. Quorum sensing (QS) is one of the key indicators of that communities behavior. Even if the presence of QS does not always guarantee the biofilm formation, this mechanism has proven to be a reliable marker in several phenotype analyses including cancer, dental biofilm, medical device, corrosion, environmental biofilm. Quorum sensing is the regulation of gene expression in response to fluctuations in cell-population density. Quorum sensing bacteria produce and release chemical signal molecules called autoinducers that increase in concentration as a function of cell density. Here we use the STRING Database and Blast+ to find the most relevant biofilm signature.


### [Submodule 5 (Python, BASH)](./SubModule05.ipynb) - Running workflows at scale with Google Life Sciences API <a name= "LSM5"> </a>

This submodule shows how to encapsulate the core concepts of microbiome community analysis into an end-to-end automated workflow that runs on a remote cloud instance. By combining Nextflow with the Google Life Sciences API, we show the user how to automate the entire pipeline. Resources are scheduled, launched, and shut down by the API so there is no need to keep track of running VMs. All output is stored in a cloud storage bucket specified in a config file. This submodule presents a great starting point for learning how to run microbiome analysis at scale with increasing data size and sample number.


---
# **Data** <a name="DATA"></a>
This training module will use 5 datasets to cover the diversity of our problem. The testing module will use the dataset from Taxonomic differences of gut microbiomes drive cellulolytic enzymatic potential within hind-gut fermenting mammals by Finlayson-Trick et al., 2017.  We subsequently downsized the data to streamline the tutorials and stored them in a Google Cloud Storage Bucket. 


---
# **Troubleshooting** <a name="TR"></a>

This workflow execution common error include: authentication to GCP error.  
1. Missing file:
    - Wrong file path: find the correct file in 5 folders 1 -> 5 then update the correct file path
    - File does not exist: find on provided bucket or given links in notebook
    - Check previous steps make sure previous step run successfully
2. Cannot create/remove file or folder: This error can appear during run and rerun the pipeline, usually the file already exist, so follow the alters that ask you to delete the directory or the files within the directory.
3. Please make sure that the picrust2 directory is not moved as it contains scripts whos path have been added to this containers PATH. If it is moved picrust will not work.
4. If your notebook does not start up when clicking JUPYTERLAB close the windo and wait 60 secs before you open it again.

---
# **Funding** <a name="FUND"></a>

>Funded by the South Dakota INBRE Program NIH/NIGMS P20 GM103443.

---
# **License for Data** <a name="LIC"></a>

All data and download files in STRING-DB are freely available under a 'Creative Commons BY 4.0' license.

Text and materials are licensed under a Creative Commons CC-BY-NC-SA license. The license allows you to copy, remix and redistribute any of our publicly available materials, under the condition that you attribute the work (details in the license) and do not make profits from it. More information is available [here](https://tilburgsciencehub.com/about/#license).

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />

This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>.

```python

```