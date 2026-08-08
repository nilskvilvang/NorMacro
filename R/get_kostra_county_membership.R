
get_kostra_county_membership <- function(
    date = Sys.Date()
) {
  
  if (inherits(date, "character")) {
    date <- as.Date(date)
  }
  
  if (
    !inherits(date, "Date") ||
    length(date) != 1L ||
    is.na(date)
  ) {
    stop(
      "`date` må være én gyldig dato.",
      call. = FALSE
    )
  }
  
  correspondence <- httr2::request(
    "https://data.ssb.no/api/klass/v1/classifications/104/correspondsAt"
  ) |>
    httr2::req_url_query(
      targetClassificationId = 131,
      date = format(
        date,
        "%Y-%m-%d"
      )
    ) |>
    httr2::req_headers(
      Accept = "application/json"
    ) |>
    httr2::req_perform() |>
    httr2::resp_body_json(
      simplifyVector = TRUE
    )
  
  items <- correspondence$correspondenceItems
  
  result <- items |>
    dplyr::transmute(
      Enhet = .data$targetCode,
      Enhet_navn = clean_kostra_unit_name(
        .data$targetName
      ),
      Fylke = .data$sourceCode,
      Fylke_navn = clean_kostra_unit_name(
        .data$sourceName
      )
    ) |>
    dplyr::arrange(
      .data$Fylke,
      .data$Enhet
    )
  
  attr(
    result,
    "date"
  ) <- date
  
  attr(
    result,
    "source_classification"
  ) <- 104L
  
  attr(
    result,
    "target_classification"
  ) <- 131L
  
  class(result) <- c(
    "kostra_county_membership",
    class(result)
  )
  
  result
}
