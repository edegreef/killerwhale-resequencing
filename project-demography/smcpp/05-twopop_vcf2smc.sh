#!/bin/bash
#SBATCH --mail-user=edegreef@ucdavis.edu
#SBATCH --mail-type=ALL
#SBATCH --time=00:20:00
#SBATCH --mem=500M
#SBATCH --array=1-85

source /home/edegreef/smcpp/bin/activate

list=killer_whale_10Mb_scaffold.txt

string="sed -n "${SLURM_ARRAY_TASK_ID}"p ${list}"

contig=$($string)
echo "Contig"
echo ${contig}

smc++ vcf2smc -d 48335KWEG2012 48335KWEG2012 --mask smcpp_removed_sites_sorted.bed.gz orca_snps_q30_biallelic_HWE0.005_miss0.4.vcf.gz killer_whale_10Mb_scaffolds/masked_data_split/group1_group2.${contig}.smc ${contig} Group1:48335KWEG2012,48336KWEG2012,48337KWEG2012,48338KWEG2012,48339KWEG2012,48340KWEG2012,ARRB_2009_1291,Pang2013 Group2:ARPI_2013_4001,ARPI_2013_4002,ARPI_2013_4003,ARPI_2013_4005,ARPI_2013_4006,ARPI_2013_4007,B045,D118_2,OO_01,OO_07,OO_11,OO_13,OO_14,OO_16,OO_17,OO_18

smc++ vcf2smc -d 48335KWEG2012 48335KWEG2012 --mask smcpp_removed_sites_sorted.bed.gz orca_snps_q30_biallelic_HWE0.005_miss0.4.vcf.gz killer_whale_10Mb_scaffolds/masked_data_split/group2_group1.${contig}.smc ${contig} Group2:ARPI_2013_4001,ARPI_2013_4002,ARPI_2013_4003,ARPI_2013_4005,ARPI_2013_4006,ARPI_2013_4007,B045,D118_2,OO_01,OO_07,OO_11,OO_13,OO_14,OO_16,OO_17,OO_18 Group1:48335KWEG2012,48336KWEG2012,48337KWEG2012,48338KWEG2012,48339KWEG2012,48340KWEG2012,ARRB_2009_1291,Pang2013