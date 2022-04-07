.libPaths("/xtdisk/baoym_group/zhengxcngdc/softwares/miniconda3/envs/R36/lib/R/library")
library(VennDiagram)
library(ggsci)
library(optparse)
library(grDevices)



#CONFIG:MODULENAME=Plot_Venn
#CONFIG:APPNAME=Plot_Venn
#CONFIG:DESC=This app draw veen plot for a given dataset.
#CONFIG:CLASS=/xtdisk/baoym_group/zhengxcngdc/softwares/miniconda3/envs/R36/bin/Rscript  /xtdisk/baoym_group/zhengxcngdc/projects/biocloud/units/plot_venn/plot_venn.r
#CONFIG:REFERENCE=https://cran.r-project.org/web/packages/VennDiagram/index.html
#CONFIG:HELP=input format is a matrix like this:
#CONFIG:HELP= A	B	C	D	E #header
#CONFIG:HELP= j	b	o	m	g 
#CONFIG:HELP= u	e	x	j	t
#CONFIG:HELP= r	m	x	m	h
#CONFIG:HELP= d	u	v	n	x
#CONFIG:HELP= f	p	b	m	o
#CONFIG:HELP= n	j	o	j	q
#CONFIG:HELP= j	h	r	l	q
#CONFIG:HELP= e	g	v	g	a
#CONFIG:HELP= h	j	g	m	a
#CONFIG:HELP= w	g	o	l	k
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
#CONFIG:OUTFINENAME=plot_venn.png



# parse arguments
option_list = list(
  # file and Canvas settings
  make_option(c("--file"), type="character", default="/xtdisk/baoym_group/zhengxcngdc/projects/biocloud/units/plot_venn/venn.demodata.txt",help="input file name"), # type=file
  make_option(c("--outdir"), type="character", default="./",help="Output file path"), 
  make_option(c("--width"), type="character", default="6", help="Width [inch]", metavar="6 inch"), 
  make_option(c("--height"), type="character", default="6", help="Height [inch]", metavar="6 inch"), 
  make_option(c("--palette"), type="character", default="NULL", help="color palette"), #type=select:npg,aaas,nejm,lancet,jama,jco,ucscgb,d3,locuszoom,igv,uchicago,startrek*,tron,futurama,rickandmorty,simpsons

  
  make_option(c("--na"), type="character", default="none", help="Missing value handling method: 'none', 'stop', 'remove'" ), #type=select:none*,stop,remove
  
  make_option(c("--transparent"), type="character", default="0.7", help="Transparent value 0-1" ),
  
  make_option(c("--main"), type="character", default="NULL", help="Character giving the main title of the diagram" ),
  
  make_option(c("--sub"), type="character", default="NULL", help="Character giving the subtitle of the diagram" ),
  
  make_option(c("--main.cex"), type="character", default="1", help="Number giving the cex (font size) of the main title" ),
  
  make_option(c("--sub.cex"), type="character", default="1", help="Number giving the cex (font size) of the subtitle" ),
  
  make_option(c("--force.unique"), type="character", default="FALSE", help="Logical specifying whether to use only unique elements in each item of the input list or use all elements. Defaults to FALSE" ), #type=select:FALSE*,TRUE
  
  make_option(c("--print.mode"), type="character", default="raw", help="Can be either 'raw' or 'percent'. This is the format that the numbers will be printed in. Can pass in a vector with the second element being printed under the first" ), #type=select:raw*,percent
  
  make_option(c("--sigdigs"), type="character", default="2", help="If one of the elements in print.mode is 'percent', then this is how many significant digits will be kept" ),
  
  make_option(c("--labelSize"), type="character", default="2", help="Label Size" ),
  
  make_option(c("--categoryLabelSize"), type="character", default="2", help="Category label Size" )
  
  
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

demodata <- read.table(opt$file,sep="\t",header = T,stringsAsFactors = F)


inputlist = list()
for(i in names(demodata)){
  inputlist[[i]] = demodata[[i]]
}


paramlist = list() 

if (opt$na != "NULL"){   paramlist[['na']] <- myconvert(opt$na) } 
if (opt$main != "NULL"){   paramlist[['main']] <- myconvert(opt$main) } 
if (opt$sub != "NULL"){   paramlist[['sub']] <- myconvert(opt$sub) } 
if (opt$sub.cex != "NULL"){   paramlist[['sub.cex']] <- myconvert(opt$sub.cex) } 
if (opt$main.cex != "NULL"){   paramlist[['main.cex']] <- myconvert(opt$main.cex) } 
if (opt$force.unique != "NULL"){   paramlist[['force.unique']] <- myconvert(opt$force.unique) } 
if (opt$print.mode != "NULL"){   paramlist[['print.mode']] <- myconvert(opt$print.mode) } 
if (opt$sigdigs != "NULL"){   paramlist[['sigdigs']] <- myconvert(opt$sigdigs) } 
if (opt$labelSize != "NULL"){   paramlist[['cex']] <- myconvert(opt$labelSize) } 
if (opt$categoryLabelSize != "NULL"){   paramlist[['cat.cex']] <- myconvert(opt$categoryLabelSize) } 
if (opt$palette != "NULL"){ 
  vc_cols = palette_list_generation_function[[opt$palette]](length(inputlist))
  paramlist[['fill']] <- vc_cols
}


prefix=dirname(opt$outdir)
paramlist[['filename']] <- paste0(prefix,"/","output_plotvenn.png")
paramlist[['imagetype']] <- "png"
paramlist[['units']] <- "in"

paramlist[['width']] <- myconvert(opt$width)
paramlist[['height']] <- myconvert(opt$height)
paramlist[['alpha']] <- myconvert(opt$transparent)
paramlist[['x']]<-inputlist



# venn.diagram 自带输出png功能
do.call(venn.diagram,paramlist)



paramlist[['imagetype']] <- "svg"
paramlist[['filename']] <- NULL
paramlist[length(paramlist)+1] <- list(NULL)
names(paramlist)[length(paramlist)] <-"filename"



pdf(paste0(prefix,"/","output_plotvenn.pdf"),width = as.numeric(opt$width),height = as.numeric(opt$height))
grid.draw(do.call(venn.diagram,paramlist))
dev.off()

svg(paste0(prefix,"/","output_plotvenn.svg"),width = as.numeric(opt$width),height = as.numeric(opt$height))
grid.draw(do.call(venn.diagram,paramlist))
dev.off()





