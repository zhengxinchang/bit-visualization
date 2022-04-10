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


