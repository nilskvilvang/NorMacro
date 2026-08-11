
#' Hent metadata for internasjonale NorMacro-data
#'
#' Returnerer metadata for variablene i NorMacros internasjonale
#' makrodatasett.
#'
#' @return En tibble med internasjonale variabelmetadata.
#'
#' @examples
#' get_international_metadata()
#'
#' @export

get_international_metadata <- function() {
  read_metadata_csv("metadata_international.csv")
}
