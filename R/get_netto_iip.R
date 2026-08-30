
#' Get Norway's net international investment position
#'
#' Retrieves Norway's net international investment position (IIP) as
#' external financial assets less external financial liabilities.
#'
#' The series combines annual BPM5 data from Statistics Norway table 08291
#' through 2011 with fourth-quarter BPM6 data from table 10644 from 2012.
#'
#' @param refresh Logical. If `TRUE`, bypass the cache and retrieve fresh data.
#'
#' @return A data frame with columns `Aar` and `Netto_IIP`.
#'
#' @keywords internal
get_netto_iip <- function(refresh = FALSE) {
  cache_get(
    name = "netto_iip",
    refresh = refresh,
    fun = function() {

      old <- ssb_get(
        url = "https://data.ssb.no/api/v0/no/table/08291",
        query = list(
          Funksjon01 = c("FORD_UTL", "GJELD_UTL"),
          ContentsCode = "Invest",
          Tid = "*"
        )
      ) |>
        dplyr::mutate(
          Aar = as.integer(.data$ar),
          Komponent = dplyr::if_else(
            grepl("^Fordringer", .data$funksjon),
            "Fordringer",
            "Gjeld"
          )
        ) |>
        dplyr::select(
          Aar,
          Komponent,
          Verdi = internasjonal_investeringsposisjon
        ) |>
        tidyr::pivot_wider(
          names_from = Komponent,
          values_from = Verdi
        ) |>
        dplyr::transmute(
          Aar,
          Netto_IIP = .data$Fordringer - .data$Gjeld
        ) |>
        dplyr::filter(.data$Aar <= 2011)

      modern <- ssb_get(
        url = "https://data.ssb.no/api/v0/no/table/10644",
        query = list(
          FordringGjeld = c("F", "G"),
          FunksjObjSektor = "3",
          ContentsCode = "Beholdning",
          Tid = "*"
        )
      ) |>
        dplyr::filter(
          grepl("K4$", .data$kvartal),
          !is.na(.data$beholdning)
        ) |>
        dplyr::mutate(
          Aar = as.integer(substr(.data$kvartal, 1, 4)),
          Komponent = .data$fordringer_og_gjeld
        ) |>
        dplyr::select(
          Aar,
          Komponent,
          Verdi = beholdning
        ) |>
        tidyr::pivot_wider(
          names_from = Komponent,
          values_from = Verdi
        ) |>
        dplyr::transmute(
          Aar,
          Netto_IIP = .data$Fordringer - .data$Gjeld
        )

      dplyr::bind_rows(old, modern) |>
        dplyr::arrange(.data$Aar)
    }
  )
}
