
get_kostra_county <- function(
    unit,
    date = Sys.Date()
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
  
  membership <- get_kostra_county_membership(
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
