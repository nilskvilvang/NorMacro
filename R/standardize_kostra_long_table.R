
standardize_kostra_long_table <- function(
    data,
    config,
    indicator_metadata,
    regions
) {
  
  data <- data |>
    dplyr::filter(
      !is.na(.data[[config$content_value]])
    )
  
  concepts_in_data <- unique(
    data[[config$concept_code]]
  )
  
  indicator_metadata <-
    indicator_metadata |>
    dplyr::filter(
      .data[[config$concept_code]] %in% concepts_in_data
    )
  
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
    indicator_metadata[[config$concept_code]],
    indicator_metadata$Variabel
  )
  
  data |>
    dplyr::rename(
      !!!dimension_map
    ) |>
    dplyr::mutate(
      Aar = as.integer(Aar)
    ) |>
    tidyr::pivot_wider(
      names_from = dplyr::all_of(config$concept_code),
      values_from = dplyr::all_of(config$content_value)
    ) |>
    dplyr::rename(
      !!!indicator_map
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


