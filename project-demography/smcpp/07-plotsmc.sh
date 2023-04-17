source /home/edegreef/smcpp/bin/activate


smc++ plot -c plots/smc_group2_miss0.4_100iter_100kb_plot.pdf smc_out_timepoints/group2/run_*/model.final.json
smc++ plot -c plots/smc_combined_run_miss0.4_100iter_10Mb_plot.pdf split_estimate/combined_run*/model.final.json