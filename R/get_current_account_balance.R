
get_current_account_balance <- function(
    countries = NULL,
    refresh = FALSE
) {

  cache_get(
    name = "international_current_account_balance",
    refresh = refresh,
    fun = function() {

      if (is.null(countries)) {
        countries <- get_standard_countries()
      }

      country_map <- c(
        NO = "NOR",
        SE = "SWE",
        DK = "DNK",
        FI = "FIN",
        DE = "DEU",
        FR = "FRA"
      )

      supported_countries <- intersect(
        countries,
        names(country_map)
      )

      if (length(supported_countries) == 0L) {
        return(
          tibble::tibble(
            Aar = integer(),
            Land = character(),
            Driftsbalanse_andel_BNP = numeric()
          )
        )
      }

      oecd_countries <- unname(
        country_map[supported_countries]
      )

      key <- paste0(
        paste(
          oecd_countries,
          collapse = "+"
        ),
        ".CBGDPR.A"
      )

      get_oecd_data(
        dataset = "OECD.ECO.MAD,DSD_EO@DF_EO",
        key = key,
        start_period = 1960
      ) |>
        dplyr::filter(
          !is.na(.data$OBS_VALUE),
          .data$TIME_PERIOD <= 2025
        ) |>
        dplyr::transmute(
          Aar = as.integer(.data$TIME_PERIOD),
          Land = names(country_map)[
            match(
              .data$REF_AREA,
              country_map
            )
          ],
          Driftsbalanse_andel_BNP =
            as.numeric(.data$OBS_VALUE)
        ) |>
        dplyr::filter(
          !is.na(.data$Land)
        ) |>
        dplyr::arrange(
          .data$Land,
          .data$Aar
        )
    }
  )
}
