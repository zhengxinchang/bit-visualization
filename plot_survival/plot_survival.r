.libPaths("/xtdisk/baoym_group/zhengxcngdc/softwares/miniconda3/envs/R36/lib/R/library")
library(survminer)
library(survival)
library(optparse)

#CONFIG:MODULENAME=Plot_Survival
#CONFIG:APPNAME=Plot_Survival
#CONFIG:DESC=This app draw Survival plot for a given dataset.
#CONFIG:CLASS=/xtdisk/baoym_group/zhengxcngdc/softwares/miniconda3/envs/R36/bin/Rscript  /xtdisk/baoym_group/zhengxcngdc/projects/biocloud/units/plot_survival/plot_survival.R
#CONFIG:REFERENCE=https://cran.r-project.org/web/packages/survminer/index.html
#CONFIG:REFERENCE=https://cran.r-project.org/web/packages/survival/index.html
#CONFIG:HELP=input format is :
#CONFIG:HELP=     
#CONFIG:HELP=No  Time    Outcome  Group #fixed header
#CONFIG:HELP=1   2   1   Goup1
#CONFIG:HELP=2   5   1   Goup1
#CONFIG:HELP=3   8   1   Goup1
#CONFIG:HELP=4   9   1   Goup1
#CONFIG:HELP=5   9   0   Goup1
#CONFIG:HELP=6   10  1   Goup1
#CONFIG:HELP=7   13  1   Goup1
#CONFIG:HELP=8   13  1   Goup1
#CONFIG:HELP=9   15  0   Goup1
#CONFIG:HELP=10  18  1   Goup1
#CONFIG:HELP=11  20  1   Goup1
#CONFIG:HELP=12  23  0   Goup1
#CONFIG:HELP=13  2   1   Goup2
#CONFIG:HELP=14  2   1   Goup2
#CONFIG:HELP=15  3   1   Goup2
#CONFIG:HELP=16  5   1   Goup2
#CONFIG:HELP=17  6   1   Goup2
#CONFIG:HELP=18  6   1   Goup2
#CONFIG:HELP=19  8   1   Goup4
#CONFIG:HELP=20  9   1   Goup4
#CONFIG:HELP=21  10  1   Goup4
#CONFIG:HELP=22  14  0   Goup4
#CONFIG:OUTFINENAME=plot_survival.png


option_list = list(
  make_option(c("--file"), type="character", default="/xtdisk/baoym_group/zhengxcngdc/projects/biocloud/units/plot_survival/example_input_survival.txt",help="MAF file name"), #type=file
  make_option(c("--outdir"), type="character", default="./",help="Output file path"), 
  make_option(c("--width"), type="character", default="10", help="Width [inch]"), 
  make_option(c("--height"), type="character", default="8", help="Height [inch]"), 
  make_option(c("--fun"), type="character", default="NULL",help="an arbitrary function defining a transformation of the survival curve. argument: 'event' plots cumulative events , 'cumhaz' plots the cumulative hazard function , and 'pct' for survival probability in percentage."), #type=select:NULL*,pct,cumhaz,event
  make_option(c("--conf.int"), type="character", default="TRUE", help="logical value. If TRUE, plots confidence interval."),  #type=select:TRUE*,FALSE
  make_option(c("--pval"), type="character", default="NULL", help="logical value, a numeric or a string. If logical and TRUE, the p-value is added on the plot."), #type=select:TRUE*,FALSE
  make_option(c("--risk.table"), type="character", default="NULL", help="TRUE or FALSE specifying whether to show or not the risk table. Default is FALSE." ),  #type=select:TRUE*,FALSE
  make_option(c("--palette"), type="character", default="NULL", help="palette for plot" ), #type=select:NULL*,npg,aaas,nejm,lancet,jama,jco,ucscgb,d3,locuszoom,igv,uchicago,startrek,tron,futurama,rickandmorty,simpsons
  make_option(c("--surv.median.line"), type="character", default="NULL", help="character vector for drawing a horizontal/vertical line at median survival. Allowed values include one of c('none', 'hv', 'h', 'v'). v: vertical, h:horizontal. if fun is cumhaz this option will not work" ) #type=select:NULL,hv*,h,v
)



opt_parser = OptionParser(option_list=option_list);
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


paramlist <- list()

dat<-read.table(opt$file,header = T)
fit <- surv_fit(Surv(Time, Outcome) ~ Group, data = dat) 

if (opt$fun != "NULL"){   paramlist[['fun']] <- myconvert(opt$fun) } 
if (opt$conf.int != "NULL"){   paramlist[['conf.int']] <- myconvert(opt$conf.int) } 
if (opt$pval != "NULL"){   paramlist[['pval']] <- myconvert(opt$pval) } 
if (opt$risk.table != "NULL"){   paramlist[['risk.table']] <- myconvert(opt$risk.table) } 
if (opt$palette != "NULL"){   paramlist[['palette']] <- myconvert(opt$palette) } 
paramlist[['fit']] <- fit
paramlist[['data']] <-dat
paramlist[['linetype']] <-seq(1,length(unique(dat[,4])))


prefix = dirname(opt$outdir)

png(paste0(prefix,"/","output_plotsurvival.png"),width = myconvert(opt$width),height = myconvert(opt$height),units = "in",res=600)

do.call(ggsurvplot,paramlist)

dev.off()


pdf(paste0(prefix,"/","output_plotsurvival.pdf"),width = myconvert(opt$width),height = myconvert(opt$height),onefile = FALSE)

do.call(ggsurvplot,paramlist)

dev.off()


svg(paste0(prefix,"/","output_plotsurvival.svg"),width = myconvert(opt$width),height = myconvert(opt$height),onefile = FALSE)

do.call(ggsurvplot,paramlist)

dev.off()




