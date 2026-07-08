
create_international_derived_variables <- function(data) {
  data |>
    dplyr::group_by(Land) |>
    dplyr::arrange(Aar, .by_group = TRUE) |>
    dplyr::mutate(
      Inflasjon = dplyr::if_else(Aar - dplyr::lag(Aar) == 1, (HICP / dplyr::lag(HICP) - 1) * 100, NA_real_),
      Befolkningsvekst = dplyr::if_else(
        Aar - dplyr::lag(Aar) == 1,
        (Befolkning / dplyr::lag(Befolkning) - 1) * 100,
        NA_real_
      ),
      BNP_vekst = dplyr::if_else(
        Aar - dplyr::lag(Aar) == 1,
        (BNP_faste_priser / dplyr::lag(BNP_faste_priser) - 1) * 100,
        NA_real_
      ),
      Industriproduksjon_vekst = dplyr::if_else(
        Aar - dplyr::lag(Aar) == 1,
        (Industriproduksjon / dplyr::lag(Industriproduksjon) - 1) * 100,
        NA_real_
      ),
      BNP_lopende_per_innbygger = BNP_lopende * 1e6 / Befolkning
    ) |>
    dplyr::ungroup()
}


