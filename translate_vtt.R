# translate vtt files
# installing my R package from github
devtools::install_github("vzhomeexperiments/translateVTT")

library(translateVTT)

# citation("translateVTT")

# make a list of files to translate specify folder where files are
# # filesToTranslate <-list.files("TEST_DATA", pattern="*.vtt", full.names=TRUE)
filesToTranslate <-list.files("C:/Users/fxtrams/Downloads/", pattern="*.vtt", full.names=TRUE)

# make a list of languages
languages <- c("fr", "de", "hi", "id","it", "ms", "pt", "ru", "es", "zh-CN", "tr") #add any other language
# get api key
out <- read_rds("api_key.enc.rds")

# decrypting the password using public data list and private key
api_key <- decrypt_envelope(out$data, out$iv, out$session, "C:/Users/fxtrams/.ssh/id_api", password = "") %>% unserialize()

# test run function for 1 file
translateVTT(filesToTranslate[1], sourceLang = "en", destLang = languages[1], apikey = api_key)

# translating multiple files
# for loop as more robust function
for (FILE in filesToTranslate) {
  # for loop for languages
  for (LANG in languages) {
    tryCatch({
      # translation
      translateVTT(fileName = FILE, sourceLang = "en", destLang = LANG, apikey = api_key)
    }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
  }
}

## Results: translated files can be found in the same folder as original files...
