
suppressMessages({
  library(VennDiagram)
  library(ggsci)
  library(optparse)
  library(grDevices)
})

source("/bit/newVersionUnits/utils.r")


#%&% $META$ config_version=0.1 
#%&% $META$ program_type=visualization
#%&% $META$ author=zhengxinchang
#%&% $META$ email=zhengxinchang@big.ac.cn
#%&% $META$ title=Venn
#%&% $META$ description=Plot Venn diagram
#%&% $META$ cmd=/bit/newVersionUnits/plot_venn/plot_venn.r
#%&% $META$ is_submit_to_queue=False
#%&% $META$ ppn=1
#%&% $META$ mem=10
#%&% $META$ reference=reference
#%&% $META$ manual= A	B	C	D	E #header
#%&% $META$ manual= j	b	o	m	g 
#%&% $META$ manual= u	e	x	j	t
#%&% $META$ manual= r	m	x	m	h
#%&% $META$ manual= d	u	v	n	x
#%&% $META$ manual= f	p	b	m	o
#%&% $META$ manual= n	j	o	j	q
#%&% $META$ manual= j	h	r	l	q
#%&% $META$ manual= e	g	v	g	a
#%&% $META$ manual= h	j	g	m	a
#%&% $META$ manual= w	g	o	l	k

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
#%&% $ result_files=${output}_plot_venn.png|show_in_page:true
#%&% $ result_files=${output}_plot_venn.svg|show_in_page:false
#%&% $ result_files=${output}_plot_venn.pdf|show_in_page:false
#%&% $ option=end
make_option(c("--outdir"), type = "character", default = "./"),

#%&% $OPTION$ option=start
#%&% $OPTION$ name= palette
#%&% $OPTION$ cmdparam= --palette
#%&% $OPTION$ type= select 
#%&% $OPTION$ default= npg
#%&% $OPTION$ range=[{"Nature Publishing Group":"npg"}, {"American Association for the Advancement of Science":"aaas"}, {"The New England Journal of Medicine":"nejm"}, {"Lancet Oncology":"lancet"}, {"The Journal of the American Medical Association":"jama"}, {"Journal of Clinical Oncology":"jco"}, {"UCSC Genome Browser":"ucscgb"}, {"D3.js":"d3"}, {"LocusZoom":"locuszoom"}, {"Integrative Genomics Viewer":"igv"}, {"University of Chicago":"uchicago"}, {"Star Trek":"startrek"}, {"Tron Legacy":"tron"}, {"TV show Futurama":"futurama"}, {"TV show Rick and Morty":"rickandmorty"}, {"TV show The Simpsons":"simpsons"}]
#%&% $OPTION$ help= palette used in the plot
#%&% $OPTION$ required= true
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end
make_option(c("--palette"), type="character",default = "NULL"),



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
#%&% $OPTION$ name= methods to NA
#%&% $OPTION$ cmdparam= na
#%&% $OPTION$ type= select 
#%&% $OPTION$ default= None
#%&% $OPTION$ range=[{"optionA":"a"}, {"optionB":"b"}, {"optionC":"c"}]
#%&% $OPTION$ help= Missing value handling method: 'none', 'stop', 'remove'
#%&% $OPTION$ required= true
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end
make_option(c("--na"), type="character", default="none"), 

#%&% $OPTION$ option=start
#%&% $OPTION$ name= transparent
#%&% $OPTION$ cmdparam= transparent
#%&% $OPTION$ type= number 
#%&% $OPTION$ default= 0.7
#%&% $OPTION$ range=min:0;max:1 
#%&% $OPTION$ help= Transparent value
#%&% $OPTION$ required= true
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end
make_option(c("--transparent"), type="character", default="NULL"),

#%&% $OPTION$ option=start
#%&% $OPTION$ name= main title
#%&% $OPTION$ cmdparam= --main
#%&% $OPTION$ type= string 
#%&% $OPTION$ default= NULL
#%&% $OPTION$ range=None
#%&% $OPTION$ help= Character giving the main title of the diagram
#%&% $OPTION$ required= true
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end
make_option(c("--main"), type="character", default="NULL"),

#%&% $OPTION$ option=start
#%&% $OPTION$ name= sub title
#%&% $OPTION$ cmdparam= --sub
#%&% $OPTION$ type= string 
#%&% $OPTION$ default= NULL
#%&% $OPTION$ range=None
#%&% $OPTION$ help= Character giving the subtitle of the diagram
#%&% $OPTION$ required= true
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end
make_option(c("--sub"), type="character", default="NULL" ),

#%&% $OPTION$ option=start
#%&% $OPTION$ name= main title font size
#%&% $OPTION$ cmdparam= --main.cex
#%&% $OPTION$ type= number 
#%&% $OPTION$ default= 2
#%&% $OPTION$ range=min:0.1;max:20 
#%&% $OPTION$ help= Number giving the cex (font size) of the main title
#%&% $OPTION$ required= true
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end
make_option(c("--main.cex"), type="character", default="NULL"),

#%&% $OPTION$ option=start
#%&% $OPTION$ name= sub title font size
#%&% $OPTION$ cmdparam= --sub.cex
#%&% $OPTION$ type= number 
#%&% $OPTION$ default= 2
#%&% $OPTION$ range=min:0.1;max:20 
#%&% $OPTION$ help= Number giving the cex (font size) of the subtitle
#%&% $OPTION$ required= true
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end
make_option(c("--sub.cex"), type="character", default="NULL"),

#%&% $OPTION$ option=start
#%&% $OPTION$ name= force unique elements
#%&% $OPTION$ cmdparam= --force.unique
#%&% $OPTION$ type= select 
#%&% $OPTION$ default= FALSE
#%&% $OPTION$ range=[{"FALSE":"FALSE"}, {"TRUE":"TRUE"}]
#%&% $OPTION$ help= Logical specifying whether to use only unique elements in each item of the input list or use all elements. Defaults to FALSE
#%&% $OPTION$ required= true
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end
make_option(c("--force.unique"), type="character", default="NULL"),

#%&% $OPTION$ option=start
#%&% $OPTION$ name= raw or percent
#%&% $OPTION$ cmdparam= --print.mode
#%&% $OPTION$ type= select 
#%&% $OPTION$ default= raw
#%&% $OPTION$ range=[{"Raw":"raw"}, {"Percent":"percent"}]
#%&% $OPTION$ help= Can be either 'raw' or 'percent'. This is the format that the numbers will be printed in. Can pass in a vector with the second element being printed under the first
#%&% $OPTION$ required= true
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end
make_option(c("--print.mode"), type="character", default="NULL"),

#%&% $OPTION$ option=start
#%&% $OPTION$ name= percent digits
#%&% $OPTION$ cmdparam= --sigdigs
#%&% $OPTION$ type= number 
#%&% $OPTION$ default=2 
#%&% $OPTION$ range=min:0;max:10 
#%&% $OPTION$ help= If one of the elements in print.mode is 'percent', then this is how many significant digits will be kept
#%&% $OPTION$ required= true
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end
make_option(c("--sigdigs"), type="character", default="NULL"),


#%&% $OPTION$ option=start
#%&% $OPTION$ name= label size
#%&% $OPTION$ cmdparam= --labelSize
#%&% $OPTION$ type= number 
#%&% $OPTION$ default= 2
#%&% $OPTION$ range=min:0;max:20 
#%&% $OPTION$ help= label size
#%&% $OPTION$ required= true
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end
make_option(c("--labelSize"), type="character", default="NULL"),


#%&% $OPTION$ option=start
#%&% $OPTION$ name= category label size
#%&% $OPTION$ cmdparam= --categoryLabelSize
#%&% $OPTION$ type= number 
#%&% $OPTION$ default= 2
#%&% $OPTION$ range=min:0;max:20 
#%&% $OPTION$ help= Category label size
#%&% $OPTION$ required= true
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end
make_option(c("--categoryLabelSize"), type="character", default="NULL")

)


opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);


#------


demodata <- read.table(opt$file,sep="\t",header = T,stringsAsFactors = F)


inputlist = list()
for(i in names(demodata)){
  inputlist[[i]] = demodata[[i]]
}


paramlist = list() 

if (!bit.check.is.null(opt$na)){   paramlist[['na']] <-bit.convert.str2object(opt$na) } 

if (!bit.check.is.null(opt$main)){   paramlist[['main']] <- bit.convert.str2object(opt$main) } 

if (!bit.check.is.null(opt$sub)){   paramlist[['sub']] <- bit.convert.str2object(opt$sub) } 

if (!bit.check.is.null(opt$sub.cex)){   paramlist[['sub.cex']] <- bit.convert.str2object(opt$sub.cex) } 


if (!bit.check.is.null(opt$main.cex)){   paramlist[['main.cex']] <- bit.convert.str2object(opt$main.cex) } 


if (!bit.check.is.null(opt$force.unique)){   paramlist[['force.unique']] <- bit.convert.str2object(opt$force.unique) } 

if (!bit.check.is.null(opt$print.mode)){   paramlist[['print.mode']] <- bit.convert.str2object(opt$print.mode) } 

if (!bit.check.is.null(opt$sigdigs)){   paramlist[['sigdigs']] <- bit.convert.str2object(opt$sigdigs) } 

if (!bit.check.is.null(opt$labelSize)){   paramlist[['labelSize']] <- bit.convert.str2object(opt$labelSize) } 

if (!bit.check.is.null(opt$categoryLabelSize)){   paramlist[['categoryLabelSize']] <- bit.convert.str2object(opt$categoryLabelSize) } 

if(!bit.check.is.null(opt$palette)){
  paramlist[['fill']] <- bit.palette_list_generation_function[[bit.convert.str2object(opt$palette)]](length(inputlist))
}


plotname<-"venn"
fullplotname <- paste0(opt$outdir,"/","output_plot_",plotname)



prefix=dirname(opt$outdir)
paramlist[['filename']] <- paste0(fullplotname,".png")
paramlist[['imagetype']] <- "png"
paramlist[['units']] <- "in"

paramlist[['width']] <- bit.convert.str2object(opt$width)
paramlist[['height']] <- bit.convert.str2object(opt$height)
paramlist[['alpha']] <- bit.convert.str2object(opt$transparent)
paramlist[['x']]<-inputlist


# venn.diagram 自带输出png功能
do.call(venn.diagram,paramlist)



paramlist[['imagetype']] <- "svg"
paramlist[['filename']] <- NULL
paramlist[length(paramlist)+1] <- list(NULL)
names(paramlist)[length(paramlist)] <-"filename"


pdf(paste0(fullplotname,".pdf"),width = as.numeric(opt$width),height = as.numeric(opt$height))
grid.draw(do.call(venn.diagram,paramlist))
dev.off()

svg(paste0(fullplotname,".svg"),width = as.numeric(opt$width),height = as.numeric(opt$height))
grid.draw(do.call(venn.diagram,paramlist))
dev.off()





