
benchmark_kostra_peer_group <- function(
    variable,
    unit,
    year = NULL,
    descending = TRUE,
    table = "12134"
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
  
  if (is.null(year)) {
    year <- as.integer(
      format(
        Sys.Date(),
        "%Y"
      )
    )
  }
  
  if (
    !is.numeric(year) ||
    length(year) != 1L ||
    is.na(year) ||
    !is.finite(year)
  ) {
    stop(
      "`year` må være ett gyldig år.",
      call. = FALSE
    )
  }
  
  year <- as.integer(
    year
  )
  
  peer_data <- get_kostra_peer_group_data(
    unit = unit,
    years = year,
    table = table
  )
  
  result <- benchmark_kostra(
    variable = variable,
    data = peer_data,
    unit = unit,
    year = year,
    descending = descending
  )
  
  group_info <- peer_data |>
    dplyr::filter(
      .data$Enhet == unit,
      .data$Aar == year
    ) |>
    dplyr::distinct(
      KOSTRA_gruppe,
      KOSTRA_gruppe_navn
    )
  
  if (nrow(group_info) > 0L) {
    result <- result |>
      dplyr::mutate(
        KOSTRA_gruppe =
          group_info$KOSTRA_gruppe[[1]],
        KOSTRA_gruppe_navn =
          group_info$KOSTRA_gruppe_navn[[1]],
        .after = .data$Enhetstype
      )
  }
  
  attr(
    result,
    "comparison_group"
  ) <- "KOSTRA-gruppe"
  
  attr(
    result,
    "kostra_group"
  ) <- attr(
    peer_data,
    "kostra_group"
  )
  
  attr(
    result,
    "kostra_group_name"
  ) <- attr(
    peer_data,
    "kostra_group_name"
  )
  
  result
}