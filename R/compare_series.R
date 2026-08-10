
#' Sammenlign tidsserier
#'
#' Sammenligner flere tidsserier i et felles datasett. Seriene kan
#' normaliseres til en felles skala, slik at utviklingen kan sammenlignes
#' selv når variablene har forskjellige måleenheter.
#'
#' @param variables En tegnvektor med variabler som skal sammenlignes.
#' @param data Datasett som inneholder `Aar` og de valgte variablene.
#'   Hvis `NULL`, brukes NorMacros standarddata.
#' @param country Valgfritt land ved analyse av internasjonale data.
#' @param unit Valgfri måleenhet.
#' @param base_year Valgfritt basisår ved normalisering.
#' @param normalize Logisk. Hvis `TRUE`, normaliseres seriene før
#'   sammenligning.
#' @param start_year Valgfritt første år i sammenligningen.
#' @param complete_cases Logisk. Hvis `TRUE`, brukes bare år med komplette
#'   observasjoner for alle valgte variabler.
#'
#' @return Et objekt som representerer de sammenlignede tidsseriene.
#'
#' @examples
#' compare_series(
#'   c("Inflasjon", "Styringsrente"),
#'   data = normacro_example
#' )
#'
#' @export

compare_series <- function(
    variables,
    data = NULL,
    country = NULL,
    unit = NULL,
    base_year = NULL,
    normalize = TRUE,
    start_year = NULL,
    complete_cases = FALSE
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
  
  if (
    !is.character(variables) ||
    length(variables) < 1L ||
    anyNA(variables) ||
    any(variables == "")
  ) {
    stop(
      "`variables` m\u00e5 v\u00e6re en tegnvektor med gyldige variabelnavn.",
      call. = FALSE
    )
  }
  
  variables <- unique(
    variables
  )
  
  missing <- setdiff(
    variables,
    names(data)
  )
  
  if (length(missing) > 0L) {
    stop(
      "Fant ikke variabler i datasettet: ",
      paste(
        missing,
        collapse = ", "
      ),
      call. = FALSE
    )
  }
  
  # ------------------------------------------------------------
  # Identifiser datasettstype
  # ------------------------------------------------------------
  
  has_country <- "Land" %in% names(data)
  
  has_kostra <- all(
    c(
      "Enhet",
      "Enhet_navn",
      "Enhetstype"
    ) %in% names(data)
  )
  
  # Metadata må hentes før KOSTRA-identifikatorene eventuelt
  # fjernes fra datasettet.
  metadata <- get_metadata(data)
  
  kostra_table <- NULL
  kostra_title <- NULL
  kostra_unit_name <- NULL
  
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
    
    available_units <- data$Enhet |>
      unique() |>
      stats::na.omit() |>
      as.character()
    
    if (is.null(unit)) {
      
      if (length(available_units) > 1L) {
        stop(
          paste0(
            "Datasettet inneholder flere KOSTRA-enheter. ",
            "Angi \u00e9n enhet med argumentet `unit`."
          ),
          call. = FALSE
        )
      }
      
      unit <- available_units[[1]]
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
    
    if (!unit %in% available_units) {
      stop(
        "Fant ikke KOSTRA-enheten i datasettet: ",
        unit,
        call. = FALSE
      )
    }
    
    selected_unit <- data |>
      dplyr::filter(
        .data$Enhet == unit
      )
    
    kostra_unit_name <- selected_unit$Enhet_navn |>
      unique() |>
      stats::na.omit() |>
      as.character()
    
    if (length(kostra_unit_name) > 0L) {
      kostra_unit_name <- kostra_unit_name[[1]]
    } else {
      kostra_unit_name <- unit
    }
    
    kostra_table <- attr(
      data,
      "kostra_table"
    )
    
    kostra_title <- attr(
      data,
      "kostra_title"
    )
    
    data <- selected_unit |>
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
  # Finn felles observasjonsperiode
  # ------------------------------------------------------------
  
  common_years <- data |>
    dplyr::select(
      Aar,
      dplyr::all_of(variables)
    ) |>
    dplyr::filter(
      stats::complete.cases(
        dplyr::pick(
          dplyr::all_of(variables)
        )
      )
    ) |>
    dplyr::pull(
      .data$Aar
    )
  
  if (
    complete_cases &&
    length(common_years) == 0L
  ) {
    stop(
      "Fant ingen \u00e5r der alle valgte variabler har data.",
      call. = FALSE
    )
  }
  
  if (
    normalize &&
    is.null(base_year) &&
    is.null(start_year)
  ) {
    
    if (length(common_years) == 0L) {
      stop(
        paste0(
          "Fant ikke et felles basis\u00e5r der alle valgte variabler har data. ",
          "Angi `base_year` eksplisitt eller bruk `normalize = FALSE`."
        ),
        call. = FALSE
      )
    }
    
    start_year <- min(
      common_years
    )
    
    base_year <- start_year
  }
  
  if (
    complete_cases &&
    is.null(start_year)
  ) {
    start_year <- min(
      common_years
    )
  }
  
  if (!is.null(start_year)) {
    
    data <- data |>
      dplyr::filter(
        .data$Aar >= start_year
      )
    
    if (
      is.null(base_year) &&
      normalize
    ) {
      base_year <- start_year
    }
  }
  
  # ------------------------------------------------------------
  # Normalisering
  # ------------------------------------------------------------
  
  if (normalize) {
    
    plot_data <- normalize_series(
      data = data,
      variables = variables,
      base_year = base_year
    )
    
    y_label <- if (is.null(base_year)) {
      "Indeks"
    } else {
      paste0(
        "Indeks, ",
        base_year,
        " = 100"
      )
    }
    
  } else {
    
    plot_data <- data |>
      dplyr::select(
        Aar,
        dplyr::all_of(variables)
      )
    
    y_label <- NULL
  }
  
  # ------------------------------------------------------------
  # Visningsnavn
  # ------------------------------------------------------------
  
  display_lookup <- tibble::tibble(
    Variabel = variables,
    Display_navn = vapply(
      variables,
      function(x) {
        if (x %in% metadata$Variabel) {
          get_display_name(
            x,
            metadata
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
      },
      character(1)
    )
  )
  
  plot_data_long <- plot_data |>
    tidyr::pivot_longer(
      cols = -Aar,
      names_to = "Variabel",
      values_to = "Verdi"
    ) |>
    dplyr::left_join(
      display_lookup,
      by = "Variabel"
    ) |>
    dplyr::filter(
      !is.na(.data$Verdi)
    )
  
  # ------------------------------------------------------------
  # Caption
  # ------------------------------------------------------------
  
  if (has_kostra) {
    
    caption <- "Kilde: SSB KOSTRA"
    
    if (
      !is.null(kostra_table) &&
      length(kostra_table) > 0L &&
      !is.na(kostra_table)
    ) {
      caption <- paste0(
        caption,
        ", tabell ",
        kostra_table
      )
    }
    
  } else if ("Kilde" %in% names(metadata)) {
    
    sources <- metadata |>
      dplyr::filter(
        .data$Variabel %in% variables
      ) |>
      dplyr::pull(
        .data$Kilde
      ) |>
      unique() |>
      stats::na.omit()
    
    caption <- if (length(sources) == 0L) {
      NULL
    } else {
      paste0(
        "Kilde: ",
        paste(
          sources,
          collapse = " / "
        )
      )
    }
    
  } else {
    caption <- NULL
  }
  
  # ------------------------------------------------------------
  # Undertittel
  # ------------------------------------------------------------
  
  subtitle_parts <- c(
    paste(
      display_lookup$Display_navn,
      collapse = ", "
    )
  )
  
  if (has_country && !is.null(country)) {
    subtitle_parts <- c(
      subtitle_parts,
      country
    )
  }
  
  if (
    has_kostra &&
    !is.null(kostra_unit_name)
  ) {
    short_unit_name <- sub(
      "\\s+-\\s+.*$",
      "",
      kostra_unit_name
    )
    
    subtitle_parts <- c(
      subtitle_parts,
      short_unit_name
    )
  }
  
  if (
    has_kostra &&
    !is.null(kostra_title) &&
    length(kostra_title) > 0L &&
    !is.na(kostra_title)
  ) {
    subtitle_parts <- c(
      subtitle_parts,
      kostra_title
    )
  }
  
  subtitle <- paste(
    subtitle_parts,
    collapse = " \u00b7 "
  )
  
  # ------------------------------------------------------------
  # Årsakse
  # ------------------------------------------------------------
  
  year_range <- range(
    plot_data_long$Aar,
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
    tail(year_breaks, 1) != year_range[[2]]
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
  
  ggplot2::ggplot(
    plot_data_long,
    ggplot2::aes(
      x = .data$Aar,
      y = .data$Verdi,
      colour = .data$Display_navn
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
    ggplot2::scale_y_continuous(
      labels = scales::label_number(
        big.mark = " ",
        decimal.mark = ","
      )
    ) +
    ggplot2::labs(
      title = "Sammenligning av tidsserier",
      subtitle = subtitle,
      x = NULL,
      y = y_label,
      colour = NULL,
      caption = caption
    ) +
    ggplot2::theme_minimal()
}
