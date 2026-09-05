
get_investeringer <- function(refresh = FALSE) {
  cache_get(
    name = "investeringer",
    refresh = refresh,
    fun = function() {
      url <- paste0(
        "https://data.ssb.no/api/v0/no/table/",
        "nk/nk03/knr/SBMENU5140/NRInvestKapital"
      )
      total_url <- paste0(
        "https://data.ssb.no/api/v0/no/table/",
        "nk/nk03/knr/SBMENU5140/NRMakroHov"
      )

      investeringer_faste_raw <- ssb_get(
        url = url,
        query = list(
          NACE = "nr23_6",
          ContentsCode = "BIF2",
          Tid = "*"
        )
      )
      investeringer_lopende_raw <- ssb_get(
        url = url,
        query = list(
          NACE = "nr23_6",
          ContentsCode = "BIF",
          Tid = "*"
        )
      )

      bruttoinvestering_alt_faste_raw <- ssb_get(
        url = total_url,
        query = list(
          Makrost = "bif.nr8_",
          ContentsCode = "Faste",
          Tid = "*"
        )
      )
      bruttoinvestering_alt_lopende_raw <- ssb_get(
        url = total_url,
        query = list(
          Makrost = "bif.nr8_",
          ContentsCode = "Priser",
          Tid = "*"
        )
      )

      bruttoinvestering_alt <-
        bruttoinvestering_alt_faste_raw |>
        dplyr::transmute(
          Aar = as.integer(.data$ar),
          Bruttoinvestering_i_alt = as.numeric(
            .data$faste_2023_priser_mill_kr)
        ) |>
        dplyr::left_join(
          bruttoinvestering_alt_lopende_raw |>
            dplyr::transmute(
              Aar = as.integer(.data$ar),
              Bruttoinvestering_i_alt_lopende =
                as.numeric(
                  .data$lopende_priser_mill_kr)
            ),
          by = "Aar"
        )
      investeringer <- investeringer_faste_raw |>
        dplyr::transmute(
          Aar = as.integer(.data$ar),
          Investeringer = as.numeric(
            .data$bruttoinvestering_i_fast_realkapital_faste_2023_priser_mill_kr
          )
        ) |>
        dplyr::left_join(
          investeringer_lopende_raw |>
            dplyr::transmute(
              Aar = as.integer(.data$ar),
              Investeringer_lopende = as.numeric(
                .data$bruttoinvestering_i_fast_realkapital_lopende_priser_mill_kr
              )
            ),
          by = "Aar"
        )
      investeringer |>
        dplyr::left_join(
          bruttoinvestering_alt,
          by = "Aar"
        ) |>
        dplyr::arrange(
          .data$Aar
        ) |>
        dplyr::mutate(
          Investeringer_vekst =
            (
              .data$Investeringer /
                dplyr::lag(.data$Investeringer) - 1
            ) * 100
        )
    }
  )
}
