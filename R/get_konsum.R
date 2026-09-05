
get_konsum <- function(refresh = FALSE) {
  cache_get(
    name = "konsum",
    refresh = refresh,
    fun = function() {

      url <- paste0(
        "https://data.ssb.no/api/v0/no/table/",
        "nk/nk03/knr/SBMENU5140/NRMakroHov"
      )

      # Privat konsum ------------------------------------------------------

      privat_faste_raw <- ssb_get(
        url = url,
        query = list(
          Makrost = "koh.nr61_",
          ContentsCode = "Faste",
          Tid = "*"
        )
      )

      privat_lopende_raw <- ssb_get(
        url = url,
        query = list(
          Makrost = "koh.nr61_",
          ContentsCode = "Priser",
          Tid = "*"
        )
      )

      privat <- privat_faste_raw |>
        dplyr::transmute(
          Aar = as.integer(.data$ar),
          Privat_konsum = as.numeric(
            .data$faste_2023_priser_mill_kr
          )
        ) |>
        dplyr::left_join(
          privat_lopende_raw |>
            dplyr::transmute(
              Aar = as.integer(.data$ar),
              Privat_konsum_lopende = as.numeric(
                .data$lopende_priser_mill_kr
              )
            ),
          by = "Aar"
        )
      # Konsum i husholdninger og ideelle organisasjoner ------------------
      husholdninger_ideelle_faste_raw <- ssb_get(
        url = url,
        query = list(
          Makrost = "koh.nrpriv",
          ContentsCode = "Faste",
          Tid = "*"
        )
      )
      husholdninger_ideelle_lopende_raw <- ssb_get(
        url = url,
        query = list(
          Makrost = "koh.nrpriv",
          ContentsCode = "Priser",
          Tid = "*"
        )
      )
      husholdninger_ideelle <-
        husholdninger_ideelle_faste_raw |>
        dplyr::transmute(
          Aar = as.integer(.data$ar),
          Konsum_husholdninger_ideelle = as.numeric(
            .data$faste_2023_priser_mill_kr
          )
        ) |>
        dplyr::left_join(
          husholdninger_ideelle_lopende_raw |>
            dplyr::transmute(
              Aar = as.integer(.data$ar),
              Konsum_husholdninger_ideelle_lopende =
                as.numeric(
                  .data$lopende_priser_mill_kr
                )
            ),
          by = "Aar"
        )

      # Offentlig konsum --------------------------------------------------

      offentlig_faste_raw <- ssb_get(
        url = url,
        query = list(
          Makrost = "koo.nroff",
          ContentsCode = "Faste",
          Tid = "*"
        )
      )

      offentlig_lopende_raw <- ssb_get(
        url = url,
        query = list(
          Makrost = "koo.nroff",
          ContentsCode = "Priser",
          Tid = "*"
        )
      )

      offentlig <- offentlig_faste_raw |>
        dplyr::transmute(
          Aar = as.integer(.data$ar),
          Offentlig_konsum = as.numeric(
            .data$faste_2023_priser_mill_kr
          )
        ) |>
        dplyr::left_join(
          offentlig_lopende_raw |>
            dplyr::transmute(
              Aar = as.integer(.data$ar),
              Offentlig_konsum_lopende = as.numeric(
                .data$lopende_priser_mill_kr
              )
            ),
          by = "Aar"
        )

      # Samlet resultat ---------------------------------------------------

      privat |>
        dplyr::left_join(
          husholdninger_ideelle,
          by = "Aar"
        ) |>
        dplyr::left_join(
          offentlig,
          by = "Aar"
        ) |>
        dplyr::arrange(
          .data$Aar
        ) |>
        dplyr::mutate(
          Privat_konsum_vekst =
            (
              .data$Privat_konsum /
                dplyr::lag(.data$Privat_konsum) - 1
            ) * 100,
          Offentlig_konsum_vekst =
            (
              .data$Offentlig_konsum /
                dplyr::lag(.data$Offentlig_konsum) - 1
            ) * 100
        )
    }
  )
}
