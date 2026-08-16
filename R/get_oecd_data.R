
get_oecd_data <- function(dataset, key, start_period = NULL) {
  url <- paste0("https://sdmx.oecd.org/public/rest/data/",
                dataset,
                "/",
                key)
  
  if (!is.null(start_period)) {
    url <- paste0(url,
                  "?startPeriod=",
                  start_period,
                  "&dimensionAtObservation=AllDimensions")
  } else {
    url <- paste0(url, "?dimensionAtObservation=AllDimensions")
  }
  
  response <- httr2::request(url) |>
    httr2::req_headers(Accept = "text/csv") |>
    httr2::req_perform()
  
  csv_text <- httr2::resp_body_string(response)
  
  readr::read_csv(I(csv_text), show_col_types = FALSE)
}
