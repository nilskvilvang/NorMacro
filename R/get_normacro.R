
#' Hent NorMacro-datasettet
#'
#' Bygger og returnerer NorMacros standardiserte makroøkonomiske datasett.
#' Datasettet valideres før det returneres.
#'
#' Dersom `export = TRUE`, lagres datasettet og tilhørende metadata i
#' mappen `data_clean`.
#'
#' @param export Logisk verdi. Dersom `TRUE`, eksporteres NorMacro-datasettet
#'   til `data_clean/normacro.csv` og `data_clean/normacro.rds`, og metadata
#'   eksporteres til `data_clean/metadata_normacro.csv` og
#'   `data_clean/metadata_normacro.xlsx`. Standard er `FALSE`.
#'
#' @return Et standardisert og validert NorMacro-datasett.
#'
#' @examples
#' \dontrun{
#' data <- get_normacro()
#'
#' # Hent data og lagre datasett og metadata lokalt
#' data <- get_normacro(
#'   export = TRUE
#' )
#' }
#'
#' @export
get_normacro <- function(export = FALSE) {
  normacro <- build_database()
  
  check_normacro(normacro)
  
  if (export) {
    dir.create(
      "data_clean",
      showWarnings = FALSE
    )
    
    rio::export(
      normacro,
      "data_clean/normacro.csv"
    )
    
    rio::export(
      normacro,
      "data_clean/normacro.rds"
    )
    
    metadata <- get_normacro_metadata()
    
    rio::export(
      metadata,
      "data_clean/metadata_normacro.csv"
    )
    
    rio::export(
      metadata,
      "data_clean/metadata_normacro.xlsx"
    )
  }
  
  normacro
}

