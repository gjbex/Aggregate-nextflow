params.data = "${launchDir}/data/"

process BuildImage {
    publishDir "${launchDir}/images", mode: 'copy'

    output:
    path "data_processing.sif"

    script:
    """
    apptainer build \
        --fakeroot \
        --build-arg environment="${projectDir}/conda_environment.yml" \
        data_processing.sif "${projectDir}/conda.recipe"
    """
}

process Summarize_A {
    label 'data_processing_container'
    publishDir "${launchDir}/results", mode: 'copy'

    output:
    path "summary_A.csv"

    script:
    """
    python "${projectDir}/workflow-scripts/sum_group.py" \
        --input_file "${params.data}/data_A.csv" \
        --column_name A \
        --output_file summary_A.csv
    """
}

process Summarize_B {
    label 'data_processing_container'
    publishDir "${launchDir}/results", mode: 'copy'

    output:
    path "summary_B.csv"

    script:
    """
    python "${projectDir}/workflow-scripts/mean_group.py" \
        --input_file "${params.data}/data_B.csv" \
        --column_name B \
        --output_file summary_B.csv
    """
}

process Summarize_C {
    label 'data_processing_container'
    publishDir "${launchDir}/results", mode: 'copy'

    output:
    path "summary_C.csv"

    script:
    """
    python ${projectDir}/workflow-scripts/sum_group.py \
        --input_file ${params.data}/data_C.csv \
        --column_name C \
        --output_file summary_C.csv
    """
}

process JoinData {
    label 'data_processing_container'
    publishDir "${launchDir}/results", mode: 'copy'

    input:
    path summary_A
    path summary_B
    path summary_C

    output:
    path "summary.csv"

    script:
    """
    python ${projectDir}/workflow-scripts/join_data.py \
        --input_files $summary_A $summary_B $summary_C \
        --output_file summary.csv
    """
}

workflow pipeline {
    summaryA_channel = Summarize_A()
    summaryB_channel = Summarize_B()
    summaryC_channel = Summarize_C()
    JoinData(summaryA_channel, summaryB_channel, summaryC_channel).view()
}

workflow build {
    BuildImage().view()
}

workflow {
    pipeline()
}
