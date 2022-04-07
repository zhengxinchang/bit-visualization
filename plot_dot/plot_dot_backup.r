
.libPaths("/xtdisk/baoym_group/zhengxcngdc/softwares/miniconda3/envs/R36/lib/R/library")
library(ggplot2)
library(ggpubr)
library("optparse")
library(stringr)
library(ggsci)




palette_list=list(
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


# parse arguments
# print(option_list)
# 
# option_list = get_option_list()
# option_list = c(option_list,
# 
# )
# print(option_list)


option_list = list(
  make_option(c("-f", "--file"), type="character", default=NULL,help="dataset file name", metavar="character"),
  make_option(c("-o", "--out"), type="character", default="out", 
              help="output file name [default= %default]", metavar="character"),
  make_option(c("-p", "--palette"), type="character", default="jco", 
              help=paste(names(palette_list),collapse = ", "), metavar="character"),
  make_option(c("--width"), type="integer", default="12", 
              help="width", metavar="character"),
  make_option(c("--height"), type="integer", default="10", 
              help="height", metavar="character"),
  make_option(c("-s","--dot_szie"), type="integer", default="6",
              help="dot_size", metavar="character"),
  make_option(c("--title"), type="character", default=NULL, 
              help="title", metavar="character"),
  make_option(c("--title_size"), type="integer", default=NULL, 
              help="title_size", metavar="character"),
  make_option(c("--x_title"), type="character", default=NULL, 
              help="x_title", metavar="character"),
  make_option(c("--x_title_size"), type="integer", default=NULL, 
              help="x_title_size", metavar="character"),
  make_option(c("--x_text_size"), type="integer", default=NULL, 
              help="x_text_size", metavar="character"),
  make_option(c("--x_text_angle"), type="integer", default=NULL, 
              help="x_text_angle", metavar="character"),
  make_option(c("--y_title"), type="character", default=NULL, 
              help="y_title", metavar="character"),
  make_option(c("--y_title_size"), type="integer", default=NULL, 
              help="y_title_size", metavar="character"),
  make_option(c("--y_text_size"), type="integer", default=NULL, 
              help="y_text_size", metavar="character"),
  make_option(c("--y_text_angle"), type="integer", default=NULL, 
              help="y_text_angle", metavar="character")
  
)


opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);

if( !(opt$palette %in% names(palette_list))){
  
  stop(simpleError(
    paste("the palette must in one of:\n",
          paste(names(palette_list),collapse = ", ")
    )
  ))
}


dat<-read.table(opt$file,header = T)

# x y 
print(names(dat))

objplot<- ggplot(dat) + 
  theme_classic2() + 
  geom_point(
    aes_string(x=names(dat)[1],y=names(dat)[2],color=names(dat)[1]),size=9
  ) 


if(! is.null(opt$title) ){
  objplot<-objplot+ ggtitle(label = opt$title)
}

if(! is.null(opt$title_size)){
  objplot<-objplot+ theme(plot.title =element_text(size =opt$title_size ))
}

if(! is.null(opt$x_title)){
  objplot<-objplot+ xlab(label = opt$x_title) + labs(fill=opt$x_title)
}

if(! is.null(opt$x_title_size)){
  objplot<-objplot+ theme(axis.title.x=element_text(size =opt$x_title_size ))
}

if(! is.null(opt$x_text_angle)){
  objplot<-objplot+ theme(axis.text.x=element_text(angle  =opt$x_text_angle ))
}

if(! is.null(opt$x_text_size)){
  objplot<-objplot+ theme(axis.text.x=element_text(size  =opt$x_text_size ))
}

if(! is.null(opt$y_title)){
  objplot<-objplot+ ylab(label = opt$y_title)
}

if(! is.null(opt$y_title_size)){
  objplot<-objplot+ theme(axis.title.y=element_text(size =opt$y_title_size ))
}

if(! is.null(opt$y_text_angle)){
  objplot<-objplot+ theme(axis.text.y=element_text(angle  =opt$y_text_angle ))
}

if(! is.null(opt$y_text_size)){
  objplot<-objplot+ theme(axis.text.y=element_text(size  =opt$y_text_size ))
}

objplot  <- objplot  + ggplot2::theme(legend.position = 'none')
objplot  <- objplot  + scale_color_manual(values =palette_list[[opt$palette]](nrow(dat)))


a = unlist(strsplit(opt$out, "/"))
prefix=paste0(a[1:length(a)-1],collapse = "/")


ggsave(objplot,device = "png",filename =paste0(prefix,"/","output_plotdot.png"),width = opt$width,height = opt$height,units = "in",dpi=100)

#ggsave(objplot,device = "pdf",filename = paste0(opt$out,".pdf"),width = opt$width,height = opt$height,units = "in")
ggsave(objplot,device = "pdf",filename = paste0(prefix,"/","output_plotdot.pdf"),width = opt$width,height = opt$height,units = "in")
