#!/bin/bash
#SBATCH --mail-user=edegreef@ucdavis.edu
#SBATCH --mail-type=ALL
#SBATCH --time=00:30:00
#SBATCH --mem=500M
#SBATCH --array=1-85

source /home/edegreef/smcpp/bin/activate
cd /scratch/edegreef/KL_killerwhale/smcpp

list=killer_whale_100kb_scaffolds.txt

string="sed -n "${SLURM_ARRAY_TASK_ID}"p ${list}"

contig=$($string)
echo "Contig"
echo ${contig}

# Group1
smc++ vcf2smc -d 48335KWEG2012 48335KWEG2012 --mask smcpp_removed_sites_sorted.bed.gz orca_snps_q30_biallelic_HWE0.005_miss0.4.vcf.gz killer_whale_100kb_scaffolds/masked_data/group1.48335KWEG2012.${contig}.smc ${contig} Group1:48335KWEG2012,48336KWEG2012,48337KWEG2012,48338KWEG2012,48339KWEG2012,48340KWEG2012,ARRB_2009_1291,Pang2013

smc++ vcf2smc -d ARRB_2009_1291 ARRB_2009_1291 --mask smcpp_removed_sites_sorted.bed.gz orca_snps_q30_biallelic_HWE0.005_miss0.4.vcf.gz killer_whale_100kb_scaffolds/masked_data/group1.ARRB_2009_1291.${contig}.smc ${contig} Group1:48335KWEG2012,48336KWEG2012,48337KWEG2012,48338KWEG2012,48339KWEG2012,48340KWEG2012,ARRB_2009_1291,Pang2013

smc++ vcf2smc -d Pang2013 Pang2013 --mask smcpp_removed_sites_sorted.bed.gz orca_snps_q30_biallelic_HWE0.005_miss0.4.vcf.gz killer_whale_100kb_scaffolds/masked_data/group1.Pang2013.${contig}.smc ${contig} Group1:48335KWEG2012,48336KWEG2012,48337KWEG2012,48338KWEG2012,48339KWEG2012,48340KWEG2012,ARRB_2009_1291,Pang2013



# Group2
smc++ vcf2smc -d ARPI_2013_4001 ARPI_2013_4001 --mask smcpp_removed_sites_sorted.bed.gz orca_snps_q30_biallelic_HWE0.005_miss0.4.vcf.gz killer_whale_100kb_scaffolds/masked_data/group2.ARPI_2013_4001.${contig}.smc ${contig} Group2:ARPI_2013_4001,ARPI_2013_4002,ARPI_2013_4003,ARPI_2013_4005,ARPI_2013_4006,ARPI_2013_4007,B045,D118_2,OO_01,OO_07,OO_11,OO_13,OO_14,OO_16,OO_17,OO_18

smc++ vcf2smc -d B045 B045 --mask smcpp_removed_sites_sorted.bed.gz orca_snps_q30_biallelic_HWE0.005_miss0.4.vcf.gz killer_whale_100kb_scaffolds/masked_data/group2.B045.${contig}.smc ${contig} Group2:ARPI_2013_4001,ARPI_2013_4002,ARPI_2013_4003,ARPI_2013_4005,ARPI_2013_4006,ARPI_2013_4007,B045,D118_2,OO_01,OO_07,OO_11,OO_13,OO_14,OO_16,OO_17,OO_18

smc++ vcf2smc -d D118_2 D118_2 --mask smcpp_removed_sites_sorted.bed.gz orca_snps_q30_biallelic_HWE0.005_miss0.4.vcf.gz killer_whale_100kb_scaffolds/masked_data/group2.D118_2.${contig}.smc ${contig} Group2:ARPI_2013_4001,ARPI_2013_4002,ARPI_2013_4003,ARPI_2013_4005,ARPI_2013_4006,ARPI_2013_4007,B045,D118_2,OO_01,OO_07,OO_11,OO_13,OO_14,OO_16,OO_17,OO_18

smc++ vcf2smc -d OO_01 OO_01 --mask smcpp_removed_sites_sorted.bed.gz orca_snps_q30_biallelic_HWE0.005_miss0.4.vcf.gz killer_whale_100kb_scaffolds/masked_data/group2.OO_01.${contig}.smc ${contig} Group2:ARPI_2013_4001,ARPI_2013_4002,ARPI_2013_4003,ARPI_2013_4005,ARPI_2013_4006,ARPI_2013_4007,B045,D118_2,OO_01,OO_07,OO_11,OO_13,OO_14,OO_16,OO_17,OO_18
