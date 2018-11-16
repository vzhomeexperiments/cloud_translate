# this is a translation function for vtt files
# note: this function is accessible using R package translateVTT 
# installing my R package from github
# devtools::install_github("vzhomeexperiments/translateVTT")
# (C) 2017 Vladimir Zhbanko

translateVTT <- function(fileName, sourceLang = "en", destLang, apikey, fileEnc = "UTF-8"){
  # PURPOSE: Translate *.vtt files from any language to any language using Google API key
  # Note: Google Tranlation with API is paid service, however 300USD is given for free for 12 month
  # variables for debugging
  # fileName <- "TEST_DATA/L0.vtt"
  # sourceLang <- "en"
  # destLang <- "de"
  # apikey <- 
  
  require(stringr)
  require(tidyverse)
  require(translateR)
  
  # read file -> it will be a dataframe
  t <- read.delim(fileName, stringsAsFactors = F)
  
  # extract logical vector indicating which rows containing timestamps
  x <- t %>% 
    # detect rows with date time (those for not translate)
    apply(MARGIN = 1, str_detect, pattern = "-->")
  
  # extract only rows containing text (e.g. not containing timestamps) 
  txt <- subset.data.frame(t, !x) 
  # extract only time stamps
  tst <- subset.data.frame(t,  x)
  
  
  ## translate this file using translate API paid service in Google
  
  # translate object txt or file in R
  # Google, translate column in dataset
  google.dataset.out <- translate(dataset = txt,
                                  content.field = 'WEBVTT',
                                  google.api.key = apikey,
                                  source.lang = sourceLang,
                                  target.lang = destLang)
  
  # extract only new column
  trsltd <- google.dataset.out %>% select(translatedContent)
  
  # give original name
  colnames(trsltd) <- "WEBVTT"
  
  
  # bind rows with original timestamps
  abc <- rbind(tst, trsltd)
  
  # order this file back again
  bcd <-  abc[ order(as.numeric(row.names(abc))), ] %>% as.character %>% as.data.frame()
  
  # return original name
  colnames(bcd) <- "WEBVTT"
  
  # adding one row in the beginning
  bcd <- as.tibble(bcd)
  # add one row
  bcd2 <- add_row(bcd, WEBVTT  = "", .before = 1)
  
  # write this file back :_)
  #fileName <- "C:/Users/fxtrams/Downloads/L1.vtt"
  #destLang <- "de"
  write.table(bcd2, paste0(fileName, destLang, ".vtt"), quote = F, row.names = F,fileEncoding = fileEnc)
  
}

