library(wordcloud)

library(optparse)
library(svglite)
source("/bit/newVersionUnits/utils.r")


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


# 
# wordcloud(w,wf,colors=bit.palette_list_generation_function[['ucscgb']] (length(w)),
#           random.order=FALSE,min.freq=4,max.words = 300,rot.per=0.5,ordered.colors = TRUE)


# 
# 
# library(tm)
# 
# color_palette<-bit.palette_list_generation_function[['aaas']] (6)
# 
# wordcloud::wordcloud("May our children and our children's children to a 
# thousand generations, continue to enjoy the benefits conferred 
# upon us by a united country, and have cause yet to rejoice under 
# those glorious institutions bequeathed us by Washington and his 
# compeers.",colors=color_palette,random.order=FALSE)
# 
# data(SOTU)
# v <- tm_map(z,function(x)removeWords(tolower(x),stopwords()))
# 
# wordcloud(x, colors=brewer.pal(6,"Dark2"),random.order=FALSE,font='微软雅黑')
# 
# 
# 
# pdf("output_plot_wordcloud.pdf")
# wordcloud(as.data.frame(wt)[,1],as.data.frame(wt)[,2],colors=bit.palette_list_generation_function[['ucscgb']] (nrow(wt)),
#           random.order=FALSE,min.freq=4,max.words = 300,rot.per=0.5,ordered.colors = TRUE)
# 
# dev.off()
# 
# length(x)
# 
# 
# x<-c("销售", "文章", "消费", "软件", "信用", "开发", "更多", "http", "一步", "描述", "是否", "最后", "的方法", "认为", "高端", "同的", "存在", "的用户", "评论", "基础", "深度", "的信", "代表", "复杂", "我的", "获得", "也是", "挖掘", "的工", "程中", "纪要", "一定", "主题", "单位", "广州", "们可", "来的", "科学家", "了解", "展示", "随机", "效果", "数学", "线性", "参会", "学的", "报名", "行了", "支持", "有效", "直接",  "在这", "对应", "当时", "的模", "价值", "基本", "新的", "目前", "营销", "论文", "不同的", "交易", "我们可", "指数", "方向", "获取", "记录", "都是", "定的", "每一", "过程中", "们可以", "出现", "学家", "知道", "第二", "策略", "美国", "考虑", "这样的", "业的", "传统", "希望", "的时候", "相对", "程度", "自己的", "说明", "进行了", "采用", "应的", "时代", "社交网", "网站", "这是", "人员", "在一", "届中国", "的预", "目标", "交网络", "是不", "服务", "的应", "者的", "觉得", "评价", "变化", "建立", "们可以 ", "更加", "的应用", "的模型", "看到", "风险", "应该", "的结", "知识", "竞争", "结合", "贝叶斯", "产生", "帮助", "测试", "理解", "组织", "经济", "他的", "具有", "出了", "容易", "成为", "用于", "准确", "的一个", "能力", "趋势", "银行", "性的", "的基", "商业", "讨论", "一下", "世界", "之间的", "人的", "包含", "数的", "最大", "系数", "是在", "里面", "专业", "成本", "计算机", "财经", "驾驶", "一次", "了一个", "工程", "我们的", "理论", "生成", "的信息", "的重", "研究中", "简历", "项目", "三个", "上海", "也可")
# y <- sample(x,100,replace=T)
# z<-SOTU[["1"]][["content"]]
# 
# w <- sample(LETTERS,100,replace = T)
# wf <- sample(1:39,100,replace = T)
# 
# wt <- table(w)

#write.table(y,"./plot_wordcloud/plot_wordcloud.example.txt",sep = "\t",row.names = F,col.names = F,quote = F)
# dat_freq<- as.data.frame(table(dat))
#write.table(dat_freq,"./plot_wordcloud/plot_wordcloud.example.freq.txt",sep = "\t",row.names = F,col.names = F,quote = F)