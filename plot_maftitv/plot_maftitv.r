

.libPaths("/xtdisk/baoym_group/zhengxcngdc/softwares/miniconda3/envs/R36/lib/R/library")
library(maftools)
library(optparse)
library(ggsci)


#CONFIG:MODULENAME=Plot_MafTitv
#CONFIG:APPNAME=Plot_MafTitv
#CONFIG:DESC=This app draw Titv plot for a given dataset.
#CONFIG:CLASS=/xtdisk/baoym_group/zhengxcngdc/softwares/miniconda3/envs/R36/bin/Rscript  /xtdisk/baoym_group/zhengxcngdc/projects/biocloud/units/plot_titv/plot_maftitv.R
#CONFIG:REFERENCE=http://bioconductor.org/packages/release/bioc/vignettes/maftools/inst/doc/maftools.html
#CONFIG:HELP=input format is MAF [https://docs.gdc.cancer.gov/Data/File_Formats/MAF_Format/]
#CONFIG:HELP=---------------------------------------------
#CONFIG:HELP=The palettes are derived from package ggsci :
#CONFIG:HELP=npg:   Nature Publishing Group
#CONFIG:HELP=aaas:  American Association for the Advancement of Science
#CONFIG:HELP=nejm:  The New England Journal of Medicine
#CONFIG:HELP=lancet:  Lancet Oncology
#CONFIG:HELP=jama:  The Journal of the American Medical Association
#CONFIG:HELP=jco:  Journal of Clinical Oncology
#CONFIG:HELP=ucscgb:  The UCSCGB palette is from the colors used by UCSC Genome Browser for representing chromosomes
#CONFIG:HELP=d3:  The D3 palette is from the categorical colors used by D3.js (version 3.x and before).
#CONFIG:HELP=locuszoom:  The LocusZoom palette is based on the colors used by LocusZoom
#CONFIG:HELP=igv:  The IGV palette is from the colors used by Integrative Genomics Viewer for representing chromosomes
#CONFIG:HELP=uchicago:  The UChicago palette is based on the colors used by the University of Chicago
#CONFIG:HELP=startrek:  This palette is inspired by the (uniform) colors in Star Trek
#CONFIG:HELP=tron:  This palette is inspired by the colors used in Tron Legacy
#CONFIG:HELP=futurama:  This palette is inspired by the colors used in the TV show Futurama
#CONFIG:HELP=rickandmorty:  This palette is inspired by the colors used in the TV show Rick and Morty
#CONFIG:HELP=simpsons:  This palette is inspired by the colors used in the TV show The Simpsons
#CONFIG:OUTFINENAME=plot_maftitv.png



# parse arguments
option_list = list(
  # file and Canvas settings
  make_option(c("--file"), type="character", default="/xtdisk/baoym_group/zhengxcngdc/projects/biocloud/units/plot_titv/TCGA.LAML.mutect.27f42413-6d8f-401f-9d07-d019def8939e.DR-10.0.somatic.maf",help="MAF file name"), # type=file
  make_option(c("--outdir"), type="character", default="./",help="Output file path"), 
  make_option(c("--width"), type="character", default="10", help="Width [inch]", metavar="10 inch"), 
  make_option(c("--height"), type="character", default="8", help="Height [inch]", metavar="8 inch"), 
  make_option(c("--useSyn"), type="character", default="FALSE", help="Logical. Whether to include synonymous variants in analysis. Defaults to FALSE."), #type=select:FALSE*,TRUE
  make_option(c("--plotType "), type="character", default="both", help="Can be 'bar', 'box' or 'both'. Defaults to 'both'"), #type=select:both*,bar,box
  make_option(c("--showBarcodes"), type="character", default="FALSE", help="Whether to include sample names for barplot" ),  #type=select:TRUE,FALSE*
  make_option(c("--textSize"), type="character", default="2", help="fontsize if showBarcodes is TRUE. Deafult 2." ),
  make_option(c("--baseFontSize"), type="character", default="1", help="basic font size. Deafult 1."),
  make_option(c("--axisTextSize_X"), type="character", default="1", help="text size x  tick labels. Default 1."), 
  make_option(c("--axisTextSize_Y"), type="character", default="1", help="text size  y tick labels. Default 1."), 
  make_option(c("--palette"), type="character", default="NULL", help="color palette") #type=select:NULL*,npg,aaas,nejm,lancet,jama,jco,ucscgb,d3,locuszoom,igv,uchicago,startrek,tron,futurama,rickandmorty,simpsons
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
print(opt$useSyn)
data.titv = titv(maf = maf , useSyn = myconvert(opt$useSyn))

paramlist[["res"]] <- data.titv

if (opt$plotType != "NULL"){   paramlist[['plotType']] <- myconvert(opt$plotType) } 

if (opt$showBarcodes != "NULL"){   paramlist[['showBarcodes']] <- myconvert(opt$showBarcodes) }

if (opt$textSize != "NULL"){ paramlist[['textSize']] <- myconvert(opt$textSize) }

if (opt$baseFontSize != "NULL"){ paramlist[['baseFontSize']] <- myconvert(opt$baseFontSize)}

paramlist[['axisTextSize']]<-c(myconvert(opt$axisTextSize_X),myconvert(opt$axisTextSize_Y))


if (opt$palette != "NULL"){ 
  vc_cols = palette_list_generation_function[[opt$palette]](6)
  
  names(vc_cols) = c(
    'C>T',
    'C>A',
    'C>G',
    'T>A',
    'T>G',
    'T>C'
  )
  
  paramlist[['color']] <- vc_cols
}



prefix=dirname(opt$outdir)

png(paste0(prefix,"/","output_plotmaftitv.png"),width = as.numeric(opt$width),height = as.numeric(opt$height),units = "in",res=600)
#plot titv summary
do.call(plotTiTv,paramlist)
dev.off()

pdf(paste0(prefix,"/","output_plotmaftitv.pdf"),width = as.numeric(opt$width),height = as.numeric(opt$height))
#plot titv summary
do.call(plotTiTv,paramlist)
dev.off()


svg(paste0(prefix,"/","output_plotmaftitv.svg"),width = as.numeric(opt$width),height = as.numeric(opt$height))
#plot titv summary
do.call(plotTiTv,paramlist)
dev.off()





