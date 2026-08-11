
#' Hent utvalgte KOSTRA-nøkkeltall
#'
#' Henter og standardiserer utvalgte kommunale nøkkeltall fra
#' KOSTRA-tabell 12134.
#'
#' Resultatet returneres i NorMacros standardiserte KOSTRA-format med
#' kolonnene `Enhet`, `Enhet_navn`, `Enhetstype` og `Aar`, i tillegg til
#' indikatorene i tabellen.
#'
#' @param regions En tegnvektor med KOSTRA-koder for kommuner eller andre
#'   støttede enheter.
#' @param years År som skal hentes. Standard er 2015 til 2025.
#'
#' @return En tibble med standardiserte KOSTRA-nøkkeltall.
#'
#' @examples
#' \dontrun{
#' kostra <- get_kostra_keyfigures(
#'   regions = c("0301", "4601"),
#'   years = 2020:2025
#' )
#' }
#'
#' @export

get_kostra_keyfigures <- function(
    regions,
    years = 2015:2025
) {
  config <- kostra_table_12134()
  
  query <- stats::setNames(
    list(
      regions,
      kostra_indicators_12134()$ContentsCode,
      years
    ),
    c(
      config$region_code,
      config$indicator_code,
      config$time_code
    )
  )
  
  data <- get_kostra_table(
    url = config$url,
    query = query
  )
  
  result <- standardize_kostra_keyfigures(
    data = data
  )
  
  set_kostra_attributes(
    data = result,
    config = config
  )
}