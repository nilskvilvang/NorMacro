
print.comparison_series_regression_summary <- function(
    x,
    ...
) {
  
  model_statistics <- x$model_statistics
  data_statistics <- x$data_statistics
  
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
    ols = "OLS lineær regresjon",
    x$model_type
  )
  
  standard_error_label <- switch(
    x$model_type,
    ols = "OLS",
    x$model_type
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
    width = 36
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
  
  format_p_value <- function(
    value,
    digits = 3
  ) {
    
    if (
      length(value) != 1 ||
      is.na(value)
    ) {
      return(
        NA_character_
      )
    }
    
    threshold <- 10^(-digits)
    
    if (value < threshold) {
      return(
        paste0(
          "< ",
          format_number(
            threshold,
            digits = digits
          )
        )
      )
    }
    
    format_number(
      value,
      digits = digits
    )
  }
  
  cat(
    "<comparison_series_regression_summary>\n\n"
  )
  
  cat(
    "MODELLINFORMASJON\n\n"
  )
  
  print_field(
    "Observasjoner",
    data_statistics$Brukte_observasjoner
  )
  
  if (
    data_statistics$Ufullstendige_perioder > 0
  ) {
    print_field(
      "Perioder uten komplette modelldata",
      data_statistics$Ufullstendige_perioder
    )
  }
  
  print_field(
    "Avhengig variabel",
    paste0(
      x$dependent_display_name,
      " [",
      x$dependent_variable,
      "]"
    )
  )
  
  print_field(
    "Modelltype",
    model_label
  )
  
  print_field(
    "Formel",
    formula_label
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
      data_statistics$Estimert_startaar,
      "–",
      data_statistics$Estimert_sluttaar
    )
  )
  
  cat(
    "\nMODELLTILPASNING\n\n"
  )
  
  if (!is.na(model_statistics$F_verdi)) {
    
    print_field(
      paste0(
        "F(",
        format(
          model_statistics$Teller_frihetsgrader,
          trim = TRUE
        ),
        ", ",
        format(
          model_statistics$Nevner_frihetsgrader,
          trim = TRUE
        ),
        ")"
      ),
      format_number(
        model_statistics$F_verdi,
        digits = 3
      )
    )
    
    print_field(
      "F-test, p-verdi",
      format_p_value(
        model_statistics$F_p_verdi,
        digits = 3
      )
    )
    
  }
  
  print_field(
    "R-kvadrert",
    format_number(
      model_statistics$R_kvadrert,
      digits = 3
    )
  )
  
  print_field(
    "Justert R-kvadrert",
    format_number(
      model_statistics$Justert_R_kvadrert,
      digits = 3
    )
  )
  
  print_field(
    "Residual standardfeil",
    format_number(
      model_statistics$Residual_standardfeil,
      digits = 3
    )
  )
  
  cat(
    "\nStandardfeil: ",
    standard_error_label,
    "\n\n",
    sep = ""
  )
  
  coefficient_output <- x$coefficients |>
    dplyr::transmute(
      Term = .data$Term,
      Estimat = format_number(
        .data$Estimat,
        digits = 3
      ),
      `Std.feil` = format_number(
        .data$Standardfeil,
        digits = 3
      ),
      `t-verdi` = format_number(
        .data$T_verdi,
        digits = 3
      ),
      `p-verdi` = vapply(
        .data$P_verdi,
        format_p_value,
        character(1),
        digits = 3
      ),
      Signifikans = .data$Signifikans
    )
  
  print(
    coefficient_output,
    ...
  )
  
  cat(
    "\nSignifikans: ",
    "*** p < 0,001; ",
    "** p < 0,01; ",
    "* p < 0,05; ",
    ". p < 0,10\n",
    sep = ""
  )
  
  invisible(
    x
  )
}