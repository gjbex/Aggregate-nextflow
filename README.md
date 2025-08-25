# Aggregate nextflow

Example of a workflow that has two entry points:
* `build`: builds an Apptainer container image with the necessary dependencies
  for the workflow.
* `pipeline`: executes the actual data processing workflow.

The `pipeline` entry point consists of
* three grouping steps that can be done in parallel,
* an aggregation step that combines the data computed by the previous step.

It is only intended to be used in a demo to illustrate how to execute a
nextflow workflow directly from a GitHub repository.  It is intended to be used
in the ["Workflows for HPC
training](https://gjbex.github.io/Workflows-for-HPC/).


## What is it?

1. `main.nf`: nextflow workflow definition file.
1. `nextflow.config`: nextflow configuration file.
1. `workflow-scripts/`: directory containing the Python scripts used in the
   workflow.
    1. `sum_group.py`: Python script that sums the values in a group.
    1. `mean_group.py`: Python script that calculates the mean of values in a
       group.
    1. `join_data.py`: Python script that joins the datasets.
1. `example_data`: directory containing the input data files.
1. `environment.yml`: Conda environment definition file that specifies the
   dependencies for the Python scripts.
1. `conda.recipe`: Apptainer recipe to build a container image with the
   necessary dependencies for the workflow.
1. `utils`: Python script that generates the input data files.


## How to use it?

The workflow has two entry points, one to build the container image, the second
to execute the actual pipeline.

### Local execution

To build the container, you need to have Apptainer installed. Then, run the
following command in the directory containing the `conda.recipe` file:

```bash
$ nextflow run  .  -entry build
```

To execute the workflow, you can use the following command:

```bash
$ nextflow run  .  -entry pipeline
```

Note that the data you want to process should be in a directory call `data`, or
specified as a command line argument `--data <absolute-path>`.


### Remote execution

Using the `slurm` profile allows you to run the workflow on an HPC cluster.

To build the container, you can use the following command:

```bash
$ nextflow run  gjbex/Aggregate-nextflow  -entry build -profile slurm
```

To execute the workflow, you can use the following command:

```bash
$ nextflow run  gjbex/Aggregate-nextflow  -entry pipeline -profile slurm
```

Note that the data you want to process should be in a directory call `data`, or
specified as a command line argument `--data <absolute-path>`.
