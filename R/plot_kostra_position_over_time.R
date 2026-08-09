
plot_kostra_position_over_time <- function(
    variable,
    data = NULL,
    unit,
    start_year = NULL,
    end_year = NULL,
    metric = c(
      "percentile",
      "rank"
    ),
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
  
  metric <- match.arg(
    metric
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
    !is.logical(descending) ||
    length(descending) != 1L ||
    is.na(descending)
  ) {
    stop(
      "`descending` m\u00e5 v\u00e6re `TRUE` eller `FALSE`.",
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
  
  selected_name <- benchmark$Enhet_navn[[1]]
  
  selected_name <- sub("\\s+-\\s+.*$", "", selected_name)
  
  # ------------------------------------------------------------
  # Metadata
  # ------------------------------------------------------------
  
  display_name <- attr(benchmark, "display_name")
  
  if (is.null(display_name) ||
      length(display_name) == 0L ||
      is.na(display_name) ||
      display_name == "") {
    display_name <- stringr::str_to_sentence(gsub("_", " ", variable))
  }
  
  # ------------------------------------------------------------
  # Keep only years with a meaningful comparison group
  # ------------------------------------------------------------
  
  if (metric == "percentile") {
    plot_data <- benchmark |>
      dplyr::filter(!is.na(.data$Percentil), .data$Antall_enheter >= 2L)
    
    if (nrow(plot_data) == 0L) {
      stop(
        paste0(
          "Fant ingen \u00e5r med tilstrekkelig ",
          "sammenligningsgrunnlag for percentil."
        ),
        call. = FALSE
      )
    }
    
  } else {
    plot_data <- benchmark |>
      dplyr::filter(.data$Antall_enheter >= 2L, !is.na(.data$Rang))
    
    if (nrow(plot_data) == 0L) {
      stop(
        paste0(
          "Fant ingen \u00e5r med tilstrekkelig ",
          "sammenligningsgrunnlag for rangering."
        ),
        call. = FALSE
      )
    }
  }
  
  # ------------------------------------------------------------
  # Time period and comparison group
  # ------------------------------------------------------------
  
  first_year <- min(plot_data$Aar, na.rm = TRUE)
  
  last_year <- max(plot_data$Aar, na.rm = TRUE)
  
  min_units <- min(plot_data$Antall_enheter, na.rm = TRUE)
  
  max_units <- max(plot_data$Antall_enheter, na.rm = TRUE)
  
  comparison_text <- if (min_units == max_units) {
    paste0(min_units, " enheter")
  } else {
    paste0(min_units, "-", max_units, " enheter over perioden")
  }
  
  comparison_group_name <- attr(benchmark, "comparison_group_name")
  
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
  
  subtitle <- paste0(selected_name,
                     " - ",
                     first_year,
                     "-",
                     last_year,
                     " - ",
                     comparison_text)
  
  if (!is.null(comparison_label) &&
      length(comparison_label) > 0L &&
      !is.na(comparison_label) &&
      comparison_label != "") {
    subtitle <- paste0(subtitle, " | ", comparison_label)
  }
  
  # ------------------------------------------------------------
  # Source
  # ------------------------------------------------------------
  
  kostra_table <- attr(benchmark, "kostra_table")
  
  if (is.null(kostra_table) ||
      length(kostra_table) == 0L ||
      is.na(kostra_table) ||
      kostra_table == "") {
    kostra_table <- table
  }
  
  caption <- "Kilde: SSB KOSTRA"
  
  if (!is.null(kostra_table) &&
      length(kostra_table) > 0L &&
      !is.na(kostra_table) &&
      kostra_table != "") {
    caption <- paste0(caption, ", tabell ", kostra_table)
  }
  
  # ------------------------------------------------------------
  # Year axis
  # ------------------------------------------------------------
  
  year_range <- range(plot_data$Aar, na.rm = TRUE)
  
  year_span <- diff(year_range)
  
  year_step <- if (year_span <= 12) {
    1
  } else if (year_span <= 25) {
    2
  } else if (year_span <= 50) {
    5
  } else {
    10
  }
  
  year_breaks <- seq(from = year_range[[1]], to = year_range[[2]], by = year_step)
  
  if (tail(year_breaks, 1) != year_range[[2]]) {
    year_breaks <- sort(unique(c(year_breaks, year_range[[2]])))
  }
  
  # ------------------------------------------------------------
  # Percentile
  # ------------------------------------------------------------
  
  if (metric == "percentile") {
    p <- ggplot2::ggplot(plot_data, ggplot2::aes(x = .data$Aar, y = .data$Percentil)) +
      ggplot2::geom_hline(
        yintercept = 50,
        linetype = "dashed",
        linewidth = 0.6,
        alpha = 0.7
      ) +
      ggplot2::geom_line(linewidth = 1) +
      ggplot2::geom_point(size = 2.5) +
      ggplot2::scale_y_continuous(limits = c(0, 100),
                                  breaks = c(0, 25, 50, 75, 100)) +
      ggplot2::labs(
        title = paste0(display_name, " - percentil over tid"),
        subtitle = subtitle,
        x = NULL,
        y = "Percentil",
        caption = caption
      )
    
  } else {
    # ----------------------------------------------------------
    # Rank
    # ----------------------------------------------------------
    
    max_rank <- max(plot_data$Antall_enheter, na.rm = TRUE)
    
    rank_breaks <- if (max_rank <= 15L) {
      seq_len(max_rank)
      
    } else {
      breaks <- unique(c(1, pretty(c(1, max_rank), n = 8)))
      
      breaks[breaks >= 1 &
               breaks <= max_rank] |>
        sort()
    }
    
    p <- ggplot2::ggplot(plot_data, ggplot2::aes(x = .data$Aar, y = .data$Rang)) +
      ggplot2::geom_line(linewidth = 1) +
      ggplot2::geom_point(size = 2.5) +
      ggplot2::scale_y_reverse(breaks = rank_breaks, limits = c(max_rank, 1)) +
      ggplot2::labs(
        title = paste0(display_name, " - rang over tid"),
        subtitle = subtitle,
        x = NULL,
        y = "Rang",
        caption = caption
      )
  }
  # ------------------------------------------------------------
  # Common styling
  # ------------------------------------------------------------
  
  p <- p +
    ggplot2::scale_x_continuous(
      breaks = year_breaks,
      labels = scales::label_number(
        accuracy = 1,
        big.mark = ""
      )
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      panel.grid.minor = ggplot2::element_blank()
    )
  
  p
}
  
