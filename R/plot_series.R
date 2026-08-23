
#' Plot en tidsserie
#'
#' Lager en tidsseriefigur for en variabel i et NorMacro-datasett.
#' Funksjonen bruker metadata til å sette tittel, beskrivelse, måleenhet
#' og kilde når denne informasjonen er tilgjengelig.
#'
#' Funksjonen støtter norske makrodata, internasjonale data med kolonnen
#' `Land` og KOSTRA-data med enhetsinformasjon.
#'
#' @param variable Navnet på variabelen som skal plottes.
#' @param data Datasett som inneholder `Aar` og variabelen som skal plottes.
#'   Hvis `NULL`, hentes standarddatasettet med [get_normacro()].
#' @param metadata Metadata for datasettet. Hvis `NULL`, hentes metadata
#'   automatisk.
#' @param countries Valgfri vektor med land som skal inkluderes når `data`
#'   er et internasjonalt datasett.
#'
#' @return Et `ggplot`-objekt.
#'
#' @examples
#' plot_series(
#'   "Inflasjon",
#'   data = normacro_example
#' )
#'
#' @export

plot_series <- function(
    variable,
    data = NULL,
    metadata = NULL,
    countries = NULL
) {

  if (is.null(data)) {
    data <- get_normacro()
  }

  if (!is.data.frame(data)) {
    stop(
      "`data` m\u00e5 v\u00e6re en data.frame eller tibble.",
      call. = FALSE
    )
  }

  if (!"Aar" %in% names(data)) {
    stop(
      "Datasettet m\u00e5 inneholde kolonnen `Aar`.",
      call. = FALSE
    )
  }

  if (!variable %in% names(data)) {
    stop(
      "Fant ikke variabelen i datasettet: ",
      variable,
      call. = FALSE
    )
  }

  if (is.null(metadata)) {
    metadata <- get_metadata(data)
  }

  has_country <- all(
    c(
      "Land",
      "Aar"
    ) %in% names(data)
  )

  has_kostra <- all(
    c(
      "Enhet",
      "Enhet_navn",
      "Enhetstype",
      "Aar"
    ) %in% names(data)
  )

  # Filtrering av internasjonale data -------------------------------

  if (has_country && !is.null(countries)) {
    available_countries <- unique(
      data$Land
    )

    missing_countries <- setdiff(
      countries,
      available_countries
    )

    if (length(missing_countries) > 0L) {
      stop(
        "Fant ikke land i datasettet: ",
        paste(
          missing_countries,
          collapse = ", "
        ),
        call. = FALSE
      )
    }

    data <- data |>
      dplyr::filter(
        .data$Land %in% countries
      )
  }

  # Metadata --------------------------------------------------------

  meta <- metadata |>
    dplyr::filter(
      .data$Variabel == variable
    )

  if (nrow(meta) == 0L) {
    title <- variable |>
      gsub(
        pattern = "_",
        replacement = " "
      ) |>
      stringr::str_to_sentence()

    subtitle <- NULL
    y_label <- NULL
    caption <- NULL

  } else {

    title <- if ("Display_navn" %in% names(meta)) {
      meta$Display_navn[[1]]
    } else {
      NULL
    }

    subtitle <- if ("Beskrivelse" %in% names(meta)) {
      meta$Beskrivelse[[1]]
    } else {
      NULL
    }

    y_label <- if ("Enhet" %in% names(meta)) {
      meta$Enhet[[1]]
    } else {
      NULL
    }

    source <- if ("Kilde" %in% names(meta)) {
      meta$Kilde[[1]]
    } else {
      NULL
    }

    if (
      is.null(title) ||
      is.na(title) ||
      title == ""
    ) {
      title <- variable |>
        gsub(
          pattern = "_",
          replacement = " "
        ) |>
        stringr::str_to_sentence()
    }

    if (
      is.null(subtitle) ||
      is.na(subtitle) ||
      subtitle == ""
    ) {
      subtitle <- NULL
    }

    if (
      is.null(y_label) ||
      is.na(y_label) ||
      y_label == ""
    ) {
      y_label <- NULL
    }

    if (
      is.null(source) ||
      is.na(source) ||
      source == ""
    ) {
      caption <- NULL
    } else {
      caption <- paste0(
        "Kilde: ",
        source
      )
    }
  }

  # KOSTRA-informasjon ---------------------------------------------

  if (has_kostra) {
    kostra_table <- attr(
      data,
      "kostra_table"
    )

    kostra_title <- attr(
      data,
      "kostra_title"
    )

    if (
      !is.null(kostra_title) &&
      length(kostra_title) > 0L &&
      !is.na(kostra_title) &&
      kostra_title != ""
    ) {
      if (is.null(subtitle)) {
        subtitle <- kostra_title
      } else {
        subtitle <- paste0(
          subtitle,
          "\n",
          kostra_title
        )
      }
    }

    caption <- "Kilde: SSB/KOSTRA"

    if (
      !is.null(kostra_table) &&
      length(kostra_table) > 0L &&
      !is.na(kostra_table) &&
      kostra_table != ""
    ) {
      caption <- paste0(
        caption,
        " \u00b7 Tabell ",
        kostra_table
      )
    }
  }

  # Internasjonale data --------------------------------------------

  if (has_country) {
    plot_data <- data |>
      dplyr::select(
        Aar,
        Land,
        Verdi = dplyr::all_of(variable)
      ) |>
      dplyr::filter(
        !is.na(.data$Aar),
        !is.na(.data$Verdi)
      ) |>
      dplyr::arrange(
        .data$Land,
        .data$Aar
      )

    n_countries <- dplyr::n_distinct(
      plot_data$Land
    )

    p <- ggplot2::ggplot(
      plot_data,
      ggplot2::aes(
        x = .data$Aar,
        y = .data$Verdi,
        colour = .data$Land,
        group = .data$Land
      )
    ) +
      ggplot2::geom_line(
        linewidth = 0.9
      ) +
      scale_colour_normacro(
        n = n_countries
      ) +
      ggplot2::labs(
        colour = NULL
      )

    # KOSTRA-data -----------------------------------------------------

  } else if (has_kostra) {
    plot_data <- data |>
      dplyr::select(
        Aar,
        Enhet,
        Enhet_navn,
        Verdi = dplyr::all_of(variable)
      ) |>
      dplyr::mutate(
        Enhet_plot = sub(
          pattern = "\\s+-\\s+.*$",
          replacement = "",
          .data$Enhet_navn
        )
      ) |>
      dplyr::filter(
        !is.na(.data$Aar),
        !is.na(.data$Verdi)
      ) |>
      dplyr::arrange(
        .data$Enhet,
        .data$Aar
      )

    n_units <- dplyr::n_distinct(
      plot_data$Enhet
    )

    if (n_units > 1L) {
      p <- ggplot2::ggplot(
        plot_data,
        ggplot2::aes(
          x = .data$Aar,
          y = .data$Verdi,
          colour = .data$Enhet_plot,
          group = .data$Enhet
        )
      ) +
        ggplot2::geom_line(
          linewidth = 0.9
        ) +
        scale_colour_normacro(
          n = n_units
        ) +
        ggplot2::labs(
          colour = NULL
        )
    } else {
      p <- ggplot2::ggplot(
        plot_data,
        ggplot2::aes(
          x = .data$Aar,
          y = .data$Verdi,
          group = .data$Enhet
        )
      ) +
        ggplot2::geom_line(
          linewidth = 0.9
        )
    }

    # Norske makrodata ------------------------------------------------

  } else {
    plot_data <- data |>
      dplyr::select(
        Aar,
        Verdi = dplyr::all_of(variable)
      ) |>
      dplyr::filter(
        !is.na(.data$Aar),
        !is.na(.data$Verdi)
      ) |>
      dplyr::arrange(
        .data$Aar
      )

    p <- ggplot2::ggplot(
      plot_data,
      ggplot2::aes(
        x = .data$Aar,
        y = .data$Verdi
      )
    ) +
      ggplot2::geom_line(
        linewidth = 0.9
      )
  }

  if (nrow(plot_data) == 0L) {
    stop(
      "Variabelen har ingen observasjoner som kan plottes.",
      call. = FALSE
    )
  }

  # Årsakse ---------------------------------------------------------

  year_range <- range(
    plot_data$Aar,
    na.rm = TRUE
  )

  year_span <- diff(
    year_range
  )

  year_step <- if (year_span <= 8) {
    1
  } else if (year_span <= 16) {
    2
  } else if (year_span <= 35) {
    5
  } else if (year_span <= 80) {
    10
  } else {
    20
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

  p <- p +
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
    ) +
    ggplot2::labs(
      title = title,
      subtitle = subtitle,
      x = NULL,
      y = y_label,
      caption = caption
    ) +
    theme_normacro()

  # Nullinje --------------------------------------------------------

  show_zero_line <- grepl(
    paste(
      c(
        "vekst",
        "inflasjon",
        "rente",
        "rentekurve",
        "andel",
        "resultat",
        "balanse"
      ),
      collapse = "|"
    ),
    variable,
    ignore.case = TRUE
  )

  if (show_zero_line) {
    p <- p +
      ggplot2::geom_hline(
        yintercept = 0,
        linetype = "dashed",
        linewidth = 0.3
      )
  }

  p
}
