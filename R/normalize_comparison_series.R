
normalize.comparison_series <- function(
    x,
    base_year = NULL,
    ...
) {
  
  required_columns <- c(
    "Aar",
    "Serie_id",
    "Verdi"
  )
  
  missing_columns <- setdiff(
    required_columns,
    names(x)
  )
  
  if (length(missing_columns) > 0) {
    stop(
      "Objektet mangler nødvendige kolonner: ",
      paste(missing_columns, collapse = ", "),
      call. = FALSE
    )
  }
  
  if (isTRUE(attr(x, "normalized"))) {
    
    old_base_year <- attr(x, "base_year")
    
    stop(
      "Objektet er allerede normalisert",
      if (!is.null(old_base_year)) {
        paste0(" med basisår ", old_base_year)
      },
      ".",
      call. = FALSE
    )
  }
  
  available_years <- x |>
    dplyr::filter(!is.na(.data$Verdi)) |>
    dplyr::distinct(
      .data$Serie_id,
      .data$Aar
    ) |>
    dplyr::count(
      .data$Aar,
      name = "Antall_serier"
    )
  
  n_series <- dplyr::n_distinct(x$Serie_id)
  
  common_years <- available_years |>
    dplyr::filter(
      .data$Antall_serier == n_series
    ) |>
    dplyr::pull(.data$Aar)
  
  if (length(common_years) == 0) {
    stop(
      paste0(
        "Fant ingen år der alle seriene har gyldige data. ",
        "Seriene kan derfor ikke normaliseres mot et felles basisår."
      ),
      call. = FALSE
    )
  }
  
  if (is.null(base_year)) {
    base_year <- min(common_years)
  } else {
    
    if (!is.numeric(base_year) ||
        length(base_year) != 1 ||
        is.na(base_year)) {
      
      stop(
        "`base_year` må være ett gyldig årstall.",
        call. = FALSE
      )
    }
    
    base_year <- as.integer(base_year)
    
    if (!base_year %in% common_years) {
      stop(
        "Alle seriene må ha data i valgt basisår: ",
        base_year,
        call. = FALSE
      )
    }
  }
  
  base_values <- x |>
    tibble::as_tibble() |>
    dplyr::filter(
      .data$Aar == base_year
    ) |>
    dplyr::select(
      Serie_id,
      Basisverdi = Verdi
    )
  
  zero_base_values <- base_values |>
    dplyr::filter(
      .data$Basisverdi == 0
    ) |>
    dplyr::pull(.data$Serie_id)
  
  if (length(zero_base_values) > 0) {
    stop(
      paste0(
        "Kan ikke normalisere serier med basisverdi lik null: ",
        paste(zero_base_values, collapse = ", ")
      ),
      call. = FALSE
    )
  }
  
  result <- x |>
    tibble::as_tibble() |>
    dplyr::left_join(
      base_values,
      by = "Serie_id"
    ) |>
    dplyr::mutate(
      Verdi = 100 * .data$Verdi / .data$Basisverdi,
      Enhet = paste0("Indeks, ", base_year, " = 100")
    ) |>
    dplyr::select(
      -Basisverdi
    )
  
  new_comparison_series(
    result,
    normalized = TRUE,
    base_year = base_year
  )
}
