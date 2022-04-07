# comment the .libPaths() line 
cd /mnt/e/projects/git_repo/biocloud_code/units/plot_heatmap
Rscript  ./plot_heatmap.r --file ./input_heatmap.txt --width 8 --height 6 --main aaa --scale row --clustering_method ward.D2 --cluster_rows TRUE  --cluster_cols TRUE --clustering_distance_rows maximum --clustering
_distance_cols correlation --kmeans_k 5 --legend TRUE --show_rownames TRUE --show_colnames TRUE --fontsize 10 --fontsize_row 30 --fontsize_col 15 --angle_col 0 --display_numbers TRUE --number_color black --fontsize
_number 15 --cellwidth 20 --cellheight 20  --border_color black  --min_color green --middle_color white  --max_color blue --outdir ./