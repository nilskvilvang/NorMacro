
get_eurostat_data <- function(id, filters) {
  
  suppressMessages(
    eurostat::get_eurostat(
      id = id,
      filters = filters,
      time_format = "date"
    )
  )
}