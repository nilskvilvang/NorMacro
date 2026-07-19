

index.comparison_series <- function(x,
                                    base_year = NULL,
                                    base_value = 100,
                                    ...) {
  required_columns <- c("Aar", "Serie_id", "Verdi", "Enhet")
  
  missing_columns <- setdiff(required_columns, names(x))
  
  if (length(missing_columns) > 0) {
    stop(
      "Objektet mangler nødvendige kolonner: ",
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
        "`index()` kan bare brukes på serier ",
        "på opprinnelig nivå. Nåværende transformasjon: ",
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
    stop("`base_value` må være ett endelig numerisk tall ulik null.",
         call. = FALSE)
  }
  
  data <- x |>
    tibble::as_tibble()
  
  if (is.null(base_year)) {
    base_year <- find_first_common_year(data)
    
  } else {
    if (!is.numeric(base_year) ||
        length(base_year) != 1 ||
        is.na(base_year) ||
        !is.finite(base_year) ||
        base_year != floor(base_year)) {
      stop("`base_year` må være ett gyldig heltallig årstall.", call. = FALSE)
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
      "Alle seriene må ha data i valgt basisår: ",
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
      "Basisverdien kan ikke være null. Gjelder: ",
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
    normalized = FALSE,
    base_year = base_year,
    transformation = "indexed",
    transformation_periods = NULL,
    transformation_base_value = base_value
  )
}