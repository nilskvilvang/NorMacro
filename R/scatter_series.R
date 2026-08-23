
#' Lag scatterplott mellom to tidsserier
#'
#' Visualiserer sammenhengen mellom to variabler i et NorMacro-datasett.
#' Figuren kan avgrenses til en bestemt periode og kan inkludere en
#' utjevnet trendlinje.
#'
#' Funksjonen støtter norske makrodata, internasjonale data og KOSTRA-data.
#'
#' @param x Navnet på variabelen på x-aksen.
#' @param y Navnet på variabelen på y-aksen.
#' @param data Valgfritt NorMacro-datasett.
#' @param start_year Valgfritt første år i analyseperioden.
#' @param end_year Valgfritt siste år i analyseperioden.
#' @param add_smooth Logisk. Om en utjevnet trendlinje skal legges til.
#' @param label_years Logisk. Om observasjonene skal merkes med år.
#' @param country Valgfritt land når `data` inneholder internasjonale data.
#' @param unit Valgfri KOSTRA-enhet når `data` inneholder flere enheter.
#'
#' @return Et `ggplot`-objekt.
#'
#' @examples
#' scatter_series(
#'   x = "BNP_Fastland_vekst",
#'   y = "Arbeidsledighetsrate_NAV",
#'   data = normacro_example
#' )
#'
#' @export

scatter_series <- function(
    x,
    y,
    data = NULL,
    start_year = NULL,
    end_year = NULL,
    add_smooth = TRUE,
    label_years = FALSE,
    country = NULL,
    unit = NULL
) {

  if (is.null(data)) {
    data <- get_normacro()
  }

  if (!is.data.frame(data)) {
    stop(
      "`data` m\u00e5 v\u00e6re et datasett.",
      call. = FALSE
    )
  }

  if (!"Aar" %in% names(data)) {
    stop(
      "Datasettet mangler \u00e5rskolonnen `Aar`.",
      call. = FALSE
    )
  }

  missing <- setdiff(
    c(x, y),
    names(data)
  )

  if (length(missing) > 0L) {
    stop(
      "Fant ikke variabler i datasettet: ",
      paste(missing, collapse = ", "),
      call. = FALSE
    )
  }

  has_country <- "Land" %in% names(data)

  has_kostra <- all(
    c(
      "Enhet",
      "Enhet_navn",
      "Enhetstype"
    ) %in% names(data)
  )

  # Metadata og KOSTRA-attributter må hentes før
  # panelidentifikatorene eventuelt fjernes.
  metadata <- get_metadata(data)

  kostra_table <- NULL
  kostra_title <- NULL
  unit_name <- NULL

  if (has_kostra) {
    kostra_table <- attr(
      data,
      "kostra_table"
    )

    kostra_title <- attr(
      data,
      "kostra_title"
    )
  }

  # ------------------------------------------------------------
  # Internasjonale data
  # ------------------------------------------------------------

  if (has_country) {

    available_countries <- data$Land |>
      unique() |>
      stats::na.omit() |>
      as.character()

    if (is.null(country)) {

      if (length(available_countries) > 1L) {
        stop(
          paste0(
            "Datasettet inneholder flere land. ",
            "Angi ett land med argumentet `country`."
          ),
          call. = FALSE
        )
      }

      country <- available_countries[[1]]
    }

    if (
      !is.character(country) ||
      length(country) != 1L ||
      is.na(country) ||
      country == ""
    ) {
      stop(
        "`country` m\u00e5 angi n\u00f8yaktig ett land.",
        call. = FALSE
      )
    }

    if (!country %in% available_countries) {
      stop(
        "Fant ikke landet i datasettet: ",
        country,
        call. = FALSE
      )
    }

    data <- data |>
      dplyr::filter(
        .data$Land == country
      ) |>
      dplyr::select(
        -dplyr::all_of("Land")
      )
  }

  # ------------------------------------------------------------
  # KOSTRA-data
  # ------------------------------------------------------------

  if (has_kostra) {

    available_units <- data |>
      dplyr::distinct(
        .data$Enhet,
        .data$Enhet_navn
      )

    if (is.null(unit)) {

      if (nrow(available_units) > 1L) {
        stop(
          paste0(
            "Datasettet inneholder flere KOSTRA-enheter. ",
            "Angi \u00e9n enhet med argumentet `unit`."
          ),
          call. = FALSE
        )
      }

      unit <- available_units$Enhet[[1]]
    }

    if (
      !is.character(unit) ||
      length(unit) != 1L ||
      is.na(unit) ||
      unit == ""
    ) {
      stop(
        "`unit` m\u00e5 angi n\u00f8yaktig \u00e9n KOSTRA-enhet.",
        call. = FALSE
      )
    }

    if (!unit %in% available_units$Enhet) {
      stop(
        "Fant ikke KOSTRA-enheten: ",
        unit,
        call. = FALSE
      )
    }

    unit_name <- available_units |>
      dplyr::filter(
        .data$Enhet == unit
      ) |>
      dplyr::pull(
        .data$Enhet_navn
      ) |>
      dplyr::first()

    if (
      !is.null(unit_name) &&
      !is.na(unit_name)
    ) {
      unit_name <- sub(
        "\\s+-\\s+.*$",
        "",
        unit_name
      )
    }

    data <- data |>
      dplyr::filter(
        .data$Enhet == unit
      ) |>
      dplyr::select(
        -dplyr::any_of(
          c(
            "Enhet",
            "Enhet_navn",
            "Enhetstype"
          )
        )
      )
  }

  # ------------------------------------------------------------
  # Analyseperiode
  # ------------------------------------------------------------

  plot_data <- data |>
    dplyr::select(
      Aar,
      dplyr::all_of(
        c(x, y)
      )
    )

  if (!is.null(start_year)) {
    plot_data <- plot_data |>
      dplyr::filter(
        .data$Aar >= start_year
      )
  }

  if (!is.null(end_year)) {
    plot_data <- plot_data |>
      dplyr::filter(
        .data$Aar <= end_year
      )
  }

  plot_data <- plot_data |>
    dplyr::filter(
      !is.na(.data[[x]]),
      !is.na(.data[[y]])
    )

  if (nrow(plot_data) == 0L) {
    stop(
      "Fant ingen observasjoner der begge variablene har data.",
      call. = FALSE
    )
  }

  # ------------------------------------------------------------
  # Visningsnavn og måleenhet
  # ------------------------------------------------------------

  x_label <- if (x %in% metadata$Variabel) {
    get_display_name(
      x,
      metadata = metadata
    )
  } else {
    stringr::str_to_sentence(
      gsub(
        "_",
        " ",
        x
      )
    )
  }

  y_label <- if (y %in% metadata$Variabel) {
    get_display_name(
      y,
      metadata = metadata
    )
  } else {
    stringr::str_to_sentence(
      gsub(
        "_",
        " ",
        y
      )
    )
  }

  x_unit <- metadata |>
    dplyr::filter(
      .data$Variabel == x
    ) |>
    dplyr::pull(
      dplyr::any_of("Enhet")
    )

  y_unit <- metadata |>
    dplyr::filter(
      .data$Variabel == y
    ) |>
    dplyr::pull(
      dplyr::any_of("Enhet")
    )

  # ------------------------------------------------------------
  # Kilde
  # ------------------------------------------------------------

  if (has_kostra) {

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

  } else if ("Kilde" %in% names(metadata)) {

    source_text <- metadata |>
      dplyr::filter(
        .data$Variabel %in% c(x, y)
      ) |>
      dplyr::pull(
        .data$Kilde
      ) |>
      unique() |>
      stats::na.omit()

    caption <- if (length(source_text) == 0L) {
      NULL
    } else {
      paste0(
        "Kilde: ",
        paste(
          source_text,
          collapse = " / "
        )
      )
    }

  } else {
    caption <- NULL
  }

  # ------------------------------------------------------------
  # Statistikk
  # ------------------------------------------------------------

  fit <- stats::lm(
    plot_data[[y]] ~ plot_data[[x]]
  )

  r <- stats::cor(
    plot_data[[x]],
    plot_data[[y]],
    use = "complete.obs"
  )

  fit_summary <- summary(
    fit
  )

  r2 <- fit_summary$r.squared

  p_value <- fit_summary$coefficients[
    2,
    4
  ]

  n <- nrow(
    plot_data
  )

  stats_label <- paste(
    sprintf(
      "r = %.2f",
      r
    ),
    sprintf(
      "R\u00b2 = %.2f",
      r2
    ),
    if (p_value < 0.001) {
      "p < 0.001"
    } else {
      sprintf(
        "p = %.3f",
        p_value
      )
    },
    sprintf(
      "n = %d",
      n
    ),
    sep = "\n"
  )

  # ------------------------------------------------------------
  # Undertittel
  # ------------------------------------------------------------

  subtitle_parts <- character()

  if (
    has_country &&
    !is.null(country)
  ) {
    subtitle_parts <- c(
      subtitle_parts,
      country
    )
  }

  if (
    has_kostra &&
    !is.null(unit_name)
  ) {
    subtitle_parts <- c(
      subtitle_parts,
      unit_name
    )
  }

  if (
    has_kostra &&
    !is.null(kostra_title) &&
    length(kostra_title) > 0L &&
    !is.na(kostra_title) &&
    kostra_title != ""
  ) {
    subtitle_parts <- c(
      subtitle_parts,
      kostra_title
    )
  }

  subtitle_parts <- c(
    subtitle_parts,
    paste0(
      min(
        plot_data$Aar
      ),
      "\u2013",
      max(
        plot_data$Aar
      )
    )
  )

  subtitle <- paste(
    subtitle_parts,
    collapse = " \u00b7 "
  )

  # ------------------------------------------------------------
  # Plot
  # ------------------------------------------------------------

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
      subtitle = subtitle,
      x = if (length(x_unit) == 0L) {
        x_label
      } else {
        paste0(
          x_label,
          " (",
          x_unit[[1]],
          ")"
        )
      },
      y = if (length(y_unit) == 0L) {
        y_label
      } else {
        paste0(
          y_label,
          " (",
          y_unit[[1]],
          ")"
        )
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
      linewidth = 0.3
    ) +
    theme_normacro()

  if (add_smooth) {
    p <- p +
      ggplot2::geom_smooth(
        method = "lm",
        formula = y ~ x,
        se = FALSE
      )
  }

  if (label_years) {
    p <- p +
      ggplot2::geom_text(
        ggplot2::aes(
          label = .data$Aar
        ),
        nudge_y = 0.02,
        check_overlap = TRUE
      )
  }

  p
}
