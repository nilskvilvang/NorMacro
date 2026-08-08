
get_kostra_group_membership <- function(date = Sys.Date()) {
  if (length(date) != 1L ||
      is.na(date)) {
    stop("`date` må være én gyldig dato.", call. = FALSE)
  }
  
  date <- as.Date(date)
  
  response <- httr2::request("https://data.ssb.no/api/klass/v1/classifications/112/correspondsAt") |>
    httr2::req_url_query(targetClassificationId = 131,
                         date = format(date, "%Y-%m-%d")) |>
    httr2::req_headers(Accept = "application/json") |>
    httr2::req_perform() |>
    httr2::resp_body_json(simplifyVector = TRUE)
  
  if (is.null(response$correspondenceItems) ||
      nrow(response$correspondenceItems) == 0L) {
    stop("Fant ingen KOSTRA-gruppetilhørighet for valgt dato.",
         call. = FALSE)
  }
  
  result <- response$correspondenceItems |>
    tibble::as_tibble() |>
    dplyr::transmute(
      Enhet = .data$targetCode,
      Enhet_navn = clean_kostra_unit_name(.data$targetName),
      KOSTRA_gruppe = .data$sourceCode,
      KOSTRA_gruppe_navn = .data$sourceName
    ) |>
    dplyr::arrange(.data$KOSTRA_gruppe, .data$Enhet)
  
  attr(result, "date") <- date
  
  attr(result, "source_classification") <- 112L
  
  attr(result, "target_classification") <- 131L
  
  class(result) <- c("kostra_group_membership", class(result))
  
  result
}
