

suppressMessages({
  library(UpSetR)
  library(ggsci)
  library(optparse)
})
source("/bit/newVersionUnits/utils.r")

#%&% $META$ config_version=0.1 
#%&% $META$ program_type=visualization
#%&% $META$ author=zhengxinchang
#%&% $META$ email=zhengxinchang@big.ac.cn
#%&% $META$ title=Upset
#%&% $META$ description=Upset plot
#%&% $META$ cmd=command
#%&% $META$ is_submit_to_queue=False
#%&% $META$ ppn=1
#%&% $META$ mem=10
#%&% $META$ reference=https://cran.r-project.org/web/packages/UpSetR/
#%&% $META$ manual= Upset plot is uesed to visualize interactions between groups


option_list = list(

    
#%&% $OPTION$ option=start
#%&% $OPTION$ name= width
#%&% $OPTION$ cmdparam= --width
#%&% $OPTION$ type= number 
#%&% $OPTION$ default= 8
#%&% $OPTION$ range=min:0;max:20 
#%&% $OPTION$ help= width of the canvas
#%&% $OPTION$ required= true
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end
make_option(c("--width"), type="character",default = "8"), 


#%&% $OPTION$ option=start
#%&% $OPTION$ name= height
#%&% $OPTION$ cmdparam= --height
#%&% $OPTION$ type= number 
#%&% $OPTION$ default= 6
#%&% $OPTION$ range=min:0;max:20 
#%&% $OPTION$ help= height of the canvas
#%&% $OPTION$ required= true
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end
make_option(c("--height"), type="character",default = "6"),

#%&% $ option=start
#%&% $ name= output
#%&% $ cmdparam= --outdir
#%&% $ type= output
#%&% $ default= run_output
#%&% $ result_files=${output}_plot_upset.png|show_in_page:true
#%&% $ result_files=${output}_plot_upset.svg|show_in_page:false
#%&% $ result_files=${output}_plot_upset.pdf|show_in_page:false
#%&% $ option=end
make_option(c("--outdir"), type = "character", default = "./"),


#%&% $OPTION$ option=start  
#%&% $OPTION$ name= File
#%&% $OPTION$ cmdparam= --file
#%&% $OPTION$ type=file_textarea 
#%&% $OPTION$ range= null
#%&% $OPTION$ default= path to example file
#%&% $OPTION$ help=datasets
#%&% $OPTION$ required= true
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end
make_option(c("--file"), type="character",default = "NULL"),

#%&% $OPTION$ option=start
#%&% $OPTION$ name= number sets
#%&% $OPTION$ cmdparam= --nsets
#%&% $OPTION$ type= number 
#%&% $OPTION$ default= 5
#%&% $OPTION$ range=min:1;max: inf
#%&% $OPTION$ help= Number of sets to look at
#%&% $OPTION$ required= true
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end
make_option(c("--nsets"), type="character", default="NULL" ), 

#%&% $OPTION$ option=start
#%&% $OPTION$ name= number of intersections
#%&% $OPTION$ cmdparam= --nintersects
#%&% $OPTION$ type= number 
#%&% $OPTION$ default= 40
#%&% $OPTION$ range=min:;max: 
#%&% $OPTION$ help= Number of intersections to plot. If set to NA, all intersections will be plotted.
#%&% $OPTION$ required= true
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end
make_option(c("--nintersects"), type="character", default="NULL"),

#%&% $OPTION$ option=start
#%&% $OPTION$ name= keep order
#%&% $OPTION$ cmdparam= --keep.order
#%&% $OPTION$ type= select 
#%&% $OPTION$ default= FALSE
#%&% $OPTION$ range=[{"TRUE":"TRUE"}, {"FALSE":"FALSE"}]
#%&% $OPTION$ help= Keep sets in the order entered using the sets parameter. The default is FALSE, which orders the sets by their sizes.
#%&% $OPTION$ required= true
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end
make_option(c("--keep.order"), type="character", default="NULL"),


#%&% $OPTION$ option=start
#%&% $OPTION$ name= matrix color
#%&% $OPTION$ cmdparam= --matrix.color
#%&% $OPTION$ type= color 
#%&% $OPTION$ default= #F23FFF
#%&% $OPTION$ range=None
#%&% $OPTION$ help= Color of the intersection points eg. gray or #F23FFF
#%&% $OPTION$ required= true
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end
make_option(c("--matrix.color"), type="character", default="NULL" ),


#%&% $OPTION$ option=start
#%&% $OPTION$ name= main bar color
#%&% $OPTION$ cmdparam= --main.bar.color
#%&% $OPTION$ type= color 
#%&% $OPTION$ default=  #F23FFF
#%&% $OPTION$ range=None
#%&% $OPTION$ help= Color of the main bar plot eg. darkblue or #F23FFF
#%&% $OPTION$ required= true
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end
make_option(c("--main.bar.color"), type="character", default="NULL" ),

#%&% $OPTION$ option=start
#%&% $OPTION$ name= y label
#%&% $OPTION$ cmdparam= --mainbar.y.label
#%&% $OPTION$ type= string 
#%&% $OPTION$ default= NULL
#%&% $OPTION$ range=None
#%&% $OPTION$ help= The y-axis label of the intersection size bar plot
#%&% $OPTION$ required= true
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end
make_option(c("--mainbar.y.label"), type="character", default="NULL" ),


#%&% $OPTION$ option=start
#%&% $OPTION$ name= max y in main plot
#%&% $OPTION$ cmdparam= --mainbar.y.max
#%&% $OPTION$ type= number 
#%&% $OPTION$ default= NULL
#%&% $OPTION$ range=min:0;max:inf 
#%&% $OPTION$ help= help
#%&% $OPTION$ required= true
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end
make_option(c("--mainbar.y.max"), type="character", default="NULL"),


#%&% $OPTION$ option=start
#%&% $OPTION$ name= x label in sets plot
#%&% $OPTION$ cmdparam= --sets.x.label
#%&% $OPTION$ type= string 
#%&% $OPTION$ default= None
#%&% $OPTION$ range=None
#%&% $OPTION$ help= The x-axis label of the set size bar plot
#%&% $OPTION$ required= true
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end
make_option(c("--sets.x.label"), type="character", default="NULL", help="The x-axis label of the set size bar plot" ),


#%&% $OPTION$ option=start
#%&% $OPTION$ name= name
#%&% $OPTION$ cmdparam= --point.size
#%&% $OPTION$ type= number 
#%&% $OPTION$ default= NULL
#%&% $OPTION$ range=min:0;max: inf
#%&% $OPTION$ help= Size of points in matrix plot
#%&% $OPTION$ required= true
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end
make_option(c("--point.size"), type="character", default="NULL", help="Size of points in matrix plot" ),



#%&% $OPTION$ option=start
#%&% $OPTION$ name= line size of main plot
#%&% $OPTION$ cmdparam= --point.size
#%&% $OPTION$ type= number 
#%&% $OPTION$ default= NULL
#%&% $OPTION$ range=min:0;max: inf
#%&% $OPTION$ help= Size of points in matrix plot
#%&% $OPTION$ required= true
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end
make_option(c("--line.size"), type="character", default="NULL", help="Width of lines in matrix plot" ),



#%&% $OPTION$ option=start
#%&% $OPTION$ name= Position of attribute plot
#%&% $OPTION$ cmdparam= --att.pos
#%&% $OPTION$ type= select 
#%&% $OPTION$ default= bottom
#%&% $OPTION$ range=[{"bottom":"bottom"}, {"top":"top"}]
#%&% $OPTION$ help= Position of attribute plot. If NULL or 'bottom' the plot will be at below UpSet plot. If 'top' it will be above UpSet plot
#%&% $OPTION$ required= true
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end
make_option(c("--att.pos"), type="character", default="NULL", help="" ), #type=select:bottom*,top


#%&% $OPTION$ option=start
#%&% $OPTION$ name= Color of attribute histogram bins
#%&% $OPTION$ cmdparam= --att.color
#%&% $OPTION$ type= color 
#%&% $OPTION$ default= 
#%&% $OPTION$ range=None
#%&% $OPTION$ help= Color of attribute histogram bins or scatterplot points for unqueried data represented by main bars. Default set to color of main bars.
#%&% $OPTION$ required= true
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end
make_option(c("--att.color"), type="character", default="NULL", help="" ),


#%&% $OPTION$ option=start
#%&% $OPTION$ name= intersections ordered by
#%&% $OPTION$ cmdparam= --order.by
#%&% $OPTION$ type= select 
#%&% $OPTION$ default= degree
#%&% $OPTION$ range=[{"Frequency":"freq"}, {"Degree":"degree"}]
#%&% $OPTION$ help= How the intersections in the matrix should be ordered by. Options include frequency (entered as 'freq'), degree, or both in any order.
#%&% $OPTION$ required= true
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end
make_option(c("--order.by"), type="character", default="freq", help="" ),



#%&% $OPTION$ option=start
#%&% $OPTION$ name= decreasing
#%&% $OPTION$ cmdparam= --decreasing
#%&% $OPTION$ type= select 
#%&% $OPTION$ default= TRUE
#%&% $OPTION$ range=[{"TRUE":"TRUE"}, {"FALSE":"FALSE"}]
#%&% $OPTION$ help= How the variables in order. by should be ordered. 'freq' is decreasing (greatest to least) and 'degree' is increasing (least to greatest)
#%&% $OPTION$ required= true
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end
make_option(c("--decreasing"), type="character", default="TRUE", help="" ), #type=select:TRUE*,FALSE



#%&% $OPTION$ option=start
#%&% $OPTION$ name= show bar numbers
#%&% $OPTION$ cmdparam= --show.numbers
#%&% $OPTION$ type= select 
#%&% $OPTION$ default= TRUE
#%&% $OPTION$ range=[{"TRUE":"TRUE"}, {"FALSE":"FALSE"}]
#%&% $OPTION$ help= help
#%&% $OPTION$ required= true
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end
make_option(c("--show.numbers"), type="character", default="NULL", help=""),


#%&% $OPTION$ option=start
#%&% $OPTION$ name= number angle
#%&% $OPTION$ cmdparam= --number.angles
#%&% $OPTION$ type= number 
#%&% $OPTION$ default= NULL
#%&% $OPTION$ range=min:0;max:360 
#%&% $OPTION$ help= The angle of the numbers atop the intersection size bars
#%&% $OPTION$ required= true
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end
make_option(c("--number.angles"), type="character", default="NULL", help="The angle of the numbers atop the intersection size bars" ),


#%&% $OPTION$ option=start
#%&% $OPTION$ name= Transparency of the empty intersections
#%&% $OPTION$ cmdparam= --matrix.dot.alpha
#%&% $OPTION$ type= number 
#%&% $OPTION$ default= NULL
#%&% $OPTION$ range=min:0;max:1 
#%&% $OPTION$ help= Transparency of the empty intersections points in the matrix
#%&% $OPTION$ required= true
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end
make_option(c("--matrix.dot.alpha"), type="character", default="NULL", help="Transparency of the empty intersections points in the matrix" ),


#%&% $OPTION$ option=start
#%&% $OPTION$ name= scale of the text size
#%&% $OPTION$ cmdparam= --command
#%&% $OPTION$ type= number 
#%&% $OPTION$ default= NULL
#%&% $OPTION$ range=min:0;max: inf
#%&% $OPTION$ help= Numeric, value to scale the text sizes, applies to all axis labels, tick labels, and numbers above bar plot
#%&% $OPTION$ required= true
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end
make_option(c("--text.scale"), type="character", default="NULL", help="Numeric, value to scale the text sizes, applies to all axis labels, tick labels, and numbers above bar plot. Can be a universal scale, or a vector containing individual scales in the following format: c(intersection size title, intersection size tick labels, set size title, set size tick labels, set names, numbers above bars)" ),


#%&% $OPTION$ option=start
#%&% $OPTION$ name= scale of sets
#%&% $OPTION$ cmdparam= --scale.sets
#%&% $OPTION$ type= number 
#%&% $OPTION$ default= NULL
#%&% $OPTION$ range=min:  0 ;max:  inf 
#%&% $OPTION$ help= help
#%&% $OPTION$ required= true
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end

make_option(c("--scale.sets"), type="character", default="NULL", help="The scale to be used for the set sizes. Options: 'identity', 'log10', 'log2" ), #type=select:identity*,log10,log2

#%&% $OPTION$ option=start
#%&% $OPTION$ name= set size of bar plot
#%&% $OPTION$ cmdparam= --sets.bar.color
#%&% $OPTION$ type= color 
#%&% $OPTION$ default= black
#%&% $OPTION$ range=None
#%&% $OPTION$ help= Color of set size bar plot
#%&% $OPTION$ required= true
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end
make_option(c("--sets.bar.color"), type="character", default="NULL", help="Color of set size bar plot" ),


#%&% $OPTION$ option=start
#%&% $OPTION$ name= set x text angle
#%&% $OPTION$ cmdparam= --set_size.angles
#%&% $OPTION$ type= number 
#%&% $OPTION$ default= 0
#%&% $OPTION$ range=min: 0 ;max: inf 
#%&% $OPTION$ help= Numeric, angle to rotate the set size plot x-axis text
#%&% $OPTION$ required= true
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end
make_option(c("--set_size.angles"), type="character", default="NULL", help="Numeric, angle to rotate the set size plot x-axis text" ),



#%&% $OPTION$ option=start
#%&% $OPTION$ name= name
#%&% $OPTION$ cmdparam= --command
#%&% $OPTION$ type= number 
#%&% $OPTION$ default=  NULL
#%&% $OPTION$ range=min: 0 ;max: inf
#%&% $OPTION$ help= If set_size.show is TRUE, adjust the size of the numbers
#%&% $OPTION$ required= true
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end

make_option(c("--set_size.numbers_size"), type="character", default="NULL", help="If set_size.show is TRUE, adjust the size of the numbers" ),



#%&% $OPTION$ option=start
#%&% $OPTION$ name= show set size
#%&% $OPTION$ cmdparam= --command
#%&% $OPTION$ type= select 
#%&% $OPTION$ default= TRUE
#%&% $OPTION$ range=[{"TRUE":"TRUE"}, {"FALSE":"FALSE"}]
#%&% $OPTION$ help= Logical, display the set sizes on the set size bar chart
#%&% $OPTION$ required= true
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end
make_option(c("--set_size.show"), type="character", default="NULL", help="Logical, display the set sizes on the set size bar chart" )

)


opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);

paramlist = list()


upsetdata <- read.table(opt$file,sep="\t",header = T,stringsAsFactors = F)
paramlist[['data']] <-upsetdata

 
if (!bit.check.is.null(opt$nsets)){ paramlist[['nsets']] <- bit.convert.str2object(opt$nsets) } 
if (!bit.check.is.null(opt$nintersects)){ paramlist[['nintersects']] <- bit.convert.str2object(opt$nintersects) } 
if (!bit.check.is.null(opt$keep.order)){ paramlist[['keep.order']] <- bit.convert.str2object(opt$keep.order) } 
if (!bit.check.is.null(opt$matrix.color)){ paramlist[['matrix.color']] <- bit.convert.str2object(opt$matrix.color) } 
if (!bit.check.is.null(opt$main.bar.color)){ paramlist[['main.bar.color']] <- bit.convert.str2object(opt$main.bar.color) } 
if (!bit.check.is.null(opt$mainbar.y.label)){ paramlist[['mainbar.y.label']] <- bit.convert.str2object(opt$mainbar.y.label) } 
if (!bit.check.is.null(opt$mainbar.y.max)){ paramlist[['mainbar.y.max']] <- bit.convert.str2object(opt$mainbar.y.max) } 
if (!bit.check.is.null(opt$sets.bar.color)){ paramlist[['sets.bar.color']] <- bit.convert.str2object(opt$sets.bar.color) } 
if (!bit.check.is.null(opt$sets.x.label)){ paramlist[['sets.x.label']] <- bit.convert.str2object(opt$sets.x.label) } 
if (!bit.check.is.null(opt$point.size)){ paramlist[['point.size']] <- bit.convert.str2object(opt$point.size) } 
if (!bit.check.is.null(opt$line.size)){ paramlist[['line.size']] <- bit.convert.str2object(opt$line.size) } 
if (!bit.check.is.null(opt$att.pos)){ paramlist[['att.pos']] <- bit.convert.str2object(opt$att.pos) } 
if (!bit.check.is.null(opt$att.color)){ paramlist[['att.color']] <- bit.convert.str2object(opt$att.color) } 
if (!bit.check.is.null(opt$order.by)){ paramlist[['order.by']] <- bit.convert.str2object(opt$order.by) } 
if (!bit.check.is.null(opt$decreasing)){ paramlist[['decreasing']] <- bit.convert.str2object(opt$decreasing) } 
if (!bit.check.is.null(opt$show.numbers)){ paramlist[['show.numbers']] <- bit.convert.str2object(opt$show.numbers) } 
if (!bit.check.is.null(opt$number.angles)){ paramlist[['number.angles']] <- bit.convert.str2object(opt$number.angles) } 
if (!bit.check.is.null(opt$matrix.dot.alpha)){ paramlist[['matrix.dot.alpha']] <- bit.convert.str2object(opt$matrix.dot.alpha) } 
if (!bit.check.is.null(opt$set_size.angles)){ paramlist[['set_size.angles']] <- bit.convert.str2object(opt$set_size.angles) } 
if (!bit.check.is.null(opt$set_size.numbers_size)){ paramlist[['set_size.numbers_size']] <- bit.convert.str2object(opt$set_size.numbers_size) } 
if (!bit.check.is.null(opt$set_size.show)){ paramlist[['set_size.show']] <- bit.convert.str2object(opt$set_size.show) } 
if (!bit.check.is.null(opt$scale.sets)){ paramlist[['scale.sets']] <- bit.convert.str2object(opt$scale.sets) } 


plotname<-"upset"
fullplotname <- paste0(opt$outdir,"/","output_plot_",plotname)


#===============
pdf(paste0(fullplotname,".pdf"),width = as.numeric(opt$width) ,height = as.numeric(opt$height))
do.call(upset,paramlist)
dev.off()

svg(paste0(fullplotname,".svg"),width = as.numeric(opt$width) ,height = as.numeric(opt$height))
do.call(upset,paramlist)
dev.off()

png(paste0(fullplotname,".png"),width = as.numeric(opt$width) ,height = as.numeric(opt$height), units = "in" ,res=800)
do.call(upset,paramlist)
dev.off()


