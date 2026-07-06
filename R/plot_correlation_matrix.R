
plot_correlation_matrix <- function(
    variables,
    data = NULL,
    start_year = NULL,
    end_year = NULL,
    use = "pairwise.complete.obs",
    method = "pearson"
){
  
  corr <- correlation_matrix(
    variables = variables,
    data = data,
    start_year = start_year,
    end_year = end_year,
    use = use,
    method = method
  )
  
  corr_df <- as.data.frame(as.table(corr))
  
  names(corr_df) <- c(
    "Variabel1",
    "Variabel2",
    "Korrelasjon"
  )
  
  ggplot2::ggplot(
    corr_df,
    ggplot2::aes(
      x = Variabel1,
      y = Variabel2,
      fill = Korrelasjon
    )
  ) +
    ggplot2::geom_tile(color = "white") +
    ggplot2::geom_text(
      ggplot2::aes(
        label = sprintf("%.2f", Korrelasjon)
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
      subtitle = paste(method, "korrelasjon"),
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
