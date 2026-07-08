
# R/international_metadata.R

international_metadata_fields <- function() {
  c(
    "Internasjonal",
    "Internasjonal_variabel",
    "Internasjonal_kilde",
    "Internasjonal_kildekode",
    "Sammenlignbarhet",
    "Standard_land",
    "Internasjonal_kommentar",
    "Fase2_prioritet"
  )
}

add_international_metadata_fields <- function(metadata = get_metadata()) {
  fields <- international_metadata_fields()
  
  for (field in fields) {
    if (!field %in% names(metadata)) {
      metadata[[field]] <- NA_character_
    }
  }
  
  metadata
}
