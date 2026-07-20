

compare_series <- function(variables,
                           data = NULL,
                           base_year = NULL,
                           normalize = TRUE,
                           start_year = NULL,
                           complete_cases = FALSE) {
  if (is.null(data)) {
    data <- get_normacro()
  }
  
  metadata <- get_metadata(data)
  
  if ("Land" %in% names(data) &&
      dplyr::n_distinct(data$Land) > 1) {
    stop(
      paste0(
        "compare_series() kan sammenligne flere variabler for ett land om gangen. ",
        "Filtrer data til ett land først."
      ),
      call. = FALSE
    )
  }
  
  if ("Land" %in% names(data)) {
    data <- data |>
      dplyr::select(-Land)
  }
  
  missing <- setdiff(variables, names(data))
  
  if (length(missing) > 0) {
    stop("Fant ikke variabler i datasettet: ",
         paste(missing, collapse = ", "),
         call. = FALSE)
  }
  
  common_years <- data |>
    dplyr::select(Aar, dplyr::all_of(variables)) |>
    dplyr::filter(stats::complete.cases(dplyr::pick(dplyr::all_of(variables)))) |>
    dplyr::pull(Aar)
  
  if (complete_cases && length(common_years) == 0) {
    stop("Fant ingen år der alle valgte variabler har data.", call. = FALSE)
  }
  
  if (normalize &&
      is.null(base_year) &&
      is.null(start_year)) {
    if (length(common_years) == 0) {
      stop(
        paste0(
          "Fant ikke et felles basisår der alle valgte variabler har data. ",
          "Angi base_year eksplisitt eller bruk normalize = FALSE."
        ),
        call. = FALSE
      )
    }
    
    start_year <- min(common_years)
    base_year <- start_year
  }
  
  if (complete_cases && is.null(start_year)) {
    start_year <- min(common_years)
  }
  
  if (!is.null(start_year)) {
    data <- data |>
      dplyr::filter(.data$Aar >= start_year)
    
    if (is.null(base_year) && normalize) {
      base_year <- start_year
    }
  }
  
  if (normalize) {
    plot_data <- normalize_series(data = data,
                                  variables = variables,
                                  base_year = base_year)
    
    y_label <- if (is.null(base_year)) {
      "Indeks"
    } else {
      paste0("Indeks, ", base_year, " = 100")
    }
    
  } else {
    plot_data <- data |>
      dplyr::select(Aar, dplyr::all_of(variables))
    
    y_label <- NULL
  }
  
  display_lookup <- tibble::tibble(
    Variabel = variables,
    Display_navn = vapply(variables, get_display_name, character(1), metadata = metadata)
  )
  
  plot_data_long <- plot_data |>
    tidyr::pivot_longer(cols = -Aar,
                        names_to = "Variabel",
                        values_to = "Verdi") |>
    dplyr::left_join(display_lookup, by = "Variabel") |>
    dplyr::filter(!is.na(.data$Verdi))
  
  sources <- metadata |>
    dplyr::filter(.data$Variabel %in% variables) |>
    dplyr::pull(.data$Kilde) |>
    unique() |>
    stats::na.omit()
  
  caption <- if (length(sources) == 0) {
    NULL
  } else {
    paste0("Kilde: ", paste(sources, collapse = " / "))
  }
  
  ggplot2::ggplot(
    plot_data_long,
    ggplot2::aes(
      x = .data$Aar,
      y = .data$Verdi,
      colour = .data$Display_navn
    )
  ) +
    ggplot2::geom_line(linewidth = 0.9) +
    ggplot2::scale_x_continuous(
      breaks = scales::breaks_pretty(n = 8),
      labels = scales::label_number(accuracy = 1)
    ) +
    ggplot2::scale_y_continuous(labels = scales::label_number(big.mark = " ", decimal.mark = ",")) +
    ggplot2::labs(
      title = "Sammenligning av tidsserier",
      subtitle = paste(display_lookup$Display_navn, collapse = ", "),
      x = NULL,
      y = y_label,
      colour = NULL,
      caption = caption
    ) +
    ggplot2::theme_minimal()
}
