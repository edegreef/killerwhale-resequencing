#!/bin/bash
#SBATCH --account=def-coling
#SBATCH --mail-user=edegreef@ucdavis.edu
#SBATCH --mail-type=ALL
#SBATCH --time=06:00:00
#SBATCH --mem=80000M
#SBATCH --array=1-100

source /home/edegreef/smcpp/bin/activate

mkdir killer_whale_100kb_scaffolds/smc_out_timepoints/group1/run_${SLURM_ARRAY_TASK_ID}/

echo killer_whale_100kb_scaffolds/smc_out_timepoints/group1/run_${SLURM_ARRAY_TASK_ID}/

smc++ estimate 2.34e-8 -o killer_whale_100kb_scaffolds/smc_out_timepoints/group1/run_${SLURM_ARRAY_TASK_ID}/ --regularization-penalty 4.0 --nonseg-cutoff 100000 --thinning 2000 --cores 4 --timepoints 10 10000 killer_whale_100kb_scaffolds/masked_data/group1.*