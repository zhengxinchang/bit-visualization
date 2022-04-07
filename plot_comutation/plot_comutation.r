
.libPaths("/xtdisk/baoym_group/zhengxcngdc/softwares/miniconda3/envs/R36/lib/R/library")
library(maftools)
library(optparse)
library(ggsci)


#CONFIG:MODULENAME=Plot_Comutation
#CONFIG:APPNAME=Plot_Comutation
#CONFIG:DESC=This app draw Comutation plot for a given dataset.
#CONFIG:CLASS=/xtdisk/baoym_group/zhengxcngdc/softwares/miniconda3/envs/R36/bin/Rscript  /xtdisk/baoym_group/zhengxcngdc/projects/biocloud/units/plot_comutation/plot_comutation.r
#CONFIG:REFERENCE=http://bioconductor.org/packages/release/bioc/vignettes/maftools/inst/doc/maftools.html
#CONFIG:HELP=input format is MAF [https://docs.gdc.cancer.gov/Data/File_Formats/MAF_Format/]
#CONFIG:OUTFINENAME=plot_comutation.png





# parse arguments
option_list = list(
  # file and Canvas settings
  make_option(c("--file"), type="character", default="/xtdisk/baoym_group/zhengxcngdc/projects/biocloud/units/plot_mafsummary/TCGA.LAML.mutect.27f42413-6d8f-401f-9d07-d019def8939e.DR-10.0.somatic.maf",help="MAF file name"), #type=file
  make_option(c("--outdir"), type="character", default="./",help="Output file path"), 
  make_option(c("--width"), type="character", default="8", help="Width [inch]", metavar="10 inch"), 
  make_option(c("--height"), type="character", default="8", help="Height [inch]", metavar="8 inch"), 
  make_option(c("--top"), type="character", default="10", help="how many top genes to be drawn. defaults to 10."),  
  make_option(c("--pval_up"), type="character", default="0.1", help="p value up threshold [0.1]"),  
  make_option(c("--pval_down"), type="character", default="0.05", help="p value up threshold [0.05]"),  
  make_option(c("--returnAll  "), type="character", default="FALSE", help="If TRUE returns test statistics for all pair of tested genes. Default FALSE, returns for only genes below pvalue threshold."), #type=select:FALSE*,TRUE
  make_option(c("--fontSize"), type="character", default="0.8", help="cex for gene names. Default 0.8" ), 
  make_option(c("--showSigSymbols"), type="character", default="TRUE", help="Default TRUE. Heighlight significant pairs" ), #type=select:TRUE*,FALSE
  make_option(c("--showCounts"), type="character", default="TRUE", help="Default TRUE. Include number of events in the plot"), #type=select:TRUE*,FALSE
  make_option(c("--countStats"), type="character", default="all", help="Can be either mean or median. Default NULL."), #type=select:all*,sig
  make_option(c("--countType"), type="character", default="cooccur", help="Default 'cooccur'. Can be 'all', 'cooccur', 'mutexcl'"), #type=select:cooccur*,mutexcl
  make_option(c("--countsFontSize"), type="character", default="0.8",help="Default 0.8"),
  make_option(c("--countsFontColor"), type="character", default="black", help="Default 'black'"),
  make_option(c("--colPal"), type="character", default="BrBG", help="font size for title and subtitle. Default 1.0") #type=select:BrBG*,PiYG,PRGn,PuOr,RdBu,RdGy,RdYlBu,RdYlGn,Spectral,Accent,Dark2Paired,Pastel1Pastel2Set1,Set2,Set3,BluesBuGn,BuPu,GnBu,Greens,GreysOrangesOrRd,PuBu,PuBuGn,PuRd,PurplesRdPu,Reds,YlGn,YlGnBu,YlOrBr,YlOrRd
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




#---- param 


# init param list
paramlist = list()

# load data
maf = maftools::read.maf(opt$file)

paramlist[["maf"]] <- maf

if (opt$top != "NULL"){   paramlist[['top']] <- myconvert(opt$top) } 

if (opt$returnAll != "NULL"){   paramlist[['returnAll']] <- myconvert(opt$returnAll) }

if (opt$fontSize != "NULL"){ paramlist[['fontSize']] <- myconvert(opt$fontSize) }

if (opt$showSigSymbols != "NULL"){ paramlist[['showSigSymbols']] <- myconvert(opt$showSigSymbols)}

if (opt$showCounts != "NULL"){ paramlist[['showCounts']] <- myconvert(opt$showCounts)}

if (opt$countStats != "NULL"){ paramlist[['countStats']] <- myconvert(opt$countStats)}

if (opt$countType != "NULL"){ paramlist[['countType']] <- myconvert(opt$countType)}

if (opt$countsFontSize != "NULL"){ paramlist[['countsFontSize']] <- myconvert(opt$countsFontSize)}

if (opt$countsFontColor != "NULL"){ paramlist[['countsFontColor']] <- myconvert(opt$countsFontColor)}

if (opt$colPal != "NULL"){ paramlist[['colPal']] <- myconvert(opt$colPal)}

#paramlist[['pvalue ']] <- c(myconvert(opt$pval_down),myconvert(opt$pval_up))

#----



prefix = dirname(opt$outdir)
print(paramlist)

png(paste0(prefix,"/","output_plotcomutation.png"),width = myconvert(opt$width),height = myconvert(opt$height),units = "in",res=600)

do.call(maftools::somaticInteractions,paramlist)

dev.off()

pdf(paste0(prefix,"/","output_plotcomutation.pdf"),width = myconvert(opt$width),height = myconvert(opt$height))

do.call(maftools::somaticInteractions,paramlist)

dev.off()

svg(paste0(prefix,"/","output_plotcomutation.svg"),width = myconvert(opt$width),height = myconvert(opt$height))

do.call(maftools::somaticInteractions,paramlist)

dev.off()








