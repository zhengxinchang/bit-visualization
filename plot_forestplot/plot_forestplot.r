#.libPaths("/xtdisk/baoym_group/zhengxcngdc/softwares/miniconda3/envs/R36/lib/R/library")


library(forestplot)
library(optparse)

#CONFIG:MODULENAME=Plot_Forestplot
#CONFIG:APPNAME=Plot_Forestplot
#CONFIG:DESC=This app draw a Histgram plot for a given dataset.
#CONFIG:CLASS=/xtdisk/baoym_group/zhengxcngdc/softwares/miniconda3/envs/R36/bin/Rscript  /xtdisk/baoym_group/zhengxcngdc/projects/biocloud/units/plot_forest/plot_forestplot.r
#CONFIG:REFERENCE=https://cran.r-project.org/web/packages/forestplot/index.html
#CONFIG:HELP=The input file format example:
#CONFIG:HELP=Comparsion      Median  Interquartile_ranges    Diff_median     Diff_down       Diff_top #header
#CONFIG:HELP=Model1 vs. Model2       1.22    (0.13 ~ 2.14)   1.22    0.13    2.14
#CONFIG:HELP=Model1 vs. Model3       1.7     (0.83 ~ 2.49)   1.7     0.83    2.49
#CONFIG:HELP=---------------------------------------------
#CONFIG:OUTFINENAME=output_plotforest.png

# parse arguments
option_list = list(
  make_option(c("--file"), type="character", default="/xtdisk/baoym_group/zhengxcngdc/projects/biocloud/units/plot_forest/input_forest_plot.txt",help="Dataset file name", metavar="file"), #type=file
  make_option(c("--outdir"), type="character", default="./",help="Output file path"), 
  make_option(c("--width"), type="character", default="8", help="Width [inch]"), 
  make_option(c("--height"), type="character", default="6", help="Height [inch]"), 
  make_option(c("--zero"), type="character", default="NULL", help="x-axis coordinate for zero line. If you provide a vector of length 2 it will print a rectangle instead of just a line. If you provide NA the line is supressed."), 
  make_option(c("--xlog"), type="character", default="NULL", help="If TRUE, x-axis tick marks are to follow a logarithmic scale, e.g. for logistic regressoin (OR), survival estimates (HR), Poisson regression etc. Note: This is an intentional break with the original forestplot function as I've found that exponentiated ticks/clips/zero effect are more difficult to for non-statisticians and there are sometimes issues with rounding the tick marks properly."), #type=select:TRUE*,FALSE
  make_option(c("--boxsize"), type="character", default="NULL", help="Override the default box size based on precision"), 
  make_option(c("--linetype"), type="character", default="NULL", help="line type of error bar" ),
  make_option(c("--linewidth"), type="character", default="NULL", help="line width of error bar"), 
  make_option(c("--ci.vertices.height"), type="character", default="NULL",help="The height hoft the vertices. Defaults to npc units corresponding to 10% of the row height. Note that the arrows correspond to the vertices heights."),
  make_option(c("--xlab"), type="character", default="NULL", help="Title size for y axis")
)


opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);

dat <- read.table(opt$file,header = T,sep = "\t",stringsAsFactors = F)


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



#dat<- read.table("./plot_forestplot/input_forest_plot.txt",sep = "\t",header = T)






dat<- read.table(opt$file,sep = "\t",header = T)
forestplot::forestplot(dat,labeltext=dat[,1:3],mean=dat[,4],lower=dat[,5],upper=dat[,6])

paramlist <- list()

paramlist[['x']] <-dat
paramlist[['labeltext']] <-dat[,1:3]
paramlist[['mean']] <-dat[,4]
paramlist[['lower']] <-dat[,5]
paramlist[['upper']] <-dat[,6]


if (opt$zero != "NULL"){   paramlist[['zero']] <- myconvert(opt$zero) } 

if (opt$xlog != "NULL"){   paramlist[['xlog']] <- myconvert(opt$xlog) }
if (opt$boxsize != "NULL"){   paramlist[['boxsize']] <- myconvert(opt$boxsize) }
if (opt$linetype != "NULL"){   paramlist[['linetype']] <- myconvert(opt$linetype) }
if (opt$linewidth != "NULL"){   paramlist[['linewidth']] <- myconvert(opt$linewidth) }
if (opt$ci.vertices.height != "NULL"){   paramlist[['ci.vertices.height']] <- myconvert(opt$ci.vertices.height) }
if (opt$xlab != "NULL"){   paramlist[['xlab']] <- myconvert(opt$xlab) }

fpc = list()


paramlist[['fpColors']]<- do.call(fpColors,fpc)

print(paramlist)

prefix = dirname(opt$outdir)


png(paste0(prefix,"/","output_plotforestplot.png"),width = myconvert(opt$width) ,height = myconvert(opt$height),units = "in",res=600)

  do.call(forestplot::forestplot,paramlist)

dev.off()

pdf(paste0(prefix,"/","output_plotforestplot.pdf"),width = myconvert(opt$width) ,height = myconvert(opt$height),onefile = FALSE)

  do.call(forestplot::forestplot,paramlist)

dev.off()


svg(paste0(prefix,"/","output_plotforestplot.svg"),width = myconvert(opt$width) ,height = myconvert(opt$height),onefile = FALSE)

  do.call(forestplot::forestplot,paramlist)

dev.off()

