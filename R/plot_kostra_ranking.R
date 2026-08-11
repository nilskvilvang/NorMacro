
#' Plot en KOSTRA-rangering
#'
#' Visualiserer rangeringen av KOSTRA-enheter etter en valgt indikator
#' i ett år.
#'
#' @param variable Navnet på KOSTRA-indikatoren.
#' @param data Et KOSTRA-datasett.
#' @param year Valgfritt år. Hvis `NULL`, brukes siste tilgjengelige år.
#' @param units Valgfri tegnvektor med enhetskoder som skal inkluderes.
#' @param highlight Valgfri enhet som skal fremheves i figuren.
#' @param descending Logisk. Hvis `TRUE`, rangeres høyeste verdi først.
#'
#' @return Et `ggplot`-objekt.
#'
#' @examples
#' plot_kostra_ranking(
#'   "Netto_driftsresultat",
#'   data = normacro_kostra_example,
#'   year = 2025
#' )
#'
#' @export

plot_kostra_ranking <- function(
    variable,
    data,
    year = NULL,
    units = NULL,
    highlight = NULL,
    descending = TRUE
) {
  
  if (!is.data.frame(data)) {
    stop(
      "`data` m\u00e5 v\u00e6re et datasett.",
      call. = FALSE
    )
  }
  
  required_columns <- c(
    "Enhet",
    "Enhet_navn",
    "Enhetstype",
    "Aar"
  )
  
  missing_columns <- setdiff(
    required_columns,
    names(data)
  )
  
  if (length(missing_columns) > 0L) {
    stop(
      "`plot_kostra_ranking()` krever et KOSTRA-datasett.",
      call. = FALSE
    )
  }
  
  if (
    !is.character(variable) ||
    length(variable) != 1L ||
    is.na(variable) ||
    variable == ""
  ) {
    stop(
      "`variable` m\u00e5 v\u00e6re navnet p\u00e5 \u00e9n gyldig variabel.",
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
  
  if (!is.numeric(data[[variable]])) {
    stop(
      "Variabelen `",
      variable,
      "` m\u00e5 v\u00e6re numerisk.",
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
  
  available_units <- data$Enhet |>
    unique() |>
    stats::na.omit() |>
    as.character()
  
  if (!is.null(units)) {
    
    if (
      !is.character(units) ||
      length(units) == 0L ||
      anyNA(units) ||
      any(units == "")
    ) {
      stop(
        "`units` m\u00e5 v\u00e6re en tegnvektor med gyldige KOSTRA-enheter.",
        call. = FALSE
      )
    }
    
    units <- unique(
      units
    )
    
    missing_units <- setdiff(
      units,
      available_units
    )
    
    if (length(missing_units) > 0L) {
      stop(
        "Fant ikke KOSTRA-enheter i datasettet: ",
        paste(
          missing_units,
          collapse = ", "
        ),
        call. = FALSE
      )
    }
    
    data <- data |>
      dplyr::filter(
        .data$Enhet %in% units
      )
  }
  
  if (!is.null(highlight)) {
    
    if (
      !is.character(highlight) ||
      length(highlight) == 0L ||
      anyNA(highlight) ||
      any(highlight == "")
    ) {
      stop(
        "`highlight` m\u00e5 v\u00e6re en tegnvektor med gyldige KOSTRA-enheter.",
        call. = FALSE
      )
    }
    
    highlight <- unique(
      highlight
    )
    
    missing_highlight <- setdiff(
      highlight,
      unique(data$Enhet)
    )
    
    if (length(missing_highlight) > 0L) {
      stop(
        "Fant ikke fremhevede KOSTRA-enheter i datasettet: ",
        paste(
          missing_highlight,
          collapse = ", "
        ),
        call. = FALSE
      )
    }
  }
  
  ranking <- rank_kostra(
    variable = variable,
    data = data,
    year = year,
    descending = descending
  )
  
  selected_year <- attr(
    ranking,
    "year"
  )
  
  metadata <- get_metadata(
    data
  )
  
  meta <- metadata |>
    dplyr::filter(
      .data$Variabel == variable
    )
  
  display_name <- if (
    nrow(meta) > 0L &&
    "Display_navn" %in% names(meta)
  ) {
    meta$Display_navn[[1]]
  } else {
    stringr::str_to_sentence(
      gsub(
        "_",
        " ",
        variable
      )
    )
  }
  
  measure_unit <- if (
    nrow(meta) > 0L &&
    "Enhet" %in% names(meta)
  ) {
    meta$Enhet[[1]]
  } else {
    NULL
  }
  
  ranking <- ranking |>
    dplyr::mutate(
      Enhet_navn_kort = sub(
        "\\s+-\\s+.*$",
        "",
        .data$Enhet_navn
      ),
      Fremhevet = if (is.null(highlight)) {
        FALSE
      } else {
        .data$Enhet %in% highlight
      }
    )
  
  # Faktorrekkefølgen må følge rangeringen.
  ranking <- ranking |>
    dplyr::mutate(
      Enhet_navn_kort = factor(
        .data$Enhet_navn_kort,
        levels = rev(
          .data$Enhet_navn_kort
        )
      )
    )
  
  kostra_table <- attr(
    data,
    "kostra_table"
  )
  
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
  
  subtitle <- paste0(
    selected_year,
    " - ",
    nrow(ranking),
    " enheter"
  )
  
  value_range <- range(
    ranking$Verdi,
    na.rm = TRUE
  )
  
  label_nudge <- diff(
    value_range
  ) * 0.025
  
  if (
    !is.finite(label_nudge) ||
    label_nudge == 0
  ) {
    label_nudge <- max(
      abs(ranking$Verdi),
      na.rm = TRUE
    ) * 0.025
  }
  
  if (
    !is.finite(label_nudge) ||
    label_nudge == 0
  ) {
    label_nudge <- 0.1
  }
  
  p <- ggplot2::ggplot(
    ranking,
    ggplot2::aes(
      x = .data$Verdi,
      y = .data$Enhet_navn_kort
    )
  ) +
    ggplot2::geom_segment(
      ggplot2::aes(
        x = 0,
        xend = .data$Verdi,
        yend = .data$Enhet_navn_kort
      ),
      linewidth = 0.6,
      alpha = 0.45
    ) +
    ggplot2::geom_point(
      data = ranking |>
        dplyr::filter(
          !.data$Fremhevet
        ),
      size = 3,
      alpha = 0.65
    ) +
    ggplot2::geom_point(
      data = ranking |>
        dplyr::filter(
          .data$Fremhevet
        ),
      size = 4
    ) +
    ggplot2::geom_text(
      ggplot2::aes(
        label = scales::number(
          .data$Verdi,
          big.mark = " ",
          decimal.mark = ",",
          accuracy = 0.1
        )
      ),
      nudge_x = label_nudge,
      hjust = 0,
      size = 3.2
    ) +
    ggplot2::scale_x_continuous(
      labels = scales::label_number(
        big.mark = " ",
        decimal.mark = ","
      ),
      expand = ggplot2::expansion(
        mult = c(
          0.02,
          0.10
        )
      )
    ) +
    ggplot2::labs(
      title = display_name,
      subtitle = subtitle,
      x = measure_unit,
      y = NULL,
      caption = caption
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      panel.grid.major.y = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank()
    )
  
  p
}

