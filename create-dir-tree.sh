#!/bin/bash

# This script creates a directory structure for a manuscript project

set -e # Exit immediately if a command exits with a non-zero status
set -u # Treat unset variables as an error when substituting
set -o pipefail # Exit when a command in a pipeline fails

if [ $# -lt 1 ]; then
    echo "Please specify the root directory for the manuscript project."
    echo "Usage example: bash create-dir-tree.sh </path/to/root/directory>"
    exit 1
fi

ROOT_DIR=$(realpath $1);

if [ -d "$ROOT_DIR" ]; then
    echo "The directory already exists. Please specify a different directory."
    ls -l "$ROOT_DIR"
    exit 1
fi

echo "Creating the directory structure for the manuscript project in $ROOT_DIR"

# Create the main directory structure
for dir in R data/raw data/processed figs/main_figures figs/supplementary_figures tables/main_tables tables/supplementary_tables refs/csl manuscript/sections output/supplementary_materials; do
    mkdir -p "$ROOT_DIR"/$dir
done

# Create initial R scripts
for script in data-cleaning.R data-processing.R data-visualization.R; do
    touch "$ROOT_DIR"/R/$script
done

# Create initial manuscript sections
for section in abstract introduction methods results discussion acknowledgements; do
    touch "$ROOT_DIR"/manuscript/sections/$section.Rmd
done

# Create main manuscript Rmd file
touch "$ROOT_DIR"/manuscript/manuscript.Rmd


# Create an empty bibliography file and CSL directory
for file in references.bib; do
    touch "$ROOT_DIR"/refs/$file
done


# Create placeholder for custom LaTeX header if needed
touch "$ROOT_DIR"/manuscript/custom-header.sty

# Notify the user
echo "Directory structure for the manuscript project has been created successfully."

# Display the created directory structure if tree is available
if command -v tree &> /dev/null; then
    tree "$ROOT_DIR"
else
    echo "The 'tree' command is not installed. Please install it to see the directory structure."
fi
