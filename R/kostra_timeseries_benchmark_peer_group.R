
kostra_timeseries_benchmark_peer_group <- function(
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
  
  result <- kostra_timeseries_benchmark(
    variable = variable,
    data = peer$data,
    unit = peer$unit,
    start_year = peer$start_year,
    end_year = peer$end_year,
    descending = descending
  )
  
  attr(result, "kostra_group") <- peer$group_code
  attr(result, "kostra_group_name") <- peer$group_name
  attr(result, "comparison_group") <- "KOSTRA-gruppe"
  attr(result, "kostra_peer_unit") <- peer$unit
  
  class(result) <- c(
    "kostra_timeseries_benchmark_peer_group",
    class(result)
  )
  
  result
}
