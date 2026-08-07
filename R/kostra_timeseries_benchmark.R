
kostra_timeseries_benchmark <- function(variable,
                                        data,
                                        unit,
                                        start_year = NULL,
                                        end_year = NULL,
                                        descending = TRUE) {
  if (!is.data.frame(data)) {
    stop("`data` må være et datasett.", call. = FALSE)
  }
  
  if (!is.logical(descending) ||
      length(descending) != 1L ||
      is.na(descending)) {
    stop("`descending` må være `TRUE` eller `FALSE`.", call. = FALSE)
  }
  
  required_columns <- c("Enhet", "Enhet_navn", "Enhetstype", "Aar")
  
  missing_columns <- setdiff(required_columns, names(data))
  
  if (length(missing_columns) > 0L) {
    stop("`kostra_timeseries_benchmark()` krever et KOSTRA-datasett.",
         call. = FALSE)
  }
  
  if (!is.character(variable) ||
      length(variable) != 1L ||
      is.na(variable) ||
      variable == "") {
    stop("`variable` må være navnet på én gyldig variabel.", call. = FALSE)
  }
  
  if (!variable %in% names(data)) {
    stop("Fant ikke variabelen i datasettet: ", variable, call. = FALSE)
  }
  
  if (!is.numeric(data[[variable]])) {
    stop("Variabelen `", variable, "` må være numerisk.", call. = FALSE)
  }
  
  if (!is.character(unit) ||
      length(unit) != 1L ||
      is.na(unit) ||
      unit == "") {
    stop("`unit` må angi én gyldig KOSTRA-enhet.", call. = FALSE)
  }
  
  available_units <- data$Enhet |>
    unique() |>
    stats::na.omit() |>
    as.character()
  
  if (!unit %in% available_units) {
    stop("Fant ikke KOSTRA-enheten: ", unit, call. = FALSE)
  }
  
  validate_year <- function(value, argument) {
    if (is.null(value)) {
      return(invisible(NULL))
    }
    
    if (!is.numeric(value) ||
        length(value) != 1L ||
        is.na(value) ||
        !is.finite(value)) {
      stop("`", argument, "` må være ett gyldig år.", call. = FALSE)
    }
    
    invisible(NULL)
  }
  
  validate_year(start_year, "start_year")
  
  validate_year(end_year, "end_year")
  
  if (!is.null(start_year) &&
      !is.null(end_year) &&
      start_year > end_year) {
    stop("`start_year` kan ikke være større enn `end_year`.", call. = FALSE)
  }
  
  analysis_data <- data |>
    dplyr::select(Enhet, Enhet_navn, Enhetstype, Aar, Verdi = dplyr::all_of(variable))
  
  if (!is.null(start_year)) {
    analysis_data <- analysis_data |>
      dplyr::filter(.data$Aar >= start_year)
  }
  
  if (!is.null(end_year)) {
    analysis_data <- analysis_data |>
      dplyr::filter(.data$Aar <= end_year)
  }
  
  analysis_data <- analysis_data |>
    dplyr::filter(!is.na(.data$Verdi))
  
  if (nrow(analysis_data) == 0L) {
    stop("Fant ingen observasjoner i valgt periode.", call. = FALSE)
  }
  
  distribution <- analysis_data |>
    dplyr::group_by(.data$Aar) |>
    dplyr::summarise(
      Antall_enheter = dplyr::n(),
      Gjennomsnitt = mean(.data$Verdi, na.rm = TRUE),
      Median = stats::median(.data$Verdi, na.rm = TRUE),
      Q1 = as.numeric(
        stats::quantile(
          .data$Verdi,
          probs = 0.25,
          na.rm = TRUE,
          names = FALSE
        )
      ),
      Q3 = as.numeric(
        stats::quantile(
          .data$Verdi,
          probs = 0.75,
          na.rm = TRUE,
          names = FALSE
        )
      ),
      .groups = "drop"
    )
  
  ranking <- analysis_data |>
    dplyr::group_by(.data$Aar)
  
  if (descending) {
    ranking <- ranking |>
      dplyr::arrange(dplyr::desc(.data$Verdi), .data$Enhet, .by_group = TRUE)
  } else {
    ranking <- ranking |>
      dplyr::arrange(.data$Verdi, .data$Enhet, .by_group = TRUE)
  }
  
  ranking <- ranking |>
    dplyr::mutate(Rang = dplyr::row_number()) |>
    dplyr::ungroup()
  
  selected_unit <- ranking |>
    dplyr::filter(.data$Enhet == unit) |>
    dplyr::left_join(distribution, by = "Aar") |>
    dplyr::mutate(Percentil = dplyr::if_else(
      .data$Antall_enheter <= 1L,
      NA_real_,
      (.data$Antall_enheter -
         .data$Rang) /
        (.data$Antall_enheter -
           1) *
        100
    )) |>
    dplyr::arrange(.data$Aar)
  
  if (nrow(selected_unit) == 0L) {
    stop("Den valgte KOSTRA-enheten har ingen observasjoner i perioden.",
         call. = FALSE)
  }
  
  metadata <- get_metadata(data)
  
  meta <- metadata |>
    dplyr::filter(.data$Variabel == variable)
  
  attr(selected_unit, "variable") <- variable
  
  attr(selected_unit, "start_year") <- min(selected_unit$Aar)
  
  attr(selected_unit, "end_year") <- max(selected_unit$Aar)
  
  attr(selected_unit, "kostra_table") <- attr(data, "kostra_table")
  
  attr(selected_unit, "kostra_title") <- attr(data, "kostra_title")
  
  attr(selected_unit, "descending") <- descending
  
  if (nrow(meta) > 0L) {
    if ("Display_navn" %in% names(meta)) {
      attr(selected_unit, "display_name") <- meta$Display_navn[[1]]
    }
    
    if ("Enhet" %in% names(meta)) {
      attr(selected_unit, "unit") <- meta$Enhet[[1]]
    }
    
    if ("Analyse_type" %in% names(meta)) {
      attr(selected_unit, "analysis_type") <- meta$Analyse_type[[1]]
    }
  }
  
  class(selected_unit) <- c("kostra_timeseries_benchmark", class(selected_unit))
  
  selected_unit
}
