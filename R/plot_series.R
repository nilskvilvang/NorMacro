
plot_series <- function(variable, data = NULL){
  
  if(is.null(data)){
    data <- suppressMessages(get_normacro())
  }
  
  if(!variable %in% names(data)){
    stop("Fant ikke variabelen i datasettet: ", variable)
  }
  
  plot_data <- data |>
    dplyr::select(Aar, Verdi = dplyr::all_of(variable)) |>
    dplyr::filter(!is.na(Verdi))
  
  ggplot2::ggplot(plot_data, ggplot2::aes(x = Aar, y = Verdi)) +
    ggplot2::geom_line() +
    ggplot2::scale_y_continuous(
      labels = scales::label_number(big.mark = " ", decimal.mark = ",")
    ) +
    ggplot2::labs(
      title = variable,
      x = NULL,
      y = NULL
    ) +
    ggplot2::theme_minimal()
}
