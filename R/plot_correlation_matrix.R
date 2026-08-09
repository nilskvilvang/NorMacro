
plot_correlation_matrix <- function(
    variables,
    data = NULL,
    start_year = NULL,
    end_year = NULL,
    country = NULL,
    unit = NULL,
    use = "pairwise.complete.obs",
    method = "pearson"
) {
  
  corr <- correlation_matrix(
    variables = variables,
    data = data,
    start_year = start_year,
    end_year = end_year,
    country = country,
    unit = unit,
    use = use,
    method = method
  )
  
  corr_df <- as.data.frame(
    as.table(corr)
  )
  
  names(corr_df) <- c(
    "Variabel1",
    "Variabel2",
    "Korrelasjon"
  )
  
  subtitle <- paste(
    method,
    "korrelasjon"
  )
  
  if (!is.null(country)) {
    subtitle <- paste0(
      subtitle,
      " \u00b7 ",
      country
    )
  }
  
  if (!is.null(unit)) {
    unit_name <- attr(
      corr,
      "kostra_unit_name"
    )
    
    if (
      !is.null(unit_name) &&
      length(unit_name) == 1L &&
      !is.na(unit_name)
    ) {
      unit_name <- sub(
        "\\s+-\\s+.*$",
        "",
        unit_name
      )
      
      subtitle <- paste0(
        subtitle,
        " \u00b7 ",
        unit_name
      )
    } else {
      subtitle <- paste0(
        subtitle,
        " \u00b7 ",
        unit
      )
    }
  }
  
  ggplot2::ggplot(
    corr_df,
    ggplot2::aes(
      x = .data$Variabel1,
      y = .data$Variabel2,
      fill = .data$Korrelasjon
    )
  ) +
    ggplot2::geom_tile(
      color = "white"
    ) +
    ggplot2::geom_text(
      ggplot2::aes(
        label = sprintf(
          "%.2f",
          .data$Korrelasjon
        )
      ),
      size = 4
    ) +
    ggplot2::scale_fill_gradient2(
      low = "#4575b4",
      mid = "white",
      high = "#d73027",
      midpoint = 0,
      limits = c(-1, 1)
    ) +
    ggplot2::labs(
      title = "Korrelasjonsmatrise",
      subtitle = subtitle,
      x = NULL,
      y = NULL,
      fill = "r"
    ) +
    ggplot2::coord_equal() +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      axis.text.x = ggplot2::element_text(
        angle = 45,
        hjust = 1
      ),
      panel.grid = ggplot2::element_blank()
    )
}
