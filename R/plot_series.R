
plot_series <- function(
    variable,
    data = NULL,
    metadata = NULL,
    countries = NULL
) {
  
  if (is.null(data)) {
    data <- get_normacro()
  }
  
  if (is.null(metadata)) {
    metadata <- get_metadata(data)
  }
  
  if (!variable %in% names(data)) {
    stop("Fant ikke variabelen i datasettet: ", variable)
  }
  
  has_country <- "Land" %in% names(data)
  
  if (has_country && !is.null(countries)) {
    missing_countries <- setdiff(countries, unique(data$Land))
    
    if (length(missing_countries) > 0) {
      stop(
        "Fant ikke land i datasettet: ",
        paste(missing_countries, collapse = ", ")
      )
    }
    
    data <- data |>
      dplyr::filter(.data$Land %in% countries)
  }
  
  meta <- metadata |>
    dplyr::filter(.data$Variabel == variable)
  
  if (nrow(meta) == 0) {
    title <- variable
    subtitle <- NULL
    y_label <- NULL
    caption <- NULL
  } else {
    title <- meta$Display_navn[1]
    subtitle <- meta$Beskrivelse[1]
    y_label <- meta$Enhet[1]
    caption <- paste0("Kilde: ", meta$Kilde[1])
    
    if (is.na(title) || title == "") {
      title <- variable
    }
  }
  
  if (has_country) {
    
    plot_data <- data |>
      dplyr::select(
        Aar,
        Land,
        Verdi = dplyr::all_of(variable)
      ) |>
      dplyr::filter(!is.na(.data$Verdi))
    
    p <- ggplot2::ggplot(
      plot_data,
      ggplot2::aes(
        x = .data$Aar,
        y = .data$Verdi,
        colour = .data$Land,
        group = .data$Land
      )
    ) +
      ggplot2::geom_line(linewidth = 0.9) +
      ggplot2::labs(colour = NULL)
    
  } else {
    
    plot_data <- data |>
      dplyr::select(
        Aar,
        Verdi = dplyr::all_of(variable)
      ) |>
      dplyr::filter(!is.na(.data$Verdi))
    
    p <- ggplot2::ggplot(
      plot_data,
      ggplot2::aes(
        x = .data$Aar,
        y = .data$Verdi
      )
    ) +
      ggplot2::geom_line(linewidth = 0.9)
  }
  
  p <- p +
    ggplot2::scale_x_continuous(
      breaks = scales::breaks_pretty(n = 8),
      labels = scales::label_number(accuracy = 1)
    ) +
    ggplot2::scale_y_continuous(
      labels = scales::label_number(
        big.mark = " ",
        decimal.mark = ","
      )
    ) +
    ggplot2::labs(
      title = title,
      subtitle = subtitle,
      x = NULL,
      y = y_label,
      caption = caption
    ) +
    ggplot2::theme_minimal()
  
  if (
    grepl(
      "vekst|inflasjon|rente|rentekurve|andel",
      variable,
      ignore.case = TRUE
    )
  ) {
    p <- p +
      ggplot2::geom_hline(
        yintercept = 0,
        linetype = "dashed",
        linewidth = 0.3
      )
  }
  
  p
}
