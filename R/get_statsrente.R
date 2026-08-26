get_statsrente_hmfs <- function() {
  path <- system.file("extdata", "statsrente_hmfs.csv", package = "NorMacro")

  if (!nzchar(path) || !file.exists(path)) {
    stop("Fant ikke historisk statsrenteserie fra HMFS.", call. = FALSE)
  }

  readr::read_csv(path, show_col_types = FALSE) |>
    dplyr::transmute(
      Aar = as.integer(.data$Aar),
      Statsrente_10aar =
        as.numeric(.data$Statsrente_10aar)
    ) |>
    dplyr::filter(.data$Aar <= 1984L, !is.na(.data$Statsrente_10aar))
}


get_statsrente_oecd <- function() {
  get_oecd_data(dataset = "OECD.SDD.STES,DSD_STES@DF_FINMARK,4.0",
                key = "NOR.A.IRLT.PA.....",
                start_period = 1985) |>
    dplyr::filter(!is.na(.data$OBS_VALUE)) |>
    dplyr::transmute(
      Aar = as.integer(.data$TIME_PERIOD),
      Statsrente_10aar =
        as.numeric(.data$OBS_VALUE)
    ) |>
    dplyr::filter(.data$Aar >= 1985L, .data$Aar <= 2018L)
}


get_statsrente_norges_bank <- function() {
  url_statsrente <- paste0(
    "https://data.norges-bank.no/api/data/",
    "GOVT_GENERIC_RATES/A.10Y.GBON.?",
    "format=csv&lastNObservations=100&locale=no&bom=include"
  )

  statsrente_raw <- rio::import(url_statsrente, format = "csv")

  statsrente_raw |>
    dplyr::transmute(
      Aar = as.integer(.data$TIME_PERIOD),
      Statsrente_10aar = readr::parse_number(.data$OBS_VALUE, locale = readr::locale(decimal_mark = ","))
    ) |>
    dplyr::filter(.data$Aar >= 2019L, !is.na(.data$Statsrente_10aar))
}


#' Get Norwegian 10-year government bond yield
#'
#' Returns an annual historical series for the Norwegian 10-year
#' government bond yield.
#'
#' The series combines three sources:
#'
#' * 1921–1984: Norges Bank Historical Monetary and Financial
#'   Statistics (HMFS), Table A3, `ST10`.
#' * 1985–2018: OECD long-term government bond yield for Norway.
#' * 2019 onwards: Norges Bank generic 10-year government bond yield.
#'
#' Overlapping periods between the sources have been checked for
#' consistency. No level adjustment is applied at the source breaks.
#'
#' @param refresh Logical. If `TRUE`, refresh cached data.
#'
#' @return A tibble with columns `Aar` and `Statsrente_10aar`.
#'

get_statsrente <- function(refresh = FALSE) {
  cache_get(
    name = "statsrente",
    refresh = refresh,
    fun = function() {
      hmfs <- get_statsrente_hmfs()
      oecd <- get_statsrente_oecd()
      norges_bank <- get_statsrente_norges_bank()

      dplyr::bind_rows(hmfs, oecd, norges_bank) |>
        dplyr::arrange(.data$Aar)
    }
  )
}
