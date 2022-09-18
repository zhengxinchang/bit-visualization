.libPaths("/xtdisk/baoym_group/zhengxcngdc/softwares/miniconda3/envs/R36/lib/R/library")
library(ggplot2)
library(optparse)

#CONFIG:MODULENAME=Plot_bar
#CONFIG:APPNAME=Plot_bar
#CONFIG:DESC=This app draw a bar plot for a given dataset.
#CONFIG:CLASS=/xtdisk/baoym_group/zhengxcngdc/softwares/miniconda3/envs/R36/bin/Rscript  /xtdisk/baoym_group/zhengxcngdc/projects/biocloud/units/plot_bar/plot_bar.r
#CONFIG:REFERENCE=https://cran.r-project.org/web/packages/ggplot2/index.html
#CONFIG:HELP=The input file format is : category   value. 
#CONFIG:HELP=The value must be numeric.
#CONFIG:HELP=The palettes are derived from package ggsci :
#CONFIG:HELP=npg:  Nature Publishing Group
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
#CONFIG:OUTFINENAME=output_plotbar.png

# parse arguments
option_list = list(
  make_option(c("--file"), type="character", default="/xtdisk/baoym_group/zhengxcngdc/projects/biocloud/units/plot_bar/example_input_bar.txt",help="Dataset file name", metavar="file"), #type=file
  make_option(c("--outdir"), type="character", default="./",help="Output file path"), 
  make_option(c("--width"), type="character", default="8", help="Width [inch]", metavar="8 inch"), 
  make_option(c("--height"), type="character", default="6", help="Height [inch]", metavar="6 inch"), 
  make_option(c("--title"), type="character", default="NULL", help="Main title"),
  make_option(c("--title_size"), type="character", default="NULL", help="Main title font size"), 
  make_option(c("--x_title"), type="character", default="NULL", help="Title of x axis"),
  make_option(c("--x_title_size"), type="character", default="15", help="Title size for x axis" ),
  make_option(c("--x_text_size"), type="character", default="NULL", help="Title size for x axis" ),
  make_option(c("--x_text_angle"), type="character", default="NULL", help="Text angle for x axis"), # type=select:0*,15,30,45,60,90
  make_option(c("--y_title"), type="character", default="NULL",help="Title of y axis"),
  make_option(c("--y_title_size"), type="character", default="15", help="Title size for y axis"),
  make_option(c("--y_text_size"), type="character", default="NULL", help="Text size for y axis"),
  make_option(c("--y_text_angle"), type="character", default="NULL", help="Text angle for y axis"),  # type=select:0*,15,30,45,60,90
  make_option(c("--palette"), type="character", default="NULL", help="Palette. see help for detial. ") # tpye=select:npg*,aaas,nejm,lancet,jama,jco,ucscgb,d3,locuszoom,igv,uchicago,startrek,tron,futurama,rickandmorty,simpsons
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


dat<-read.table(opt$file,header = T,sep="\t",stringsAsFactors = F)



datname = names(dat)
leveee = unique(dat[datname[1]])
dat[,1] <- factor(dat[,1],levels = dat[,1])
print(dat[,1])
# x y 

objplot<- ggplot(dat) + 
  theme_classic() + 
  geom_bar(
  aes(x=.data[[datname[1]]],y=.data[[datname[2]]],fill=dat[,1]),stat = "identity"
  ) 

if (opt$palette != "NULL"){
  objplot <- objplot + scale_fill_manual(values = palette_list_generation_function[[opt$palette]](nrow(dat)) )
}


tryCatch({
  objplot<- objplot + labs(fill=datname[1])
})


if(opt$title != "NULL" ){
  objplot<-objplot+ ggtitle(label = opt$title) + theme(plot.title = element_text(hjust = 0.5))
}


if(opt$title_size != "NULL"){
  objplot<-objplot+ theme(plot.title =element_text(size =as.numeric(opt$title_size) ))
}


if(opt$x_title != "NULL"){
  objplot<-objplot+ xlab(label = opt$x_title) + labs(fill=opt$x_title) 
  
}

if(opt$x_title_size != "NULL" ){
  objplot<-objplot+ theme(axis.title.x=element_text(size =as.numeric(opt$x_title_size )))
}

if(opt$x_text_angle != "NULL"){
  objplot<-objplot+ theme(axis.text.x=element_text(angle  =as.numeric(opt$x_text_angle),hjust=1 ))
}

if(opt$x_text_size != "NULL"){
  objplot<-objplot+ theme(axis.text.x=element_text(size  = as.numeric(opt$x_text_size) ))
}


if(opt$y_title != "NULL"){
  objplot<-objplot+ ylab(label = opt$y_title)
}

if(opt$y_title_size != "NULL"){
  objplot<-objplot+ theme(axis.title.y=element_text(size = as.numeric(opt$y_title_size) ))
}

if(opt$y_text_angle != "NULL"){
  objplot<-objplot+ theme(axis.text.y=element_text(angle  = as.numeric(opt$y_text_angle),hjust=1 ))
}

if(opt$y_text_size != "NULL"){
  objplot<-objplot+ theme(axis.text.y=element_text(size  = as.numeric(opt$y_text_size) ))
}


# 
# a = unlist(strsplit(opt$out, "/"))
prefix2=dirname(opt$outdir)

ggsave(objplot,device = "png",filename =paste0(prefix2,"/","output_plotbar.png"),width = as.numeric(opt$width),height = as.numeric(opt$height),units = "in",dpi=600)

ggsave(objplot,device = "pdf",filename = paste0(prefix2,"/","output_plotbar.pdf"),width = as.numeric(opt$width),height = as.numeric(opt$height),units = "in")

ggsave(objplot,device = "svg",filename = paste0(prefix2,"/","output_plotbar.svg"),width = as.numeric(opt$width),height = as.numeric(opt$height),units = "in")



