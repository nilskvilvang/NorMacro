
get_arbeidsstyrke <- function(refresh = FALSE) {
  cache_get(
    name = "arbeidsstyrke",
    refresh = refresh,
    fun = function() {
      
      arbeidsstyrke_raw <- ssb_get(
        url = paste0(
          "https://data.ssb.no/api/v0/no/table/",
          "al/al03/aku/SBMENU9728/ArbStyrkAar"
        ),
        query = list(
          Alder = "15-74",
          Kjonn = c("2", "1"),
          ContentsCode = c("Personer", "Prosent"),
          Tid = "*"
        )
      )
      
      arbeidsstyrke_raw |>
        dplyr::transmute(
          Aar = as.integer(.data$ar),
          Kjonn = .data$kjonn,
          Arbeidsstyrke_1000 =
            as.numeric(.data$personer_i_arbeidsstyrken_1_000_personer),
          Arbeidsstyrkeandel_kjonn =
            as.numeric(.data$personer_i_arbeidsstyrken_prosent)
        ) |>
        dplyr::mutate(
          Befolkning_15_74_kjonn =
            Arbeidsstyrke_1000 /
            (Arbeidsstyrkeandel_kjonn / 100)
        ) |>
        dplyr::group_by(Aar) |>
        dplyr::summarise(
          Arbeidsstyrke =
            sum(Arbeidsstyrke_1000, na.rm = TRUE) * 1000,
          
          Befolkning_15_74 =
            sum(Befolkning_15_74_kjonn, na.rm = TRUE) * 1000,
          
          Arbeidsstyrkeandel =
            sum(Arbeidsstyrke_1000, na.rm = TRUE) /
            sum(Befolkning_15_74_kjonn, na.rm = TRUE) * 100,
          
          .groups = "drop"
        ) |>
        dplyr::arrange(Aar)
    }
  )
}
