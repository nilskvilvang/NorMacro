
get_boliginvesteringer <- function(refresh = FALSE) {
  cache_get(
    name = "boliginvesteringer",
    refresh = refresh,
    fun = function() {

      url <- paste0(
        "https://data.ssb.no/api/v0/no/table/",
        "nk/nk03/knr/SBMENU5140/NRMakroHov"
      )

      bolig_inv_faste_raw <- ssb_get(
        url = url,
        query = list(
          Makrost = "bif.nr8368",
          ContentsCode = "Faste",
          Tid = "*"
        )
      )

      bolig_inv_lopende_raw <- ssb_get(
        url = url,
        query = list(
          Makrost = "bif.nr8368",
          ContentsCode = "Priser",
          Tid = "*"
        )
      )

      bolig_inv_faste_raw |>
        dplyr::transmute(
          Aar = as.integer(.data$ar),

          Boliginvesteringer = as.numeric(
            .data$faste_2023_priser_mill_kr
          )
        ) |>
        dplyr::left_join(
          bolig_inv_lopende_raw |>
            dplyr::transmute(
              Aar = as.integer(.data$ar),

              Boliginvesteringer_lopende = as.numeric(
                .data$lopende_priser_mill_kr
              )
            ),
          by = "Aar"
        ) |>
        dplyr::arrange(
          .data$Aar
        ) |>
        dplyr::mutate(
          Boliginvesteringer_vekst =
            (
              .data$Boliginvesteringer /
                dplyr::lag(.data$Boliginvesteringer) - 1
            ) * 100
        )
    }
  )
}
