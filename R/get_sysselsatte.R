
get_sysselsatte <- function(refresh = FALSE) {
  cache_get(
    name = "sysselsatte",
    refresh = refresh,
    fun = function() {
      query <- list(
        Alder = "15-74",
        Kjonn = c("2", "1"),
        ContentsCode = "Personer",
        Tid = "*"
      )
      
      sysselsatte_raw <- ssb_get(url = "https://data.ssb.no/api/v0/no/table/al/al06/aku/SBMENU9726/SysselAKUAar", query = query)
      
      sysselsatte_raw |>
        dplyr::rename(Aar = ar, Sysselsatte_1000 = sysselsatte_1_000_personer) |>
        dplyr::mutate(
          Aar = readr::parse_number(Aar),
          Sysselsatte_1000 = as.numeric(Sysselsatte_1000)
        ) |>
        dplyr::group_by(Aar) |>
        dplyr::summarise(
          Sysselsatte = sum(Sysselsatte_1000, na.rm = TRUE) * 1000,
          .groups = "drop"
        ) |>
        dplyr::arrange(Aar)
    }
  )
}
