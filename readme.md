#  **********
#  [ logina1 | Sun Jan  9 16:08:05 CST 2022 | /xtdisk/baoym_group/zhengxcngdc/projects/biocloud/newVersionUnits ]
Rscript plot_comutation/plot_comutation.r  --file  ./test_files/TCGA.LAML.mutect.27f42413-6d8f-401f-9d07-d019def8939e.DR-10.0.somatic.maf   --outdir ./
# Rscript plot_bar/plot_bar.r --file  plot_bar/example_input_bar.txt  --outdir ./
Rscript plot_venn/plot_venn.r  --file  plot_venn/venn.demodata.txt   --outdir ./
Rscript plot_upset/plot_upset.r  --file  plot_upset/upset.demodata.txt   --outdir ./
Rscript plot_survival/plot_survival.r --file  plot_survival/example_input_survival.txt   --outdir ./
Rscript plot_oncoprint/plot_oncoprint.r  --file    ./test_files/TCGA.LAML.mutect.27f42413-6d8f-401f-9d07-d019def8939e.DR-10.0.somatic.maf   --outdir ./
Rscript plot_maftitv/plot_maftitv.r  --file   ./test_files/units/TCGA.LAML.mutect.27f42413-6d8f-401f-9d07-d019def8939e.DR-10.0.somatic.maf   --outdir ./
Rscript plot_mafsummary/plot_mafsummary.r  --file  ./test_files/units/TCGA.LAML.mutect.27f42413-6d8f-401f-9d07-d019def8939e.DR-10.0.somatic.maf   --outdir ./
Rscript plot_lollipop/plot_lollipop.r  --file  ./test_files/units/TCGA.LAML.mutect.27f42413-6d8f-401f-9d07-d019def8939e.DR-10.0.somatic.maf   --outdir ./
Rscript plot_line/plot_line.r  --file  plot_line/example_input_line.txt   --outdir ./
Rscript plot_histogram/plot_histogram.r  --file  plot_histogram/example_input_hist.txt   --outdir ./
Rscript plot_heatmap/plot_heatmap.r  --file  plot_heatmap/input_heatmap.txt   --outdir ./
Rscript plot_forestplot/plot_forestplot.r  --file  plot_forestplot/input_forest_plot.txt   --outdir ./
Rscript plot_dot/plot_dot.r  --file  plot_dot/example_input_bar.txt   --outdir ./

