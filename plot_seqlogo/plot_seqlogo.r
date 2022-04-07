library(ggplot2)
library(optparse)
library(ggseqlogo)

source("/bit/newVersionUnits/utils.r")

#%&% $META$ config_version=0.1 
#%&% $META$ program_type=visualization
#%&% $META$ author=zhengxinchang
#%&% $META$ email=zhengxinchang@big.ac.cn
#%&% $META$ title=SeqLogo
#%&% $META$ description=Sequence logos plot for DNA sequence alignments.
#%&% $META$ cmd=Rscript /bit/newVersionUnits/plot_seqlogo/plot_seqlogo.r 
#%&% $META$ is_submit_to_queue=False
#%&% $META$ ppn=1
#%&% $META$ mem=10
#%&% $META$ reference=https://cran.r-project.org/web/packages/ggseqlogo/index.html
#%&% $META$ reference=https://github.com/omarwagih/ggseqlogo
#%&% $META$ reference=Wagih, Omar. ggseqlogo: a versatile R package for drawing sequence logos. Bioinformatics (2017). https://doi.org/10.1093/bioinformatics/btx469
#%&% $META$ manual=Plots sequence logo as a layer on ggplot


option_list = list(
  
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
  #%&% $OPTION$ default= 8
  #%&% $OPTION$ range=min:0;max:20 
  #%&% $OPTION$ help= width of the canvas
  #%&% $OPTION$ required= true
  #%&% $OPTION$ add_option_in_cmd= true
  #%&% $OPTION$ option=end
  make_option(c("--width"), type="character",default = "NULL"), 
  
  
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
  make_option(c("--height"), type="character",default = "NULL"),
  
  
  #%&% $OPTION$ option=start
  #%&% $OPTION$ name= methods
  #%&% $OPTION$ cmdparam= --method
  #%&% $OPTION$ type= select 
  #%&% $OPTION$ default= bits
  #%&% $OPTION$ range=[{"probability":"probability"}, {"bits":"bits"}]
  #%&% $OPTION$ help= Height method, can be one of "bits" or "probability" (default: "bits")
  #%&% $OPTION$ required= true
  #%&% $OPTION$ add_option_in_cmd= true
  #%&% $OPTION$ option=end
  make_option(c("--method"), type="character",default = "NULL"), 
  
  
  #%&% $OPTION$ option=start
  #%&% $OPTION$ name= sequence type
  #%&% $OPTION$ cmdparam= "--seq_type"
  #%&% $OPTION$ type= select 
  #%&% $OPTION$ default= auto
  #%&% $OPTION$ range=[{"automatic guess":"auto"},{"amino acid":"aa"},{"DNA":"dna"},{"RNA":"rna"}]
  #%&% $OPTION$ help= Sequence type, can be one of "auto", "aa", "dna", "rna" or "other" (default: "auto", sequence type is automatically guessed)
  #%&% $OPTION$ required= true
  #%&% $OPTION$ add_option_in_cmd= true
  #%&% $OPTION$ option=end
  make_option(c("--seq_type"), type="character",default = "NULL"),
  
  
  #%&% $OPTION$ option=start
  #%&% $OPTION$ name= font
  #%&% $OPTION$ cmdparam= --font
  #%&% $OPTION$ type= select 
  #%&% $OPTION$ default= helvetica_regular
  #%&% $OPTION$ range=[{"helvetica regular":"helvetica_regular"}, {"helvetica bold":"helvetica_bold"}, {"helvetica light":"helvetica_light"}, {"roboto medium":"roboto_medium"}, {"roboto bold":"roboto_bold"}, {"roboto regular":"roboto_regular"}, {"akrobat bold":"akrobat_bold"}, {"akrobat regular":"akrobat_regular"}, {"roboto slab_bold":"roboto_slab_bold"}, {"roboto slab_regular":"roboto_slab_regular"}, {"roboto slab_light":"roboto_slab_light"}, {"xkcd regular":"xkcd_regular"}]
  #%&% $OPTION$ help= Name of font.
  #%&% $OPTION$ required= true
  #%&% $OPTION$ add_option_in_cmd= true
  #%&% $OPTION$ option=end
  make_option(c("--font"), type="character",default = "NULL"),
  
  
  #%&% $OPTION$ option=start
  #%&% $OPTION$ name= stack_width
  #%&% $OPTION$ cmdparam= --stack_width
  #%&% $OPTION$ type= number 
  #%&% $OPTION$ default= 0.95
  #%&% $OPTION$ range=min:0;max:1 
  #%&% $OPTION$ help= Width of letter stack between 0 and 1 (
  #%&% $OPTION$ required= true
  #%&% $OPTION$ add_option_in_cmd= true
  #%&% $OPTION$ option=end
  make_option(c("--stack_width"), type="character",default = "NULL"),
  
  
  #%&% $OPTION$ option=start
  #%&% $OPTION$ name= reverse the letter stack
  #%&% $OPTION$ cmdparam= --rev_stack_order
  #%&% $OPTION$ type= select 
  #%&% $OPTION$ default= FALSE
  #%&% $OPTION$ range=[{"TRUE":"TRUE"}, {"FALSE":"FALSE"}]
  #%&% $OPTION$ help= If TRUE, order of letter stack is reversed (default: FALSE)
  #%&% $OPTION$ required= true
  #%&% $OPTION$ add_option_in_cmd= true
  #%&% $OPTION$ option=end
  make_option(c("--rev_stack_order"), type="character",default = "NULL"),
  
  
  #%&% $OPTION$ option=start
  #%&% $OPTION$ name= Color for missing values
  #%&% $OPTION$ cmdparam= --na_col
  #%&% $OPTION$ type= color 
  #%&% $OPTION$ default= grey20
  #%&% $OPTION$ range=None
  #%&% $OPTION$ help= Color for letters missing in color scheme (default: "grey20")
  #%&% $OPTION$ required= true
  #%&% $OPTION$ add_option_in_cmd= true
  #%&% $OPTION$ option=end
  make_option(c("--na_col"), type="character",default = "NULL"), #type=select:0*,15,30,45,60,90
  
  
  #%&% $OPTION$ option=start
  #%&% $OPTION$ name= Color Scheme
  #%&% $OPTION$ cmdparam= --col_scheme
  #%&% $OPTION$ type= select 
  #%&% $OPTION$ default= auto
  #%&% $OPTION$ range=  [{"auto":"auto"}, {"chemistry":"chemistry"}, {"chemistry2":"chemistry2"}, {"hydrophobicity":"hydrophobicity"}, {"nucleotide":"nucleotide"}, {"nucleotide2":"nucleotide2"}, {"base_pairing":"base_pairing"}, {"clustalx":"clustalx"}, {"taylor":"taylor"}]
  #%&% $OPTION$ help= Color scheme applied to the sequence logo.
  #%&% $OPTION$ required= true
  #%&% $OPTION$ add_option_in_cmd= true
  #%&% $OPTION$ option=end
  make_option(c("--col_scheme"), type="character",default = "NULL")
 
)

opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);


dat <- read.table(file = opt$file,header = FALSE)

paramlist = list()

paramlist[["data"]] <- as.vector(dat$V1)
 
if (!bit.check.is.null(opt$method)){ paramlist[['method']] <- bit.convert.str2object(opt$method) } 
if (!bit.check.is.null(opt$seq_type)){ paramlist[['seq_type']] <- bit.convert.str2object(opt$seq_type) } 
if (!bit.check.is.null(opt$font)){ paramlist[['font']] <- bit.convert.str2object(opt$font) } 
if (!bit.check.is.null(opt$stack_width)){ paramlist[['stack_width']] <- bit.convert.str2object(opt$stack_width) } 
if (!bit.check.is.null(opt$rev_stack_order)){ paramlist[['rev_stack_order']] <- bit.convert.str2object(opt$rev_stack_order) } 
if (!bit.check.is.null(opt$na_col)){ paramlist[['na_col']] <- bit.convert.str2object(opt$na_col) } 
if (!bit.check.is.null(opt$col_scheme)){ paramlist[['col_scheme']] <- bit.convert.str2object(opt$col_scheme) } 



objplot <- do.call(ggseqlogo::ggseqlogo,paramlist)


plotname<-"seqlogo"
fullplotname <- paste0(opt$outdir,"/","output_plot_",plotname)

ggsave(objplot,device = "png",filename =paste0(fullplotname,".png"),width =  bit.convert.str2object(opt$width),height =  bit.convert.str2object(opt$height),units = "in",dpi=600)

ggsave(objplot,device = "pdf",filename = paste0(fullplotname,".pdf"),width =  bit.convert.str2object(opt$width),height = bit.convert.str2object(opt$height),units = "in")

ggsave(objplot,device = "svg",filename = paste0(fullplotname,".svg"),width =  bit.convert.str2object(opt$width),height =  bit.convert.str2object(opt$height),units = "in")



