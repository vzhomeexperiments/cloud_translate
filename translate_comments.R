# translate csv file with comments on each lines
# language is different on each row
# all rows must be translated to english
# if the comment line was in english it has to be added as is

# libraries
library(tidyverse)
library(openssl)
library(translateR) #install.packages("translate")
library(translate)
# read sample file
df_comments <- read_csv("TEST_DATA/comments.csv", col_names = F)

# get back our encrypted API key
out <- read_rds("api_key.enc.rds")
# path to our key
path_private_key <- file.path("C:/Users/fxtrams/.ssh", "id_api")
api_key <- decrypt_envelope(out$data, out$iv, out$session, path_private_key, password = "") %>% 
  unserialize()

#languages(key = api_key) # to check supported languages

# for loop
# apply for loop for each row
for(i in 1:nrow(df_comments)){
  # i <- 1 #english
  # i <- 2 #italian
  # i <- 8 #language un defined
  
  # put our row into the vector
  vec_row <- df_comments[i, 1]
  
  # inside for loop you must detect language, note: 'und' will be returned in case google can't determine language
  language_detected <- translate::detect.source(vec_row, api_key)
  lang_srs <- language_detected[[1]]
  
  # ... or skip translation if the detected language is already English...
  if(lang_srs == "en") { 
    # create new result dataframe or aggregate if it exists
    # use 'aggregation' of your data inside of the for loop
    if(!exists("df_res")){
      # create new data frame
      df_res <- vec_row %>% mutate(X2 = lang_srs)
      
      } else {
       # add new row without translation 
       df_res <- vec_row %>% mutate(X2 = lang_srs) %>% bind_rows(df_res)
     }
  
  } else if(lang_srs == "und")  {
    
    # language is not defined 
    next # go to the next row
    
  } else {
    # # translate the current row with package translateR
    # google.dataset.out <- translateR::translate(dataset = vec_row,
    #                                             content.field = 'X1',
    #                                             google.api.key = api_key,
    #                                             source.lang = lang_srs,
    #                                             target.lang = 'en')
    # 
    # # get translated column
    # transl_vec <- google.dataset.out %>% select(translatedContent)
    # 
    # # rename it
    # colnames(transl_vec) <- "X1"
    
    # # translate the current row with package translate
     translated_row <- translate::translate(query = vec_row,
                                            source = lang_srs,
                                            target = "en",
                                            key = api_key)

     # get vector from this list
     transl_vec <- translated_row[[1]] %>% as.data.frame() %>% mutate_at(".", as.character)
     names(transl_vec) <- "X1" # rename it
    
    # use 'aggregation' of your data inside of the for loop
    if(!exists("df_res")){

      # create new data frame using translated character
      df_res <- transl_vec %>% mutate(X2 = lang_srs)


      } else {
      df_res <- transl_vec %>% mutate(X2 = lang_srs) %>% bind_rows(df_res)
    }
    
  }
}
# write translated result to the file
write_csv(df_res, "translated.csv")

