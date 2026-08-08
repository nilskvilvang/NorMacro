
get_kostra_peer_group_history <- function(
    unit,
    start_year = 2020,
    end_year = as.integer(format(Sys.Date(), "%Y"))
) {
  
  history <- get_kostra_group_membership_history(
    start_year = start_year,
    end_year = end_year
  )
  
  selected <- history |>
    dplyr::filter(
      .data$Enhet == unit
    ) |>
    dplyr::select(
      Aar,
      KOSTRA_gruppe
    )
  
  if (nrow(selected) == 0L) {
    stop(
      "Fant ikke KOSTRA-enheten: ",
      unit,
      call. = FALSE
    )
  }
  
  history |>
    dplyr::inner_join(
      selected,
      by = c(
        "Aar",
        "KOSTRA_gruppe"
      )
    ) |>
    dplyr::arrange(
      .data$Aar,
      .data$Enhet
    )
}

