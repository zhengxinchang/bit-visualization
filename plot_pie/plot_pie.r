suppressMessages({
    library(optparse)
    library(ggpubr)
})


source("/bit/newVersionUnits/utils.r")


#%&% $META$ config_version=0.1 
#%&% $META$ program_type=visualization
#%&% $META$ author=zhengxinchang
#%&% $META$ email=zhengxinchang@big.ac.cn
#%&% $META$ title=Pie
#%&% $META$ description=Plot pie chart
#%&% $META$ cmd=/bit/newVersionUnits/plot_pie/plot_pie.r
#%&% $META$ is_submit_to_queue=False
#%&% $META$ ppn=1
#%&% $META$ mem=10
#%&% $META$ reference=reference
#%&% $META$ manual=
#%&% $META$ manual=


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
    make_option(c("--width"), type="character",default = "10"), 
    
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
    make_option(c("--height"), type="character",default = "8"),
    
    #%&% $ option=start
    #%&% $ name= output
    #%&% $ cmdparam= --outdir
    #%&% $ type= output
    #%&% $ default= run_output
    #%&% $ result_files=${output}_plot_pie.png|show_in_page:true
    #%&% $ result_files=${output}_plot_pie.svg|show_in_page:false
    #%&% $ result_files=${output}_plot_pie.pdf|show_in_page:false
    #%&% $ option=end
    make_option(c("--outdir"), type = "character", default = "./"),
    
    #%&% $OPTION$ option=start    
    #%&% $OPTION$ name= file
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
    #%&% $OPTION$ name= Label postion
    #%&% $OPTION$ cmdparam= --labpos
    #%&% $OPTION$ type= select 
    #%&% $OPTION$ default= in
    #%&% $OPTION$ range=[{"outside":"out"}, {"inside":"in"}]
    #%&% $OPTION$ help= character specifying the position for labels. 
    #%&% $OPTION$ required= true
    #%&% $OPTION$ add_option_in_cmd= true
    #%&% $OPTION$ option=end
    make_option(c("--labpos"), type="character",default = "NULL"),
    
    #%&% $OPTION$ option=start
    #%&% $OPTION$ name= inside labels adjust
    #%&% $OPTION$ cmdparam= --labadj
    #%&% $OPTION$ type= number 
    #%&% $OPTION$ default= NULL
    #%&% $OPTION$ range=min:-20;max:20 
    #%&% $OPTION$ help= numeric value, used to adjust label position when Label postion is 'inside'
    #%&% $OPTION$ required= true
    #%&% $OPTION$ add_option_in_cmd= true
    #%&% $OPTION$ option=end
    make_option(c("--labadj"), type="character",default = "NULL"),
    
    
    #%&% $OPTION$ option=start
    #%&% $OPTION$ name= label color
    #%&% $OPTION$ cmdparam=  --labcolor
    #%&% $OPTION$ type= color 
    #%&% $OPTION$ default= white
    #%&% $OPTION$ range=None
    #%&% $OPTION$ help= help
    #%&% $OPTION$ required= true
    #%&% $OPTION$ add_option_in_cmd= true
    #%&% $OPTION$ option=end
    make_option(c("--labcolor"), type="character",default = "NULL"),
    
    
    #%&% $OPTION$ option=start
    #%&% $OPTION$ name= line color
    #%&% $OPTION$ cmdparam= --linecolor
    #%&% $OPTION$ type= color 
    #%&% $OPTION$ default= black
    #%&% $OPTION$ range=None
    #%&% $OPTION$ help= help
    #%&% $OPTION$ required= true
    #%&% $OPTION$ add_option_in_cmd= true
    #%&% $OPTION$ option=end
    make_option(c("--linecolor"), type="character",default = "NULL"),
    
    

    
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
    make_option(c("--palette"), type="character",default = "NULL")
    
    

)


opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)


dat <- read.table(file = opt$file,header = TRUE)

paramlist = list()

paramlist[["data"]] <- as.vector(dat)

paramlist[["fill"]] <- "group"

paramlist[["x"]] <- "percent"
paramlist[["label"]] <- paste0(dat$group, " (", dat$percent, "%)")

 
if (!bit.check.is.null(opt$labpos)) {
    paramlist[['lab.pos']] <- bit.convert.str2object(opt$labpos)
    
    if (opt$labpos == "in") {
        if (!bit.check.is.null(opt$labadj)) {
            paramlist[['lab.adjust']] <- bit.convert.str2object(opt$labadj)
        }
    }
}


if(!bit.check.is.null(opt$labcolor)){ paramlist[['lab.font']] <- bit.convert.str2object(opt$labcolor) }
if(!bit.check.is.null(opt$linecolor)){ paramlist[['color']] <- bit.convert.str2object(opt$linecolor) }
if(!bit.check.is.null(opt$palette)){ paramlist[['palette']] <- bit.convert.str2object(opt$palette) }





plotname<-"pie"
fullplotname <- paste0(opt$outdir,"/","output_plot_",plotname)





df <- data.frame(
    group = c("Male", "Female", "Child","Old","Newborn"),
    percent = c(25, 25, 40,5,5))


# write.table(df,"plot_pie/plot_pie.example.txt",col.names = TRUE,quote = F,row.names = F,sep="\t")
# 
# 
# ggpie(df, "percent", label = labs,
#       lab.pos = "out", lab.font = "white",
#       fill = "group", color = "white",
#       lab.adjust=-3,palette='npg') 

#===============

objplot <- do.call(ggpubr::ggpie,paramlist)
ggsave(objplot,device = "png",filename =paste0(fullplotname,".png"),width =  bit.convert.str2object(opt$width),height =  bit.convert.str2object(opt$height),units = "in",dpi=600)

ggsave(objplot,device = "pdf",filename = paste0(fullplotname,".pdf"),width =  bit.convert.str2object(opt$width),height = bit.convert.str2object(opt$height),units = "in")

ggsave(objplot,device = "svg",filename = paste0(fullplotname,".svg"),width =  bit.convert.str2object(opt$width),height =  bit.convert.str2object(opt$height),units = "in")