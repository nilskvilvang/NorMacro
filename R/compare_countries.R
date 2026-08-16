
#' Sammenlign en variabel mellom land
#'
#' Lager et tidsserieplott for en internasjonal makrovariabel
#' paa tvers av valgte land.
#'
#' @param variable Navn paa en variabel i det internasjonale datasettet.
#' @param countries Tegnvektor med landkoder som skal sammenlignes.
#'   Hvis `NULL`, brukes tilgjengelige standardland.
#' @param data Internasjonalt NorMacro-datasett. Hvis `NULL`, brukes
#'   [get_international_macro()].
#' @param start_year Forste aar som skal vises. Standard er `NULL`.
#' @param normalize Logisk. Hvis `TRUE`, normaliseres seriene til
#'   100 i et felles basisaar.
#' @param base_year Basisaar ved normalisering. Hvis `NULL`, brukes
#'   forste felles aar med data for alle valgte land.
#'
#' @return Et `ggplot`-objekt.
#'
#' @examples
#' \dontrun{
#' compare_countries(
#'   "BNP_vekst",
#'   countries = c("NO", "SE", "DK", "DE")
#' )
#'
#' compare_countries(
#'   "Arbeidsproduktivitet",
#'   countries = c("NO", "SE", "DK", "DE"),
#'   start_year = 2000,
#'   normalize = TRUE
#' )
#' }
#'
#' @export

compare_countries <- function(
    variable,
    countries = NULL,
    data = NULL,
    start_year = NULL,
    normalize = FALSE,
    base_year = NULL
) {
  
  # ------------------------------------------------------------
  # Hent data
  # ------------------------------------------------------------
  
  if (is.null(data)) {
    data <- get_international_macro()
  }
  
  if (!is.data.frame(data)) {
    stop(
      "`data` m\u00e5 v\u00e6re en data.frame eller tibble.",
      call. = FALSE
    )
  }
  
  required_columns <- c(
    "Aar",
    "Land"
  )
  
  missing_columns <- setdiff(
    required_columns,
    names(data)
  )
  
  if (length(missing_columns) > 0L) {
    stop(
      "Datasettet m\u00e5 inneholde kolonnene: ",
      paste(missing_columns, collapse = ", "),
      ".",
      call. = FALSE
    )
  }
  
  # ------------------------------------------------------------
  # Valider variabel
  # ------------------------------------------------------------
  
  if (
    !is.character(variable) ||
    length(variable) != 1L ||
    is.na(variable) ||
    variable == ""
  ) {
    stop(
      "`variable` m\u00e5 angi n\u00f8yaktig \u00e9n variabel.",
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
  
  # ------------------------------------------------------------
  # Land
  # ------------------------------------------------------------
  
  available_countries <- data$Land |>
    unique() |>
    stats::na.omit() |>
    as.character()
  
  if (is.null(countries)) {
    countries <- intersect(
      get_standard_countries(),
      available_countries
    )
  }
  
  if (
    !is.character(countries) ||
    length(countries) < 1L ||
    anyNA(countries) ||
    any(countries == "")
  ) {
    stop(
      "`countries` m\u00e5 v\u00e6re en tegnvektor med gyldige landkoder.",
      call. = FALSE
    )
  }
  
  countries <- unique(countries)
  
  missing_countries <- setdiff(
    countries,
    available_countries
  )
  
  if (length(missing_countries) > 0L) {
    stop(
      "Fant ikke land i datasettet: ",
      paste(missing_countries, collapse = ", "),
      call. = FALSE
    )
  }
  
  # ------------------------------------------------------------
  # Velg data
  # ------------------------------------------------------------
  
  plot_data <- data |>
    dplyr::filter(
      .data$Land %in% countries
    ) |>
    dplyr::select(
      Aar,
      Land,
      dplyr::all_of(variable)
    ) |>
    dplyr::filter(
      !is.na(.data[[variable]])
    )
  
  if (!is.null(start_year)) {
    plot_data <- plot_data |>
      dplyr::filter(
        .data$Aar >= start_year
      )
  }
  
  # ------------------------------------------------------------
  # Normalisering
  # ------------------------------------------------------------
  
  if (normalize) {
    
    if (is.null(base_year)) {
      
      common_years <- plot_data |>
        dplyr::count(
          .data$Aar
        ) |>
        dplyr::filter(
          .data$n == length(countries)
        ) |>
        dplyr::pull(
          .data$Aar
        )
      
      if (!is.null(start_year)) {
        common_years <- common_years[
          common_years >= start_year
        ]
      }
      
      if (length(common_years) == 0L) {
        stop(
          paste0(
            "Fant ikke et felles basis\u00e5r der alle valgte land har data.",
            "Angi `base_year` eksplisitt eller bruk `normalize = FALSE`."
          ),
          call. = FALSE
        )
      }
      
      base_year <- min(common_years)
    }
    
    base_values <- plot_data |>
      dplyr::filter(
        .data$Aar == base_year
      ) |>
      dplyr::select(
        Land,
        dplyr::all_of(variable)
      ) |>
      dplyr::rename(
        Baseverdi = dplyr::all_of(variable)
      )
    
    missing_base <- setdiff(
      countries,
      base_values$Land[
        !is.na(base_values$Baseverdi)
      ]
    )
    
    if (length(missing_base) > 0L) {
      stop(
        "Mangler data i basis\u00e5ret ",
        base_year,
        " for: ",
        paste(missing_base, collapse = ", "),
        ".",
        call. = FALSE
      )
    }
    
    plot_data <- plot_data |>
      dplyr::left_join(
        base_values,
        by = "Land"
      ) |>
      dplyr::mutate(
        Verdi = .data[[variable]] /
          .data$Baseverdi * 100
      )
    
    y_label <- paste0(
      "Indeks, ",
      base_year,
      " = 100"
    )
    
  } else {
    
    plot_data <- plot_data |>
      dplyr::mutate(
        Verdi = .data[[variable]]
      )
    
    y_label <- NULL
  }
  
  # ------------------------------------------------------------
  # Landnavn og rekkefolge
  # ------------------------------------------------------------
  
  plot_data <- plot_data |>
    dplyr::mutate(
      Land_navn = factor(
        get_country_name(.data$Land),
        levels = get_country_name(countries)
      )
    )
  
  # ------------------------------------------------------------
  # Metadata
  # ------------------------------------------------------------
  
  metadata <- get_metadata(data)
  
  meta <- metadata |>
    dplyr::filter(
      .data$Variabel == variable
    )
  
  display <- if (nrow(meta) > 0L) {
    get_display_name(
      variable,
      metadata
    )
  } else {
    stringr::str_to_sentence(
      gsub(
        "_",
        " ",
        variable
      )
    )
  }
  
  source_text <- if (nrow(meta) > 0L) {
    meta$Kilde |>
      unique() |>
      stats::na.omit() |>
      as.character()
  } else {
    character()
  }
  
  source_text <- source_text[
    nzchar(source_text)
  ]
  
  caption <- if (length(source_text) > 0L) {
    paste0(
      "Kilde: ",
      paste(
        source_text,
        collapse = ", "
      )
    )
  } else {
    NULL
  }

  # ------------------------------------------------------------
  # Plot
  # ------------------------------------------------------------
  
  ggplot2::ggplot(
    plot_data,
    ggplot2::aes(
      x = .data$Aar,
      y = .data$Verdi,
      colour = .data$Land_navn
    )
  ) +
    ggplot2::geom_line(
      linewidth = 0.9
    ) +
    ggplot2::scale_colour_discrete(
      limits = get_country_name(countries)
    ) +
    ggplot2::scale_y_continuous(
      labels = scales::label_number(
        big.mark = " ",
        decimal.mark = ","
      )
    ) +
    ggplot2::labs(
      title = display,
      subtitle = "Internasjonal sammenligning",
      x = NULL,
      y = y_label,
      colour = "Land",
      caption = caption
    ) +
    ggplot2::theme_minimal()
}
