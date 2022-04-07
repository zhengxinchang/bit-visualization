
.libPaths("/xtdisk/baoym_group/zhengxcngdc/softwares/miniconda3/envs/R36/lib/R/library")
library(maftools)
library(optparse)
library(ggsci)


#CONFIG:MODULENAME=Plot_Lollipop
#CONFIG:APPNAME=Plot_Lollipop
#CONFIG:DESC=This app draw iollipop plot for a given dataset.
#CONFIG:CLASS=/xtdisk/baoym_group/zhengxcngdc/softwares/miniconda3/envs/R36/bin/Rscript  /xtdisk/baoym_group/zhengxcngdc/projects/biocloud/units/plot_lollipop/plot_lollipop.R
#CONFIG:REFERENCE=http://bioconductor.org/packages/release/bioc/vignettes/maftools/inst/doc/maftools.html
#CONFIG:HELP=input format is MAF [https://docs.gdc.cancer.gov/Data/File_Formats/MAF_Format/]
#CONFIG:HELP=the gene to plot lollipop plot must be included in MAF file.
#CONFIG:OUTFINENAME=plot_lollipop.png




option_list = list(
  make_option(c("--file"), type="character", default="/xtdisk/baoym_group/zhengxcngdc/projects/biocloud/units/plot_mafsummary/TCGA.LAML.mutect.27f42413-6d8f-401f-9d07-d019def8939e.DR-10.0.somatic.maf",help="MAF file name"), #type=file
  make_option(c("--outdir"), type="character", default="./",help="Output file path"), 
  make_option(c("--width"), type="character", default="10", help="Width [inch]", metavar="10 inch"), 
  make_option(c("--height"), type="character", default="8", help="Height [inch]", metavar="8 inch"), 
  make_option(c("--gene"), type="character", default="FLT3",help="output file name", metavar="character"),
  make_option(c("--showMutationRate"), type="character", default="10", help="Whether to show the somatic mutation rate on the title. Default TRUE"),  #type=select:TRUE*,FALSE
  make_option(c("--showDomainLabel "), type="character", default="NULL", help="Label domains within the plot. Default TRUE. If FALSE they will be annotated in legend."), #type=select:TRUE*,FALSE
  make_option(c("--printCount"), type="character", default="NULL", help="If TRUE, prints number of summarized variants for the given protein." ),  #type=select:TRUE*,FALSE
  make_option(c("--titleMainSize"), type="character", default="1.2", help="font size for title Default 1.2" ), 
  make_option(c("--titleSubSize"), type="character", default="1", help="font size for subtitle. Default 1" ),  
  make_option(c("--pointSize"), type="character", default="1.5", help="size of lollipop heads. Default 1.5" ), 
  make_option(c("--defaultYaxis"), type="character", default="1.5", help="If FALSE, just labels min and maximum y values on y axis." ), #type=select:TRUE*,FALSE
  make_option(c("--palette"), type="character", default="NULL", help="palette for plot" ) #type=select:NULL*,npg,aaas,nejm,lancet,jama,jco,ucscgb,d3,locuszoom,igv,uchicago,startrek,tron,futurama,rickandmorty,simpsons
  
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



maf = maftools::read.maf(opt$file)

paramlist <- list()

paramlist[["maf"]] <- maf

print("start drawing")
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
  
  paramlist[['colors']] <- vc_cols
}

print("start drawing")

if (opt$gene != "NULL"){   paramlist[['gene']] <- myconvert(opt$gene) } 
if (opt$showMutationRate != "NULL"){   paramlist[['showMutationRate']] <- myconvert(opt$showMutationRate) } 
if (opt$showDomainLabel != "NULL"){   paramlist[['showDomainLabel']] <- myconvert(opt$showDomainLabel) } 
if (opt$printCount != "NULL"){   paramlist[['printCount']] <- myconvert(opt$printCount) } 
if (opt$pointSize != "NULL"){   paramlist[['pointSize']] <- myconvert(opt$pointSize) } 
if (opt$defaultYaxis != "NULL"){   paramlist[['defaultYaxis']] <- myconvert(opt$defaultYaxis) } 
paramlist[["titleSize"]] <- c(myconvert(opt$titleMainSize),myconvert(opt$titleSubSize))



prefix=dirname(opt$outdir)




png(paste0(prefix,"/","output_plotlollipop.png"),width = myconvert(opt$width),height = myconvert(opt$height),units = "in",res=600)

do.call(lollipopPlot,paramlist)
print("end drawing")
dev.off()

pdf(paste0(prefix,"/","output_plotlollipop.pdf"),width = myconvert(opt$width),height = myconvert(opt$height))

do.call(lollipopPlot,paramlist)
dev.off()

svg(paste0(prefix,"/","output_plotlollipop.svg"),width = myconvert(opt$width),height = myconvert(opt$height))

do.call(lollipopPlot,paramlist)
dev.off()


