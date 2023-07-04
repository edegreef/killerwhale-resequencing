#!/bin/bash
#SBATCH --job-name=GONE_killerwhale
#SBATCH --output=%j.out
#SBATCH -c 20
#SBATCH --mem=10GB
#SBATCH -t 24:00:00
#SBATCH --account=def-coling
#SBATCH --mail-type=ALL
#SBATCH --mail-user=evelien.degreef@umanitoba.ca

cd GONE_program

# orca P1 took under an hr (16 samples). Ran the two pops separately b/c didn't want to overlap the temporary output files.
./script_GONE.sh orca_snps_q30_biallelic_HWE0.005_miss0.4.P1.maf05.scafrename
