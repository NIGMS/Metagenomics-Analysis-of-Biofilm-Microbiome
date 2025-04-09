#!/usr/bin/env nextflow


process blast_search {
    tag { params.query_file }

    publishDir params.data_path, mode: 'copy'

    input:
    path fasta
    path query

    output:
    path "${params.output_file}"

    container 'ncbi/blast'

    script:
    def db_name = "subset_proteins_db"

    """
    # Create the BLAST database
    makeblastdb -in $fasta -dbtype prot -parse_seqids -out ${db_name} -title 'Subset STRING Proteins DB' -blastdb_version 5

    # Run the BLAST search
    blastp -query $query -db ${db_name} -out ${params.output_file} -evalue ${params.evalue} -outfmt '6'

    # Add header to the BLAST output
    sed -i '1i qseqids\\tseqid\\tpident\\tlength\\tmismatch\\tgapopen\\tqstart\\tqend\\tsstart\\tsend\\tevalue\\tbitscore' ${params.output_file}
    """
}


workflow {
    fasta_ch = Channel.value(params.fasta_file)
    query_ch = Channel.value(params.query_file)

    blast_search(fasta_ch, query_ch)
}