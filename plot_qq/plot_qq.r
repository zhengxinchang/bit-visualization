suppressMessages({
    library(qqman)
    library(optparse)
})




library(ggsci)



bit.check.is.null <- function(x) {
    if (length(x) > 1) {
        return(FALSE)
    }
    if (is.character(x)) {
        
        if (toupper(x) == 'NULL'){
            return (TRUE)
        }else if(toupper(x) == 'NONE'){
            return (TRUE)
        }else{
            return(FALSE)
        }
        
        
    } else{
        return(base::is.null(x))
    }
}



#optparse 传入的所有内容都是字符串类型，在这里统一转换
bit.convert.str2object <-function(s){
    
    suppressWarnings({
        if(class(s)=="character"){
            if(s=="NA"){
                return(NA)
            }else if(toupper(s)=="NULL"){
                return(NULL)
            }else if (toupper(s)=="NONE"){
                return(NULL)
            }else if(toupper(s) == "TRUE"){
                return(TRUE)
            }else if(toupper(s)=="FALSE"){
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
            stop(paste0("Command line parameter",s, "must be a string!"))
        }
        
        
    })
    
}



bit.palette_list_generation_function=list(
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



#%&% $META$ config_version=0.1 
#%&% $META$ program_type=visualization
#%&% $META$ author=zhengxinchang
#%&% $META$ email=zhengxinchang@big.ac.cn
#%&% $META$ title=Pie
#%&% $META$ description=Plot qq plot
#%&% $META$ cmd=/bit/newVersionUnits/plot_qq/plot_qq.r
#%&% $META$ is_submit_to_queue=False
#%&% $META$ ppn=1
#%&% $META$ mem=10
#%&% $META$ manual= The header of input data must be "SNP"	"CHR"	"BP"	and "P"
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
    #%&% $OPTION$ name= line color
    #%&% $OPTION$ cmdparam= --linecolor
    #%&% $OPTION$ type= color 
    #%&% $OPTION$ default= red
    #%&% $OPTION$ range=None
    #%&% $OPTION$ help= help
    #%&% $OPTION$ required= true
    #%&% $OPTION$ add_option_in_cmd= true
    #%&% $OPTION$ option=end
    make_option(c("--linecolor"), type="character",default = "red")
    
    
    
)


opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)




dat <- read.table(opt$file,sep="\t",header=T)

pvals <- dat[,4]

observe_logpvals <- -1 * log10(sort(pvals))
expected_logpvals <- -1 * log10(c(1:length(observe_logpvals))/(length(observe_logpvals)+ 1))


max_y = ceiling(max(observe_logpvals))
max_x = ceiling(max(expected_logpvals))

plotname<-"qq"
fullplotname <- paste0(opt$outdir,"/","output_plot_",plotname)


pdf(paste0(fullplotname,".pdf"),width = as.numeric(opt$width) ,height = as.numeric(opt$height))


plot(
    y=observe_logpvals, 
    x=expected_logpvals,
    ylab="Observed(-logP)",
    xlab="Expected(-logP)",
    ylim=c(0,max_y),
    xlim=c(0,max_x),
    col= opt$linecolor,
    cex=0.5,
    pch=19
    )


line_t = min(max_y,max_x)
lines(x=c(0,line_t),y=c(line_t,line_t),col=1,lwd=1,lty=2)
lines(x=c(0,line_t),y=c(0,line_t),col=1,lwd=2)

dev.off()