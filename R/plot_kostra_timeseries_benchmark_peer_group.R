
plot_kostra_timeseries_benchmark_peer_group <- function(
    variable,
    unit,
    start_year = NULL,
    end_year = NULL,
    descending = TRUE,
    table = "12134"
) {
  
  peer <- prepare_kostra_peer_analysis(
    unit = unit,
    start_year = start_year,
    end_year = end_year,
    table = table
  )
  
  p <- plot_kostra_timeseries_benchmark(
    variable = variable,
    data = peer$data,
    unit = peer$unit,
    start_year = peer$start_year,
    end_year = peer$end_year,
    descending = descending
  )
  
  subtitle <- if (!is.null(peer$group_name)) {
    paste0(
      peer$unit_name,
      " - ",
      peer$group_name,
      " - ",
      peer$start_year,
      "-",
      peer$end_year
    )
  } else {
    paste0(
      peer$unit_name,
      " - ",
      peer$start_year,
      "-",
      peer$end_year
    )
  }
  
  p <- p +
    ggplot2::labs(
      subtitle = subtitle
    )
  
  attr(p, "comparison_group") <- "KOSTRA-gruppe"
  attr(p, "kostra_peer_unit") <- peer$unit
  attr(p, "kostra_group") <- peer$group_code
  attr(p, "kostra_group_name") <- peer$group_name
  
  p
}
