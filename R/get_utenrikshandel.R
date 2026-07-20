
get_utenrikshandel <- function(refresh = FALSE) {
  cache_get(
    name = "utenrikshandel",
    refresh = refresh,
    fun = function() {
      url <- "https://data.ssb.no/api/v0/no/table/nk/nk03/knr/SBMENU5140/NRMakroHov"
      
      eksport_raw <- ssb_get(
        url = url,
        query = list(
          Makrost = "eks.nrtot",
          ContentsCode = "Faste",
          Tid = "*"
        )
      )
      
      import_raw <- ssb_get(
        url = url,
        query = list(
          Makrost = "imp.nrtot",
          ContentsCode = "Faste",
          Tid = "*"
        )
      )
      
      eksport <- eksport_raw |>
        dplyr::transmute(Aar = as.integer(ar),
                         Eksport = as.numeric(faste_2023_priser_mill_kr))
      
      import <- import_raw |>
        dplyr::transmute(Aar = as.integer(ar),
                         Import = as.numeric(faste_2023_priser_mill_kr))
      
      eksport |>
        dplyr::left_join(import, by = "Aar") |>
        dplyr::arrange(Aar) |>
        dplyr::mutate(
          Eksportvekst =
            (Eksport / dplyr::lag(Eksport) - 1) * 100,
          Importvekst =
            (Import / dplyr::lag(Import) - 1) * 100
        )
    }
  )
}
