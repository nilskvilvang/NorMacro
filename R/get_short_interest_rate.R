
get_short_interest_rate <- function(
    countries = NULL,
    refresh = FALSE
) {
  
  cache_get(
    name = "international_short_interest_rate",
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
        FR = "FRA",
        EA20 = "EA20"
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
            Pengemarkedsrente_3mnd = numeric()
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
        ".A.IR3TIB......"
      )
      
      get_oecd_data(
        dataset = "OECD.SDD.STES,DSD_STES@DF_FINMARK,4.0",
        key = key,
        start_period = 1960
      ) |>
        dplyr::filter(
          !is.na(.data$OBS_VALUE)
        ) |>
        dplyr::transmute(
          Aar = as.integer(.data$TIME_PERIOD),
          Land = names(country_map)[
            match(
              .data$REF_AREA,
              country_map
            )
          ],
          Pengemarkedsrente_3mnd =
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
