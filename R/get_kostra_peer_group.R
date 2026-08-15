
get_kostra_peer_group <- function(
    unit,
    date = Sys.Date()
) {
  membership <- get_kostra_group_membership(
    date = date
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
  
  group_code <- selected$KOSTRA_gruppe[[1]]
  
  membership |>
    dplyr::filter(
      .data$KOSTRA_gruppe == group_code
    ) |>
    dplyr::arrange(
      .data$Enhet
    )
}
