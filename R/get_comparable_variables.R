
# R/get_comparable_variables.R

get_comparable_variables <- function(metadata = get_metadata()) {
  metadata <- add_international_metadata_fields(metadata)
  
  mapping <- international_mapping()
  
  metadata |>
    dplyr::left_join(mapping, by = "Variabel", suffix = c("", "_mapping")) |>
    dplyr::mutate(
      Internasjonal = dplyr::if_else(
        !is.na(.data$Internasjonal_variabel_mapping),
        "Ja",
        .data$Internasjonal
      ),
      Internasjonal_variabel = dplyr::coalesce(
        .data$Internasjonal_variabel_mapping,
        .data$Internasjonal_variabel
      ),
      Internasjonal_kilde = dplyr::coalesce(
        .data$Internasjonal_kilde_mapping,
        .data$Internasjonal_kilde
      ),
      Internasjonal_kildekode = dplyr::coalesce(
        .data$Internasjonal_kildekode_mapping,
        .data$Internasjonal_kildekode
      ),
      Sammenlignbarhet = dplyr::coalesce(
        .data$Sammenlignbarhet_mapping,
        .data$Sammenlignbarhet
      ),
      Fase2_prioritet = dplyr::coalesce(
        .data$Fase2_prioritet_mapping,
        .data$Fase2_prioritet
      ),
      Internasjonal_kommentar = dplyr::coalesce(
        .data$Internasjonal_kommentar_mapping,
        .data$Internasjonal_kommentar
      )
    ) |>
    dplyr::select(-dplyr::ends_with("_mapping")) |>
    dplyr::filter(.data$Internasjonal == "Ja")
}