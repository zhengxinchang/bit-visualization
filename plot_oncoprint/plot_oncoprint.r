
#.libPaths("/xtdisk/baoym_group/zhengxcngdc/softwares/miniconda3/envs/R36/lib/R/library")
library(maftools)
library(optparse)
library(ggsci)


#CONFIG:MODULENAME=Plot_Oncoprint2
#CONFIG:APPNAME=Plot_Oncoprint2
#CONFIG:DESC=This app draw Oncoprint plot for a given dataset.
#CONFIG:CLASS=/xtdisk/baoym_group/zhengxcngdc/softwares/miniconda3/envs/R36/bin/Rscript  /xtdisk/baoym_group/zhengxcngdc/projects/biocloud/units/plot_oncoprint/plot_oncoprint.r
#CONFIG:REFERENCE=http://bioconductor.org/packages/release/bioc/vignettes/maftools/inst/doc/maftools.html
#CONFIG:HELP=input format is MAF [https://docs.gdc.cancer.gov/Data/File_Formats/MAF_Format/]
#CONFIG:OUTFINENAME=plot_oncoplot.png



# parse arguments
option_list = list(
  # file and Canvas settings
  make_option(c("--file"), type="character", default="/xtdisk/baoym_group/zhengxcngdc/projects/biocloud/units/plot_oncoprint/TCGA.LAML.mutect.27f42413-6d8f-401f-9d07-d019def8939e.DR-10.0.somatic.maf",help="MAF file name", metavar="file"), # type=file
  make_option(c("--outdir"), type="character", default="./",help="Output file path"), 
  make_option(c("--width"), type="character", default="10", help="Width [inch]", metavar="8 inch"), 
  make_option(c("--height"), type="character", default="6", help="Height [inch]", metavar="6 inch"), 
  make_option(c("--top"), type="character", default="NULL", help="how many top genes to be drawn. defaults to 20."),  
  make_option(c("--altered "), type="character", default="NULL", help="Chooses top genes based on muatation status. If TRUE chooses top genes based alterations (CNV or mutation)."), #type=select:FALSE*,TRUE
  make_option(c("--drawRowBar"), type="character", default="TRUE", help="logical plots barplot for each gene" ),  #type=select:TRUE*,FALSE
  make_option(c("--drawColBar"), type="character", default="TRUE", help="logical plots barplot for each sample" ), #type=select:TRUE*,FALSE
  make_option(c("--includeColBarCN"), type="character", default="NULL", help="Whether to include CN in column bar plot"), # type=select:TRUE*,FALSE
  make_option(c("--draw_titv"), type="character", default="NULL", help="logical Includes TiTv plot"), #type=select:FALSE*,TRUE
  make_option(c("--logColBar"), type="character", default="NULL", help="Plot top bar plot on log10 scale"), #type=select:FALSE*,TRUE
  make_option(c("--showTumorSampleBarcodes"), type="character", default="NULL",help="logical to include sample names."), # type=select:TRUE*,FALSE
  make_option(c("--removeNonMutated"), type="character", default="TRUE", help="Logical. If TRUE removes samples with no mutations in the oncoplot for better visualization"), # type=select:TRUE*,FALSE
  make_option(c("--fill"), type="character", default="TRUE", help="If TRUE draws genes and samples as blank grids even when they are not altered."), # type=select:TRUE*,FALSE
  make_option(c("--cohortSize"), type="character", default="NULL", help="Number of sequenced samples in the cohort. Default all samples from Cohort. You can manually specify the cohort size"), 
  make_option(c("--palette"), type="character", default="NULL", help="color palette"), # tpye=select:NULL*,npg,aaas,nejm,lancet,jama,jco,ucscgb,d3,locuszoom,igv,uchicago,startrek,tron,futurama,rickandmorty,simpsons
  make_option(c("--sortByMutation"), type="character", default="NULL", help="Force sort matrix according mutations. Helpful in case of MAF was read along with copy number data"), #type=select:FALSE*,TRUE
  make_option(c("--keepGeneOrder"), type="character", default="NULL", help="logical whether to keep order of given genes. Default FALSE, order according to mutation frequency"),  #type=select:FALSE*,TRUE
  make_option(c("--sepwd_genes"), type="character", default="0.5", help="sepreate width of genes,default is 0.5"),  
  make_option(c("--sepwd_samples"), type="character", default="0.5", help="sepreate width of samples,default is 0.5"),  
  make_option(c("--fontSize"), type="character", default="0.8", help="font size for gene names. Default 0.8."), 
  make_option(c("--SampleNamefontSize"), type="character", default="1", help="font size for sample names. Default 1"),  
  make_option(c("--showTitle"), type="character", default="NULL", help="individual cell width in points. If left as NULL, then the values depend on the size of plotting window."),    #type=select:FALSE,TRUE*
  make_option(c("--titleFontSize"), type="character", default="1.5", help="font size for title."), 
  make_option(c("--legendFontSize	"), type="character", default="1.2", help="font size for legend."), 
  make_option(c("--bgCol"), type="character", default="gray", help="Background grid color for wild-type (not-mutated) samples. Default gray - '#CCCCCC'"), 
  make_option(c("--borderCol"), type="character", default="white", help="border grid color (not-mutated) samples. Default 'white'.") 
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

if (opt$altered != "NULL"){   paramlist[['altered']] <- myconvert(opt$altered) }

if (opt$drawRowBar != "NULL"){ paramlist[['drawRowBar']] <- myconvert(opt$drawRowBar) }

if (opt$drawColBar != "NULL"){ paramlist[['drawColBar']] <- myconvert(opt$drawColBar)}

if (opt$includeColBarCN != "NULL"){ paramlist[['includeColBarCN']] <- myconvert(opt$includeColBarCN)}

if (opt$draw_titv != "NULL"){ paramlist[['draw_titv']] <- myconvert(opt$draw_titv)}

if (opt$logColBar != "NULL"){ paramlist[['logColBar']] <- myconvert(opt$logColBar)}

if (opt$showTumorSampleBarcodes != "NULL"){ paramlist[['showTumorSampleBarcodes']] <- myconvert(opt$showTumorSampleBarcodes)}

if (opt$removeNonMutated != "NULL"){ paramlist[['removeNonMutated']] <- myconvert(opt$removeNonMutated)}

if (opt$fill != "NULL"){ paramlist[['fill']] <- myconvert(opt$fill)}

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

if (opt$sortByMutation != "NULL"){ paramlist[['sortByMutation']] <- myconvert(opt$sortByMutation)}

if (opt$keepGeneOrder != "NULL"){ paramlist[['keepGeneOrder']] <- myconvert(opt$keepGeneOrder)}

if (opt$sepwd_genes != "NULL"){ paramlist[['sepwd_genes']] <- myconvert(opt$sepwd_genes)}

if (opt$sepwd_samples != "NULL"){ paramlist[['sepwd_samples']] <- myconvert(opt$sepwd_samples)}

if (opt$fontSize != "NULL"){ paramlist[['fontSize']] <- myconvert(opt$fontSize)}

if (opt$SampleNamefontSize != "NULL"){ paramlist[['SampleNamefontSize']] <- myconvert(opt$SampleNamefontSize)}

if (opt$showTitle != "NULL"){ paramlist[['showTitle']] <- myconvert(opt$showTitle)}

if (opt$titleFontSize != "NULL"){ paramlist[['titleFontSize']] <- myconvert(opt$titleFontSize)}

if (opt$legendFontSize != "NULL"){ paramlist[['legendFontSize']] <- myconvert(opt$legendFontSize)}

if (opt$bgCol != "NULL"){ paramlist[['bgCol']] <- myconvert(opt$bgCol)}

if (opt$borderCol != "NULL"){ paramlist[['borderCol']] <- myconvert(opt$borderCol)}


prefix=dirname(opt$outdir)

png(paste0(prefix,"/","output_plotoncoprint.png"),width = as.numeric(opt$width),height = as.numeric(opt$height),units = "in",res=600)

do.call(maftools::oncoplot, paramlist )

dev.off()



pdf(paste0(prefix,"/","output_plotoncoprint.pdf"),width = as.numeric(opt$width),height = as.numeric(opt$height))

do.call(maftools::oncoplot, paramlist )

dev.off()

svg(paste0(prefix,"/","output_plotoncoprint.svg"),width = as.numeric(opt$width),height = as.numeric(opt$height))

do.call(maftools::oncoplot, paramlist )

dev.off()

