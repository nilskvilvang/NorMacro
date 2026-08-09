
#' List tilgjengelige variabler
#'
#' Gir en oversikt over variablene som er tilgjengelige i NorMacro eller
#' i et angitt datasett. Variablene grupperes etter kategori og vises med
#' både variabelnavn og beskrivende navn når dette finnes.
#'
#' Listen kan avgrenses til en bestemt kategori eller variabeltype.
#' Funksjonen er særlig nyttig for å utforske hvilke data som finnes før
#' en analyse.
#'
#' @param data Et NorMacro-datasett eller `NULL`. Dersom `NULL`, brukes
#'   den samlede NorMacro-metadataen.
#' @param category Valgfri kategori som variabellisten skal begrenses til.
#'   Standard er `NULL`, som inkluderer alle kategorier.
#' @param type Valgfri variabeltype som listen skal begrenses til.
#'   Standard er `NULL`, som inkluderer alle typer.
#' @param print Logisk verdi. Dersom `TRUE`, skrives en formatert oversikt
#'   til konsollen. Standard er `TRUE`.
#'
#' @return Metadata for variablene som oppfyller kriteriene, returnert
#'   usynlig.
#'
#' @examples
#' \dontrun{
#' list_variables()
#'
#' # Resultatet kan også lagres uten utskrift
#' variables <- list_variables(
#'   print = FALSE
#' )
#' }
#'
#' @export

list_variables <- function(data = NULL,
                           category = NULL,
                           type = NULL,
                           print = TRUE) {
  metadata <- get_metadata(data)
  
  if (!is.null(category)) {
    metadata <- metadata |>
      dplyr::filter(.data$Kategori == category)
  }
  
  if (!is.null(type)) {
    metadata <- metadata |>
      dplyr::filter(.data$Type == type)
  }
  
  if (nrow(metadata) == 0) {
    message("Fant ingen variabler med valgte kriterier.")
    return(invisible(metadata))
  }
  
  metadata <- metadata |>
    dplyr::arrange(.data$Kategori, .data$Display_navn, .data$Variabel)
  
  dataset_name <- if (is.null(data)) {
    "Alle metadata"
  } else if ("Land" %in% names(data)) {
    "Internasjonale data"
  } else{
    "Norske data"
  }
  
  duplicate_variables <- metadata$Variabel[duplicated(metadata$Variabel) |
                                             duplicated(metadata$Variabel, fromLast = TRUE)]
  
  if (print) {
    cat("\n")
    cat(dataset_name, "\n")
    cat(strrep("-", nchar(dataset_name)), "\n", sep = "")
    cat(nrow(metadata), " variabler\n\n", sep = "")
    
    categories <- unique(metadata$Kategori)
    
    for (category_name in categories) {
      vars <- metadata |>
        dplyr::filter(.data$Kategori == category_name)
      
      cat(category_name, "\n")
      cat(strrep("-", nchar(category_name)), "\n", sep = "")
      
      for (i in seq_len(nrow(vars))) {
        variable_name <- vars$Variabel[i]
        display_name <- vars$Display_navn[i]
        
        label <- if (is.na(display_name) ||
                     display_name == "" ||
                     display_name == variable_name) {
          variable_name
        } else{
          paste0(variable_name, " \u2014 ", display_name)
        }
        
        if (variable_name %in% duplicate_variables) {
          label <- paste0(label, " [", vars$Omraade[i], "]")
        }
        
        cat("- ", label, "\n", sep = "")
      }
      
      cat("\n")
    }
  }
  
  invisible(metadata)
}

