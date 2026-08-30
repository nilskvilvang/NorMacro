
get_igangsatte_boliger <- function(refresh = FALSE) {
  cache_get(
    name = "igangsatte_boliger",
    refresh = refresh,
    fun = function() {
      
      url <- "https://data.ssb.no/api/v0/no/table/05940"
      
      igangsatte_raw <- ssb_get(
        url = url,
        query = list(
          Region = "0",
          Byggeareal = "*",
          ContentsCode = "Igangsatte",
          Tid = "*"
        )
      )
      
      igangsatte_raw |>
        dplyr::transmute(
          Aar = as.integer(.data$ar),
          Igangsatte_boliger = as.numeric(
            .data$igangsettingstillatelser_boliger
          )
        ) |>
        dplyr::group_by(.data$Aar) |>
        dplyr::summarise(
          Igangsatte_boliger = sum(
            .data$Igangsatte_boliger,
            na.rm = TRUE
          ),
          .groups = "drop"
        ) |>
        dplyr::arrange(.data$Aar)
    }
  )
}
