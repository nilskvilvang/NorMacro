
get_aksjekursindeks <- function(refresh = FALSE) {

  cache_get(
    name = "aksjekursindeks",
    refresh = refresh,
    fun = function() {

      # Historical Norwegian stock price index from Norges Bank
      # Historical Monetary Statistics (HMFS), Table A1.
      #
      # The aggregate "Total" price index is annualised as the
      # arithmetic mean of available monthly observations.
      # The static file covers 1914–2000.
      hmfs <- readr::read_delim(
        system.file(
          "extdata",
          "aksjekurs_hmfs.csv",
          package = "NorMacro"
        ),
        delim = ";",
        show_col_types = FALSE
      ) |>
        dplyr::mutate(
          Aar = as.integer(.data$Aar)
        ) |>
        dplyr::arrange(.data$Aar) |>
        dplyr::mutate(
          Aksjekursindeks_vekst = (
            .data$Aksjekursindeks /
              dplyr::lag(.data$Aksjekursindeks) - 1
          ) * 100
        ) |>
        dplyr::select(
          .data$Aar,
          Aksjekursindeks_vekst = .data$Aksjekursindeks_vekst
        )

      # OECD share price index for Norway.
      #
      # Annual observations are used from 2000 onwards so that
      # the 2001 growth rate is calculated entirely within the
      # OECD series. The OECD index has base year 2015 = 100.
      oecd <- get_oecd_data(
        dataset = "OECD.SDD.STES,DSD_STES@DF_FINMARK,4.0",
        key = "NOR.A.SHARE.IX.....",
        start_period = 2000
      ) |>
        dplyr::filter(
          !is.na(.data$OBS_VALUE)
        ) |>
        dplyr::transmute(
          Aar = as.integer(.data$TIME_PERIOD),
          OECD = as.numeric(.data$OBS_VALUE)
        ) |>
        dplyr::arrange(.data$Aar) |>
        dplyr::mutate(
          Aksjekursindeks_vekst = (
            .data$OECD /
              dplyr::lag(.data$OECD) - 1
          ) * 100
        ) |>
        dplyr::filter(
          .data$Aar >= 2001
        ) |>
        dplyr::select(
          .data$Aar,
          .data$Aksjekursindeks_vekst
        )

      # Combine the historical HMFS growth rates with OECD growth
      # rates and chain them into one continuous index.
      #
      # The chained index is rebased to 2015 = 100. From 2001
      # onwards this reproduces the OECD share price index.
      result <- dplyr::bind_rows(
        hmfs,
        oecd
      ) |>
        dplyr::arrange(.data$Aar) |>
        dplyr::mutate(
          index_raw = cumprod(
            dplyr::if_else(
              is.na(.data$Aksjekursindeks_vekst),
              1,
              1 + .data$Aksjekursindeks_vekst / 100
            )
          )
        )

      base_2015 <- result |>
        dplyr::filter(.data$Aar == 2015L) |>
        dplyr::pull(.data$index_raw)

      result |>
        dplyr::mutate(
          Aksjekursindeks =
            .data$index_raw / base_2015 * 100
        ) |>
        dplyr::select(
          .data$Aar,
          .data$Aksjekursindeks,
          .data$Aksjekursindeks_vekst
        )
    }
  )
}
