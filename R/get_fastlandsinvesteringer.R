
get_fastlandsinvesteringer <- function(refresh = FALSE) {
  cache_get(
    name = "fastlandsinvesteringer",
    refresh = refresh,
    fun = function() {

      url <- paste0(
        "https://data.ssb.no/api/v0/no/table/",
        "nk/nk03/knr/SBMENU5140/NRInvestKapital"
      )

      fastland_inv_faste_raw <- ssb_get(
        url = url,
        query = list(
          NACE = "nr23_6fn",
          ContentsCode = "BIF2",
          Tid = "*"
        )
      )

      fastland_inv_lopende_raw <- ssb_get(
        url = url,
        query = list(
          NACE = "nr23_6fn",
          ContentsCode = "BIF",
          Tid = "*"
        )
      )

      fastland_inv_faste_raw |>
        dplyr::transmute(
          Aar = as.integer(.data$ar),

          Fastlandsinvesteringer = as.numeric(
            .data$bruttoinvestering_i_fast_realkapital_faste_2023_priser_mill_kr
          )
        ) |>
        dplyr::left_join(
          fastland_inv_lopende_raw |>
            dplyr::transmute(
              Aar = as.integer(.data$ar),

              Fastlandsinvesteringer_lopende = as.numeric(
                .data$bruttoinvestering_i_fast_realkapital_lopende_priser_mill_kr
              )
            ),
          by = "Aar"
        ) |>
        dplyr::arrange(
          .data$Aar
        ) |>
        dplyr::mutate(
          Fastlandsinvesteringer_vekst =
            (
              .data$Fastlandsinvesteringer /
                dplyr::lag(.data$Fastlandsinvesteringer) - 1
            ) * 100
        )
    }
  )
}
