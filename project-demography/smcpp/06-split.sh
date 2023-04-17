#!/bin/bash
#SBATCH --mail-user=edegreef@ucdavis.edu
#SBATCH --mail-type=ALL
#SBATCH --time=02:00:00
#SBATCH --mem=50000M
#SBATCH --array=1-100

source /home/edegreef/smcpp/bin/activate

echo run_${SLURM_ARRAY_TASK_ID}

smc++ split -o killer_whale_10Mb_scaffolds/split_estimate/combined_run${SLURM_ARRAY_TASK_ID} killer_whale_10Mb_scaffolds/smc_out_timepoints/group1/run_${SLURM_ARRAY_TASK_ID}/model.final.json killer_whale_10Mb_scaffolds/smc_out_timepoints/group2/run_${SLURM_ARRAY_TASK_ID}/model.final.json killer_whale_10Mb_scaffolds/masked_data_split/*.smc