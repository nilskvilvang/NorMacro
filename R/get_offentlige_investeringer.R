
get_offentlige_investeringer <- function(refresh = FALSE) {
  cache_get(
    name = "offentlige_investeringer",
    refresh = refresh,
    fun = function() {

      url <- paste0(
        "https://data.ssb.no/api/v0/no/table/",
        "nk/nk03/knr/SBMENU5140/NRMakroHov"
      )

      off_inv_faste_raw <- ssb_get(
        url = url,
        query = list(
          Makrost = "bif.nr83_6",
          ContentsCode = "Faste",
          Tid = "*"
        )
      )

      off_inv_lopende_raw <- ssb_get(
        url = url,
        query = list(
          Makrost = "bif.nr83_6",
          ContentsCode = "Priser",
          Tid = "*"
        )
      )

      off_inv_faste_raw |>
        dplyr::transmute(
          Aar = as.integer(.data$ar),

          Offentlige_investeringer = as.numeric(
            .data$faste_2023_priser_mill_kr
          )
        ) |>
        dplyr::left_join(
          off_inv_lopende_raw |>
            dplyr::transmute(
              Aar = as.integer(.data$ar),

              Offentlige_investeringer_lopende = as.numeric(
                .data$lopende_priser_mill_kr
              )
            ),
          by = "Aar"
        ) |>
        dplyr::arrange(
          .data$Aar
        ) |>
        dplyr::mutate(
          Offentlige_investeringer_vekst =
            (
              .data$Offentlige_investeringer /
                dplyr::lag(.data$Offentlige_investeringer) - 1
            ) * 100
        )
    }
  )
}
