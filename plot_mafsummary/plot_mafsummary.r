
#.libPaths("/xtdisk/baoym_group/zhengxcngdc/softwares/miniconda3/envs/R36/lib/R/library")
library(maftools)
library(optparse)
library(ggsci)


#CONFIG:MODULENAME=Plot_Mafsummary
#CONFIG:APPNAME=Plot_Mafsummary
#CONFIG:DESC=This app draw summary plot for a given dataset.
#CONFIG:CLASS=/xtdisk/baoym_group/zhengxcngdc/softwares/miniconda3/envs/R36/bin/Rscript  /xtdisk/baoym_group/zhengxcngdc/projects/biocloud/units/plot_mafsummary/plot_mafsummary.R
#CONFIG:REFERENCE=http://bioconductor.org/packages/release/bioc/vignettes/maftools/inst/doc/maftools.html
#CONFIG:HELP=input format is MAF [https://docs.gdc.cancer.gov/Data/File_Formats/MAF_Format/]
#CONFIG:OUTFINENAME=plot_mafsummary.png



# parse arguments
option_list = list(
  # file and Canvas settings
  make_option(c("--file"), type="character", default="/xtdisk/baoym_group/zhengxcngdc/projects/biocloud/units/plot_mafsummary/TCGA.LAML.mutect.27f42413-6d8f-401f-9d07-d019def8939e.DR-10.0.somatic.maf",help="MAF file name"), # type=file
  make_option(c("--outdir"), type="character", default="./",help="Output file path"), 
  make_option(c("--width"), type="character", default="10", help="Width [inch]", metavar="10 inch"), 
  make_option(c("--height"), type="character", default="8", help="Height [inch]", metavar="8 inch"), 
  make_option(c("--top"), type="character", default="10", help="how many top genes to be drawn. defaults to 10."),  
  make_option(c("--rmOutlier "), type="character", default="NULL", help="If TRUE removes outlier from boxplot."), #type=select:FALSE,TRUE*
  make_option(c("--dashboard"), type="character", default="NULL", help="If FALSE plots simple summary instead of dashboard style." ),  #type=select:TRUE*,FALSE
  make_option(c("--titvRaw"), type="character", default="NULL", help="TRUE. If false instead of raw counts, plots fraction." ), #type=select:TRUE*,FALSE
  make_option(c("--log_scale"), type="character", default="NULL", help="FALSE. If TRUE log10 transforms Variant Classification, Variant Type and Variants per sample sub-plots."), # type=select:TRUE*,FALSE
  make_option(c("--addStat"), type="character", default="NULL", help="Can be either mean or median. Default NULL."), #type=select:NULL*,mean,median
  make_option(c("--showBarcodes"), type="character", default="NULL", help="include sample names in the top bar plot."), #type=select:FALSE*,TRUE
  make_option(c("--fs"), type="character", default="1",help="base size for text. Default 1"),
  make_option(c("--palette"), type="character", default="NULL", help="color palette"), #type=select:NULL*,npg,aaas,nejm,lancet,jama,jco,ucscgb,d3,locuszoom,igv,uchicago,startrek,tron,futurama,rickandmorty,simpsons
  make_option(c("--mainTitleSize"), type="character", default="1", help="font size for title and subtitle. Default 1.0"),
  make_option(c("--subTitleSize"), type="character", default="0.8", help="font size for title and subtitle. Default 0.8")
)


opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);

palette_list_generation_function=list(
  "npg"= colorRampPalette(ggsci::pal_npg()(10)),
  "aaas"= colorRampPalette(ggsci::pal_aaas()(10)),
  "nejm"= colorRampPalette(ggsci::pal_nejm()(8)),
  "lancet"= colorRampPalette(ggsci::pal_lancet()(9)),
  "jama"= colorRampPalette(ggsci::pal_jama()(7)),
  "jco"= colorRampPalette(ggsci::pal_jco()(10)),
  "ucscgb"= colorRampPalette(ggsci::pal_aaas()(10)),
  "d3"= colorRampPalette(ggsci::pal_d3()(10)),
  "locuszoom"= colorRampPalette(ggsci::pal_locuszoom()(7)),
  "igv"= colorRampPalette(ggsci::pal_igv()(51)),
  "uchicago"= colorRampPalette(ggsci::pal_aaas()(9)),
  "startrek"= colorRampPalette(ggsci::pal_startrek()(7)),
  "tron"= colorRampPalette(ggsci::pal_tron()(7)),
  "futurama"= colorRampPalette(ggsci::pal_futurama()(12)),
  "rickandmorty"= colorRampPalette(ggsci::pal_rickandmorty()(12)),
  "simpsons"= colorRampPalette(ggsci::pal_simpsons()(16))
)


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


# init param list
paramlist = list()

# load data
maf = maftools::read.maf(opt$file)

paramlist[["maf"]] <- maf

if (opt$top != "NULL"){   paramlist[['top']] <- myconvert(opt$top) } 

if (opt$rmOutlier != "NULL"){   paramlist[['rmOutlier']] <- myconvert(opt$rmOutlier) }

if (opt$dashboard != "NULL"){ paramlist[['dashboard']] <- myconvert(opt$dashboard) }

if (opt$titvRaw != "NULL"){ paramlist[['titvRaw']] <- myconvert(opt$titvRaw)}

if (opt$log_scale != "NULL"){ paramlist[['log_scale']] <- myconvert(opt$log_scale)}

if (opt$addStat != "NULL"){ paramlist[['addStat']] <- myconvert(opt$addStat)}

if (opt$showBarcodes != "NULL"){ paramlist[['showBarcodes']] <- myconvert(opt$showBarcodes)}

if (opt$fs != "NULL"){ paramlist[['fs']] <- myconvert(opt$fs)}

if (opt$palette != "NULL"){ 
  vc_cols = palette_list_generation_function[[opt$palette]](8)
  
  names(vc_cols) = c(
    'Frame_Shift_Del',
    'Missense_Mutation',
    'Nonsense_Mutation',
    'Multi_Hit',
    'Frame_Shift_Ins',
    'In_Frame_Ins',
    'Splice_Site',
    'In_Frame_Del'
  )
  
  paramlist[['color']] <- vc_cols
}


paramlist[['titleSize']]<-c(myconvert(opt$mainTitleSize),myconvert(opt$subTitleSize))



prefix=dirname(opt$outdir)


png(paste0(prefix,"/","output_plotmafsummary.png"),width = as.numeric(opt$width),height = as.numeric(opt$height),units = "in",res=600)

do.call(plotmafSummary,paramlist)
dev.off()

pdf(paste0(prefix,"/","output_plotmafsummary.pdf"),width = as.numeric(opt$width),height = as.numeric(opt$height))

do.call(plotmafSummary,paramlist)

dev.off()

svg(paste0(prefix,"/","output_plotmafsummary.svg"),width = as.numeric(opt$width),height = as.numeric(opt$height))

do.call(plotmafSummary,paramlist)

dev.off()









