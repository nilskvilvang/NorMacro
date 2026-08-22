
get_utenrikshandel <- function(refresh = FALSE) {
  cache_get(
    name = "utenrikshandel",
    refresh = refresh,
    fun = function() {

      url <- paste0(
        "https://data.ssb.no/api/v0/no/table/",
        "nk/nk03/knr/SBMENU5140/NRMakroHov"
      )

      # Eksport ------------------------------------------------------------

      eksport_faste_raw <- ssb_get(
        url = url,
        query = list(
          Makrost = "eks.nrtot",
          ContentsCode = "Faste",
          Tid = "*"
        )
      )

      eksport_lopende_raw <- ssb_get(
        url = url,
        query = list(
          Makrost = "eks.nrtot",
          ContentsCode = "Priser",
          Tid = "*"
        )
      )

      eksport <- eksport_faste_raw |>
        dplyr::transmute(
          Aar = as.integer(.data$ar),
          Eksport = as.numeric(
            .data$faste_2023_priser_mill_kr
          )
        ) |>
        dplyr::left_join(
          eksport_lopende_raw |>
            dplyr::transmute(
              Aar = as.integer(.data$ar),
              Eksport_lopende = as.numeric(
                .data$lopende_priser_mill_kr
              )
            ),
          by = "Aar"
        )

      # Import -------------------------------------------------------------

      import_faste_raw <- ssb_get(
        url = url,
        query = list(
          Makrost = "imp.nrtot",
          ContentsCode = "Faste",
          Tid = "*"
        )
      )

      import_lopende_raw <- ssb_get(
        url = url,
        query = list(
          Makrost = "imp.nrtot",
          ContentsCode = "Priser",
          Tid = "*"
        )
      )

      import <- import_faste_raw |>
        dplyr::transmute(
          Aar = as.integer(.data$ar),
          Import = as.numeric(
            .data$faste_2023_priser_mill_kr
          )
        ) |>
        dplyr::left_join(
          import_lopende_raw |>
            dplyr::transmute(
              Aar = as.integer(.data$ar),
              Import_lopende = as.numeric(
                .data$lopende_priser_mill_kr
              )
            ),
          by = "Aar"
        )

      # Samlet resultat ----------------------------------------------------

      eksport |>
        dplyr::left_join(
          import,
          by = "Aar"
        ) |>
        dplyr::arrange(
          .data$Aar
        ) |>
        dplyr::mutate(
          Eksportvekst =
            (
              .data$Eksport /
                dplyr::lag(.data$Eksport) - 1
            ) * 100,
          Importvekst =
            (
              .data$Import /
                dplyr::lag(.data$Import) - 1
            ) * 100
        )
    }
  )
}
