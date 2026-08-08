
plot_kostra_timeseries_benchmark <- function(
    variable,
    data = NULL,
    unit,
    start_year = NULL,
    end_year = NULL,
    descending = TRUE,
    comparison = c(
      "data",
      "kostra_group"
    ),
    table = "12134"
) {
  
  comparison <- match.arg(
    comparison
  )
  
  if (
    !is.character(unit) ||
    length(unit) != 1L ||
    is.na(unit) ||
    unit == ""
  ) {
    stop(
      "`unit` må angi én gyldig KOSTRA-enhet.",
      call. = FALSE
    )
  }
  
  if (comparison == "kostra_group") {
    
    return(
      plot_kostra_timeseries_benchmark_peer_group(
        variable = variable,
        unit = unit,
        start_year = start_year,
        end_year = end_year,
        descending = descending,
        table = table
      )
    )
  }
  
  if (is.null(data)) {
    stop(
      "`data` må oppgis når `comparison = \"data\"`.",
      call. = FALSE
    )
  }
  
  if (!is.data.frame(data)) {
    stop(
      "`data` må være et datasett.",
      call. = FALSE
    )
  }
  
  if (!is.data.frame(data)) {
    stop(
      "`data` må være et datasett.",
      call. = FALSE
    )
  }
  
  benchmark <- kostra_timeseries_benchmark(
    variable = variable,
    data = data,
    unit = unit,
    start_year = start_year,
    end_year = end_year,
    descending = descending
  )
  
  metadata <- get_metadata(data)
  
  meta <- metadata |>
    dplyr::filter(
      .data$Variabel == variable
    )
  
  display_name <- if (
    nrow(meta) > 0L &&
    "Display_navn" %in% names(meta)
  ) {
    meta$Display_navn[[1]]
  } else {
    stringr::str_to_sentence(
      gsub(
        "_",
        " ",
        variable
      )
    )
  }
  
  measure_unit <- if (
    nrow(meta) > 0L &&
    "Enhet" %in% names(meta)
  ) {
    meta$Enhet[[1]]
  } else {
    NULL
  }
  
  selected_name <- benchmark$Enhet_navn[[1]]
  
  selected_name <- sub(
    "\\s+-\\s+.*$",
    "",
    selected_name
  )
  
  first_year <- min(
    benchmark$Aar,
    na.rm = TRUE
  )
  
  last_year <- max(
    benchmark$Aar,
    na.rm = TRUE
  )
  
  # Benchmarkreferansen gir først mening når minst
  # to enheter har observasjon samme år.
  
  reference_data <- benchmark |>
    dplyr::filter(
      .data$Antall_enheter >= 2L
    )
  
  kostra_table <- attr(
    data,
    "kostra_table"
  )
  
  caption <- "Kilde: SSB KOSTRA"
  
  if (
    !is.null(kostra_table) &&
    length(kostra_table) > 0L &&
    !is.na(kostra_table) &&
    kostra_table != ""
  ) {
    caption <- paste0(
      caption,
      ", tabell ",
      kostra_table
    )
  }
  
  subtitle <- paste0(
    selected_name,
    " - ",
    first_year,
    "-",
    last_year
  )
  
  year_range <- range(
    benchmark$Aar,
    na.rm = TRUE
  )
  
  year_span <- diff(
    year_range
  )
  
  year_step <- if (year_span <= 12) {
    1
  } else if (year_span <= 25) {
    2
  } else if (year_span <= 50) {
    5
  } else {
    10
  }
  
  year_breaks <- seq(
    from = year_range[[1]],
    to = year_range[[2]],
    by = year_step
  )
  
  if (
    tail(year_breaks, 1) !=
    year_range[[2]]
  ) {
    year_breaks <- sort(
      unique(
        c(
          year_breaks,
          year_range[[2]]
        )
      )
    )
  }
  
  p <- ggplot2::ggplot(
    benchmark,
    ggplot2::aes(
      x = .data$Aar
    )
  )
  
  # ------------------------------------------------------------
  # Benchmark distribution
  # ------------------------------------------------------------
  
  if (nrow(reference_data) > 0L) {
    
    p <- p +
      ggplot2::geom_ribbon(
        data = reference_data,
        ggplot2::aes(
          x = .data$Aar,
          ymin = .data$Q1,
          ymax = .data$Q3,
          fill = "Midtre 50 %"
        ),
        inherit.aes = FALSE,
        alpha = 0.15
      ) +
      ggplot2::geom_line(
        data = reference_data,
        ggplot2::aes(
          x = .data$Aar,
          y = .data$Median,
          linetype = "Median"
        ),
        inherit.aes = FALSE,
        linewidth = 0.7
      )
  }
  
  # ------------------------------------------------------------
  # Selected KOSTRA unit
  # ------------------------------------------------------------
  
  p <- p +
    ggplot2::geom_line(
      ggplot2::aes(
        y = .data$Verdi
      ),
      linewidth = 1
    ) +
    ggplot2::geom_point(
      ggplot2::aes(
        y = .data$Verdi
      ),
      size = 2
    ) +
    ggplot2::scale_x_continuous(
      breaks = year_breaks,
      labels = scales::label_number(
        accuracy = 1,
        big.mark = ""
      )
    ) +
    ggplot2::scale_y_continuous(
      labels = scales::label_number(
        big.mark = " ",
        decimal.mark = ","
      )
    )
  
  # ------------------------------------------------------------
  # Benchmark legend
  # ------------------------------------------------------------
  
  if (nrow(reference_data) > 0L) {
    
    p <- p +
      ggplot2::scale_fill_manual(
        values = c(
          "Midtre 50 %" = "grey50"
        )
      ) +
      ggplot2::scale_linetype_manual(
        values = c(
          "Median" = "dashed"
        )
      )
  }
  
  # ------------------------------------------------------------
  # Labels and theme
  # ------------------------------------------------------------
  
  p <- p +
    ggplot2::labs(
      title = display_name,
      subtitle = subtitle,
      x = NULL,
      y = measure_unit,
      fill = NULL,
      linetype = NULL,
      caption = caption
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      legend.position = "bottom"
    )
  
  p
}

