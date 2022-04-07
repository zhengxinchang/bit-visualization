.libPaths("/xtdisk/baoym_group/zhengxcngdc/softwares/miniconda3/envs/R36/lib/R/library")
library(ggplot2)
library(optparse)
library(ggsci)

#CONFIG:MODULENAME=Plot_Dot
#CONFIG:APPNAME=Plot_Dot
#CONFIG:DESC=This app draw a Dot plot for a given dataset.
#CONFIG:CLASS=/xtdisk/baoym_group/zhengxcngdc/softwares/miniconda3/envs/R36/bin/Rscript  /xtdisk/baoym_group/zhengxcngdc/projects/biocloud/units/plot_dot/plot_dot.r
#CONFIG:REFERENCE=https://cran.r-project.org/web/packages/ggplot2/index.html
#CONFIG:HELP=The input file format example:
#CONFIG:HELP=x	y #header
#CONFIG:HELP=A	2
#CONFIG:HELP=B	3
#CONFIG:HELP=C	6
#CONFIG:HELP=D	4
#CONFIG:HELP=E	8
#CONFIG:HELP=F	5
#CONFIG:HELP=G	2
#CONFIG:HELP=H	1
#CONFIG:HELP=I	9
#CONFIG:HELP=J	8
#CONFIG:HELP=---------------------------------------------
#CONFIG:OUTFINENAME=output_plotdot.png


# parse arguments
option_list = list(
  make_option(c("--file"), type="character", default="/xtdisk/baoym_group/zhengxcngdc/projects/biocloud/units/plot_dot/example_input_bar.txt",help="Dataset file name", metavar="file"), #type=file
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
  make_option(c("--color"), type="character", default="black", help="dot color"),
  make_option(c("--dotsize"), type="character", default="4", help="dot size")
  
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


dat<-read.csv(opt$file,header = T,sep="\t")

print(opt$dotsize)

objplot<- ggplot(dat) + 
  theme_classic() + 
  ggplot2::geom_point(
    aes_string(x=names(dat)[1],y=names(dat)[2]),size=myconvert(opt$dotsize),color=myconvert(opt$color)
  ) 






# if (opt$palette != "NULL"){
#   objplot <- objplot + scale_fill_manual(values = palette_list_generation_function[[opt$palette]](length(unique(dat[,1]))) )
# }


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



ggsave(objplot,device = "png",filename =paste0(prefix,"/","output_plotdot.png"),width = myconvert(opt$width),height = myconvert(opt$height),units = "in",dpi=600)

ggsave(objplot,device = "pdf",filename = paste0(prefix,"/","output_plotdot.pdf"),width = as.numeric(opt$width),height = as.numeric(opt$height),units = "in")

ggsave(objplot,device = "svg",filename = paste0(prefix,"/","output_plotdot.svg"),width = as.numeric(opt$width),height = as.numeric(opt$height),units = "in")

