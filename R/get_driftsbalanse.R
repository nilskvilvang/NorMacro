
get_driftsbalanse <- function(refresh = FALSE) {
  cache_get(
    name = "driftsbalanse",
    refresh = refresh,
    fun = function() {
      ssb_get(
        url = "https://data.ssb.no/api/v0/no/table/09401",
        query = list(
          DriftKapita = "sal.saldodrift",
          ContentsCode = "DriftsKapital",
          Tid = "*"
        )
      ) |>
        dplyr::transmute(
          Aar = as.integer(.data$ar),
          Driftsbalanse =
            as.numeric(.data$drifts_og_kapitalregnskap)
        ) |>
        dplyr::filter(
          !is.na(.data$Driftsbalanse)
        ) |>
        dplyr::arrange(.data$Aar)
    }
  )
}
