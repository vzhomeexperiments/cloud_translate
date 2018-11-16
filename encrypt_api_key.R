# encrypt api key
# for more info on how to use RSA cryptography in R check my course
# https://www.udemy.com/keep-your-secrets-under-control/?couponCode=CRYPTOGRAPHY-GIT

# encrypt my key (I am showing my API key because I will delete it anyhow after creating the course)
library(openssl)
library(tidyverse)

# private and public key path - replace paths with those of your computer
path_private_key <- file.path("C:/Users/fxtrams/.ssh", "id_api")
path_public_key <- file.path("C:/Users/fxtrams/.ssh", "id_api.pub")

## Encrypt with your public key - replace xxxx with your API key
"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" %>% 
  # serialize the object
  serialize(connection = NULL) %>% 
  # encrypt the object
  encrypt_envelope(path_public_key) %>% 
  # write encrypted data to File to your working directory
  write_rds("api_key.enc.rds")