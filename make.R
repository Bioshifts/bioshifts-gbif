#' Explore GBIF Data for BIOSHIFTS Species
#' 
#' @description 
#' Research compendium of the project 
#' _Global redistribution of biodiversity: a macro- and eco-evolutionary 
#' approach to understand species vulnerability to global changes_. 
#' This project is part of the FRB-CESAB research group BIOSHIFTS
#' \url{https://www.fondationbiodiversite.fr/en/the-frb-in-action/programs-and-
#' projects/le-cesab/bioshifts/}.
#' 
#' @author Nicolas Casajus \email{nicolas.casajus@fondationbiodiversite.fr}
#' 
#' @date 2022/03/08



## Install `remotes` package ----

if (!("remotes" %in% installed.packages())) install.packages("remotes")


## Install required packages (listed in DESCRIPTION) ----

remotes::install_deps(upgrade = "never")


## Load project dependencies ----

devtools::load_all(here::here())


## Create folders ----

dir.create(here::here("outputs"), showWarnings = FALSE)


## Download GBIF records ----

# source(here::here("analyses", "search_gbif_records.R"))
source(here::here("analyses", "explore_gbif_records.R"))
