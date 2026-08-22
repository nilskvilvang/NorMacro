
get_bnp_fastland <- function(refresh = FALSE) {
  cache_get(
    name = "bnp_fastland",
    refresh = refresh,
    fun = function() {

      url <- paste0(
        "https://data.ssb.no/api/v0/no/table/",
        "nk/nk03/knr/SBMENU5140/NRMakroHov"
      )

      bnp_faste_raw <- ssb_get(
        url = url,
        query = list(
          Makrost = "bnpb.nr23_9fn",
          ContentsCode = "Faste",
          Tid = "*"
        )
      )

      bnp_lopende_raw <- ssb_get(
        url = url,
        query = list(
          Makrost = "bnpb.nr23_9fn",
          ContentsCode = "Priser",
          Tid = "*"
        )
      )

      bnp_faste_raw |>
        dplyr::transmute(
          Aar = as.integer(.data$ar),
          BNP_Fastland = as.numeric(
            .data$faste_2023_priser_mill_kr
          )
        ) |>
        dplyr::left_join(
          bnp_lopende_raw |>
            dplyr::transmute(
              Aar = as.integer(.data$ar),
              BNP_Fastland_lopende = as.numeric(
                .data$lopende_priser_mill_kr
              )
            ),
          by = "Aar"
        ) |>
        dplyr::arrange(
          .data$Aar
        ) |>
        dplyr::mutate(
          BNP_Fastland_vekst =
            (
              .data$BNP_Fastland /
                dplyr::lag(.data$BNP_Fastland) - 1
            ) * 100
        )
    }
  )
}
