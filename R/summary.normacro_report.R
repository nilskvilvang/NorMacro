
#' Summarise a NorMacro macro report
#'
#' @param object A `normacro_report` object.
#' @param ... Additional arguments.
#'
#' @return An object of class `summary_normacro_report`.
#'
#' @export

summary.normacro_report <- function(
    object,
    ...
) {
  indicators <- object$key_indicators

  get_indicator <- function(variable) {
    row <- indicators |>
      dplyr::filter(
        .data$Variabel == variable
      )

    if (
      nrow(row) == 0L ||
      is.na(row$Verdi[[1]])
    ) {
      return(NULL)
    }

    row[1, , drop = FALSE]
  }

  format_value <- function(row) {
    if (is.null(row)) {
      return(NULL)
    }

    value <- row$Verdi[[1]]
    unit <- row$Enhet[[1]]

    paste0(
      formatC(
        value,
        format = "f",
        digits = 1,
        decimal.mark = ","
      ),
      if (
        !is.na(unit) &&
        unit != ""
      ) {
        paste0(
          " ",
          tolower(unit)
        )
      } else {
        ""
      }
    )
  }

  gdp <- get_indicator(
    "BNP_Fastland_vekst"
  )

  inflation <- get_indicator(
    "Inflasjon"
  )

  unemployment <- get_indicator(
    "Arbeidsledighetsrate_NAV"
  )

  policy_rate <- get_indicator(
    "Styringsrente"
  )

  yield_curve <- get_indicator(
    "Rentekurve"
  )

  cycle <- object$business_cycle

  paragraphs <- character()

  if (nrow(cycle) > 0L) {
    paragraphs <- c(
      paragraphs,
      paste0(
        "NorMacro klassifiserer konjunktursituasjonen i ",
        object$year,
        " som ",
        tolower(
          cycle$Fase[[1]]
        ),
        "."
      )
    )
  }

  if (!is.null(gdp)) {

    gdp_value <- gdp$Verdi[[1]]

    if (gdp_value >= 0) {

      gdp_text <- paste0(
        "BNP Fastlands-Norge vokste med ",
        format_value(gdp),
        "."
      )

    } else {

      gdp_positive <- gdp
      gdp_positive$Verdi[[1]] <- abs(
        gdp_value
      )

      gdp_text <- paste0(
        "BNP Fastlands-Norge falt med ",
        format_value(gdp_positive),
        "."
      )
    }

    paragraphs <- c(
      paragraphs,
      gdp_text
    )
  }

  labour_price_parts <- character()

  if (!is.null(inflation)) {
    labour_price_parts <- c(
      labour_price_parts,
      paste0(
        "Inflasjonen var ",
        format_value(inflation)
      )
    )
  }

  if (!is.null(unemployment)) {
    labour_price_parts <- c(
      labour_price_parts,
      paste0(
        "NAV-ledigheten var ",
        format_value(unemployment)
      )
    )
  }

  if (length(labour_price_parts) > 0L) {
    paragraphs <- c(
      paragraphs,
      paste0(
        paste(
          labour_price_parts,
          collapse = ", mens "
        ),
        "."
      )
    )
  }

  rate_parts <- character()

  if (!is.null(policy_rate)) {
    rate_parts <- c(
      rate_parts,
      paste0(
        "Styringsrenten var ",
        format_value(policy_rate)
      )
    )
  }

  if (!is.null(yield_curve)) {
    rate_parts <- c(
      rate_parts,
      paste0(
        "rentekurven var ",
        format_value(yield_curve)
      )
    )
  }

  if (length(rate_parts) > 0L) {
    paragraphs <- c(
      paragraphs,
      paste0(
        paste(
          rate_parts,
          collapse = ", og "
        ),
        "."
      )
    )
  }

  result <- list(
    year = object$year,
    text = paragraphs
  )

  class(
    result
  ) <- "summary_normacro_report"

  result
}
