
get_sysselsatte <- function(refresh = FALSE) {
  cache_get(
    name = "sysselsatte",
    refresh = refresh,
    fun = function() {
      
      sysselsatte_raw <- ssb_get(
        url = paste0(
          "https://data.ssb.no/api/v0/no/table/",
          "al/al06/aku/SBMENU9726/SysselAKUAar"
        ),
        query = list(
          Alder = "15-74",
          Kjonn = c("2", "1"),
          ContentsCode = c("Personer", "Prosent"),
          Tid = "*"
        )
      )
      
      sysselsatte_raw |>
        dplyr::filter(.data$ar != "2006 Gml") |>
        dplyr::transmute(
          Aar = as.integer(.data$ar),
          Kjonn = .data$kjonn,
          Sysselsatte_1000 =
            as.numeric(.data$sysselsatte_1_000_personer),
          Sysselsettingsandel_kjonn =
            as.numeric(.data$sysselsatte_prosent)
        ) |>
        dplyr::mutate(
          Befolkning_15_74_kjonn =
            Sysselsatte_1000 /
            (Sysselsettingsandel_kjonn / 100)
        ) |>
        dplyr::group_by(Aar) |>
        dplyr::summarise(
          Sysselsatte =
            sum(Sysselsatte_1000, na.rm = TRUE) * 1000,
          
          Sysselsettingsandel =
            sum(Sysselsatte_1000, na.rm = TRUE) /
            sum(Befolkning_15_74_kjonn, na.rm = TRUE) * 100,
          
          .groups = "drop"
        ) |>
        dplyr::arrange(Aar)
    }
  )
}
