
benchmark_kostra_peer_group <- function(
    variable,
    unit,
    year = NULL,
    descending = TRUE,
    table = "12134"
) {
  
  if (is.null(year)) {
    year <- as.integer(
      format(
        Sys.Date(),
        "%Y"
      )
    )
  }
  
  peer <- prepare_kostra_peer_analysis(
    unit = unit,
    start_year = year,
    end_year = year,
    table = table
  )
  
  result <- benchmark_kostra(
    variable = variable,
    data = peer$data,
    unit = peer$unit,
    year = peer$end_year,
    descending = descending
  )
  
  result <- result |>
    dplyr::mutate(
      KOSTRA_gruppe = peer$group_code,
      KOSTRA_gruppe_navn = peer$group_name,
      .after = Enhetstype
    )
  
  attr(result, "comparison_group") <- "KOSTRA-gruppe"
  attr(result, "kostra_group") <- peer$group_code
  attr(result, "kostra_group_name") <- peer$group_name
  
  result
}
