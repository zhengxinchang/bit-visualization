#.libPaths("/xtdisk/baoym_group/zhengxcngdc/softwares/miniconda3/envs/R36/lib/R/library")
library(ggplot2)
library("optparse")
library(ggsci)



# parse arguments
option_list = list(
  make_option(c("--file"), type="character", default="/xtdisk/baoym_group/zhengxcngdc/projects/biocloud/units/plot_box/example_box.txt",help="Dataset file name", metavar="file"), #type=file
  make_option(c("--outdir"), type="character", default="./",help="Output file path"), 
  make_option(c("--width"), type="character", default="8", help="Width [inch]", metavar="8 inch"), 
  make_option(c("--height"), type="character", default="6", help="Height [inch]", metavar="6 inch"), 
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
  make_option(c("--palette"), type="character", default="NULL", help="Palette. see help for detial. ") #tpye=select:npg*,aaas,nejm,lancet,jama,jco,ucscgb,d3,locuszoom,igv,uchicago,startrek,tron,futurama,rickandmorty,simpsons
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


dat<-read.table(opt$file,header = T,sep="\t")


objplot<- ggplot(dat) + 
  theme_classic() + 
  ggplot2::geom_boxplot(
    aes_string(x=names(dat)[1],y=names(dat)[2],fill=names(dat)[1]),color="black"
  ) 




if (opt$palette != "NULL"){
  objplot <- objplot + scale_fill_manual(values = palette_list_generation_function[[opt$palette]](length(unique(dat[,1]))) )
}


tryCatch({
  objplot<- objplot + labs(fill=unique(dat[,1]))
})


if(opt$title != "NULL" ){
  objplot<-objplot+ ggtitle(label = opt$title) + theme(plot.title = element_text(hjust = 0.5))
}


if(opt$title_size != "NULL"){
  objplot<-objplot+ theme(plot.title =element_text(size =myconvert(opt$title_size) ))
}


if(opt$x_title != "NULL"){
  objplot<-objplot+ xlab(label = opt$x_title) + labs(fill=opt$x_title)
  
}

if(opt$x_title_size != "NULL" ){
  objplot<-objplot+ theme(axis.title.x=element_text(size =myconvert(opt$x_title_size )))
}

if(opt$x_text_angle != "NULL"){
  objplot<-objplot+ theme(axis.text.x=element_text(angle  =myconvert(opt$x_text_angle) ))
}

if(opt$x_text_size != "NULL"){
  objplot<-objplot+ theme(axis.text.x=element_text(size  = myconvert(opt$x_text_size) ))
}


if(opt$y_title != "NULL"){
  objplot<-objplot+ ylab(label = opt$y_title)
}

if(opt$y_title_size != "NULL"){
  objplot<-objplot+ theme(axis.title.y=element_text(size = myconvert(opt$y_title_size) ))
}

if(opt$y_text_angle != "NULL"){
  objplot<-objplot+ theme(axis.text.y=element_text(angle  = myconvert(opt$y_text_angle) ))
}

if(opt$y_text_size != "NULL"){
  objplot<-objplot+ theme(axis.text.y=element_text(size  = myconvert(opt$y_text_size) ))
}





objplot  <- objplot  + ggplot2::theme(legend.position = 'none')
prefix=dirname(opt$outdir)



ggsave(objplot,device = "png",filename =paste0(prefix,"/","output_plotbox.png"),width = myconvert(opt$width),height = myconvert(opt$height),units = "in",dpi=600)

ggsave(objplot,device = "pdf",filename = paste0(prefix,"/","output_plotbox.pdf"),width = as.numeric(opt$width),height = as.numeric(opt$height),units = "in")

ggsave(objplot,device = "svg",filename = paste0(prefix,"/","output_plotbox.svg"),width = as.numeric(opt$width),height = as.numeric(opt$height),units = "in")



