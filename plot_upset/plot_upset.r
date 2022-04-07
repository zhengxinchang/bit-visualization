
.libPaths("/xtdisk/baoym_group/zhengxcngdc/softwares/miniconda3/envs/R36/lib/R/library")
library(UpSetR)
library(ggsci)
library(optparse)



#CONFIG:MODULENAME=Plot_Upset
#CONFIG:APPNAME=Plot_Upset
#CONFIG:DESC=This app draw Upset plot for a given dataset.
#CONFIG:CLASS=/xtdisk/baoym_group/zhengxcngdc/softwares/miniconda3/envs/R36/bin/Rscript  /xtdisk/baoym_group/zhengxcngdc/projects/biocloud/units/plot_upset/plot_upset.r
#CONFIG:REFERENCE=https://cran.r-project.org/web/packages/UpSetR/
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
#CONFIG:OUTFINENAME=plot_upset.png

# parse arguments
option_list = list(
  
  make_option(c("--file"), type="character", default="/xtdisk/baoym_group/zhengxcngdc/projects/biocloud/units/plot_upset/upset.demodata.txt",help="input file name"), #type=file
  make_option(c("--outdir"), type="character", default="./",help="Output file path"), 
  make_option(c("--width"), type="character", default="4", help="Width [inch]", metavar="4 inch"), 
  make_option(c("--height"), type="character", default="4", help="Height [inch]", metavar="4 inch"), 

  make_option(c("--nsets"), type="character", default="5", help="Number of sets to look at" ), 
  
  make_option(c("--nintersects"), type="character", default="40", help="Number of intersections to plot. If set to NA, all intersections will be plotted." ),
  
  make_option(c("--keep.order"), type="character", default="FALSE", help="Keep sets in the order entered using the sets parameter. The default is FALSE, which orders the sets by their sizes." ), #type=select:FALSE*,TRUE
  
  make_option(c("--matrix.color"), type="character", default="gray23", help="Color of the intersection points eg. gray or #F23FFF" ),
  
  make_option(c("--main.bar.color"), type="character", default="NULL", help="Color of the main bar plot eg. darkblue or #F23FFF" ),
  
  make_option(c("--mainbar.y.label"), type="character", default="NULL", help="The y-axis label of the intersection size bar plot" ),
  
  make_option(c("--mainbar.y.max"), type="character", default="NULL", help="The maximum y value of the intersection size bar plot scale. May be useful when aligning multiple UpSet plots horizontally." ),
  make_option(c("--sets.x.label"), type="character", default="NULL", help="The x-axis label of the set size bar plot" ),
  
  make_option(c("--point.size"), type="character", default="NULL", help="Size of points in matrix plot" ),
  
  make_option(c("--line.size"), type="character", default="NULL", help="Width of lines in matrix plot" ),
  
  make_option(c("--att.pos"), type="character", default="NULL", help="Position of attribute plot. If NULL or 'bottom' the plot will be at below UpSet plot. If 'top' it will be above UpSet plot" ), #type=select:bottom*,top
  
  make_option(c("--att.color"), type="character", default="NULL", help="Color of attribute histogram bins or scatterplot points for unqueried data represented by main bars. Default set to color of main bars." ),
  
  make_option(c("--order.by"), type="character", default="freq", help="How the intersections in the matrix should be ordered by. Options include frequency (entered as 'freq'), degree, or both in any order." ), #type=select:freq*,degree
  
  make_option(c("--decreasing"), type="character", default="TRUE", help="How the variables in order. by should be ordered. 'freq' is decreasing (greatest to least) and 'degree' is increasing (least to greatest)" ), #type=select:TRUE*,FALSE
  
  make_option(c("--show.numbers"), type="character", default="NULL", help="Show numbers of intersection sizes above bars" ), #type=select:TRUE*,FALSE
  
  make_option(c("--number.angles"), type="character", default="NULL", help="The angle of the numbers atop the intersection size bars" ),
  
  make_option(c("--matrix.dot.alpha"), type="character", default="NULL", help="Transparency of the empty intersections points in the matrix" ),
  
  make_option(c("--text.scale"), type="character", default="NULL", help="Numeric, value to scale the text sizes, applies to all axis labels, tick labels, and numbers above bar plot. Can be a universal scale, or a vector containing individual scales in the following format: c(intersection size title, intersection size tick labels, set size title, set size tick labels, set names, numbers above bars)" ),
  
  make_option(c("--scale.sets"), type="character", default="NULL", help="The scale to be used for the set sizes. Options: 'identity', 'log10', 'log2" ), #type=select:identity*,log10,log2
  
  make_option(c("--sets.bar.color"), type="character", default="black", help="Color of set size bar plot" ),
  
  make_option(c("--set_size.angles"), type="character", default="NULL", help="Numeric, angle to rotate the set size plot x-axis text" ),
  
  make_option(c("--set_size.numbers_size"), type="character", default="NULL", help="If set_size.show is TRUE, adjust the size of the numbers" ),
  
  make_option(c("--set_size.show"), type="character", default="NULL", help="Logical, display the set sizes on the set size bar chart" )
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


paramlist = list() 

if (opt$nsets != "NULL"){   paramlist[['nsets']] <- myconvert(opt$nsets) } 
if (opt$nintersects != "NULL"){   paramlist[['nintersects']] <- myconvert(opt$nintersects) } 
if (opt$keep.order != "NULL"){   paramlist[['keep.order']] <- myconvert(opt$keep.order) } 
if (opt$matrix.color != "NULL"){   paramlist[['matrix.color']] <- myconvert(opt$matrix.color) } 
if (opt$main.bar.color != "NULL"){   paramlist[['main.bar.color']] <- myconvert(opt$main.bar.color) } 
if (opt$mainbar.y.label != "NULL"){   paramlist[['mainbar.y.label']] <- myconvert(opt$mainbar.y.label) } 
if (opt$mainbar.y.max != "NULL"){   paramlist[['mainbar.y.max']] <- myconvert(opt$mainbar.y.max) } 
if (opt$sets.bar.color != "NULL"){   paramlist[['sets.bar.color']] <- myconvert(opt$sets.bar.color) } 
if (opt$sets.x.label != "NULL"){   paramlist[['sets.x.label']] <- myconvert(opt$sets.x.label) } 
if (opt$point.size != "NULL"){   paramlist[['point.size']] <- myconvert(opt$point.size) } 
if (opt$line.size != "NULL"){   paramlist[['line.size']] <- myconvert(opt$line.size) } 
if (opt$att.pos != "NULL"){   paramlist[['att.pos']] <- myconvert(opt$att.pos) } 
if (opt$att.color != "NULL"){   paramlist[['att.color']] <- myconvert(opt$att.color) } 
if (opt$order.by != "NULL"){   paramlist[['order.by']] <- myconvert(opt$order.by) } 
if (opt$decreasing != "NULL"){   paramlist[['decreasing']] <- myconvert(opt$decreasing) } 
if (opt$show.numbers != "NULL"){ if(opt$show.numbers =='yes'){paramlist[['show.numbers']] <- myconvert(opt$show.numbers)}} 
if (opt$number.angles != "NULL"){   paramlist[['number.angles']] <- myconvert(opt$number.angles) } 
if (opt$matrix.dot.alpha != "NULL"){   paramlist[['matrix.dot.alpha']] <- myconvert(opt$matrix.dot.alpha) } 
if (opt$set_size.angles != "NULL"){   paramlist[['set_size.angles']] <- myconvert(opt$set_size.angles) } 
if (opt$set_size.numbers_size != "NULL"){   paramlist[['set_size.numbers_size']] <- myconvert(opt$set_size.numbers_size) } 
if (opt$set_size.show != "NULL"){   paramlist[['set_size.show']] <- myconvert(opt$set_size.show) } 
if (opt$scale.sets != "NULL"){   paramlist[['scale.sets']] <- myconvert(opt$scale.sets) } 


upsetdata <- read.table(opt$file,sep="\t",header = T,stringsAsFactors = F)
paramlist[['data']] <-upsetdata

prefix=dirname(opt$outdir)

png(paste0(prefix,"/","output_plotupset.png"),width = as.numeric(opt$width) ,height = as.numeric(opt$height) ,units = "in",res=600)
  do.call(upset,paramlist)
dev.off()


pdf(paste0(prefix,"/","output_plotupset.pdf"),width = as.numeric(opt$width) ,height = as.numeric(opt$height),onefile = FALSE)
  do.call(upset,paramlist)
dev.off()

svg(paste0(prefix,"/","output_plotupset.svg"),width = as.numeric(opt$width) ,height = as.numeric(opt$height),onefile = FALSE)
  do.call(upset,paramlist)
dev.off()





