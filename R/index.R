
#' Indekser en sammenligningsserie
#'
#' Omdanner serier til en felles indeks med valgt basisår og basisverdi.
#'
#' @param x Objektet som skal indekseres.
#' @param ... Tilleggsargumenter sendt til metode.
#'
#' @return Et indeksert objekt.
#'
#' @export

index <- function(
    x,
    ...
) {
  UseMethod(
    "index"
  )
}

#' @export

index.comparison_series <- function(x,
                                    base_year = NULL,
                                    base_value = 100,
                                    ...) {
  required_columns <- c("Aar", "Serie_id", "Verdi", "Enhet")
  
  missing_columns <- setdiff(required_columns, names(x))
  
  if (length(missing_columns) > 0) {
    stop(
      "Objektet mangler n\u00f8dvendige kolonner: ",
      paste(missing_columns, collapse = ", "),
      ".",
      call. = FALSE
    )
  }
  
  if (nrow(x) == 0) {
    stop("Objektet inneholder ingen observasjoner.", call. = FALSE)
  }
  
  transformation <- attr(x, "transformation")
  
  if (is.null(transformation)) {
    transformation <- if (isTRUE(attr(x, "normalized"))) {
      "indexed"
    } else {
      "level"
    }
  }
  
  if (!identical(transformation, "level")) {
    stop(
      paste0(
        "`index()` kan bare brukes p\u00e5 serier ",
        "p\u00e5 opprinnelig niv\u00e5. N\u00e5v\u00e6rende transformasjon: ",
        transformation,
        "."
      ),
      call. = FALSE
    )
  }
  
  if (!is.numeric(base_value) ||
      length(base_value) != 1 ||
      is.na(base_value) ||
      !is.finite(base_value) ||
      base_value == 0) {
    stop("`base_value` m\u00e5 v\u00e6re ett endelig numerisk tall ulik null.",
         call. = FALSE)
  }
  
  data <- x |>
    tibble::as_tibble()
  
  if (is.null(base_year)) {
    common_years <- data |>
      dplyr::filter(!is.na(.data$Verdi)) |>
      dplyr::distinct(.data$Serie_id, .data$Aar) |>
      dplyr::count(.data$Aar, name = "number_of_series")
    
    number_of_series <- data |>
      dplyr::distinct(.data$Serie_id) |>
      nrow()
    
    common_years <- common_years |>
      dplyr::filter(.data$number_of_series == number_of_series) |>
      dplyr::arrange(.data$Aar)
    
    if (nrow(common_years) == 0) {
      stop(paste0(
        "Fant ingen felles \u00e5r med gyldige verdier ",
        "for alle seriene."
      ),
      call. = FALSE)
    }
    
    base_year <- common_years$Aar[[1]]
    
  } else {
    if (!is.numeric(base_year) ||
        length(base_year) != 1 ||
        is.na(base_year) ||
        !is.finite(base_year) ||
        base_year != floor(base_year)) {
      stop("`base_year` m\u00e5 v\u00e6re ett gyldig heltallig \u00e5rstall.", call. = FALSE)
    }
    
    base_year <- as.integer(base_year)
  }
  
  base_data <- data |>
    dplyr::filter(.data$Aar == base_year, !is.na(.data$Verdi)) |>
    dplyr::select(.data$Serie_id, Basisverdi = .data$Verdi)
  
  all_series <- data |>
    dplyr::distinct(.data$Serie_id) |>
    dplyr::pull(.data$Serie_id)
  
  base_series <- base_data |>
    dplyr::distinct(.data$Serie_id) |>
    dplyr::pull(.data$Serie_id)
  
  missing_series <- setdiff(all_series, base_series)
  
  if (length(missing_series) > 0) {
    stop(
      "Alle seriene m\u00e5 ha data i valgt basis\u00e5r: ",
      base_year,
      ". Mangler for: ",
      paste(missing_series, collapse = ", "),
      ".",
      call. = FALSE
    )
  }
  
  zero_series <- base_data |>
    dplyr::filter(.data$Basisverdi == 0) |>
    dplyr::pull(.data$Serie_id)
  
  if (length(zero_series) > 0) {
    stop(
      "Basisverdien kan ikke v\u00e6re null. Gjelder: ",
      paste(zero_series, collapse = ", "),
      ".",
      call. = FALSE
    )
  }
  
  result <- data |>
    dplyr::left_join(base_data, by = "Serie_id") |>
    dplyr::mutate(
      Verdi = base_value *
        .data$Verdi /
        .data$Basisverdi,
      Enhet = paste0(
        "Indeks, ",
        base_year,
        " = ",
        format(base_value, trim = TRUE, scientific = FALSE)
      )
    ) |>
    dplyr::select(-.data$Basisverdi)
  
  new_comparison_series(
    result,
    normalized = identical(base_value, 100),
    base_year = base_year,
    transformation = "indexed",
    transformation_periods = NULL,
    transformation_base_value = base_value
  )
}
