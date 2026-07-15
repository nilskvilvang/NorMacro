
plot.comparison_series <- function(
    x,
    normalize = FALSE,
    base_year = NULL,
    ...
) {
  
  plot_data <- x
  
  if (normalize) {
    
    available_years <- plot_data |>
      dplyr::filter(!is.na(.data$Verdi)) |>
      dplyr::group_by(.data$Serie_id) |>
      dplyr::summarise(
        years = list(.data$Aar),
        .groups = "drop"
      )
    
    common_years <- Reduce(
      intersect,
      available_years$years
    )
    
    if (length(common_years) == 0) {
      stop(
        "Fant ikke et felles basisår der alle seriene har data.",
        call. = FALSE
      )
    }
    
    if (is.null(base_year)) {
      base_year <- min(common_years)
    }
    
    if (!base_year %in% common_years) {
      stop(
        "Alle seriene må ha data i valgt basisår: ",
        base_year,
        call. = FALSE
      )
    }
    
    base_values <- plot_data |>
      dplyr::filter(
        .data$Aar == base_year
      ) |>
      dplyr::select(
        Serie_id,
        Basisverdi = Verdi
      )
    
    if (any(is.na(base_values$Basisverdi))) {
      stop(
        "Én eller flere serier mangler verdi i valgt basisår.",
        call. = FALSE
      )
    }
    
    if (any(base_values$Basisverdi == 0)) {
      stop(
        "Kan ikke normalisere fordi én eller flere serier har verdien 0 i basisåret.",
        call. = FALSE
      )
    }
    
    plot_data <- plot_data |>
      dplyr::left_join(
        base_values,
        by = "Serie_id"
      ) |>
      dplyr::mutate(
        Verdi_plot = 100 * .data$Verdi / .data$Basisverdi
      )
    
    y_label <- paste0(
      "Indeks, ",
      base_year,
      " = 100"
    )
    
  } else {
    
    units <- unique(
      stats::na.omit(plot_data$Enhet)
    )
    
    if (length(units) > 1) {
      stop(
        paste0(
          "Seriene har ulike enheter og kan ikke vises på samme akse. ",
          "Bruk normalize = TRUE eller velg serier med samme enhet."
        ),
        call. = FALSE
      )
    }
    
    plot_data <- plot_data |>
      dplyr::mutate(
        Verdi_plot = .data$Verdi
      )
    
    y_label <- if (length(units) == 0) {
      NULL
    } else {
      units[1]
    }
  }
  
  plot_data <- plot_data |>
    dplyr::mutate(
      Serie_navn = paste0(
        .data$Land,
        " – ",
        .data$Display_navn
      )
    )
  
  source_text <- plot_data |>
    dplyr::distinct(.data$Kilde) |>
    dplyr::filter(
      !is.na(.data$Kilde),
      .data$Kilde != ""
    ) |>
    dplyr::pull(.data$Kilde)
  
  caption <- if (length(source_text) == 0) {
    NULL
  } else {
    paste0(
      "Kilde: ",
      paste(source_text, collapse = " / ")
    )
  }
  
  ggplot2::ggplot(
    plot_data,
    ggplot2::aes(
      x = .data$Aar,
      y = .data$Verdi_plot,
      colour = .data$Serie_navn
    )
  ) +
    ggplot2::geom_line(
      linewidth = 0.9,
      na.rm = TRUE
    ) +
    ggplot2::scale_x_continuous(
      breaks = scales::breaks_pretty(n = 8),
      labels = scales::label_number(
        accuracy = 1
      )
    ) +
    ggplot2::scale_y_continuous(
      labels = scales::label_number(
        big.mark = " ",
        decimal.mark = ","
      )
    ) +
    ggplot2::labs(
      title = "Sammenligning av tidsserier",
      subtitle = paste(
        unique(plot_data$Serie_navn),
        collapse = ", "
      ),
      x = NULL,
      y = y_label,
      colour = NULL,
      caption = caption
    ) +
    ggplot2::theme_minimal()
}
