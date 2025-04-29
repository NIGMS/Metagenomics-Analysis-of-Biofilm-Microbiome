#!/bin/bash
## Setup the WD
exec 2>&1 > q2_postprocess.log

set -e

while getopts o: flag 
do
  case "${flag}" in
    o) Q_out=${OPTARG} ;;
    ?) echo "script usage: $(basename \$0) [-o output directory that contains your qiime2 outputs]" >&2
      exit 1 ;;
  esac
done
#shift "$(($OPTIND -1))"
#


for d in ${Q_out}/* ; do              
    if [[ $d == *.qza ]]; then
        echo "$d"
        unzip $d -d "${d%*.qza}-unzipped"       
     elif [[ $d == *.qzv ]]; then
         echo "$d"     
         unzip $d -d "${d%*.qzv}-viz-unzipped" 
    fi
done
for e in ${Q_out}/* ; do
    if [[ $e == *unzipped ]]; then
        echo "$e"
        e2=$(ls $e)
        echo $e/$e2
        cp -a ${e}/${e2}/* $e
        rm -r ${e}/${e2}
    fi
done


for r in ${Q_out}/core-metrics-results/* ; do          
    if [[ $r == *.qza ]]; then
        echo "$r"
        unzip $r -d "${r%*.qza}-unzipped"       
     elif [[ $r == *.qzv ]]; then
         echo "$r"  
         unzip $r -d "${r%*.qzv}-viz-unzipped" 
    fi
 done   
for s in ${Q_out}/core-metrics-results/* ; do
    if [[ $s == *unzipped ]]; then
        echo "$s"
        s2=$(ls $s)
        echo $s/$s2
        cp -a ${s}/${s2}/* $s
        rm -r ${s}/${s2}
    fi
done




echo "done"
