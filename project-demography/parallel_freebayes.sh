#!/bin/bash
#SBATCH --time=72:00:00
#SBATCH --account=def-kmj477
#SBATCH --mail-user=thorstem@myumanitoba.ca
#SBATCH --mail-type=ALL
#SBATCH --cpus-per-task=32
#SBATCH --mem=256000M

module load nixpkgs/16.09  intel/2018.3
module load bamtools/2.4.1
module load gcc/7.3.0 freebayes/1.2.0


outdir="/home/biomatt/scratch/"

/home/biomatt/orca/freebayes-parallel \
<(/cvmfs/soft.computecanada.ca/easybuild/software/2017/avx2/Compiler/gcc5.4/freebayes/1.2.0/scripts/fasta_generate_regions.py /home/biomatt/projects/def-kmj477/biomatt/orca/00_Reference_files/unplaced.scaf.fna.fai 100000) \
$SLURM_CPUS_PER_TASK -f /home/biomatt/projects/def-kmj477/biomatt/orca/00_Reference_files/unplaced.scaf.fna \
/home/biomatt/scratch/merged_orca.bam >${outdir}orca_7day.vcf