
plot_public_sector_macro <- function(
    start_year = 1990,
    end_year = NULL,
    measure = c(
      "index",
      "share_gdp",
      "share_public",
      "level"
    ),
    base_year = NULL,
    include_state = FALSE
) {
  
  measure <- match.arg(
    measure
  )
  
  # ------------------------------------------------------------
  # Validation
  # ------------------------------------------------------------
  
  if (
    !is.numeric(start_year) ||
    length(start_year) != 1L ||
    is.na(start_year) ||
    !is.finite(start_year)
  ) {
    stop(
      "`start_year` m\u00e5 v\u00e6re ett gyldig \u00e5r.",
      call. = FALSE
    )
  }
  
  start_year <- as.integer(
    start_year
  )
  
  if (is.null(end_year)) {
    end_year <- as.integer(
      format(
        Sys.Date(),
        "%Y"
      )
    )
  }
  
  if (
    !is.numeric(end_year) ||
    length(end_year) != 1L ||
    is.na(end_year) ||
    !is.finite(end_year)
  ) {
    stop(
      "`end_year` m\u00e5 v\u00e6re ett gyldig \u00e5r.",
      call. = FALSE
    )
  }
  
  end_year <- as.integer(
    end_year
  )
  
  if (start_year > end_year) {
    stop(
      "`start_year` kan ikke v\u00e6re st\u00f8rre enn `end_year`.",
      call. = FALSE
    )
  }
  
  if (
    !is.logical(include_state) ||
    length(include_state) != 1L ||
    is.na(include_state)
  ) {
    stop(
      "`include_state` m\u00e5 v\u00e6re `TRUE` eller `FALSE`.",
      call. = FALSE
    )
  }
  
  if (
    measure == "index" &&
    is.null(base_year)
  ) {
    base_year <- start_year
  }
  
  # ------------------------------------------------------------
  # Analysis data
  # ------------------------------------------------------------
  
  data <- public_sector_analysis(
    start_year = start_year,
    end_year = end_year,
    measure = measure,
    base_year = base_year
  )
  
  # ------------------------------------------------------------
  # Select series
  # ------------------------------------------------------------
  
  if (measure == "index") {
    
    variables <- c(
      "BNP_Fastlands",
      "Offentlig_konsum",
      "Kommunalt_konsum"
    )
    
    if (include_state) {
      variables <- c(
        variables,
        "Statlig_konsum"
      )
    }
    
    data <- data |>
      dplyr::filter(
        .data$Variabel %in% variables
      )
    
  } else if (measure == "level") {
    
    variables <- c(
      "BNP_Fastlands",
      "Offentlig_konsum",
      "Kommunalt_konsum"
    )
    
    if (include_state) {
      variables <- c(
        variables,
        "Statlig_konsum"
      )
    }
    
    data <- data |>
      dplyr::filter(
        .data$Variabel %in% variables
      )
    
  } else if (measure == "share_gdp") {
    
    variables <- c(
      "Offentlig_konsum",
      "Kommunalt_konsum"
    )
    
    if (include_state) {
      variables <- c(
        variables,
        "Statlig_konsum"
      )
    }
    
    data <- data |>
      dplyr::filter(
        .data$Variabel %in% variables
      )
    
  }
  
  # For share_public beholdes begge seriene alltid:
  # Kommunalt_konsum og Statlig_konsum.
  
  # ------------------------------------------------------------
  # Display labels
  # ------------------------------------------------------------
  
  data <- data |>
    dplyr::mutate(
      Serie = dplyr::recode(
        .data$Variabel,
        BNP_Fastlands = "BNP Fastlands-Norge",
        Offentlig_konsum = "Offentlig konsum",
        Statlig_konsum = "Statlig konsum",
        Kommunalt_konsum = "Kommunalt konsum"
      )
    )
  
  # ------------------------------------------------------------
  # Plot metadata
  # ------------------------------------------------------------
  
  if (measure == "index") {
    
    title <- "Utvikling i BNP og offentlig konsum"
    
    subtitle <- paste0(
      "Volumutvikling, ",
      base_year,
      " = 100"
    )
    
    y_label <- paste0(
      "Indeks (",
      base_year,
      " = 100)"
    )
    
  } else if (measure == "share_gdp") {
    
    title <- "Offentlig konsum som andel av Fastlands-BNP"
    
    subtitle <- paste0(
      start_year,
      "-",
      end_year
    )
    
    y_label <- "Prosent av Fastlands-BNP"
    
  } else if (measure == "share_public") {
    
    title <- paste0(
      "Fordelingen av offentlig konsum ",
      "mellom stat og kommune"
    )
    
    subtitle <- paste0(
      start_year,
      "-",
      end_year
    )
    
    y_label <- "Prosent av offentlig konsum"
    
  } else {
    
    title <- "BNP og offentlig konsum"
    
    subtitle <- paste0(
      "Faste 2023-priser, ",
      start_year,
      "-",
      end_year
    )
    
    y_label <- "Millioner kroner"
  }
  
  # ------------------------------------------------------------
  # Year axis
  # ------------------------------------------------------------
  
  year_range <- range(
    data$Aar,
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
    data,
    ggplot2::aes(
      x = .data$Aar,
      y = .data$Verdi,
      colour = .data$Serie
    )
  ) +
    ggplot2::geom_line(
      linewidth = 0.9
    ) +
    ggplot2::scale_x_continuous(
      breaks = year_breaks,
      labels = scales::label_number(
        accuracy = 1,
        big.mark = ""
      )
    ) +
    ggplot2::labs(
      title = title,
      subtitle = subtitle,
      x = NULL,
      y = y_label,
      colour = NULL,
      caption = paste0(
        "Kilde: Statistisk sentralbyr\u00e5, ",
        "tabell 09189"
      )
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      legend.position = "bottom",
      panel.grid.minor = ggplot2::element_blank()
    )
  
  # ------------------------------------------------------------
  # Measure-specific y scale
  # ------------------------------------------------------------
  
  if (
    measure %in% c(
      "share_gdp",
      "share_public"
    )
  ) {
    
    p <- p +
      ggplot2::scale_y_continuous(
        labels = scales::label_number(
          suffix = " %",
          decimal.mark = ",",
          accuracy = 1
        )
      )
    
  } else if (measure == "level") {
    
    p <- p +
      ggplot2::scale_y_continuous(
        labels = scales::label_number(
          big.mark = " ",
          decimal.mark = ","
        )
      )
  }
  
  # ------------------------------------------------------------
  # Metadata
  # ------------------------------------------------------------
  
  attr(
    p,
    "measure"
  ) <- measure
  
  attr(
    p,
    "start_year"
  ) <- start_year
  
  attr(
    p,
    "end_year"
  ) <- end_year
  
  attr(
    p,
    "base_year"
  ) <- if (measure == "index") {
    base_year
  } else {
    NULL
  }
  
  attr(
    p,
    "include_state"
  ) <- include_state
  
  attr(
    p,
    "source"
  ) <- "SSB"
  
  attr(
    p,
    "ssb_table"
  ) <- "09189"
  
  p
}

