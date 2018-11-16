# translate csv file with comments on each lines
# language is different on each row
# all rows must be translated to english
# if the comment line was in english it has to be added as is

# library
library(tidyverse)

# read sample file
df_comments <- read_csv("TEST_DATA/comments.csv", col_names = F)

# get back our encrypted API key
out <- read_rds("api_key.enc.rds")
# path to our key
path_private_key <- file.path("C:/Users/fxtrams/.ssh", "id_api")
api_key <- decrypt_envelope(out$data, out$iv, out$session, path_private_key, password = "") %>% 
  unserialize()

# 
#install.packages("translate")
library(translate)

# for loop
# apply for loop for each row
for(i in 1:nrow(df_comments)){
  # i <- 2
  
  # put our row into the vector
  vec_row <- df_comments[i, 1]
  
  # inside for loop you must detect language
  language_detected <- detect.source(vec_row, api_key)
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
  
  } else {
    # translate the current row
    translated_row <- translate(query = vec_row,
                                source = lang_srs,
                                target = "en",
                                key = api_key)
    # get vector from this list
    transl_vec <- translated_row[[1]] %>% as.data.frame()
    names(transl_vec) <- "X1"
    
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

