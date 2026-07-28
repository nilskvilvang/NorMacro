
get_kostra_regions <- function(
    url,
    region_code
) {
  metadata <- pxweb::pxweb_get(url)
  
  region_variable <- get_px_variable(
    metadata = metadata,
    code = region_code
  )
  
  tibble::tibble(
    Enhet = as.character(region_variable$values),
    Enhet_navn = as.character(region_variable$valueTexts)
  ) |>
    dplyr::mutate(
      Enhetstype = dplyr::case_when(
        grepl("^EKG\\d+$", Enhet) ~ "kostragruppe",
        grepl("^\\d{4}$", Enhet) ~ "kommune",
        TRUE ~ "annet"
      )
    )
}
