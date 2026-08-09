
filter_kostra_peer_group <- function(
    data,
    unit,
    date = Sys.Date()
) {
  if (!is.data.frame(data)) {
    stop(
      "`data` m\u00e5 v\u00e6re et datasett.",
      call. = FALSE
    )
  }
  
  required_columns <- c(
    "Enhet",
    "Enhet_navn",
    "Enhetstype",
    "Aar"
  )
  
  missing_columns <- setdiff(
    required_columns,
    names(data)
  )
  
  if (length(missing_columns) > 0L) {
    stop(
      "`filter_kostra_peer_group()` krever et KOSTRA-datasett.",
      call. = FALSE
    )
  }
  
  peer_group <- get_kostra_peer_group(
    unit = unit,
    date = date
  )
  
  peer_units <- peer_group$Enhet
  
  result <- data |>
    dplyr::filter(
      .data$Enhet %in% peer_units
    )
  
  if (nrow(result) == 0L) {
    stop(
      "Ingen enheter fra KOSTRA-gruppen finnes i datasettet.",
      call. = FALSE
    )
  }
  
  attr(
    result,
    "kostra_group"
  ) <- peer_group$KOSTRA_gruppe[[1]]
  
  attr(
    result,
    "kostra_group_name"
  ) <- peer_group$KOSTRA_gruppe_navn[[1]]
  
  attr(
    result,
    "kostra_group_date"
  ) <- as.Date(date)
  
  attr(
    result,
    "kostra_group_unit"
  ) <- unit
  
  result
}
