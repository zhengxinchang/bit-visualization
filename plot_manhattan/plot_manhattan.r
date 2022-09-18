
suppressMessages({
    library(optparse)
    library(svglite)
    library(qqman)
})

#source("/bit/newVersionUnits/utils.r")



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
#%&% $META$ title=Manhattan
#%&% $META$ description=Plot Manhattan
#%&% $META$ cmd=/bit/newVersionUnits/plot_manhattan/plot_manhattan.r
#%&% $META$ is_submit_to_queue=False
#%&% $META$ ppn=1
#%&% $META$ mem=10
#%&% $META$ reference=https://cran.r-project.org/web/packages/qqman/vignettes/qqman.html
#%&% $META$ reference=https://cran.r-project.org/web/packages/qqman/index.html
#%&% $META$ reference=Turner, (2018). qqman: an R package for visualizing GWAS results using Q-Q and manhattan plots. Journal of Open Source Software, 3(25), 731, https://doi.org/10.21105/joss.00731.
#%&% $META$ manual=



option_list = list(
    
    #%&% $OPTION$ option=start
    #%&% $OPTION$ name= width
    #%&% $OPTION$ cmdparam= --width
    #%&% $OPTION$ type= number
    #%&% $OPTION$ default= 10
    #%&% $OPTION$ range=min:0;max:20
    #%&% $OPTION$ help= width of the canvas
    #%&% $OPTION$ required= true
    #%&% $OPTION$ add_option_in_cmd= true
    #%&% $OPTION$ option=end
    make_option(c("--width"), type = "character", default = "10"),
    
    
    #%&% $OPTION$ option=start
    #%&% $OPTION$ name= height
    #%&% $OPTION$ cmdparam= --height
    #%&% $OPTION$ type= number
    #%&% $OPTION$ default= 6
    #%&% $OPTION$ range=min:0;max:12
    #%&% $OPTION$ help= height of the canvas
    #%&% $OPTION$ required= true
    #%&% $OPTION$ add_option_in_cmd= true
    #%&% $OPTION$ option=end
    make_option(c("--height"), type = "character", default = "6"),
    
    
    
    
    
    #%&% $OPTION$ option=start
    #%&% $OPTION$ name= output
    #%&% $OPTION$ cmdparam= --outdir
    #%&% $OPTION$ type= output
    #%&% $OPTION$ default= run_output
    #%&% $OPTION$ result_files=${output}_plot_manhattan.png|show_in_page:true
    #%&% $OPTION$ result_files=${output}_plot_manhattan.svg|show_in_page:false
    #%&% $OPTION$ result_files=${output}_plot_manhattan.pdf|show_in_page:false
    #%&% $OPTION$ option=end
    make_option(c("--outdir"), type = "character", default = "./"),
    
    
    
    #%&% $OPTION$ option=start
    #%&% $OPTION$ name= ylabel
    #%&% $OPTION$ cmdparam= --ylab
    #%&% $OPTION$ type= string
    #%&% $OPTION$ default= None
    #%&% $OPTION$ range=None
    #%&% $OPTION$ help= label of y axis.
    #%&% $OPTION$ required= true
    #%&% $OPTION$ add_option_in_cmd= true
    #%&% $OPTION$ option=end
    make_option(c("--ylab"), type = "character", default = "NULL"),
    
    
    
    #%&% $OPTION$ option=start
    #%&% $OPTION$ name= xlabel
    #%&% $OPTION$ cmdparam= --xlab
    #%&% $OPTION$ type= string
    #%&% $OPTION$ default= None
    #%&% $OPTION$ range=None
    #%&% $OPTION$ help= label of x axis.
    #%&% $OPTION$ required= true
    #%&% $OPTION$ add_option_in_cmd= true
    #%&% $OPTION$ option=end
    make_option(c("--xlab"), type = "character", default = "NULL"),
    
    
    
    
    #%&% $OPTION$ option=start
    #%&% $OPTION$ name= SNP file
    #%&% $OPTION$ cmdparam= --snpfile
    #%&% $OPTION$ type=file_textarea
    #%&% $OPTION$ range= null
    #%&% $OPTION$ default= plot_manhattan.example.snp.txt
    #%&% $OPTION$ help=snp data, a table with columns "BP," "CHR," "P," and optionally, "SNP." If you have X, Y, or MT chromosomes, be sure to renumber these 23, 24, 25, etc.
    #%&% $OPTION$ required= true
    #%&% $OPTION$ add_option_in_cmd= true
    #%&% $OPTION$ option=end
    make_option(c("--snpfile"), type = "character", default = "NULL"),
    
    
    #%&% $OPTION$ option=start
    #%&% $OPTION$ name= chr name file
    #%&% $OPTION$ cmdparam= --chrnamefile
    #%&% $OPTION$ type=file_textarea
    #%&% $OPTION$ range= null
    #%&% $OPTION$ default=  plot_manhattan.example.chrname.txt
    #%&% $OPTION$ help=A character vector equal to the number of chromosomes specifying the chromosome labels (e.g., c(1:22, "X", "Y", "MT")).
    #%&% $OPTION$ required= true
    #%&% $OPTION$ add_option_in_cmd= true
    #%&% $OPTION$ option=end
    make_option(c("--chrnamefile"), type = "character", default = "NULL"),
    
    
    #%&% $OPTION$ option=start
    #%&% $OPTION$ name= highlight snp file
    #%&% $OPTION$ cmdparam= --highlightfile
    #%&% $OPTION$ type=file_textarea
    #%&% $OPTION$ range= null
    #%&% $OPTION$ default= plot_manhattan.example.highlight.txt
    #%&% $OPTION$ help=A character vector of SNPs in your dataset to highlight. These SNPs should all be in your dataset.
    #%&% $OPTION$ required= true
    #%&% $OPTION$ add_option_in_cmd= true
    #%&% $OPTION$ option=end
    make_option(c("--highlightfile"), type = "character", default = "NULL"),
    
    
    #%&% $OPTION$ option=start
    #%&% $OPTION$ name= Main title
    #%&% $OPTION$ cmdparam= --main
    #%&% $OPTION$ type= string
    #%&% $OPTION$ default= None
    #%&% $OPTION$ range=None
    #%&% $OPTION$ help= Main title of the plot
    #%&% $OPTION$ required= true
    #%&% $OPTION$ add_option_in_cmd= true
    #%&% $OPTION$ option=end
    make_option(c("--main"), type = "character", default = "NULL"),
    
    
    #%&% $OPTION$ option=start
    #%&% $OPTION$ name= colorA
    #%&% $OPTION$ cmdparam= --colora
    #%&% $OPTION$ type= color
    #%&% $OPTION$ default= blue4
    #%&% $OPTION$ range=None
    #%&% $OPTION$ help= One of color in manhattan plot. if specified, program will ignore the palette paramter. this paramter must co-occur with colorB.
    #%&% $OPTION$ required= true
    #%&% $OPTION$ add_option_in_cmd= true
    #%&% $OPTION$ option=end
    
    make_option(c("--colora"), type = "character", default = "NULL"),
    
    
    
    #%&% $OPTION$ option=start
    #%&% $OPTION$ name= colorB
    #%&% $OPTION$ cmdparam= --colorb
    #%&% $OPTION$ type= color
    #%&% $OPTION$ default= orange3
    #%&% $OPTION$ range=None
    #%&% $OPTION$ help= One of color in manhattan plot. if specified, program will ignore the palette paramter. this paramter must co-occur with colorA.
    #%&% $OPTION$ required= true
    #%&% $OPTION$ add_option_in_cmd= true
    #%&% $OPTION$ option=end
    make_option(c("--colorb"), type = "character", default = "NULL"),
    
    
    
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
    make_option(c("--palette"), type = "character", default = "NULL"),
    
    
    
    #%&% $OPTION$ option=start
    #%&% $OPTION$ name= logp
    #%&% $OPTION$ cmdparam= --logp
    #%&% $OPTION$ type= select
    #%&% $OPTION$ default= TRUE
    #%&% $OPTION$ range=[{"TRUE":"TRUE"}, {"FALSE":"FALSE"}]
    #%&% $OPTION$ help= If TRUE, the -log10 of the p-value is plotted. It isn't very useful to plot raw p-values, but plotting the raw value could be useful for other genome-wide plots, for example, peak heights, bayes factors, test statistics, other "scores," etc.
    #%&% $OPTION$ required= true
    #%&% $OPTION$ add_option_in_cmd= true
    #%&% $OPTION$ option=end
    make_option(c("--logp"), type = "character", default = "NULL"),
    
    
    
    #%&% $OPTION$ option=start
    #%&% $OPTION$ name= annotate top snp
    #%&% $OPTION$ cmdparam= --annotop
    #%&% $OPTION$ type= select
    #%&% $OPTION$ default= FALSE
    #%&% $OPTION$ range=[{"TRUE":"TRUE"}, {"FALSE":"FALSE"}]
    #%&% $OPTION$ help= If TRUE, only annotates the top hit on each chromosome that is below the annotatePval threshold (or above if logp is FALSE). Note that this parameter will only working when annotate pvalue is provided.
    #%&% $OPTION$ required= true
    #%&% $OPTION$ add_option_in_cmd= true
    #%&% $OPTION$ option=end
    make_option(c("--annotop"), type = "character", default = "NULL"),
    
    
    
    #%&% $OPTION$ option=start
    #%&% $OPTION$ name= annotate p-cutoff
    #%&% $OPTION$ cmdparam= --annopval
    #%&% $OPTION$ type= number
    #%&% $OPTION$ default= None
    #%&% $OPTION$ range=min:0;max:1
    #%&% $OPTION$ help= If set, SNPs below this p-value will be annotated on the plot. If logp is FALSE, SNPs above the specified value will be annotated.
    #%&% $OPTION$ required= true
    #%&% $OPTION$ add_option_in_cmd= true
    #%&% $OPTION$ option=end
    make_option(c("--annopval"), type = "character", default = "NULL"),
    
    
    #%&% $OPTION$ option=start
    #%&% $OPTION$ name= suggestive line
    #%&% $OPTION$ cmdparam= --suggestiveline
    #%&% $OPTION$ type= number
    #%&% $OPTION$ default= NULL
    #%&% $OPTION$ range=min:0;max:100
    #%&% $OPTION$ help= Where to draw a "suggestive" line. Value will be plot directly. Set NULL to disable.
    #%&% $OPTION$ required= true
    #%&% $OPTION$ add_option_in_cmd= true
    #%&% $OPTION$ option=end
    make_option(c("--suggestiveline"), type = "character", default = "NULL"),
    
    #%&% $OPTION$ option=start
    #%&% $OPTION$ name= genomewide line
    #%&% $OPTION$ cmdparam= --genomewideline
    #%&% $OPTION$ type= number
    #%&% $OPTION$ default= NULL
    #%&% $OPTION$ range=min:0;max:100
    #%&% $OPTION$ help= Where to draw a "genome-wide sigificant" line. Value will be plot directly. Set NULL to disable.
    #%&% $OPTION$ required= true
    #%&% $OPTION$ add_option_in_cmd= true
    #%&% $OPTION$ option=end
    make_option(c("--genomewideline"), type = "character", default = "NULL"),
    
    
    
    #%&% $OPTION$ option=start
    #%&% $OPTION$ name= y max
    #%&% $OPTION$ cmdparam= ymax
    #%&% $OPTION$ type= number
    #%&% $OPTION$ default= None
    #%&% $OPTION$ range=min:0;max: 100
    #%&% $OPTION$ help= max value of the y axis
    #%&% $OPTION$ required= true
    #%&% $OPTION$ add_option_in_cmd= true
    #%&% $OPTION$ option=end
    make_option(c("--ymax"), type = "character", default = "NULL"),
    
    
    
    #%&% $OPTION$ option=start
    #%&% $OPTION$ name= x label rotate
    #%&% $OPTION$ cmdparam= --xrotate
    #%&% $OPTION$ type= select
    #%&% $OPTION$ default= "0"
    #%&% $OPTION$ range=[{"always parallel to the axis":"0"}, {"always horizontal":1"}, {"always perpendicular to the axis",":"2"}, {"always vertical",":"3"}]
    #%&% $OPTION$ help= Set another value if the x labels were ommited.
    #%&% $OPTION$ required= true
    #%&% $OPTION$ add_option_in_cmd= true
    #%&% $OPTION$ option=end
    make_option(c("--xrotate"), type = "character", default = "NULL")
    
    
    
)


opt_parser = OptionParser(option_list = option_list)

opt = parse_args(opt_parser)


paramlist = list()


datsnp <- read.table(file = opt$snpfile,
                     header = TRUE,
                     sep = "\t")

paramlist[["x"]] <- datsnp


# add chr name file
if (!bit.check.is.null(opt$chrnamefile)) {
    datchrnamefile <-
        read.table(file = opt$chrnamefile,
                   header = FALSE,
                   sep = "\t")
    if (length(unique(datsnp$CHR)) ==  nrow(datchrnamefile)) {
        paramlist[['chrlabs']] <- as.character(datchrnamefile[, 1])
    } else{
        stop("chr name vector must have same length to chrs in snp file! ")
    }
}


# add highlights snp
if (!bit.check.is.null(opt$highlightfile)) {
    dathighlightfile <-
        read.table(file = opt$highlightfile,
                   header = FALSE,
                   sep = "\t")
    if (FALSE %in% (as.character(dathighlightfile[, 1]) %in% as.character(unique(datsnp$SNP)))) {
        stop("highlight snp not present in snp file!")
    } else{
        paramlist[['highlight']] <- as.character(dathighlightfile[, 1])
    }
}



if (!bit.check.is.null(opt$main)) {
    paramlist[['main']] <- bit.convert.str2object(opt$main)
}

if (!bit.check.is.null(opt$xlab)) {
    paramlist[['xlab']] <- bit.convert.str2object(opt$xlab)
}

if (!bit.check.is.null(opt$ylab)) {
    paramlist[['ylab']] <- bit.convert.str2object(opt$ylab)
}

if (!bit.check.is.null(opt$logp)) {
    paramlist[['logp']] <- bit.convert.str2object(opt$logp)
}

if (!bit.check.is.null(opt$annotop)) {
    paramlist[['annotateTop']] <- bit.convert.str2object(opt$annotop)
}

if (!bit.check.is.null(opt$annopval)) {
    paramlist[['annotatePval']] <-
        bit.convert.str2object(opt$annopval)
}
if (!bit.check.is.null(opt$xrotate)) {
    paramlist[['las']] <-
        bit.convert.str2object(opt$xrotate)
}

if (!bit.check.is.null(opt$ymax)) {
    paramlist[['ylim']] <- c(0,
                             bit.convert.str2object(opt$ymax))
}

if (!bit.check.is.null(opt$suggestiveline)) {
    paramlist[['suggestiveline']] <-
        bit.convert.str2object(opt$suggestiveline)
} else{
    paramlist[['suggestiveline']] <- FALSE
    
}
if (!bit.check.is.null(opt$genomewideline)) {
    paramlist[['genomewideline']] <-
        bit.convert.str2object(opt$genomewideline)
} else{
    paramlist[['genomewideline']] <- FALSE
    
}

# deal with color

if ((!bit.check.is.null(opt$colora)) &&
    (!bit.check.is.null(opt$colorb))) {
    print("color A and color B are provided")
    paramlist[['col']] <-
        c(bit.convert.str2object(opt$colora),
          bit.convert.str2object(opt$colorb))
    
    
} else{
    if (!bit.check.is.null(opt$palette)) {
        this_palette <-
            bit.palette_list_generation_function[[opt$palette]](length(unique(datsnp$CHR)))
        
        paramlist[['col']] <- this_palette
    }
    
}



plotname <- "manhattan"
fullplotname <- paste0(opt$outdir, "/", "output_plot_", plotname)


head(paramlist[["x"]])

paramlist[['suggestiveline']]

#===============
pdf(
    paste0(fullplotname, ".pdf"),
    width = as.numeric(opt$width) ,
    height = as.numeric(opt$height)
)
do.call(qqman::manhattan, paramlist)
dev.off()

svg(
    paste0(fullplotname, ".svg"),
    width = as.numeric(opt$width) ,
    height = as.numeric(opt$height)
)
do.call(qqman::manhattan, paramlist)
dev.off()

png(
    paste0(fullplotname, ".png"),
    width = as.numeric(opt$width) ,
    height = as.numeric(opt$height),
    units = "in" ,
    res = 600
)
do.call(qqman::manhattan, paramlist)
dev.off()
