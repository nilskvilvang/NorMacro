
#' Estimer regresjonsmodell for sammenligningsserier
#'
#' Estimerer en regresjonsmodell basert på seriene i et
#' `comparison_series`-objekt.
#'
#' Modellen angis med en vanlig R-formel der variablene er `Serie_id`-ene i
#' objektet.
#'
#' @param x Et `comparison_series`-objekt.
#' @param formula En R-formel, for eksempel
#'   `NO_BNP_Fastland_vekst ~ NO_Inflasjon + SE_BNP_vekst`.
#' @param model Modelltype. Standard er `"ols"`.
#' @param start_year Valgfritt første år i estimeringsperioden.
#' @param end_year Valgfritt siste år i estimeringsperioden.
#' @param ... Videre argumenter til metoden.
#'
#' @return Et objekt av klassen `comparison_series_regression`.
#'
#' @method regress comparison_series
#' @keywords internal
#' @export

regress.comparison_series <- function(x,
                                      formula,
                                      model = "ols",
                                      start_year = NULL,
                                      end_year = NULL,
                                      ...) {
  # ------------------------------------------------------------
  # Valider argumenter
  # ------------------------------------------------------------
  
  if (!inherits(formula, "formula")) {
    stop("`formula` m\u00e5 v\u00e6re en R-formel, for eksempel ",
         "`NO_KPI ~ SE_HICP + DK_HICP`.",
         call. = FALSE)
  }
  
  model <- match.arg(model, choices = "ols")
  
  validate_year <- function(value, argument) {
    if (is.null(value)) {
      return(invisible(NULL))
    }
    
    if (!is.numeric(value) ||
        length(value) != 1 ||
        is.na(value) ||
        !is.finite(value)) {
      stop("`", argument, "` m\u00e5 v\u00e6re ett endelig numerisk \u00e5r.", call. = FALSE)
    }
    
    invisible(NULL)
  }
  
  validate_year(start_year, "start_year")
  
  validate_year(end_year, "end_year")
  
  if (!is.null(start_year) &&
      !is.null(end_year) &&
      start_year > end_year) {
    stop("`start_year` kan ikke v\u00e6re st\u00f8rre enn `end_year`.", call. = FALSE)
  }
  
  required_columns <- c("Aar", "Serie_id", "Display_navn", "Verdi")
  
  missing_columns <- setdiff(required_columns, names(x))
  
  if (length(missing_columns) > 0) {
    stop(
      "Mangler n\u00f8dvendige kolonner: ",
      paste(missing_columns, collapse = ", "),
      ".",
      call. = FALSE
    )
  }
  
  # Første versjon krever én enkel serie på venstresiden.
  formula_response <- formula[[2]]
  
  if (!is.symbol(formula_response)) {
    stop(
      "Venstresiden i `formula` m\u00e5 v\u00e6re \u00e9n `Serie_id`, ",
      "for eksempel `NO_KPI ~ SE_HICP`.",
      call. = FALSE
    )
  }
  
  dependent_variable <- as.character(formula_response)
  
  formula_variables <- all.vars(formula)
  
  independent_variables <- setdiff(formula_variables, dependent_variable)
  
  if (length(independent_variables) == 0) {
    stop("Formelen m\u00e5 inneholde minst \u00e9n forklaringsvariabel.",
         call. = FALSE)
  }
  
  available_series <- unique(x$Serie_id)
  
  missing_series <- setdiff(formula_variables, available_series)
  
  if (length(missing_series) > 0) {
    stop(
      "Fant ikke f\u00f8lgende serier i objektet: ",
      paste(missing_series, collapse = ", "),
      ".",
      call. = FALSE
    )
  }
  
  # ------------------------------------------------------------
  # Klargjør data
  # ------------------------------------------------------------
  
  analysis_data <- tibble::as_tibble(x) |>
    dplyr::filter(.data$Serie_id %in% formula_variables)
  
  if (!is.null(start_year)) {
    analysis_data <- analysis_data |>
      dplyr::filter(.data$Aar >= start_year)
  }
  
  if (!is.null(end_year)) {
    analysis_data <- analysis_data |>
      dplyr::filter(.data$Aar <= end_year)
  }
  
  if (nrow(analysis_data) == 0) {
    stop("Fant ingen observasjoner i valgt periode.", call. = FALSE)
  }
  
  duplicate_observations <- analysis_data |>
    dplyr::count(.data$Serie_id, .data$Aar, name = "Antall") |>
    dplyr::filter(.data$Antall > 1)
  
  if (nrow(duplicate_observations) > 0) {
    duplicate_example <- duplicate_observations |>
      dplyr::slice_head(n = 1)
    
    stop(
      "Hver serie m\u00e5 ha maksimalt \u00e9n observasjon per \u00e5r. ",
      "Fant flere observasjoner for `",
      duplicate_example$Serie_id,
      "` i ",
      duplicate_example$Aar,
      ".",
      call. = FALSE
    )
  }
  
  series_lookup <- tibble::tibble(Serie_id = analysis_data$Serie_id,
                                  Display_navn = analysis_data$Display_navn) |>
    dplyr::distinct()
  
  inconsistent_display_names <- series_lookup |>
    dplyr::count(Serie_id, name = "Antall_navn") |>
    dplyr::filter(.data$Antall_navn > 1)
  
  if (nrow(inconsistent_display_names) > 0) {
    stop("Minst \u00e9n `Serie_id` har flere ulike display-navn.", call. = FALSE)
  }
  
  wide_data <- analysis_data |>
    dplyr::select(Aar, Serie_id, Verdi) |>
    tidyr::pivot_wider(names_from = Serie_id, values_from = Verdi) |>
    dplyr::arrange(.data$Aar)
  
  # ------------------------------------------------------------
  # Finn komplette modellobservasjoner
  # ------------------------------------------------------------
  
  model_frame <- tryCatch(
    stats::model.frame(
      formula = formula,
      data = wide_data,
      na.action = stats::na.pass
    ),
    error = function(error) {
      stop("Kunne ikke evaluere regresjonsformelen: ",
           conditionMessage(error),
           call. = FALSE)
    }
  )
  
  complete_rows <- stats::complete.cases(model_frame)
  
  number_of_candidate_observations <- nrow(model_frame)
  
  number_of_observations <- sum(complete_rows)
  
  number_of_incomplete_observations <-
    number_of_candidate_observations -
    number_of_observations
  
  if (number_of_observations == 0) {
    stop("Ingen komplette observasjoner er tilgjengelige for modellen.",
         call. = FALSE)
  }
  
  model_data <- wide_data[complete_rows, , drop = FALSE]
  
  number_of_parameters <- ncol(stats::model.matrix(formula, data = model_data))
  
  if (number_of_observations <= number_of_parameters) {
    stop(
      "For f\u00e5 komplette observasjoner til \u00e5 estimere modellen. ",
      "Modellen har ",
      number_of_parameters,
      " parametere og bare ",
      number_of_observations,
      " komplette observasjoner.",
      call. = FALSE
    )
  }
  
  # ------------------------------------------------------------
  # Estimer modell
  # ------------------------------------------------------------
  
  model_object <- switch(model,
                         
                         ols = stats::lm(
                           formula = formula,
                           data = model_data,
                           na.action = stats::na.fail,
                           ...
                         ))
  
  estimated_years <- model_data$Aar
  
  coefficient_table <- tibble::tibble(Term = names(stats::coef(model_object)),
                                      Estimat = unname(stats::coef(model_object)))
  
  dependent_display_name <- series_lookup |>
    dplyr::filter(.data$Serie_id == dependent_variable) |>
    dplyr::pull(.data$Display_navn)
  
  independent_display_names <- series_lookup |>
    dplyr::filter(.data$Serie_id %in% independent_variables) |>
    dplyr::select(Serie_id, Display_navn)
  
  # ------------------------------------------------------------
  # Bygg NorMacro-resultat
  # ------------------------------------------------------------
  
  result <- list(
    model = model_object,
    formula = formula,
    model_type = model,
    dependent_variable = dependent_variable,
    independent_variables = independent_variables,
    dependent_display_name = dependent_display_name,
    independent_display_names = independent_display_names,
    coefficients = coefficient_table,
    model_data = model_data,
    number_of_candidate_observations =
      number_of_candidate_observations,
    number_of_observations =
      number_of_observations,
    number_of_incomplete_observations =
      number_of_incomplete_observations,
    estimated_start_year = min(estimated_years),
    estimated_end_year = max(estimated_years),
    requested_start_year = start_year,
    requested_end_year = end_year
  )
  
  attr(result, "transformation") <- attr(x, "transformation")
  
  attr(result, "transformation_periods") <- attr(x, "transformation_periods")
  
  attr(result, "base_year") <- attr(x, "base_year")
  
  attr(result, "transformation_base_value") <- attr(x, "transformation_base_value")
  
  class(result) <- c("comparison_series_regression", "list")
  
  result
}
