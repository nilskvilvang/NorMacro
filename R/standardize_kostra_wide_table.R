
standardize_kostra_wide_table <- function(
    data,
    config,
    indicator_metadata,
    regions
) {
  
  dimension_map <- stats::setNames(
    c(
      config$region_code,
      config$time_code
    ),
    c(
      "Enhet",
      "Aar"
    )
  )
  
  indicator_map <- stats::setNames(
    indicator_metadata$ContentsCode,
    indicator_metadata$Variabel
  )
  
  indicator_names <- indicator_metadata$Variabel
  
  data |>
    dplyr::rename(
      !!!dimension_map,
      !!!indicator_map
    ) |>
    dplyr::mutate(
      Aar = as.integer(Aar)
    ) |>
    dplyr::left_join(
      regions,
      by = "Enhet"
    ) |>
    dplyr::mutate(
      Enhet_navn = clean_kostra_unit_name(
        .data$Enhet_navn
      )
    ) |>
    dplyr::filter(
      dplyr::if_any(
        dplyr::all_of(indicator_names),
        ~ !is.na(.x)
      )
    ) |>
    dplyr::relocate(
      Enhet,
      Enhet_navn,
      Enhetstype,
      Aar
    ) |>
    dplyr::arrange(
      Enhetstype,
      Enhet,
      Aar
    )
}
