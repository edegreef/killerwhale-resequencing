# killerwhale-resequencing
A repository for genomic work on Canadian Arctic killer whales, organized by two projects: 
1. Demography (and population structure) with n=29
2. Adaptation with n=#.

## Demography
Notes: Samples were mapped to reference genome accession #GCA_000331955.1 and processed following Foote et al. 2016. Genomic variants were called by Matt Thorstensen using FreeBayes

Repository contents:
* Filter/prepare SNP datasets for analyses
* Site map
* Kinship analysis with MLE
* Population structure (PCA, FST, SNMF)
* Roh---- still need to edit this script, it is v. messy. also need to include script for plotting in R!
* Demographic history with SMC++ and GONE
* Estimating contemporary Ne with StrataG

## Adaptation
* Samples were mapped to updated reference genome accession #GCA_937001465.1 (chromosome-level updated in 2022)

remember to note that for the mapping step did it in batches/chunks, and for some samples that took very long, submitted separate jobs even for 12 days o_o

also for trim step, remember that there were some reads had to remove before merging.
