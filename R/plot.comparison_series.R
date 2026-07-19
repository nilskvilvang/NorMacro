

plot.comparison_series <- function(x,
                                   start_year = NULL,
                                   end_year = NULL,
                                   ...) {
  required_columns <- c("Aar", "Serie_id", "Land", "Display_navn", "Verdi", "Enhet")
  
  missing_columns <- setdiff(required_columns, names(x))
  
  if (length(missing_columns) > 0) {
    stop(
      "Objektet mangler nødvendige kolonner: ",
      paste(missing_columns, collapse = ", "),
      call. = FALSE
    )
  }
  
  if (nrow(x) == 0) {
    stop("Objektet inneholder ingen observasjoner.", call. = FALSE)
  }
  
  # Valider startår og sluttår
  if (!is.null(start_year)) {
    if (!is.numeric(start_year) ||
        length(start_year) != 1 ||
        is.na(start_year)) {
      stop("`start_year` må være ett gyldig årstall.", call. = FALSE)
    }
    
    start_year <- as.integer(start_year)
  }
  
  if (!is.null(end_year)) {
    if (!is.numeric(end_year) ||
        length(end_year) != 1 ||
        is.na(end_year)) {
      stop("`end_year` må være ett gyldig årstall.", call. = FALSE)
    }
    
    end_year <- as.integer(end_year)
  }
  
  if (!is.null(start_year) &&
      !is.null(end_year) &&
      start_year > end_year) {
    stop("`start_year` kan ikke være større enn `end_year`.", call. = FALSE)
  }
  
  plot_data <- x |>
    tibble::as_tibble()
  
  # Avgrens bare det som vises. Originalobjektet endres ikke.
  if (!is.null(start_year)) {
    plot_data <- plot_data |>
      dplyr::filter(.data$Aar >= start_year)
  }
  
  if (!is.null(end_year)) {
    plot_data <- plot_data |>
      dplyr::filter(.data$Aar <= end_year)
  }
  
  if (nrow(plot_data) == 0) {
    requested_period <- paste0(if (is.null(start_year))
      "-Inf"
      else
        start_year, "–", if (is.null(end_year))
          "Inf"
      else
        end_year)
    
    stop("Ingen observasjoner finnes i valgt periode: ",
         requested_period,
         ".",
         call. = FALSE)
  }
  
  # Fjern serier som ikke har noen gyldige verdier i valgt periode.
  series_with_data <- plot_data |>
    dplyr::filter(!is.na(.data$Verdi)) |>
    dplyr::distinct(Serie_id) |>
    dplyr::pull(Serie_id)
  
  if (length(series_with_data) == 0) {
    stop("Ingen av seriene har gyldige verdier i valgt periode.", call. = FALSE)
  }
  
  plot_data <- plot_data |>
    dplyr::filter(.data$Serie_id %in% series_with_data)
  
  # Kontroller at seriene kan vises på samme y-akse.
  units <- plot_data |>
    dplyr::filter(!is.na(.data$Enhet), .data$Enhet != "") |>
    dplyr::distinct(Enhet) |>
    dplyr::pull(Enhet)
  
  if (length(units) == 0) {
    y_label <- NULL
  } else if (length(units) == 1) {
    y_label <- units
  } else {
    stop(
      paste0(
        "Seriene har ulike enheter. ",
        "Normaliser dem først med normalize(), ",
        "for eksempel plot(normalize(x))."
      ),
      call. = FALSE
    )
  }
  
  # Bruk brukerrettede navn i legenden.
  plot_data <- plot_data |>
    dplyr::mutate(
      Serie = dplyr::case_when(
        is.na(.data$Display_navn) |
          .data$Display_navn == "" ~ .data$Serie_id,
        
        is.na(.data$Land) |
          .data$Land == "" ~ .data$Display_navn,
        
        TRUE ~ paste0(.data$Land, ": ", .data$Display_navn)
      )
    )
  
  normalized <- isTRUE(
    attr(x, "normalized")
  )
  
  base_year <- attr(
    x,
    "base_year"
  )
  
  transformation <- attr(
    x,
    "transformation"
  )
  
  transformation_periods <- attr(
    x,
    "transformation_periods"
  )
  
  transformation_base_value <- attr(
    x,
    "transformation_base_value"
  )
  
  if (normalized && is.null(base_year)) {
    warning(
      paste0(
        "Objektet er merket som normalisert, ",
        "men mangler attributtet `base_year`."
      ),
      call. = FALSE
    )
  }
  
  transformation <- attr(x, "transformation")
  
  transformation_periods <- attr(x, "transformation_periods")
  
  if (identical(transformation, "indexed")) {
    
    if (
      !is.null(base_year) &&
      !is.null(transformation_base_value)
    ) {
      title <- paste0(
        "Indekserte serier (",
        base_year,
        " = ",
        format(
          transformation_base_value,
          trim = TRUE,
          scientific = FALSE
        ),
        ")"
      )
    } else {
      title <- "Indekserte serier"
    }
    
  } else if (identical(
    transformation,
    "growth_percent"
  )) {
    
    if (identical(
      transformation_periods,
      1L
    )) {
      title <- "Årlig vekst"
    } else {
      title <- paste0(
        "Vekst over ",
        transformation_periods,
        " perioder"
      )
    }
    
  } else if (identical(
    transformation,
    "growth_absolute"
  )) {
    
    if (identical(
      transformation_periods,
      1L
    )) {
      title <- "Årlig endring"
    } else {
      title <- paste0(
        "Endring over ",
        transformation_periods,
        " perioder"
      )
    }
    
  } else {
    
    title <- "Sammenlikning av serier"
  }
  
  subtitle <- create_comparison_subtitle(plot_data)
  
  ggplot2::ggplot(
    plot_data,
    ggplot2::aes(
      x = .data$Aar,
      y = .data$Verdi,
      colour = .data$Serie,
      group = .data$Serie_id
    )
  ) +
    ggplot2::geom_line(linewidth = 0.9, na.rm = TRUE) +
    ggplot2::labs(
      title = title,
      subtitle = subtitle,
      x = NULL,
      y = y_label,
      colour = NULL
    ) +
    ggplot2::scale_x_continuous(breaks = scales::breaks_pretty()) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      legend.position = "bottom",
      legend.text = ggplot2::element_text(size = 9),
      panel.grid.minor = ggplot2::element_blank(),
      plot.title.position = "plot"
    )
}

