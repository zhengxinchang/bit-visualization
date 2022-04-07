

#%&% $META$ config_version=0.1 
#%&% $META$ program_type=visualization
#%&% $META$ author=zhangsan
#%&% $META$ email=zhangsan@big.ac.cn
#%&% $META$ title=Test Program
#%&% $META$ description=aaaaa
#%&% $META$ cmd="/xtdisk/baoym_group/zhengxcngdc/softwares/miniconda3/envs/R36/bin/Rscript  /xtdisk/baoym_group/zhengxcngdc/projects/biocloud/units/plot_heatmap/plot_heatmap.r"
#%&% $META$ is_submit_to_queue=T
#%&% $META$ ppn=1
#%&% $META$ mem=10
#%&% $META$ reference=ccc
#%&% $META$ reference=ddd
#%&% $META$ manual=
#%&% $META$ manual=xz
#%&% $META$ manual=xxx
#%&% $META$ manual=fff
#%&% $META$ manual=ddd
#%&% $META$ manual=
#%&% $META$ manual=
#%&% $META$ manual=df





option_list = list(

#%&% $OPTION$ option=start
#%&% $OPTION$ name= "File"
#%&% $OPTION$ cmdparam= "--file"
#%&% $OPTION$ type=file_textarea 
#%&% $OPTION$ range= null
#%&% $OPTION$ default= null
#%&% $OPTION$ help=""
#%&% $OPTION$ required= true
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end

#%&% $OPTION$ option=start
#%&% $OPTION$ name= Gene type
#%&% $OPTION$ cmdparam= --gene_type
#%&% $OPTION$ type= select 
#%&% $OPTION$ default= OptionA,
#%&% $OPTION$ range=OptionA:a;OptionB:b;OptionC:c 
#%&% $OPTION$ help=
#%&% $OPTION$ required= false
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end

#%&% $OPTION$ option=start
#%&% $OPTION$ name= Gene type
#%&% $OPTION$ cmdparam= --gene_type
#%&% $OPTION$ type= number 
#%&% $OPTION$ default= 0.1,
#%&% $OPTION$ range=min:0;max:1 
#%&% $OPTION$ help=
#%&% $OPTION$ required= false
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end



#%&% $OPTION$ option=start
#%&% $OPTION$ name= out
#%&% $OPTION$ cmdparam= --outname
#%&% $OPTION$ type= output, 
#%&% $OPTION$ default= run_output
#%&% $OPTION$ result_files=${output}_plot_bar.png|show_in_page=true
#%&% $OPTION$ result_files=${output}_plot_bar.svg|show_in_page=false
#%&% $OPTION$ result_files=${output}_plot_bar.pdf|show_in_page=false
#%&% $OPTION$ option=end


#%&% $OPTION$ option=start
#%&% $OPTION$ name= File
#%&% $OPTION$ cmdparam= --file
#%&% $OPTION$ type= file_textarea
#%&% $OPTION$ range= null
#%&% $OPTION$ default= null
#%&% $OPTION$ help=
#%&% $OPTION$ required= true
#%&% $OPTION$ add_option_in_cmd= true
#%&% $OPTION$ option=end


  make_option(c("--file"), type="character", default="/xtdisk/baoym_group/zhengxcngdc/projects/biocloud/units/plot_dot/example_input_bar.txt",help="Dataset file name", metavar="file"), #type=file

#%&% $OPTION$ option=start
#%&% $OPTION$ name= "out",
#%&% $OPTION$ cmdparam= "--outname",
#%&% $OPTION$ type= output
#%&% $OPTION$ default= run_output,
#%&% $OPTION$ result_files=${output}_plot_bar.png|show_in_page:true
#%&% $OPTION$ result_files=${output}_plot_bar.svg|show_in_page:false
#%&% $OPTION$ result_files=${output}_plot_bar.pdf|show_in_page:false
#%&% $OPTION$ option=end
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


