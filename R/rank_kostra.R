
rank_kostra <- function(
    variable,
    data,
    year = NULL,
    descending = TRUE,
    top_n = NULL
) {
  
  if (!is.data.frame(data)) {
    stop(
      "`data` må være et datasett.",
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
      "`rank_kostra()` krever et KOSTRA-datasett med kolonnene: ",
      paste(required_columns, collapse = ", "),
      ".",
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
      "`variable` må være navnet på én gyldig variabel.",
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
      "` må være numerisk.",
      call. = FALSE
    )
  }
  
  if (
    !is.logical(descending) ||
    length(descending) != 1L ||
    is.na(descending)
  ) {
    stop(
      "`descending` må være `TRUE` eller `FALSE`.",
      call. = FALSE
    )
  }
  
  if (!is.null(top_n)) {
    if (
      !is.numeric(top_n) ||
      length(top_n) != 1L ||
      is.na(top_n) ||
      !is.finite(top_n) ||
      top_n < 1
    ) {
      stop(
        "`top_n` må være et positivt heltall eller `NULL`.",
        call. = FALSE
      )
    }
    
    top_n <- as.integer(top_n)
  }
  
  analysis_data <- data |>
    dplyr::select(
      Enhet,
      Enhet_navn,
      Enhetstype,
      Aar,
      Verdi = dplyr::all_of(variable)
    ) |>
    dplyr::filter(
      !is.na(.data$Verdi)
    )
  
  if (nrow(analysis_data) == 0L) {
    stop(
      "Variabelen `",
      variable,
      "` har ingen observasjoner.",
      call. = FALSE
    )
  }
  
  if (is.null(year)) {
    year <- max(
      analysis_data$Aar,
      na.rm = TRUE
    )
  } else {
    if (
      !is.numeric(year) ||
      length(year) != 1L ||
      is.na(year) ||
      !is.finite(year)
    ) {
      stop(
        "`year` må være ett gyldig år.",
        call. = FALSE
      )
    }
  }
  
  result <- analysis_data |>
    dplyr::filter(
      .data$Aar == year
    )
  
  if (nrow(result) == 0L) {
    stop(
      "Fant ingen observasjoner for `",
      variable,
      "` i ",
      year,
      ".",
      call. = FALSE
    )
  }
  
    if (descending) {
    result <- result |>
      dplyr::arrange(
        dplyr::desc(.data$Verdi),
        .data$Enhet
      ) |>
      dplyr::mutate(
        Rang = dplyr::min_rank(
          dplyr::desc(.data$Verdi)
        ),
        .before = 1
      )
  } else {
    result <- result |>
      dplyr::arrange(
        .data$Verdi,
        .data$Enhet
      ) |>
      dplyr::mutate(
        Rang = dplyr::min_rank(
          .data$Verdi
        ),
        .before = 1
      )
  }
  
  if (!is.null(top_n)) {
    result <- result |>
      dplyr::slice_head(
        n = top_n
      )
  }
  
  metadata <- get_metadata(data)
  
  meta <- metadata |>
    dplyr::filter(
      .data$Variabel == variable
    )
  
  attr(result, "variable") <- variable
  attr(result, "year") <- year
  attr(result, "descending") <- descending
  
  if (nrow(meta) > 0L) {
    if ("Display_navn" %in% names(meta)) {
      attr(result, "display_name") <- meta$Display_navn[1]
    }
    
    if ("Enhet" %in% names(meta)) {
      attr(result, "unit") <- meta$Enhet[1]
    }
    
    if ("Analyse_type" %in% names(meta)) {
      attr(result, "analysis_type") <- meta$Analyse_type[1]
    }
  }
  
  class(result) <- c(
    "kostra_ranking",
    class(result)
  )
  
  result
}
