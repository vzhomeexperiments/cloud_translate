# translating into chinese or russian

library(translateVTT)


# https://stackoverflow.com/questions/18789330/r-on-windows-character-encoding-hell

translateVTT("L0.vtt", destLang = "zh-CN", apikey = k)
library(translateR)
getGoogleLanguages()

ret <- translate(content.vec = "This is my text",google.api.key = k,source.lang = "en", target.lang = "zh-CN")



# load library
library(translateR)

# return chinese tranlation
result_chinese <- translate(content.vec = "This is my Text",
                            google.api.key = api_key,
                            source.lang = "en",
                            target.lang = "zh-CN")

print(result_chinese)

# writing
write.table(result_chinese, "translation.txt")




iconv(x = "<U+8FD9>", from = "windows-1252", to = "UTF-8")


txt <- ret
rty <- file("test.txt",encoding="UTF-8")
writeLines(text = txt, con=rty, useBytes = T)
close(rty)
rty <- file("test.txt",encoding="UTF-8")
inp <- scan(rty,what=character())
#Read 1 item
close(rty)
inp

### BRUTEFORCE Solution!
# writing all encodings to vector
encodings <- iconvlist()
# prepare vector for results (never grow vector in R)
resultings <- vector(mode = "character", length = length(encodings))

# run the for loop to write all outcomes!
for (ENC in encodings) {

  resultings[ENC] <- iconv(x = "<U+8FD9>", from = "ASCII", to = ENC)
}
be  <- "<U+8FD9>"

txt <- "在"
writeLines(txt, "test.txt", useBytes=T)

cvb <- readLines("test.txt", encoding="UTF-8")

cvb

write.table(cvb, "test1.txt") # does not work :)

# trial
Sys.getlocale() # to get current locale
Sys.setlocale() # to set up current locale to be default of the system

Sys.setlocale(locale = "Chinese") # set locale to Chinese

# make trial now
write.table(cvb, "test2.txt")  #

# Set locale back to English
Sys.setlocale() # set original system settings


Sys.setlocale(locale = "Hindi")

resultLocale <- Sys.setlocale(locale = "Hindi")

resultOK <- Sys.setlocale(locale = "Chinese")

Sys.getlocale()
Sys.setlocale(locale = "russian")


### Trial harvest and translate websites
## inspiration from: https://www.datacamp.com/community/tutorials/r-web-scraping-rvest
library(rvest)
# this url for the jobs website
# https://www.jobs.ch/en/vacancies/?region=13&term=
url <- "https://www.jobs.ch/en/vacancies/?region=13&term="
  
d1 <- url %>% read_html() %>% html_nodes("h2") %>% html_text()
d2 <- url %>% read_html() %>% html_nodes(".serp-item-head-3") %>% html_text()


### ===============================================
# General-purpose data wrangling
library(tidyverse)  

# Parsing of HTML/XML files  
library(rvest)    

# String manipulation
library(stringr)   

# Verbose regular expressions
library(rebus)     

# Eases DateTime manipulation
library(lubridate)

# this url for the jobs website
# https://www.jobs.ch/en/vacancies/?region=13&term=
url <- "https://www.jobs.ch/en/vacancies/?region=13&term="

# first page
"https://www.jobs.ch/en/vacancies/?page=1&region=13&term="

# last page
"https://www.jobs.ch/en/vacancies/?page=100&region=13&term="

url1 <- "https://www.jobs.ch/en/vacancies/?page=2&region=24&term="

# job title
job_data1 <- url1 %>% 
  read_html() %>%     
  html_nodes(".t--job-link") %>% 
  # Extract the raw text as a list
  html_text()  

# job company
job_data2 <- url1 %>% 
  read_html() %>%     
  html_nodes(".serp-item-head-2") %>% #.x--company-link
  # Extract the raw text as a list
  html_text()  

# job description
job_data3 <- url1 %>% 
  read_html() %>%     
  html_nodes(".serp-item-head-3") %>% 
  # Extract the raw text as a list
  html_text()  

job_table <- data.frame(job_title = job_data1,
                        job_firma = job_data2,
                        job_descr = job_data3)




# function to ge the last page as a number
get_last_page <- function(url, class_html = 'x--paginator row'){
  #url <- "https://www.jobs.ch/en/vacancies/?page=2&region=24&term="
  #class_html <- 'page hidden-xs'
  pages_data <- url %>% 
    read_html() %>% 
    # The '.' indicates the class
    html_nodes(class_html) %>% 
    # Extract the raw text as a list
    html_text()                   
  
  # The second to last of the buttons is the one
  pages_data[(length(pages_data)-1)] %>%            
    # Take the raw string
    unname() %>%                                     
    # Convert to number
    as.numeric()                                     
}


first_page <- read_html(url)
latest_page_number <- get_last_page(first_page)




