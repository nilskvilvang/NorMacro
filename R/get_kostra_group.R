
get_kostra_group <- function(
    unit,
    date = Sys.Date()
) {
  membership <- get_kostra_group_membership(
    date = date
  )
  
  result <- membership |>
    dplyr::filter(
      .data$Enhet == unit
    )
  
  if (nrow(result) == 0L) {
    stop(
      "Fant ikke KOSTRA-enheten: ",
      unit,
      call. = FALSE
    )
  }
  
  result
}