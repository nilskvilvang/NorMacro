
#' Hent internasjonale makrodata
#'
#' Henter NorMacros standardiserte internasjonale makrodatasett.
#'
#' Datasettet inneholder årlige makroøkonomiske indikatorer for Norge og
#' utvalgte europeiske land i et felles format med kolonnene `Aar` og
#' `Land`.
#'
#' @param export Logisk. Om datasettet også skal eksporteres til fil.
#' @param refresh Logisk. Om eksisterende cache skal fornyes.
#'
#' @return En tibble med internasjonale makroøkonomiske tidsserier.
#'
#' @examples
#' \dontrun{
#' international <- get_international_macro()
#' }
#'
#' @export

get_international_macro <- function(export = FALSE, refresh = FALSE) {
  international <- build_international_database(refresh = refresh)
  
  check_metadata(international)
  
  if (export) {
    dir.create("data_clean", showWarnings = FALSE)
    
    rio::export(international, "data_clean/international.csv")
    
    rio::export(international, "data_clean/international.rds")
    
    metadata <- get_international_metadata()
    
    rio::export(metadata, "data_clean/metadata_international.csv")
    
    rio::export(metadata, "data_clean/metadata_international.xlsx")
  }
  
  international
}