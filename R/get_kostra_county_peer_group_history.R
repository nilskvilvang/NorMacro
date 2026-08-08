
get_kostra_county_peer_group_history <- function(
    unit,
    start_year,
    end_year
) {
  
  if (
    !is.character(unit) ||
    length(unit) != 1L ||
    is.na(unit) ||
    unit == ""
  ) {
    stop(
      "`unit` må angi én gyldig KOSTRA-enhet.",
      call. = FALSE
    )
  }
  
  membership <- get_kostra_county_membership_history(
    start_year = start_year,
    end_year = end_year
  )
  
  selected <- membership |>
    dplyr::filter(
      .data$Enhet == unit
    )
  
  if (nrow(selected) == 0L) {
    stop(
      "Fant ikke KOSTRA-enheten: ",
      unit,
      call. = FALSE
    )
  }
  
  selected_counties <- selected |>
    dplyr::select(
      "Aar",
      "Fylke"
    )
  
  result <- membership |>
    dplyr::inner_join(
      selected_counties,
      by = c(
        "Aar",
        "Fylke"
      )
    ) |>
    dplyr::arrange(
      .data$Aar,
      .data$Enhet
    )
  
  result
}
