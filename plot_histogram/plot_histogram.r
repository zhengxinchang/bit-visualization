
.libPaths("/xtdisk/baoym_group/zhengxcngdc/softwares/miniconda3/envs/R36/lib/R/library")
library(ggplot2)
library("optparse")
library(ggsci)

#CONFIG:MODULENAME=Plot_Histgram
#CONFIG:APPNAME=Plot_Histgram
#CONFIG:DESC=This app draw a Histgram plot for a given dataset.
#CONFIG:CLASS=/xtdisk/baoym_group/zhengxcngdc/softwares/miniconda3/envs/R36/bin/Rscript  /xtdisk/baoym_group/zhengxcngdc/projects/biocloud/units/plot_hist/plot_hist.r
#CONFIG:REFERENCE=https://cran.r-project.org/web/packages/ggplot2/index.html
#CONFIG:HELP=The input file format example:
#CONFIG:HELP=discrete input
#CONFIG:HELP=letter #header
#CONFIG:HELP=a
#CONFIG:HELP=c
#CONFIG:HELP=e
#CONFIG:HELP=b
#CONFIG:HELP=b
#CONFIG:HELP=c
#CONFIG:HELP=--------------------
#CONFIG:HELP=continuous input
#CONFIG:HELP=letter #header
#CONFIG:HELP=1.2
#CONFIG:HELP=3
#CONFIG:HELP=4.4
#CONFIG:HELP=6
#CONFIG:HELP=11
#CONFIG:HELP=8
#CONFIG:HELP=---------------------------------------------
#CONFIG:HELP=The palettes are derived from package ggsci :
#CONFIG:HELP=npg: Nature Publishing Group
#CONFIG:HELP=aaas:  American Association for the Advancement of Science
#CONFIG:HELP=nejm:  The New England Journal of Medicine
#CONFIG:HELP=lancet:  Lancet Oncology
#CONFIG:HELP=jama:  The Journal of the American Medical Association
#CONFIG:HELP=jco: Journal of Clinical Oncology
#CONFIG:HELP=ucscgb:  The UCSCGB palette is from the colors used by UCSC Genome Browser for representing chromosomes
#CONFIG:HELP=d3:  The D3 palette is from the categorical colors used by D3.js (version 3.x and before).
#CONFIG:HELP=locuszoom: The LocusZoom palette is based on the colors used by LocusZoom
#CONFIG:HELP=igv: The IGV palette is from the colors used by Integrative Genomics Viewer for representing chromosomes
#CONFIG:HELP=uchicago:  The UChicago palette is based on the colors used by the University of Chicago
#CONFIG:HELP=startrek:  This palette is inspired by the (uniform) colors in Star Trek
#CONFIG:HELP=tron:  This palette is inspired by the colors used in Tron Legacy
#CONFIG:HELP=futurama:  This palette is inspired by the colors used in the TV show Futurama
#CONFIG:HELP=rickandmorty:  This palette is inspired by the colors used in the TV show Rick and Morty
#CONFIG:HELP=simpsons:  This palette is inspired by the colors used in the TV show The Simpsons
#CONFIG:OUTFINENAME=output_plothistgram.png



# parse arguments
option_list = list(
  make_option(c("--file"), type="character", default="/xtdisk/baoym_group/zhengxcngdc/projects/biocloud/units/plot_hist/example_box.txt",help="Dataset file name", metavar="file"), #type=file
  make_option(c("--outdir"), type="character", default="./",help="Output file path"), 
  make_option(c("--width"), type="character", default="8", help="Width [inch]"), 
  make_option(c("--height"), type="character", default="6", help="Height [inch]"), 
  make_option(c("--binwidths"), type="character", default="0.2",help="binwidths"),
  make_option(c("--datatype"), type="character", default="discrete",help="Discrete or continous"), #type=select:discrete*,continuous
  make_option(c("--title"), type="character", default="NULL", help="Main title"),
  make_option(c("--title_size"), type="character", default="NULL", help="Main title font size"), 
  make_option(c("--x_title"), type="character", default="NULL", help="Title of x axis"),
  make_option(c("--x_title_size"), type="character", default="15", help="Title size for x axis" ),
  make_option(c("--x_text_size"), type="character", default="NULL", help="Title size for x axis" ),
  make_option(c("--x_text_angle"), type="character", default="NULL", help="Text angle for x axis"), #type=select:0*,15,30,45,60,90
  make_option(c("--y_title"), type="character", default="NULL",help="Title of y axis"),
  make_option(c("--y_title_size"), type="character", default="15", help="Title size for y axis"),
  make_option(c("--y_text_size"), type="character", default="NULL", help="Text size for y axis"),
  make_option(c("--y_text_angle"), type="character", default="NULL", help="Text angle for y axis"),  #type=select:0*,15,30,45,60,90
  make_option(c("--palette"), type="character", default="npg", help="Palette. see help for detail.") #type=select:npg*,aaas,nejm,lancet,jama,jco,ucscgb,d3,locuszoom,igv,uchicago,startrek,tron,futurama,rickandmorty,simpsons
)




opt_parser = OptionParser(option_list=option_list)
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



dat<-read.csv(opt$file,header = T)
summary(dat)
# x y 


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


if(opt$datatype == "discrete"){
objplot<- ggplot(dat) + 
  theme_classic() + 
  ggplot2::geom_histogram(
    aes_string(x=names(dat)[1],fill=names(dat)[1]),binwidth = myconvert(opt$binwidths),stat = "count"
  ) 
  
}else{
objplot<- ggplot(dat) + 
  theme_classic() + 
  ggplot2::geom_histogram(
    aes_string(x=names(dat)[1]),binwidth = myconvert(opt$binwidths)
  ) 
  
}



if (opt$palette != "NULL"){
  objplot <- objplot + scale_fill_manual(values = palette_list_generation_function[[opt$palette]](nrow(dat)) )
}


if( opt$title != "NULL" ){
  objplot<-objplot+ ggtitle(label = opt$title) + theme(plot.title = element_text(hjust = 0.5))
}

if(opt$title_size  != "NULL"){
  objplot<-objplot+ theme(plot.title =element_text(size =opt$title_size ))
}

if(opt$x_title !="NULL"){
  objplot<-objplot+ xlab(label = opt$x_title) + labs(fill=opt$x_title)
}

if(opt$x_title_size  != "NULL"){
  objplot<-objplot+ theme(axis.title.x=element_text(size =opt$x_title_size ))
}

if(opt$x_text_angle  != "NULL"){
  objplot<-objplot+ theme(axis.text.x=element_text(angle  = as.numeric(opt$x_text_angle) ))
}


if(opt$y_title  != "NULL"){
  objplot<-objplot+ ylab(label = opt$y_title)
}

if(opt$y_title_size  != "NULL"){
  objplot<-objplot+ theme(axis.title.y=element_text(size =opt$y_title_size ))
}

if(opt$y_text_angle  != "NULL"){
  objplot<-objplot+ theme(axis.text.y=element_text(angle  = as.numeric(opt$y_text_angle) ))
}

if( opt$y_text_size  != "NULL"){
  objplot<-objplot+ theme(axis.text.y=element_text(size  =opt$y_text_size ))
}

objplot  <- objplot  + ggplot2::theme(legend.position = 'none')


if( opt$palette != "NULL"){
objplot  <- objplot  + scale_fill_manual(values =palette_list_generation_function[[opt$palette]](nrow(dat)))
}


prefix=dirname(opt$outdir)


ggsave(objplot,device = "png",filename =paste0(prefix,"/","output_plothistogram.png"),width = myconvert(opt$width),height = myconvert(opt$height),units = "in",dpi=600)


ggsave(objplot,device = "pdf",filename = paste0(prefix,"/","output_plothistogram.pdf"),width = as.numeric(opt$width),height = as.numeric(opt$height),units = "in")

ggsave(objplot,device = "svg",filename = paste0(prefix,"/","output_plothistogram.svg"),width = as.numeric(opt$width),height = as.numeric(opt$height),units = "in")
