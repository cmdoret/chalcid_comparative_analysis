#!/bin/bash

# This script submit a job for parallel simulations of glm with permutations of factor levels.
# Cyril Matthey-Doret
# 11.01.2017

#BSUB -J par_sim_glm
#BSUB -M 16777216
#BSUB -n 30

R < rangedist_auto_permutation_test.R --no-save 
