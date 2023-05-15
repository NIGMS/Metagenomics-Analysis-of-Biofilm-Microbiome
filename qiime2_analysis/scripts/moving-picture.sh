#!/bin/bash
## Setup the WD
exec   > >(tee -ia moving_pictures.log)
exec  2> >(tee -ia moving_pictures.log >& 2)
exec 19> moving_pictures.log

export BASH_XTRACEFD="19"
set -x

SECONDS=0
start=`date`

while getopts m:s:b:c:o:l:t: flag 
do
  case "${flag}" in
    m) meta=${OPTARG} ;;
    s) seq_m_dir=${OPTARG} ;;
    b) body=${OPTARG} ;;
    c) class=${OPTARG} ;;
    o) WDir_OutPut=${OPTARG} ;;
    l) trimleft=${OPTARG} ;; 
    t) trunclen=${OPTARG} ;;
    ?) echo "script usage: $(basename \$0) [-m metadata file] [-s directory that contains sequence and barcode fastq files] [-b body site] [-c classifier file] [-o output directory] [-l position to trim left side] [-t starting position to trim and onwards]" ,
      exit 1 ;;
  esac
done

#shift "$(($OPTIND -1))"

if [ ! -d "${WDir_OutPut}" ]
then
    mkdir "${WDir_OutPut}"
else
    echo "Directory ${WDir_OutPut} exists!"
fi


convert="${seq_m_dir##*/}"

qiime tools import --type EMPSingleEndSequences --input-path ${seq_m_dir} --output-path ${WDir_OutPut}/${convert}.qza

qiime demux emp-single --i-seqs  ${WDir_OutPut}/${convert}.qza --m-barcodes-file ${meta} --m-barcodes-column barcode-sequence --o-per-sample-sequences ${WDir_OutPut}/demux.qza --o-error-correction-details ${WDir_OutPut}/demux-details.qza

qiime dada2 denoise-single --i-demultiplexed-seqs ${WDir_OutPut}/demux.qza --p-trim-left $trimleft --p-trunc-len $trunclen --o-representative-sequences ${WDir_OutPut}/rep-seqs-dada2.qza --o-table ${WDir_OutPut}/table-dada2.qza --o-denoising-stats ${WDir_OutPut}/stats-dada2.qza

qiime metadata tabulate --m-input-file ${WDir_OutPut}/stats-dada2.qza --o-visualization ${WDir_OutPut}/stats-dada2.qzv

mv ${WDir_OutPut}/rep-seqs-dada2.qza ${WDir_OutPut}/rep-seqs.qza
mv ${WDir_OutPut}/table-dada2.qza ${WDir_OutPut}/table.qza

#### Alternative to DADA2
# qiime quality-filter q-score --i-demux ${WDir_OutPut}/demux.qza --o-filtered-sequences ${WDir_OutPut}/demux-filtered.qza --o-filter-stats ${WDir_OutPut}/demux-filter-stats.qza

# qiime deblur denoise-16S --i-demultiplexed-seqs ${WDir_OutPut}/demux-filtered.qza --p-trim-length 120 --o-representative-sequences ${WDir_OutPut}/rep-seqs-deblur.qza --o-table ${WDir_OutPut}/table-deblur.qza --p-sample-stats --o-stats ${WDir_OutPut}/deblur-stats.qza

# qiime metadata tabulate --m-input-file ${WDir_OutPut}/demux-filter-stats.qza --o-visualization ${WDir_OutPut}/demux-filter-stats.qzv

# qiime deblur visualize-stats --i-deblur-stats ${WDir_OutPut}/deblur-stats.qza --o-visualization ${WDir_OutPut}/deblur-stats.qzv

# mv ${WDir_OutPut}/rep-seqs-deblur.qza ${WDir_OutPut}/rep-seqs.qza

# mv ${WDir_OutPut}/table-deblur.qza ${WDir_OutPut}/table.qza

qiime feature-table summarize --i-table ${WDir_OutPut}/table.qza --o-visualization ${WDir_OutPut}/table.qzv --m-sample-metadata-file ${meta}

qiime feature-table tabulate-seqs --i-data ${WDir_OutPut}/rep-seqs.qza --o-visualization ${WDir_OutPut}/rep-seqs.qzv

qiime phylogeny align-to-tree-mafft-fasttree --i-sequences ${WDir_OutPut}/rep-seqs.qza --o-alignment ${WDir_OutPut}/aligned-rep-seqs.qza --o-masked-alignment ${WDir_OutPut}/masked-aligned-rep-seqs.qza --o-tree ${WDir_OutPut}/unrooted-tree.qza --o-rooted-tree ${WDir_OutPut}/rooted-tree.qza

if [ -d "${WDir_OutPut}/core-metrics-results" ] 
then
    echo "Deleting existing directory ${WDir_OutPut}/core-metrics-results"
    rm -r  "${WDir_OutPut}/core-metrics-results"
    echo "Running: qiime diversity core-metrics-phylogenetic"
    qiime diversity core-metrics-phylogenetic --i-phylogeny ${WDir_OutPut}/rooted-tree.qza --i-table ${WDir_OutPut}/table.qza --p-sampling-depth 1103 --m-metadata-file ${meta} --output-dir ${WDir_OutPut}/core-metrics-results   
else
    qiime diversity core-metrics-phylogenetic --i-phylogeny ${WDir_OutPut}/rooted-tree.qza --i-table ${WDir_OutPut}/table.qza --p-sampling-depth 1103 --m-metadata-file ${meta} --output-dir ${WDir_OutPut}/core-metrics-results
fi

qiime diversity alpha-group-significance --i-alpha-diversity ${WDir_OutPut}/core-metrics-results/faith_pd_vector.qza --m-metadata-file ${meta} --o-visualization ${WDir_OutPut}/core-metrics-results/faith-pd-group-significance.qzv

qiime diversity alpha-group-significance --i-alpha-diversity ${WDir_OutPut}/core-metrics-results/evenness_vector.qza --m-metadata-file ${meta} --o-visualization ${WDir_OutPut}/core-metrics-results/evenness-group-significance.qzv

qiime diversity beta-group-significance --i-distance-matrix ${WDir_OutPut}/core-metrics-results/unweighted_unifrac_distance_matrix.qza --m-metadata-file ${meta} --m-metadata-column body-site --o-visualization ${WDir_OutPut}/core-metrics-results/unweighted-unifrac-body-site-significance.qzv --p-pairwise

qiime diversity beta-group-significance --i-distance-matrix ${WDir_OutPut}/core-metrics-results/unweighted_unifrac_distance_matrix.qza --m-metadata-file ${meta} --m-metadata-column subject --o-visualization ${WDir_OutPut}/core-metrics-results/unweighted-unifrac-subject-group-significance.qzv --p-pairwise

qiime emperor plot --i-pcoa ${WDir_OutPut}/core-metrics-results/unweighted_unifrac_pcoa_results.qza --m-metadata-file ${meta} --p-custom-axes days-since-experiment-start --o-visualization ${WDir_OutPut}/core-metrics-results/unweighted-unifrac-emperor-days-since-experiment-start.qzv

qiime emperor plot --i-pcoa ${WDir_OutPut}/core-metrics-results/bray_curtis_pcoa_results.qza --m-metadata-file ${meta} --p-custom-axes days-since-experiment-start --o-visualization ${WDir_OutPut}/core-metrics-results/bray-curtis-emperor-days-since-experiment-start.qzv

qiime diversity alpha-rarefaction --i-table ${WDir_OutPut}/table.qza --i-phylogeny ${WDir_OutPut}/rooted-tree.qza --p-max-depth 4000 --m-metadata-file ${meta} --o-visualization ${WDir_OutPut}/alpha-rarefaction.qzv

qiime feature-classifier classify-sklearn --i-classifier ${class} --i-reads ${WDir_OutPut}/rep-seqs.qza --o-classification ${WDir_OutPut}/taxonomy.qza

qiime metadata tabulate --m-input-file ${WDir_OutPut}/taxonomy.qza --o-visualization ${WDir_OutPut}/taxonomy.qzv

qiime taxa barplot --i-table ${WDir_OutPut}/table.qza --i-taxonomy ${WDir_OutPut}/taxonomy.qza --m-metadata-file ${meta} --o-visualization ${WDir_OutPut}/taxa-bar-plots.qzv

qiime feature-table filter-samples --i-table ${WDir_OutPut}/table.qza --m-metadata-file ${meta} --p-where "[body-site]= '$body'" --o-filtered-table ${WDir_OutPut}/${body}-table.qza

qiime composition add-pseudocount --i-table ${WDir_OutPut}/${body}-table.qza --o-composition-table ${WDir_OutPut}/comp-${body}-table.qza

qiime composition ancom --i-table ${WDir_OutPut}/comp-${body}-table.qza --m-metadata-file ${meta} --m-metadata-column subject --o-visualization ${WDir_OutPut}/ancom-subject.qzv

qiime taxa collapse --i-table ${WDir_OutPut}/${body}-table.qza --i-taxonomy ${WDir_OutPut}/taxonomy.qza --p-level 6 --o-collapsed-table ${WDir_OutPut}/${body}-table-l6.qza

qiime composition add-pseudocount --i-table ${WDir_OutPut}/${body}-table-l6.qza --o-composition-table ${WDir_OutPut}/comp-${body}-table-l6.qza

qiime composition ancom --i-table ${WDir_OutPut}/comp-${body}-table-l6.qza --m-metadata-file ${meta} --m-metadata-column subject --o-visualization ${WDir_OutPut}/l6-ancom-subject.qzv

echo "done"
echo "Your output files are located: ${WDir_OutPut}"

end=`date`
# do some work
duration=$SECONDS

echo -e "Start: $start \nEnd: $end"
echo "Run Time: $(($duration / 60))m $(($duration % 60))s."
