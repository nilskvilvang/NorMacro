
#' Klassifiser konjunkturfase
#'
#' Klassifiserer hvert år i en konjunkturfase basert på en samlet score
#' fra NorMacros konjunkturindikatorer.
#'
#' Klassifiseringen bruker terskler for nedgang, svak vekst,
#' ekspansjon og høykonjunktur.
#'
#' @param data Valgfritt NorMacro-datasett. Hvis `NULL`, brukes
#'   standarddatasettet.
#' @param recession_max Øvre grense for klassifisering som `"Nedgang"`.
#' @param slowdown_max Øvre grense for klassifisering som `"Svak vekst"`.
#' @param boom_min Nedre grense for klassifisering som `"Høykonjunktur"`.
#' @param ... Videre argumenter sendt til den underliggende
#'   konjunkturscoringen.
#'
#' @return En tibble med år, konjunkturfase, samlet score,
#'   antall indikatorer og underliggende delkomponenter.
#'
#' @examples
#' \dontrun{
#' cycle <- business_cycle()
#' }
#'
#' @export

business_cycle <- function(
    data = NULL,
    recession_max = -8,
    slowdown_max = -2,
    boom_min = 6,
    ...
){
  
  score <- business_cycle_score(
    data = data,
    ...
  )
  
  score |>
    dplyr::mutate(
      Fase = dplyr::case_when(
        Score <= recession_max ~ "Nedgang",
        Score > recession_max & Score <= slowdown_max ~ "Svak vekst",
        Score >= boom_min ~ "H\u00f8ykonjunktur",
        TRUE ~ "Ekspansjon"
      )
    ) |>
    dplyr::select(
      Aar,
      Fase,
      Score,
      Antall_indikatorer,
      dplyr::everything()
    )
}
