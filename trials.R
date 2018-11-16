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
