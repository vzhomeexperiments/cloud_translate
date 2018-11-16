Automated Translations of Videos Closed Captions with R and Google Translator API
=================================================================================

Recent development of cloud services allowing to easily integrate translations 'speach-to-text'. In particular all videos for my online courses were captioned by the learning platform. I have manually checked english auto-generated subtitles and decided to study ways how can I translate them to other languages. For example I would be able to *delight my students with option to read subtitles*. This may help them to better catch idea from voice on the video.

This post explains the idea to use R and Google Translate API to completely automate process and even introducing dedicated R package for that...

What are the options?
---------------------

First idea is obvious! Open the file, copy and paste to Google Translator Webpage, translate and back... This is however something undersireable:

``` r
# In each course: ~ 23 videos -> 10 languages 
23 * 10
```

    ## [1] 230

Second idea was to automate the process. Bad news that I am not a programmer. The only remote chance was to try using **R** which may allow something more realistic.

Solving for one
---------------

I started to read file with Closed Captions into R:

``` r
library(magrittr)
# read file -> it will be a dataframe
read.delim("L0.vtt", stringsAsFactors = F) %>%  head()
```

    ##                                                     WEBVTT
    ## 1                                                        0
    ## 2                                  00:03.330 --> 00:07.020
    ## 3 Hello! We all know about existence of Google translator.
    ## 4                                                        1
    ## 5                                  00:07.230 --> 00:08.240
    ## 6                                            This is free.

Next step was to perform some manipulations with text strings. In particular *Google* charge for each translated symbol, hence sending time-stamps would be inefficient...

``` r
library(tidyverse)
# read file -> it will be a dataframe
t <- read.delim("L0.vtt", stringsAsFactors = F)

# extract logical vector indicating which rows containing timestamps
x <- t %>% 
  # detect rows with date time (those for not translate)
  apply(MARGIN = 1, str_detect, pattern = "-->")

# extract only rows containing text (e.g. not containing timestamps) 
txt <- subset.data.frame(t, !x) 
# extract only time stamps
tst <- subset.data.frame(t,  x)

head(txt)
```

    ##                                                     WEBVTT
    ## 1                                                        0
    ## 3 Hello! We all know about existence of Google translator.
    ## 4                                                        1
    ## 6                                            This is free.
    ## 7                                                        2
    ## 9                   Millions of people using it every day.

This dataframe `txt` can now be translated... good news is that someone already thought about translation with **Google Cloud Platform and Translate API** from **R**.

Automating translation has a cost. Hence anyone who want to use this service should pay. Official cost is 20$ for 1000000 symbols translated. Great news is that Google is giving $300 and 12 months free trials. API key then can be generated from the Google Cloud Platform.

I usually encrypt any of the credentials used in the R scripts so here I will demonstrate how I will translate my text extract to German (language I am currently study)

``` r
library(translateR)
library(openssl)

# get back our encrypted API key
out <- read_rds("api_key.enc.rds")
api_key <- decrypt_envelope(out$data, out$iv, out$session, "C:/Users/fxtrams/.ssh/id_api", password = "") %>% 
  unserialize()
# translate object txt or file in R
# Google, translate column in dataset
google.dataset.out <- translate(dataset = txt,
                                content.field = 'WEBVTT',
                                google.api.key = api_key,
                                source.lang = 'en',
                                target.lang = 'de')

# extract only new column
trsltd <- google.dataset.out %>% select(translatedContent)

# give original name
colnames(trsltd) <- "WEBVTT"

head(trsltd)
```

    ##                                                            WEBVTT
    ## 1                                                               0
    ## 3 Hallo! Wir alle wissen über die Existenz von Google Übersetzer.
    ## 4                                                               1
    ## 6                                                 Das ist gratis.
    ## 7                                                               2
    ## 9                     Millionen von Menschen nutzen es jeden Tag.

Next I will rejoin timestamps with translated text and order this dataframe by rownames

``` r
# bind rows with original timestamps
abc <- rbind(tst, trsltd)

# order this file back again
bcd <-  abc[ order(as.numeric(row.names(abc))), ] %>% as.character() %>% as.data.frame()

head(bcd)
```

    ##                                                                 .
    ## 1                                                               0
    ## 2                                         00:03.330 --> 00:07.020
    ## 3 Hallo! Wir alle wissen über die Existenz von Google Übersetzer.
    ## 4                                                               1
    ## 5                                         00:07.230 --> 00:08.240
    ## 6                                                 Das ist gratis.

I should add empty row otherwise it will not work and write to Write to the file...

``` r
# return original name
colnames(bcd) <- "WEBVTT"

bcd <- as.tibble(bcd)
# add one row
bcd2 <- add_row(bcd, WEBVTT  = "", .before = 1)

# write this file back :_)
write.table(bcd2, "translated.vtt",quote = F, row.names = F, fileEncoding = "UTF-8")
```

Function and even R Package
---------------------------

All the code manipulations were nicely placed into the R function. I went a bit further by learning how to create an R package...

``` r
# installing the R package
devtools::install_github("vzhomeexperiments/translateVTT")
```

After that I can just give a file path to the closed caption file and it will does everything by itself:

``` r
# load R package
library(translateVTT)

# send VTT file for translation and writing it back
translateVTT(fileName = "L0.vtt", 
             sourceLang = "en",
             destLang = "de",
             apikey = api_key)
```

    ## [1] "LC_COLLATE=English_United Kingdom.1252;LC_CTYPE=English_United Kingdom.1252;LC_MONETARY=English_United Kingdom.1252;LC_NUMERIC=C;LC_TIME=English_United Kingdom.1252"

``` r
read.delim("L0.vttnl.vtt") %>% head()
```

    ##                                                                           WEBVTT
    ## 1                                                                              0
    ## 2                                                        00:03.330 --> 00:07.020
    ## 3 Hallo! We weten allemaal over het bestaan <U+200B><U+200B>van Google vertaler.
    ## 4                                                                              1
    ## 5                                                        00:07.230 --> 00:08.240
    ## 6                                                                 Dit is gratis.

More automation?
----------------

Real usecase may entail keeping all my files to translate in one folder. I can read the names of those files and store them in a vector.

``` r
# make a list of files to translate
filesToTranslate <-list.files("C:/Users/fxtrams/Downloads/", pattern="*.vtt", full.names=TRUE)
head(filesToTranslate)
```

    ## [1] "C:/Users/fxtrams/Downloads/L0.vtt" "C:/Users/fxtrams/Downloads/L1.vtt"
    ## [3] "C:/Users/fxtrams/Downloads/L2.vtt" "C:/Users/fxtrams/Downloads/L3.vtt"
    ## [5] "C:/Users/fxtrams/Downloads/L4.vtt" "C:/Users/fxtrams/Downloads/L5.vtt"

I will also be able to setup vector with languages symbols:

``` r
# make a list of languages
languages <- c("fr", "tr", "it", "id", "pt", "es", "ms", "de")
```

Finally basic for loop in R will do the entire job:

``` r
# for loop
for (FILE in filesToTranslate) {
  # for loop for languages
  for (LANG in languages) {
    # translation
    translateVTT(fileName = FILE, sourceLang = "en", destLang = LANG, apikey = api_key)
  }
  
}
```

Conclusion!
-----------

Entire exercise lasted 1.26 hours and consumed 18.37$. It has translated my 23 files to 8 different languages including Chinese... Things that would be otherwise impossible to accomplish without **Google Translate API**
