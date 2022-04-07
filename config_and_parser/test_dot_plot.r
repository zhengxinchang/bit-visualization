.libPaths("/xtdisk/baoym_group/zhengxcngdc/softwares/miniconda3/envs/R36/lib/R/library")
library(ggplot2)
library(optparse)
library(ggsci)

#%&% $META$ config_version=0.1 
#%&% $META$ program_type=visualization
#%&% $META$ author=zhengxinchang
#%&% $META$ email=zhengxinchang@big.ac.cn
#%&% $META$ title=Dot
#%&% $META$ description=Dot plot
#%&% $META$ cmd=/xtdisk/baoym_group/zhengxcngdc/softwares/miniconda3/envs/R36/bin/Rscript  /xtdisk/baoym_group/zhengxcngdc/projects/biocloud/units/plot_dot/plot_dot.r
#%&% $META$ is_submit_to_queue=False
#%&% $META$ ppn=1
#%&% $META$ mem=10
#%&% $META$ reference=https://cran.r-project.org/web/packages/ggplot2/index.html
#%&% $META$ manual=
#%&% $META$ manual=The input file format example:
#%&% $META$ manual=x	y #header
#%&% $META$ manual=A	2
#%&% $META$ manual=B	3
#%&% $META$ manual=C	6
#%&% $META$ manual=D	4
#%&% $META$ manual=E	8
#%&% $META$ manual=F	5
#%&% $META$ manual=G	2
#%&% $META$ manual=H	1
#%&% $META$ manual=I	9
#%&% $META$ manual=J	8
#%&% $META$ manual=---------------------------------------------


option_list = list(
#%&% $OPTION$ option=start
#%&% $OPTION$ name= File
#%&% $OPTION$ cmdparam= --file
#%&% $OPTION$ type=file_textarea 
#%&% $OPTION$ range= null
#%&% $OPTION$ default= /xtdisk/baoym_group/zhengxcngdc/projects/biocloud/units/plot_dot/example_input_bar.txt
#%&% $OPTION$ help="Dataset file name"
#%&% $OPTION$ required= true
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end
make_option(c("--file"), type="character", default="/xtdisk/baoym_group/zhengxcngdc/projects/biocloud/units/plot_dot/example_input_bar.txt",help="Dataset file name", metavar="file"), #type=file

#%&% $OPTION$ option=start
#%&% $OPTION$ name= out
#%&% $OPTION$ cmdparam= --outdir
#%&% $OPTION$ type= output
#%&% $OPTION$ default= run_output
#%&% $OPTION$ result_files=${output}_plot_bar.png|show_in_page:true
#%&% $OPTION$ result_files=${output}_plot_bar.svg|show_in_page:false
#%&% $OPTION$ result_files=${output}_plot_bar.pdf|show_in_page:false
#%&% $OPTION$ option=end
make_option(c("--outdir"), type="character", default="./",help="Output file path"), 

#%&% $OPTION$ option=start
#%&% $OPTION$ name= Width
#%&% $OPTION$ cmdparam= --width
#%&% $OPTION$ type= number 
#%&% $OPTION$ default= 8
#%&% $OPTION$ range=min:null;max:null 
#%&% $OPTION$ help= Width of the plot
#%&% $OPTION$ required= false
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end
make_option(c("--width"), type="character", default="8", help="Width [inch]", metavar="8 inch"), 

#%&% $OPTION$ option=start
#%&% $OPTION$ name= Height
#%&% $OPTION$ cmdparam= --height
#%&% $OPTION$ type= number 
#%&% $OPTION$ default= 6
#%&% $OPTION$ range=min:null;max:null 
#%&% $OPTION$ help= Height of the plot
#%&% $OPTION$ required= false
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end
make_option(c("--height"), type="character", default="6", help="Height [inch]", metavar="6 inch"), 

#%&% $OPTION$ option=start
#%&% $OPTION$ name= Title
#%&% $OPTION$ cmdparam= --title
#%&% $OPTION$ type= string 
#%&% $OPTION$ default= ""
#%&% $OPTION$ range=None
#%&% $OPTION$ help= Main title
#%&% $OPTION$ required= false
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end
make_option(c("--title"), type="character", default="NULL", help="Main title"),

#%&% $OPTION$ option=start
#%&% $OPTION$ name= Title Size
#%&% $OPTION$ cmdparam= --title_size
#%&% $OPTION$ type= number 
#%&% $OPTION$ default= None
#%&% $OPTION$ range=min:null;max:null 
#%&% $OPTION$ help= Font size of main title
#%&% $OPTION$ required= false
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end
make_option(c("--title_size"), type="character", default="NULL", help="Main title font size"), 

#%&% $OPTION$ option=start
#%&% $OPTION$ name= Title of x axis
#%&% $OPTION$ cmdparam= --x_title
#%&% $OPTION$ type= string 
#%&% $OPTION$ default= 
#%&% $OPTION$ range=null
#%&% $OPTION$ help= Title of x axis
#%&% $OPTION$ required= false
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end
make_option(c("--x_title"), type="character", default="NULL", help="Title of x axis"),

#%&% $OPTION$ option=start
#%&% $OPTION$ name= Title size of x axis
#%&% $OPTION$ cmdparam= --x_title_size
#%&% $OPTION$ type= number 
#%&% $OPTION$ default= None
#%&% $OPTION$ range=min:null;max:null 
#%&% $OPTION$ help= Font size of axis title
#%&% $OPTION$ required= false
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end
make_option(c("--x_title_size"), type="character", default="15", help="Title size for x axis" ),

#%&% $OPTION$ option=start
#%&% $OPTION$ name= Text size of x axis
#%&% $OPTION$ cmdparam= --x_text_size
#%&% $OPTION$ type= number 
#%&% $OPTION$ default= None
#%&% $OPTION$ range=min:null;max:null 
#%&% $OPTION$ help= Font size of x axis text
#%&% $OPTION$ required= false
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end
make_option(c("--x_text_size"), type="character", default="NULL", help="Title size for x axis" ),

#%&% $OPTION$ option=start
#%&% $OPTION$ name= Text angle of x axis
#%&% $OPTION$ cmdparam= --x_text_angle
#%&% $OPTION$ type= select 
#%&% $OPTION$ default= None
#%&% $OPTION$ range=15:15;30:30;45:45;60:60;75:75;90:90;
#%&% $OPTION$ help= Font size of axis text
#%&% $OPTION$ required= false
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end
make_option(c("--x_text_angle"), type="character", default="NULL", help="Text angle for x axis"), #type=select:0*,15,30,45,60,90


#%&% $OPTION$ option=start
#%&% $OPTION$ name= Title of y axis
#%&% $OPTION$ cmdparam= --y_title
#%&% $OPTION$ type= string 
#%&% $OPTION$ default= ""
#%&% $OPTION$ range=None
#%&% $OPTION$ help= Title of x axis
#%&% $OPTION$ required= false
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end
make_option(c("--y_title"), type="character", default="NULL",help="Title of y axis"),


#%&% $OPTION$ option=start
#%&% $OPTION$ name= Title size of y axis
#%&% $OPTION$ cmdparam= --y_title_size
#%&% $OPTION$ type= number 
#%&% $OPTION$ default= 15
#%&% $OPTION$ range=min:null;max:null 
#%&% $OPTION$ help= Font size of y axis title
#%&% $OPTION$ required= false
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end
make_option(c("--y_title_size"), type="character", default="15", help="Title size for y axis"),

#%&% $OPTION$ option=start
#%&% $OPTION$ name= Text size of y axis
#%&% $OPTION$ cmdparam= --y_text_size
#%&% $OPTION$ type= number 
#%&% $OPTION$ default= None
#%&% $OPTION$ range=min:null;max:null 
#%&% $OPTION$ help= Font size of y axis text
#%&% $OPTION$ required= false
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end
make_option(c("--y_text_size"), type="character", default="NULL", help="Text size for y axis"),

#%&% $OPTION$ option=start
#%&% $OPTION$ name= Text size of y axis
#%&% $OPTION$ cmdparam= --y_text_size
#%&% $OPTION$ type= number 
#%&% $OPTION$ default= None
#%&% $OPTION$ range=min:null;max:null 
#%&% $OPTION$ help= Font size of y axis text
#%&% $OPTION$ required= false
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end
make_option(c("--y_text_angle"), type="character", default="NULL", help="Text angle for y axis"),  #type=select:0*,15,30,45,60,90

#%&% $OPTION$ option=start
#%&% $OPTION$ name= Color
#%&% $OPTION$ cmdparam= --color
#%&% $OPTION$ type= color 
#%&% $OPTION$ default= black
#%&% $OPTION$ range=None
#%&% $OPTION$ help= Dot color
#%&% $OPTION$ required= false
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end
make_option(c("--color"), type="character", default="black", help="dot color"),

#%&% $OPTION$ option=start
#%&% $OPTION$ name= Dot size
#%&% $OPTION$ cmdparam= --dotsize
#%&% $OPTION$ type= number 
#%&% $OPTION$ default= 4
#%&% $OPTION$ range=min:null;max:null
#%&% $OPTION$ help= Dot size
#%&% $OPTION$ required= false
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end
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

