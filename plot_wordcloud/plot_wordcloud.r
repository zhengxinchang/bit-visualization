library(wordcloud)

library(optparse)
library(svglite)

# source("/bit/newVersionUnits/utils.r")


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
#%&% $META$ title=wordcloud
#%&% $META$ description=Functionality to create pretty word clouds
#%&% $META$ cmd=/bit/newVersionUnits/plot_wordcloud/plot_wordcloud.r
#%&% $META$ is_submit_to_queue=False
#%&% $META$ ppn=1
#%&% $META$ mem=10
#%&% $META$ reference=https://cran.r-project.org/web/packages/wordcloud/wordcloud.pdf
#%&% $META$ reference=http://blog.fellstat.com/?cat=11
#%&% $META$ reference=https://cran.r-project.org/web/packages/wordcloud/
#%&% $META$ manual= Due to the limiation of the 'wordcloud' package, only english letters are supported.



option_list = list(
  
  #%&% $OPTION$ option=start  
  #%&% $OPTION$ name= File
  #%&% $OPTION$ cmdparam= --file
  #%&% $OPTION$ type=file_textarea 
  #%&% $OPTION$ range= null
  #%&% $OPTION$ default= 
  #%&% $OPTION$ help=datasets
  #%&% $OPTION$ required= true
  #%&% $OPTION$ add_option_in_cmd= true
  #%&% $OPTION$ option=end
  make_option(c("--file"), type="character",default = "NULL"), 
  
  
  
  
  #%&% $OPTION$ option=start
  #%&% $OPTION$ name= output
  #%&% $OPTION$ cmdparam= --outdir
  #%&% $OPTION$ type= output
  #%&% $OPTION$ default= None
  #%&% $OPTION$ result_files=${output}_plot_seqlogo.png|show_in_page:true
  #%&% $OPTION$ result_files=${output}_plot_seqlogo.svg|show_in_page:false
  #%&% $OPTION$ result_files=${output}_plot_seqlogo.pdf|show_in_page:false
  #%&% $OPTION$ option=end
  make_option(c("--outdir"), type="character",default = "NULL"),
  
  
  #%&% $OPTION$ option=start
  #%&% $OPTION$ name= width
  #%&% $OPTION$ cmdparam= --width
  #%&% $OPTION$ type= number 
  #%&% $OPTION$ default= 6
  #%&% $OPTION$ range=min:0;max:20 
  #%&% $OPTION$ help= width of the canvas
  #%&% $OPTION$ required= true
  #%&% $OPTION$ add_option_in_cmd= true
  #%&% $OPTION$ option=end
  make_option(c("--width"), type="character",default = "6"), 
  
  
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
  #%&% $OPTION$ name= words random order
  #%&% $OPTION$ cmdparam= --random.order
  #%&% $OPTION$ type= select 
  #%&% $OPTION$ default= FALSE
  #%&% $OPTION$ range=[{"TRUE":"TRUE"}, {"FALSE":"FALSE"}]
  #%&% $OPTION$ help= If TRUE the biggest words will be plotted randomly
  #%&% $OPTION$ required= true
  #%&% $OPTION$ add_option_in_cmd= true
  #%&% $OPTION$ option=end
  make_option(c("--random.order"), type="character",default = "NULL"),
  
  
  #%&% $OPTION$ option=start
  #%&% $OPTION$ name= minimal frequency
  #%&% $OPTION$ cmdparam= --min.freq
  #%&% $OPTION$ type= number 
  #%&% $OPTION$ default= 3
  #%&% $OPTION$ range=min:0;max:inf
  #%&% $OPTION$ help= words with frequency below the threshold will not be plotted
  #%&% $OPTION$ required= true
  #%&% $OPTION$ add_option_in_cmd= true
  #%&% $OPTION$ option=end
  make_option(c("--min.freq"), type="character",default = "NULL"),
  
  #%&% $OPTION$ option=start
  #%&% $OPTION$ name= rotate percent
  #%&% $OPTION$ cmdparam= --rot.per
  #%&% $OPTION$ type= number 
  #%&% $OPTION$ default= 0.1
  #%&% $OPTION$ range=min:0;max:1
  #%&% $OPTION$ help= proportion words with 90 degree rotation
  #%&% $OPTION$ required= true
  #%&% $OPTION$ add_option_in_cmd= true
  #%&% $OPTION$ option=end
  make_option(c("--rot.per"), type="character",default = "NULL"),
  
  #%&% $OPTION$ option=start
  #%&% $OPTION$ name= max words cutoff
  #%&% $OPTION$ cmdparam= --max.words
  #%&% $OPTION$ type= number 
  #%&% $OPTION$ default= Inf
  #%&% $OPTION$ range=min:0;max: inf
  #%&% $OPTION$ help= Maximum number of words to be plotted. least frequent terms dropped
  #%&% $OPTION$ required= true
  #%&% $OPTION$ add_option_in_cmd= true
  #%&% $OPTION$ option=end
  make_option(c("--max.words"), type="character",default = "NULL")
  
  
  )




opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);


dat <- read.table(file = opt$file,header = FALSE)

if (ncol(dat) ==1){
  datfreq <- as.data.frame(table(dat))
}else if (ncol(dat)==2){
  datfreq <- dat
}else{
  stop("Input file format error!")
}

paramlist = list()


paramlist[["words"]] <-datfreq[,1]
paramlist[["freq"]] <-datfreq[,2]


if (!bit.check.is.null(opt$palette)){ paramlist[['colors']] <-   bit.palette_list_generation_function[[ bit.convert.str2object(opt$palette)]] (nrow(datfreq))      } 
if (!bit.check.is.null(opt$random.order)){ paramlist[['random.order']] <- bit.convert.str2object(opt$random.order) } 
if (!bit.check.is.null(opt$min.freq)){ paramlist[['min.freq']] <- bit.convert.str2object(opt$min.freq) } 
if (!bit.check.is.null(opt$rot.per)){ paramlist[['rot.per']] <- bit.convert.str2object(opt$rot.per) } 
if (!bit.check.is.null(opt$max.words)){ paramlist[['max.words']] <- bit.convert.str2object(opt$max.words) } 

# print(paramlist)paramlist


plotname<-"wordcloud"
fullplotname <- paste0(opt$outdir,"/","output_plot_",plotname)


pdf(paste0(fullplotname,".pdf"),width = as.numeric(opt$width) ,height = as.numeric(opt$height))
do.call(wordcloud::wordcloud,paramlist)
dev.off()

svg(paste0(fullplotname,".svg"),width = as.numeric(opt$width) ,height = as.numeric(opt$height))
do.call(wordcloud::wordcloud,paramlist)
dev.off()

png(paste0(fullplotname,".png"),width = as.numeric(opt$width) ,height = as.numeric(opt$height), units = "in" ,res=600)
do.call(wordcloud::wordcloud,paramlist)
dev.off()

