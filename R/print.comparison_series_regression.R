
print.comparison_series_regression <- function(
    x,
    ...
) {
  
  model_summary <- summary(
    x$model
  )
  
  transformation <- attr(
    x,
    "transformation"
  )
  
  transformation_periods <- attr(
    x,
    "transformation_periods"
  )
  
  model_label <- switch(
    x$model_type,
    ols = "OLS"
  )
  
  formula_label <- paste(
    deparse(
      x$formula
    ),
    collapse = " "
  )
  
  print_field <- function(
    label,
    value,
    width = 23
  ) {
    
    cat(
      sprintf(
        paste0(
          "%-",
          width,
          "s%s\n"
        ),
        paste0(
          label,
          ":"
        ),
        value
      )
    )
    
  }
  
  cat(
    "<comparison_series_regression>\n\n"
  )
  
  print_field(
    "Modell",
    model_label
  )
  
  print_field(
    "Formel",
    formula_label
  )
  
  print_field(
    "Avhengig variabel",
    paste0(
      x$dependent_display_name,
      " [",
      x$dependent_variable,
      "]"
    )
  )
  
  if (!is.null(transformation)) {
    print_field(
      "Transformasjon",
      transformation
    )
  }
  
  if (!is.null(transformation_periods)) {
    print_field(
      "Perioder",
      transformation_periods
    )
  }
  
  print_field(
    "Estimert periode",
    paste0(
      x$estimated_start_year,
      "–",
      x$estimated_end_year
    )
  )
  
  print_field(
    "Observasjoner",
    x$number_of_observations
  )
  
  print_field(
    "R-kvadrert",
    format_number(
      model_summary$r.squared,
      digits = 3
    )
  )
  
  print_field(
    "Justert R-kvadrert",
    format_number(
      model_summary$adj.r.squared,
      digits = 3
    )
  )
  
  coefficient_output <- x$coefficients |>
    dplyr::mutate(
      Estimat = format_number(
        .data$Estimat,
        digits = 3
      )
    )
  
  cat(
    "\nKoeffisienter:\n\n"
  )
  
  print(
    coefficient_output,
    ...
  )
  
  invisible(
    x
  )
}