#' Retrieve total number of GBIF records for a list of species
#'
#' @author Nicolas Casajus \email{nicolas.casajus@fondationbiodiversite.fr}
#' 
#' @date 2022/03/08



## Import BIOSHIFTS data ----

tab <- read.csv(here::here("data", "standardized_names_rechecked.csv"))


## Extract species names ----

sp_list <- sort(unique(tab$"SpeciesChecked"))


all_records <- data.frame()

for (i in 1:length(sp_list)) {
  
  cat("Processing species", i, "on", length(sp_list), "\r")
  
  
  ## Retrieve GBIF species key ----
  
  response   <- rgbif::name_suggest(q = sp_list[i], rank = "species")
  taxon_keys <- response$"data"$"key"
  
  
  ## Select GBIF species key only for accepted name ----
  
  status <- NULL
  
  for (j in 1:length(taxon_keys))
    status[j] <- rgbif::name_usage(taxon_keys[j])$"data"$"taxonomicStatus"
  
  taxon_keys <- taxon_keys[which(status == "ACCEPTED")]
  

  ## If species present in the GBIF system ----
  
  if (length(taxon_keys)) {
    
    for (j in 1:length(taxon_keys)) {
    
      
      ## Get total number of records ----
      
      n_records <- rgbif::occ_search(taxonKey = taxon_keys[j],
                                     hasCoordinate = TRUE, limit = 0)
      
      n_records <- data.frame("n_records" = n_records$"meta"$"count",
                              "taxon_key" = taxon_keys[j],
                              "taxon"     = sp_list[i])
      
      all_records <- rbind(all_records, n_records)
    }
  }
}


## Export results -----

saveRDS(all_records, file = here::here("outputs", "gbifs_n_records.rds"))
