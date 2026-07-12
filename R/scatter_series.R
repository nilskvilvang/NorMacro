
scatter_series <- function(
    x,
    y,
    data = NULL,
    start_year = NULL,
    end_year = NULL,
    add_smooth = TRUE,
    label_years = FALSE
) {
  
  if (is.null(data)) {
    data <- get_normacro()
  }
  
  metadata <- get_metadata(data)
  
  if (
    "Land" %in% names(data) &&
    dplyr::n_distinct(data$Land) > 1
  ) {
    stop(
      paste0(
        "scatter_series() kan analysere ett land om gangen. ",
        "Filtrer data til ett land først."
      ),
      call. = FALSE
    )
  }
  
  missing <- setdiff(c(x, y), names(data))
  
  if (length(missing) > 0) {
    stop(
      "Fant ikke variabler i datasettet: ",
      paste(missing, collapse = ", "),
      call. = FALSE
    )
  }
  
  plot_data <- data |>
    dplyr::select(
      Aar,
      dplyr::all_of(c(x, y))
    )
  
  if (!is.null(start_year)) {
    plot_data <- plot_data |>
      dplyr::filter(.data$Aar >= start_year)
  }
  
  if (!is.null(end_year)) {
    plot_data <- plot_data |>
      dplyr::filter(.data$Aar <= end_year)
  }
  
  plot_data <- plot_data |>
    dplyr::filter(
      !is.na(.data[[x]]),
      !is.na(.data[[y]])
    )
  
  if (nrow(plot_data) == 0) {
    stop(
      "Fant ingen observasjoner der begge variablene har data.",
      call. = FALSE
    )
  }
  
  x_label <- get_display_name(
    x,
    metadata = metadata
  )
  
  y_label <- get_display_name(
    y,
    metadata = metadata
  )
  
  x_unit <- metadata |>
    dplyr::filter(.data$Variabel == x) |>
    dplyr::pull(.data$Enhet)
  
  y_unit <- metadata |>
    dplyr::filter(.data$Variabel == y) |>
    dplyr::pull(.data$Enhet)
  
  source_text <- metadata |>
    dplyr::filter(.data$Variabel %in% c(x, y)) |>
    dplyr::pull(.data$Kilde) |>
    unique() |>
    stats::na.omit()
  
  caption <- if (length(source_text) == 0) {
    NULL
  } else {
    paste0(
      "Kilde: ",
      paste(source_text, collapse = " / ")
    )
  }
  
  fit <- stats::lm(
    plot_data[[y]] ~ plot_data[[x]]
  )
  
  r <- stats::cor(
    plot_data[[x]],
    plot_data[[y]],
    use = "complete.obs"
  )
  
  r2 <- summary(fit)$r.squared
  
  p_value <- summary(fit)$coefficients[2, 4]
  
  n <- nrow(plot_data)
  
  stats_label <- paste(
    sprintf("r = %.2f", r),
    sprintf("R² = %.2f", r2),
    if (p_value < 0.001) {
      "p < 0.001"
    } else {
      sprintf("p = %.3f", p_value)
    },
    sprintf("n = %d", n),
    sep = "\n"
  )
  
  p <- ggplot2::ggplot(
    plot_data,
    ggplot2::aes(
      x = .data[[x]],
      y = .data[[y]]
    )
  ) +
    ggplot2::geom_point() +
    ggplot2::scale_x_continuous(
      labels = scales::label_number(
        big.mark = " ",
        decimal.mark = ","
      )
    ) +
    ggplot2::scale_y_continuous(
      labels = scales::label_number(
        big.mark = " ",
        decimal.mark = ","
      )
    ) +
    ggplot2::labs(
      title = paste0(
        y_label,
        " mot ",
        x_label
      ),
      subtitle = paste0(
        "Observasjoner: ",
        nrow(plot_data)
      ),
      x = if (length(x_unit) == 0) {
        x_label
      } else {
        paste0(x_label, " (", x_unit[1], ")")
      },
      y = if (length(y_unit) == 0) {
        y_label
      } else {
        paste0(y_label, " (", y_unit[1], ")")
      },
      caption = caption
    ) +
    ggplot2::annotate(
      "label",
      x = Inf,
      y = Inf,
      label = stats_label,
      hjust = 1.05,
      vjust = 1.1,
      size = 3.5,
      label.size = 0.25
    )+
    ggplot2::theme_minimal()
  
  if (add_smooth) {
    p <- p +
      ggplot2::geom_smooth(
        method = "lm",
        se = FALSE
      )
  }
  
  if (label_years) {
    p <- p +
      ggplot2::geom_text(
        ggplot2::aes(label = .data$Aar),
        nudge_y = 0.02,
        check_overlap = TRUE
      )
  }
  
  p
}
