FROM gcr.io/deeplearning-platform-release/r-cpu.4-2

LABEL authors="Tuyen Do" description="Docker image containing all software requirements for mamba env"

#WORKDIR /app

RUN apt-get update --allow-unauthenticated 
#RUN apt-get install -y wget --allow-unauthenticated
#RUN apt-get install -y unzip --allow-unauthenticated
RUN apt-get install git

###### MicrobiomeAnalystR
#RUN Rscript -e ".libPaths('/home/jupyter/.R/library')"
#ENTRYPOINT ['/home/jupyter/.R/library']
RUN apt-get install -y libssl-dev
RUN apt-get install -y libxml2-dev
RUN apt-get install -y libcairo2-dev
RUN apt-get install -y libxt-dev
RUN apt-get install -y libcurl4-openssl-dev

#COPY install-1.R .
#RUN Rscript install.R

RUN Rscript -e "install.packages('BiocManager')"
RUN Rscript -e "install.packages('pacman')"
RUN Rscript -e "library(pacman)"
RUN Rscript -e "pacman::p_load(phyloseq, metacoder, pryr, biomformat, RColorBrewer, ggplot2, gplots, Cairo, igraph, BiocParallel, RCurl, randomForest, metagenomeSeq, MASS, DESeq2, vegan, RJSONIO, ggfortify, pheatmap, xtable, genefilter, data.table, reshape, stringr, ape, grid, gridExtra, splitstackshape, edgeR, globaltest, R.utils, viridis, ggrepel, ppcor, qs, dplyr, limma, memoise, tidyverse, pandoc, taxa, Matrix, rhdf5)"


RUN wget https://mran.microsoft.com/snapshot/2017-12-24/src/contrib/qiimer_0.9.4.tar.gz
RUN Rscript -e "install.packages('qiimer_0.9.4.tar.gz', repos = NULL, type='source')"

RUN wget https://cran.r-project.org/src/contrib/Archive/biom/biom_0.3.12.tar.gz
RUN Rscript -e "install.packages('biom_0.3.12.tar.gz', repos = NULL, type='source')"

RUN wget http://tax4fun.gobics.de/Tax4Fun/Tax4Fun_0.3.1.tar.gz
RUN Rscript -e "install.packages('Tax4Fun_0.3.1.tar.gz', repos = NULL, type='source')"

RUN Rscript -e "install.packages('devtools')"
RUN Rscript -e "library(devtools)"

# Step 2: Install MicrobiomeAnalystR WITHOUT documentation
RUN Rscript -e "devtools::install_github('xia-lab/MicrobiomeAnalystR', build = TRUE, build_opts = c('--no-resave-data', '--no-manual', '--no-build-vignettes'))"

#RUN git clone https://github.com/xia-lab/MicrobiomeAnalystR.git
#RUN R CMD build MicrobiomeAnalystR

#RUN R CMD INSTALL MicrobiomeAnalystR_*.tar.gz

###Conda ENVs

RUN conda install mamba -n base -c conda-forge

RUN mamba install -c bioconda fastqc multiqc 

RUN mamba create -n qiime2-2021.11 -c https://packages.qiime2.org/qiime2/2021.11/passed/core/ -c conda-forge -c bioconda qiime2-core

ENV PATH /opt/conda/envs/qiime2-2021.11/bin:$PATH

#SHELL ["mamba", "run", "--no-capture-output", "-n", "qiime2-2021.11", "/bin/bash", "-c"]

RUN mamba install -n qiime2-2021.11 q2-picrust2=2021.11 -c conda-forge -c bioconda -c gavinmdouglas

RUN wget https://github.com/picrust/picrust2/archive/v2.5.1.tar.gz

RUN tar xvzf  v2.5.1.tar.gz

RUN mamba env create -f picrust2-2.5.1/picrust2-env.yaml

ENV PATH /opt/conda/envs/picrust2/bin:$PATH
#SHELL ["mamba", "run", "--no-capture-output", "-n", "picrust2", "/bin/bash", "-c"]
#RUN cd picrust2-2.5.1
#RUN pip install --editable .
RUN mamba install -n picrust2 ipykernel
RUN mamba run -n picrust2 pip install --editable picrust2-2.5.1/

#RUN mamba run -n picrust2 pytest