
old_wd <- getwd()
setwd("../..")

source("source_all.R")

normacro <- get_normacro()
metadata <- get_metadata()

setwd(old_wd)