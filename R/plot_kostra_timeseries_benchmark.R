
plot_kostra_timeseries_benchmark <- function(
    variable,
    data = NULL,
    unit,
    start_year = NULL,
    end_year = NULL,
    descending = TRUE,
    comparison = c(
      "data",
      "kostra_group",
      "county",
      "custom"
    ),
    comparison_units = NULL,
    comparison_name = NULL,
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
      "`unit` m\u00e5 angi \u00e9n gyldig KOSTRA-enhet.",
      call. = FALSE
    )
  }
  
  if (
    comparison == "data" &&
    is.null(data)
  ) {
    stop(
      "`data` m\u00e5 oppgis n\u00e5r `comparison = \"data\"`.",
      call. = FALSE
    )
  }
  
  if (
    comparison == "data" &&
    !is.data.frame(data)
  ) {
    stop(
      "`data` m\u00e5 v\u00e6re et datasett.",
      call. = FALSE
    )
  }
  
  # ------------------------------------------------------------
  # Benchmark
  # ------------------------------------------------------------
  
  benchmark <- kostra_timeseries_benchmark(
    variable = variable,
    data = data,
    unit = unit,
    start_year = start_year,
    end_year = end_year,
    descending = descending,
    comparison = comparison,
    comparison_units = comparison_units,
    comparison_name = comparison_name,
    table = table
  )
  
  # ------------------------------------------------------------
  # Metadata
  # ------------------------------------------------------------
  
  display_name <- attr(
    benchmark,
    "display_name"
  )
  
  if (
    is.null(display_name) ||
    length(display_name) == 0L ||
    is.na(display_name) ||
    display_name == ""
  ) {
    display_name <- stringr::str_to_sentence(
      gsub(
        "_",
        " ",
        variable
      )
    )
  }
  
  measure_unit <- attr(
    benchmark,
    "unit"
  )
  
  if (
    is.null(measure_unit) ||
    length(measure_unit) == 0L ||
    is.na(measure_unit) ||
    measure_unit == ""
  ) {
    measure_unit <- NULL
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
  
  # ------------------------------------------------------------
  # Comparison label
  # ------------------------------------------------------------
  
  comparison_group_name <- attr(
    benchmark,
    "comparison_group_name"
  )
  
  comparison_label <- switch(
    comparison,
    
    data = NULL,
    
    kostra_group = comparison_group_name,
    
    county = if (
      !is.null(comparison_group_name) &&
      length(comparison_group_name) > 0L &&
      !is.na(comparison_group_name) &&
      comparison_group_name != ""
    ) {
      paste0(
        "Fylke: ",
        comparison_group_name
      )
    } else {
      "Fylke"
    },
    
    custom = if (
      !is.null(comparison_group_name) &&
      length(comparison_group_name) > 0L &&
      !is.na(comparison_group_name) &&
      comparison_group_name != ""
    ) {
      comparison_group_name
    } else {
      "Egendefinert gruppe"
    }
  )
  
  # ------------------------------------------------------------
  # Benchmarkreferansen gir først mening når minst
  # to enheter har observasjon samme år.
  # ------------------------------------------------------------
  
  reference_data <- benchmark |>
    dplyr::filter(
      .data$Antall_enheter >= 2L
    )
  
  # ------------------------------------------------------------
  # Caption
  # ------------------------------------------------------------
  
  kostra_table <- attr(
    benchmark,
    "kostra_table"
  )
  
  if (
    is.null(kostra_table) ||
    length(kostra_table) == 0L ||
    is.na(kostra_table) ||
    kostra_table == ""
  ) {
    kostra_table <- table
  }
  
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
  
  # ------------------------------------------------------------
  # Subtitle
  # ------------------------------------------------------------
  
  subtitle <- paste0(
    selected_name,
    " - ",
    first_year,
    "-",
    last_year
  )
  
  if (
    !is.null(comparison_label) &&
    length(comparison_label) > 0L &&
    !is.na(comparison_label) &&
    comparison_label != ""
  ) {
    subtitle <- paste0(
      subtitle,
      " | ",
      comparison_label
    )
  }
  
  # ------------------------------------------------------------
  # Year axis
  # ------------------------------------------------------------
  
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
    tail(
      year_breaks,
      1
    ) != year_range[[2]]
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
  
  # ------------------------------------------------------------
  # Plot
  # ------------------------------------------------------------
  
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



