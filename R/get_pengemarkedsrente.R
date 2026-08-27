
get_pengemarkedsrente <- function(refresh = FALSE) {
  cache_get(
    name = "pengemarkedsrente",
    refresh = refresh,
    fun = function() {

      # Norwegian 3-month NIBOR from Statistics Norway.
      ssb_rate <- ssb_get(
        url = paste0(
          "https://data.ssb.no/api/v0/no/table/",
          "bf/bf03/renter/SBMENU4005/NbFolioNibor"
        ),
        query = list(
          RenterNbNibor = "01",
          ContentsCode = "Renter",
          Tid = "*"
        )
      ) |>
        dplyr::transmute(
          Aar = as.integer(substr(.data$maned, 1, 4)),
          Pengemarkedsrente_3mnd = as.numeric(.data$renter)
        ) |>
        dplyr::filter(
          !is.na(.data$Pengemarkedsrente_3mnd)
        ) |>
        dplyr::group_by(.data$Aar) |>
        dplyr::summarise(
          Pengemarkedsrente_3mnd = mean(
            .data$Pengemarkedsrente_3mnd,
            na.rm = TRUE
          ),
          .groups = "drop"
        ) |>
        dplyr::arrange(.data$Aar)

      # OECD is used to extend the Norwegian series backwards
      # before the SSB NIBOR series begins.
      first_ssb_year <- min(ssb_rate$Aar)

      oecd_rate <- get_short_interest_rate(
        countries = "NO",
        refresh = refresh
      ) |>
        dplyr::filter(
          .data$Aar < first_ssb_year
        ) |>
        dplyr::select(
          .data$Aar,
          .data$Pengemarkedsrente_3mnd
        )

      dplyr::bind_rows(
        oecd_rate,
        ssb_rate
      ) |>
        dplyr::arrange(.data$Aar)
    }
  )
}
