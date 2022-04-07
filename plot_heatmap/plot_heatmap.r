.libPaths("/xtdisk/baoym_group/zhengxcngdc/softwares/miniconda3/envs/R36/lib/R/library")
library(pheatmap)
library(optparse)
library(ggsci)

#CONFIG:MODULENAME=Plot_heatmap3
#CONFIG:APPNAME=Plot_heatmap3
#CONFIG:DESC=This app draw heatmap plot for a given dataset.
#CONFIG:CLASS=/xtdisk/baoym_group/zhengxcngdc/softwares/miniconda3/envs/R36/bin/Rscript  /xtdisk/baoym_group/zhengxcngdc/projects/biocloud/units/plot_heatmap/plot_heatmap.r
#CONFIG:REFERENCE=https://cran.r-project.org/web/packages/pheatmap/index.html
#CONFIG:REFERENCE=https://cran.r-project.org/web/packages/ggsci/index.html
#CONFIG:HELP=The input file format is : matix, column and row names are string, values are number.
#CONFIG:OUTFINENAME=plot_heatmap.png

# parse arguments
option_list = list(
  # file and Canvas settings
  make_option(c("--file"), type="character", default="/xtdisk/baoym_group/zhengxcngdc/projects/biocloud/units/plot_heatmap/input_heatmap.txt",help="Dataset file name", metavar="file"), # type=file
  make_option(c("--outdir"), type="character", default="./",help="Output file path"), 
  make_option(c("--width"), type="character", default="8", help="Width [inch]", metavar="8 inch"), 
  make_option(c("--height"), type="character", default="6", help="Height [inch]", metavar="6 inch"), 
  make_option(c("--main"), type="character", default="NULL", help="Main title"),
  
  # scale and cluster settings
  make_option(c("--scale"), type="character", default="NULL", help="Character indicating if the values should be centered and scaled in either the row direction or the column direction, or none. Corresponding values are 'row', 'column' and 'none'"),  # type=select:none*,row,column
  make_option(c("--clustering_method "), type="character", default="NULL", help="The agglomeration method to be used. This should be (an unambiguous abbreviation of) one of 'ward.D', 'ward.D2', 'single', 'complete', 'average' (= UPGMA), 'mcquitty' (= WPGMA), 'median' (= WPGMC) or 'centroid' (= UPGMC)"), #type=select:complete*,ward.D,ward.D2,single,average,mcquitty,median,centroid
  make_option(c("--cluster_rows"), type="character", default="TRUE", help="Boolean values determining if columns should be clustered or hclust object" ),  #type=select:TRUE*,FALSE
  make_option(c("--cluster_cols"), type="character", default="TRUE", help="Boolean values determining if columns should be clustered or hclust object." ), #type=select:TRUE*,FALSE
  make_option(c("--clustering_distance_rows"), type="character", default="NULL", help="Distance measure used in clustering rows. Possible values are correlation,euclidean,maximum,manhattan,canberra,binary,minkowski"), # type=select:correlation*,euclidean,maximum,manhattan,canberra,binary,minkowski
  make_option(c("--clustering_distance_cols"), type="character", default="NULL", help="Distance measure used in clustering columns. Possible values the same as for clustering_distance_rows."), # type=select:correlation*,euclidean,maximum,manhattan,canberra,binary,minkowski
  make_option(c("--kmeans_k"), type="character", default="NULL", help="The number of kmeans ROW clusters to make, if we want to aggregate the rows before drawing heatmap. If NA then the rows are not aggregated. Note that the number of K must less than rows "), 
  
  
  # legend font size settings
  make_option(c("--legend"), type="character", default="NULL",help="Logical to determine if legend should be drawn or not."), # type=select:TRUE*,FALSE
  make_option(c("--show_rownames"), type="character", default="TRUE", help="boolean specifying if row names are be shown."), # type=select:TRUE*,FALSE
  make_option(c("--show_colnames"), type="character", default="TRUE", help="boolean specifying if column names are be shown."), # type=select:TRUE*,FALSE
  make_option(c("--fontsize"), type="character", default="NULL", help="base fontsize for the plot"), 
  make_option(c("--fontsize_row"), type="character", default="NULL", help="fontsize for rownames (Default: fontsize)"),  
  make_option(c("--fontsize_col"), type="character", default="NULL", help="fontsize for colnames (Default: fontsize)"), 
  make_option(c("--angle_col"), type="character", default="NULL", help="angle of the column labels, right now one can choose only from few predefined options (0, 45, 90, 270 and 315)"),  # type=select:0*,45,90,270,315

  
  # number in cells settings
  make_option(c("--display_numbers"), type="character", default="NULL", help="logical determining if the numeric values are also printed to the cells. If this is a matrix (with same dimensions as original matrix), the contents of the matrix are shown instead of original values."),  # type=select:TRUE*,FALSE
  make_option(c("--number_color"), type="character", default="black", help="color of the text"),  
  make_option(c("--fontsize_number"), type="character", default="NULL", help="fontsize of the numbers displayed in cells"), 
  
  # cell settings
  make_option(c("--cellwidth"), type="character", default="NULL", help="individual cell width in points. If left as NULL, then the values depend on the size of plotting window."),  
  make_option(c("--cellheight"), type="character", default="NULL", help="individual cell width in points. If left as NULL, then the values depend on the size of plotting window."),  
  make_option(c("--border_color"), type="character", default="NULL", help="color of cell borders on heatmap, use NA if no border should be drawn."), 
  make_option(c("--min_color"), type="character", default="darkblue", help="Color for minimal value"), 
  make_option(c("--middle_color"), type="character", default="white", help="Color for middle value"), 
  make_option(c("--max_color"), type="character", default="orangered", help="Color for maximal value") 
)







opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser);



myconvert <-function(s){
  if(class(s)=="character"){
    if(s=="NA"){
      return(NA)
    }else if(s=="NULL"){
      return(NULL)
    }else if(s == "TRUE"){
      return(TRUE)
    }else if(s=="FALSE"){
      return(FALSE)
    }else{
      tryCatch(
        {
          a = as.numeric(s)
          if(is.na(a)){
            return(s)
          }else{
            return(a)
          }
               
        }
        ,error=function(){
          return(s)
        }
      )
      
    }    
  }else{
    return(s)
  }
}

dat <- read.table(opt$file,header = T,stringsAsFactors = F)



paramlist = list()

paramlist[["mat"]] <- dat
paramlist[['width']] <- as.numeric(opt$width)
paramlist[['height']] <- as.numeric(opt$height)

if (opt$main != "NULL"){   paramlist[['main']] <- opt$main } 

if (opt$scale != "NULL"){   paramlist[['scale']] <- opt$scale }

if (opt$clustering_method != "NULL"){ paramlist[['clustering_method']] <- opt$clustering_method }

if (opt$cluster_rows != "NULL"){ paramlist[['cluster_rows']] <- myconvert(opt$cluster_rows)}

if (opt$cluster_cols != "NULL"){ paramlist[['cluster_cols']] <- myconvert(opt$cluster_cols)}

if (opt$clustering_distance_rows != "NULL"){ paramlist[['clustering_distance_rows']] <- opt$clustering_distance_rows }

if (opt$clustering_distance_cols != "NULL"){ paramlist[['clustering_distance_cols']] <- opt$clustering_distance_cols }

if (opt$kmeans_k != "NULL"){ paramlist[['kmeans_k']] <- opt$kmeans_k }

if (opt$legend != "NULL"){ paramlist[['legend']] <- myconvert(opt$legend) }

if (opt$show_rownames != "NULL"){ paramlist[['show_rownames']] <- myconvert(opt$show_rownames) }

if (opt$show_colnames != "NULL"){ paramlist[['show_colnames']] <- myconvert(opt$show_colnames) }

if (opt$fontsize != "NULL"){ paramlist[['fontsize']] <- myconvert(opt$fontsize) }

if (opt$fontsize_row != "NULL"){ paramlist[['fontsize_row']] <- myconvert(opt$fontsize_row) }

if (opt$fontsize_col != "NULL"){ paramlist[['fontsize_col']] <- myconvert(opt$fontsize_col) }

if (opt$angle_col != "NULL"){ paramlist[['angle_col']] <- myconvert(opt$angle_col) }

#--
if (opt$display_numbers != "NULL"){ paramlist[['display_numbers']] <- myconvert(opt$display_numbers) }

if (opt$number_color != "NULL"){ paramlist[['number_color']] <- myconvert(opt$number_color) }

if (opt$fontsize_number != "NULL"){ paramlist[['fontsize_number']] <- myconvert(opt$fontsize_number) }

if (opt$cellwidth != "NULL"){ paramlist[['cellwidth']] <- myconvert(opt$cellwidth) }

if (opt$cellheight != "NULL"){ paramlist[['cellheight']] <- myconvert(opt$cellheight) }

if (opt$border_color != "NULL"){ paramlist[['border_color']] <- myconvert(opt$border_color) }


paramlist[['color']] <-  colorRampPalette(c(myconvert(opt$min_color) ,myconvert(opt$middle_color) ,myconvert(opt$max_color) ))(12)



prefix = dirname(opt$outdir)
png(paste0(prefix,"/","output_plotheatmap.png"),width = as.numeric(opt$width) ,height = as.numeric(opt$height) ,units = "in",res=600)
do.call(pheatmap,paramlist)
dev.off()

pdf(paste0(prefix,"/","output_plotheatmap.pdf"),width = as.numeric(opt$width) ,height = as.numeric(opt$height))
do.call(pheatmap,paramlist)
dev.off()

svg(paste0(prefix,"/","output_plotheatmap.svg"),width = as.numeric(opt$width) ,height = as.numeric(opt$height))
do.call(pheatmap,paramlist)
dev.off()


