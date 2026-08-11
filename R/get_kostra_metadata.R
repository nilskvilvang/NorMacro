
#' Hent metadata for et KOSTRA-datasett
#'
#' Henter metadata for indikatorene i en støttet KOSTRA-tabell.
#' Tabellen kan identifiseres enten fra attributtene på et KOSTRA-datasett
#' eller ved å oppgi tabellnummer eksplisitt.
#'
#' @param data Valgfritt KOSTRA-datasett med attributtet `kostra_table`.
#' @param table Valgfritt KOSTRA-tabellnummer.
#'
#' @return En tibble med metadata for indikatorene i KOSTRA-tabellen.
#'
#' @examples
#' get_kostra_metadata(
#'   data = normacro_kostra_example
#' )
#'
#' @export

get_kostra_metadata <- function(
    data = NULL,
    table = NULL
) {
  
  if (!is.null(data)) {
    table <- attr(
      data,
      "kostra_table"
    )
  }
  
  if (
    is.null(table) ||
    length(table) != 1L ||
    is.na(table) ||
    table == ""
  ) {
    stop(
      "Kunne ikke identifisere KOSTRA-tabellen.",
      call. = FALSE
    )
  }
  
  function_name <- paste0(
    "kostra_indicators_",
    table
  )
  
  indicator_function <- get0(
    function_name,
    mode = "function",
    inherits = TRUE
  )
  
  if (is.null(indicator_function)) {
    stop(
      "Fant ikke indikatormetadata for KOSTRA-tabell ",
      table,
      ".",
      call. = FALSE
    )
  }
  
  metadata <- indicator_function()
  
  required_columns <- c(
    "Variabel",
    "Display_navn",
    "Enhet",
    "Analyse_type"
  )
  
  missing_columns <- setdiff(
    required_columns,
    names(metadata)
  )
  
  if (length(missing_columns) > 0L) {
    stop(
      "KOSTRA-metadata mangler kolonner: ",
      paste(
        missing_columns,
        collapse = ", "
      ),
      call. = FALSE
    )
  }
  
  metadata
}
