library(devtools);library(roxygen2)
document('.'); install('.')
devtools::build_vignettes()