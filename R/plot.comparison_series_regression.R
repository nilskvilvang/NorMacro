
plot.comparison_series_regression <- function(
    x,
    type = c(
      "fitted",
      "residuals"
    ),
    ...
) {
  
  type <- match.arg(
    type
  )
  
  plot_data <-
    regression_plot_data(
      x
    )
  
  if (type == "fitted") {
    
    fitted_data <-
      plot_data |>
      tidyr::pivot_longer(
        cols = c(
          "Faktisk",
          "Estimert"
        ),
        names_to = "Serie",
        values_to = "Verdi"
      ) |>
      dplyr::mutate(
        Serie = factor(
          .data$Serie,
          levels = c(
            "Faktisk",
            "Estimert"
          )
        )
      )
    
    p <-
      ggplot2::ggplot(
        fitted_data,
        ggplot2::aes(
          x = .data$Aar,
          y = .data$Verdi,
          linetype = .data$Serie
        )
      ) +
      ggplot2::geom_line(
        linewidth = 0.8
      ) +
      ggplot2::labs(
        title = paste0(
          x$dependent_display_name,
          ": faktisk og estimert"
        ),
        x = NULL,
        y = NULL,
        linetype = NULL
      ) +
      ggplot2::theme_minimal() + 
      ggplot2::scale_linetype_manual(
        values = c(
          "Faktisk" = "solid",
          "Estimert" = "dashed"
        )
      )
    
  }
  
  if (type == "residuals") {
    
    p <-
      ggplot2::ggplot(
        plot_data,
        ggplot2::aes(
          x = .data$Aar,
          y = .data$Residual
        )
      ) +
      ggplot2::geom_hline(
        yintercept = 0,
        linetype = "dashed"
      ) +
      ggplot2::geom_line(
        linewidth = 0.8
      ) +
      ggplot2::geom_point(
        size = 1.8
      ) +
      ggplot2::labs(
        title = paste0(
          x$dependent_display_name,
          ": residualer"
        ),
        x = NULL,
        y = NULL
      ) +
      ggplot2::theme_minimal()
  }
  
  p
  
}