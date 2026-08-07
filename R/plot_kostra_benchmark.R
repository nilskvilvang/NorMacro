
plot_kostra_benchmark <- function(variable,
                                  data,
                                  unit,
                                  year = NULL,
                                  descending = TRUE) {
  if (!is.data.frame(data)) {
    stop("`data` må være et datasett.", call. = FALSE)
  }
  
  required_columns <- c("Enhet", "Enhet_navn", "Enhetstype", "Aar")
  
  missing_columns <- setdiff(required_columns, names(data))
  
  if (length(missing_columns) > 0L) {
    stop("`plot_kostra_benchmark()` krever et KOSTRA-datasett.",
         call. = FALSE)
  }
  
  benchmark <- benchmark_kostra(
    variable = variable,
    data = data,
    unit = unit,
    year = year,
    descending = descending
  )
  
  selected_year <- benchmark$Aar[[1]]
  
  metadata <- get_metadata(data)
  
  meta <- metadata |>
    dplyr::filter(.data$Variabel == variable)
  
  display_name <- if (nrow(meta) > 0L &&
                      "Display_navn" %in% names(meta)) {
    meta$Display_navn[[1]]
  } else {
    stringr::str_to_sentence(gsub("_", " ", variable))
  }
  
  measure_unit <- if (nrow(meta) > 0L &&
                      "Enhet" %in% names(meta)) {
    meta$Enhet[[1]]
  } else {
    NULL
  }
  
  plot_data <- data |>
    dplyr::select(Enhet, Enhet_navn, Enhetstype, Aar, Verdi = dplyr::all_of(variable)) |>
    dplyr::filter(.data$Aar == selected_year, !is.na(.data$Verdi)) |>
    dplyr::mutate(Valgt = .data$Enhet == unit)
  
  if (nrow(plot_data) == 0L) {
    stop("Fant ingen observasjoner for valgt år.", call. = FALSE)
  }
  
  selected_name <- benchmark$Enhet_navn[[1]]
  
  selected_name <- sub("\\s+-\\s+.*$", "", selected_name)
  
  selected_value <- benchmark$Verdi[[1]]
  
  reference_data <- tibble::tibble(
    Referanse = factor(c("Q1", "Median", "Q3"), levels = c("Q1", "Median", "Q3")),
    Verdi = c(benchmark$Q1[[1]], benchmark$Median[[1]], benchmark$Q3[[1]])
  )
  
  subtitle <- paste0(
    selected_name,
    ": ",
    format(
      selected_value,
      big.mark = " ",
      decimal.mark = ",",
      trim = TRUE
    ),
    " - rang ",
    benchmark$Rang[[1]],
    " av ",
    benchmark$Antall_enheter[[1]],
    " - percentil ",
    round(benchmark$Percentil[[1]])
  )
  
  kostra_table <- attr(data, "kostra_table")
  
  caption <- "Kilde: SSB KOSTRA"
  
  if (!is.null(kostra_table) &&
      length(kostra_table) > 0L &&
      !is.na(kostra_table) &&
      kostra_table != "") {
    caption <- paste0(caption, ", tabell ", kostra_table)
  }
  
  p <- ggplot2::ggplot(plot_data, ggplot2::aes(x = .data$Verdi, y = 0)) +
    ggplot2::annotate(
      "rect",
      xmin = benchmark$Q1[[1]],
      xmax = benchmark$Q3[[1]],
      ymin = -0.025,
      ymax = 0.025,
      alpha = 0.15
    ) +
    ggplot2::annotate(
      "segment",
      x = benchmark$Median[[1]],
      xend = benchmark$Median[[1]],
      y = -0.07,
      yend = 0.07,
      linetype = "dashed",
      linewidth = 0.6
    ) +
    ggplot2::annotate(
      "text",
      x = mean(
        c(
          benchmark$Q1[[1]],
          benchmark$Q3[[1]]
        )
      ),
      y = 0.032,
      label = "Midtre 50 %",
      size = 3
    ) +
    ggplot2::annotate(
      "text",
      x = benchmark$Median[[1]],
      y = -0.075,
      label = "Median",
      size = 3.2
    ) +
    ggplot2::geom_point(
      data = plot_data |>
        dplyr::filter(
          !.data$Valgt
        ),
      position = ggplot2::position_jitter(
        width = 0,
        height = 0.018,
        seed = 123
      ),
      size = 2.5,
      alpha = 0.55
    ) +
    ggplot2::geom_point(data = plot_data |>
                          dplyr::filter(.data$Valgt),
                        size = 4) +
    ggplot2::annotate(
      "label",
      x = selected_value,
      y = 0.12,
      label = selected_name,
      size = 3.5,
      linewidth = 0.25
    ) +
    ggplot2::scale_x_continuous(labels = scales::label_number(big.mark = " ", decimal.mark = ",")) +
    ggplot2::labs(
      title = display_name,
      subtitle = subtitle,
      x = measure_unit,
      y = NULL,
      caption = caption
    ) +
    ggplot2::coord_cartesian(ylim = c(-0.14, 0.22), clip = "off") +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      axis.text.y = ggplot2::element_blank(),
      axis.ticks.y = ggplot2::element_blank(),
      panel.grid.major.y = ggplot2::element_blank(),
      panel.grid.minor.y = ggplot2::element_blank()
    )
  
  p
}



