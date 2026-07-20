
get_pengemarkedsrente <- function(refresh = FALSE) {
  cache_get(
    name = "pengemarkedsrente",
    refresh = refresh,
    fun = function() {
      rente_raw <- ssb_get(
        url = "https://data.ssb.no/api/v0/no/table/bf/bf03/renter/SBMENU4005/NbFolioNibor",
        query = list(
          RenterNbNibor = "01",
          ContentsCode = "Renter",
          Tid = "*"
        )
      )
      
      rente_raw |>
        dplyr::transmute(Aar = as.integer(substr(maned, 1, 4)),
                         Pengemarkedsrente_3mnd = as.numeric(renter)) |>
        dplyr::filter(!is.na(Pengemarkedsrente_3mnd)) |>
        dplyr::group_by(Aar) |>
        dplyr::summarise(
          Pengemarkedsrente_3mnd = mean(Pengemarkedsrente_3mnd, na.rm = TRUE),
          .groups = "drop"
        ) |>
        dplyr::arrange(Aar)
    }
  )
}