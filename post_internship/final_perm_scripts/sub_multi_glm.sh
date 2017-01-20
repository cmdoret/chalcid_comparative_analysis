#!/bin/bash

# This script submit a job for parallel simulations of glm with permutations of factor levels.
# Cyril Matthey-Doret
# 11.01.2017

#BSUB -J auto_glm
#BSUB -M 16777216
#BSUB -n 30
#BSUB -R "span[ptile=30]"

R < auto_permutation_test.R --no-save 
