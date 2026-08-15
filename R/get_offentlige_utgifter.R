
get_offentlige_utgifter <- function(refresh = FALSE) {
  cache_get(
    name = "offentlige_utgifter",
    refresh = refresh,
    fun = function() {
      
      url <- paste0(
        "https://data.ssb.no/api/v0/no/table/",
        "os/os02/offinnut/SBMENU4642/OffInnUt21"
      )
      
      # Samlede inntekter og nettofinansinvestering
      offentlig_raw <- ssb_get(
        url = url,
        query = list(
          Art = c("A", "F"),
          Sektor = "C_OFF",
          ContentsCode = "Belop",
          Tid = "*"
        )
      )
      
      offentlig <- offentlig_raw |>
        dplyr::mutate(
          Aar = as.integer(.data$ar),
          belop = as.numeric(.data$belop)
        ) |>
        dplyr::select(
          Aar,
          art = .data$art,
          belop = .data$belop
        ) |>
        tidyr::pivot_wider(
          names_from = "art",
          values_from = "belop"
        ) |>
        dplyr::rename(
          Offentlige_inntekter =
            `Totale inntekter`,
          Nettofinansinvestering =
            `Overskudd (nettofinansinvestering, A-E)`
        )
      
      # Utgifter fordelt på forvaltningsnivå
      utgifter_raw <- ssb_get(
        url = url,
        query = list(
          Art = "E",
          Sektor = c(
            "C_OFF",
            "6100",
            "6500"
          ),
          ContentsCode = "Belop",
          Tid = "*"
        )
      )
      
      utgifter <- utgifter_raw |>
        dplyr::mutate(
          Aar = as.integer(ar),
          belop = as.numeric(belop)
        ) |>
        dplyr::select(
          Aar,
          sektor,
          belop
        ) |>
        tidyr::pivot_wider(
          names_from = sektor,
          values_from = belop
        ) |>
        dplyr::rename(
          Offentlige_utgifter =
            `Offentlig forvaltning`,
          Statlige_utgifter =
            Statsforvaltningen,
          Kommunale_utgifter =
            Kommuneforvaltningen
        )
      
      offentlig |>
        dplyr::left_join(
          utgifter,
          by = "Aar"
        ) |>
        dplyr::arrange(Aar)
    }
  )
}
