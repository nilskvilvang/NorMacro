
#' Get general government gross debt
#'
#' Retrieves general government gross debt as a percentage of GDP
#' from Eurostat.
#'
#' Annual data from `gov_10dd_edpt1` are used as the primary source.
#' For countries not covered by the annual dataset, quarterly data from
#' `gov_10q_ggdebt` are used as a fallback, with the fourth-quarter
#' observation representing the annual value.
#'
#' Both sources use the Maastricht definition of consolidated general
#' government gross debt.
#'
#' @param countries Character vector of country codes. If `NULL`,
#'   the standard NorMacro country set is used.
#' @param refresh Logical. If `TRUE`, refresh cached data.
#'
#' @return A tibble with columns `Aar`, `Land` and
#'   `Offentlig_gjeld_andel_BNP`.

get_government_debt <- function(countries = NULL, refresh = FALSE) {
  cache_get(
    name = "international_government_debt",
    refresh = refresh,
    fun = function() {
      if (is.null(countries)) {
        countries <- get_standard_countries()
      }

      annual <- tryCatch(
        get_eurostat_data(
          id = "gov_10dd_edpt1",
          filters = list(
            unit = "PC_GDP",
            sector = "S13",
            na_item = "GD",
            geo = countries
          )
        ) |>
          dplyr::transmute(
            Aar = as.integer(format(.data$time, "%Y")),
            Land = .data$geo,
            Offentlig_gjeld_andel_BNP = .data$values
          ) |>
          dplyr::filter(
            !is.na(.data$Offentlig_gjeld_andel_BNP)
          ),
        error = function(e) {
          tibble::tibble(
            Aar = integer(),
            Land = character(),
            Offentlig_gjeld_andel_BNP = numeric()
          )
        }
      )

      missing_countries <- setdiff(
        countries,
        unique(annual$Land)
      )

      if (length(missing_countries) > 0L) {
        quarterly <- get_eurostat_data(
          id = "gov_10q_ggdebt",
          filters = list(
            unit = "PC_GDP",
            sector = "S13",
            na_item = "GD",
            geo = missing_countries
          )
        ) |>
          dplyr::filter(
            !is.na(.data$values),
            as.integer(format(.data$time, "%m")) == 10L
          ) |>
          dplyr::transmute(
            Aar = as.integer(format(.data$time, "%Y")),
            Land = .data$geo,
            Offentlig_gjeld_andel_BNP = .data$values
          )

        annual <- dplyr::bind_rows(
          annual,
          quarterly
        )
      }

      annual |>
        dplyr::arrange(
          .data$Land,
          .data$Aar
        )
    }
  )
}