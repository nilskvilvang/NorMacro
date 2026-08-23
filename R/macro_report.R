
#' Build a NorMacro macro report
#'
#' Creates a structured macroeconomic report object for a selected year.
#'
#' The report contains the estimated business-cycle phase and a table of
#' selected macroeconomic indicators. The returned object can be printed
#' directly or passed to [render_macro_report()] for document rendering.
#'
#' @param data Optional NorMacro dataset. If `NULL`, [get_normacro()] is used.
#' @param year Year to report. If `NULL`, the latest available year is used.
#'
#' @return An object of class `normacro_report`.
#'
#' @export

macro_report <- function(data = NULL, year = NULL) {
  if (is.null(data)) {
    data <- suppressMessages(get_normacro())
  }

  if (is.null(year)) {
    year <- max(data$Aar, na.rm = TRUE)
  }

  metadata <- get_metadata(data)

  cycle <- business_cycle(data = data) |>
    dplyr::filter(.data$Aar == year)

  get_value <- function(variable) {
    data |>
      dplyr::filter(.data$Aar == year) |>
      dplyr::pull(dplyr::all_of(variable)) |>
      dplyr::first()
  }

  key_vars <- c(
    "BNP_Fastland_vekst",
    "Inflasjon",
    "Arbeidsledighetsrate_NAV",
    "Styringsrente",
    "Pengemarkedsrente_3mnd",
    "Statsrente_10aar",
    "Rentekurve",
    "Industriproduksjon",
    "Byggeaktivitet",
    "Tjenesteproduksjon",
    "Detaljhandel",
    "Konjunkturindikator",
    "Kapasitetsutnytting",
    "Ressursknapphet",
    "Ordrebeholdning"
  )

  available <- intersect(key_vars, names(data))

  report_table <- tibble::tibble(Variabel = available,
                                 Verdi = purrr::map_dbl(available, get_value)) |>
    dplyr::left_join(
      metadata |>
        dplyr::select(Variabel, Display_navn, Kategori, Beskrivelse, Enhet, Kilde),
      by = "Variabel"
    ) |>
    dplyr::mutate(
      Display_navn = dplyr::if_else(
        is.na(.data$Display_navn) |
          .data$Display_navn == "",
        .data$Variabel,
        .data$Display_navn
      )
    ) |>
    dplyr::select(Display_navn, Verdi, Enhet, Kategori, Kilde, Variabel)

  plot_data <- data |>
    dplyr::filter(.data$Aar >= 2000)

  activity_plot <- plot_series(variable = "BNP_Fastland_vekst", data = plot_data)

  prices_rates_plot <- compare_series(
    variables = c("Inflasjon", "Styringsrente", "Pengemarkedsrente_3mnd"),
    data = data,
    normalize = FALSE,
    start_year = 2000
  )

  result <- list(
    year = year,
    business_cycle = cycle,
    key_indicators = report_table,
    plots = list(activity = activity_plot, prices_rates = prices_rates_plot)
  )

  class(result) <- "normacro_report"

  result
}
