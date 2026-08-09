
prepare_kostra_peer_analysis <- function(
    unit,
    start_year = NULL,
    end_year = NULL,
    table = "12134"
) {
  
  if (
    !is.character(unit) ||
    length(unit) != 1L ||
    is.na(unit) ||
    unit == ""
  ) {
    stop(
      "`unit` m\u00e5 angi \u00e9n gyldig KOSTRA-enhet.",
      call. = FALSE
    )
  }
  
  current_year <- as.integer(
    format(
      Sys.Date(),
      "%Y"
    )
  )
  
  if (is.null(end_year)) {
    end_year <- current_year
  }
  
  if (
    !is.numeric(end_year) ||
    length(end_year) != 1L ||
    is.na(end_year) ||
    !is.finite(end_year)
  ) {
    stop(
      "`end_year` m\u00e5 v\u00e6re ett gyldig \u00e5r.",
      call. = FALSE
    )
  }
  
  end_year <- as.integer(
    end_year
  )
  
  if (is.null(start_year)) {
    start_year <- max(
      2020L,
      end_year - 10L
    )
  }
  
  if (
    !is.numeric(start_year) ||
    length(start_year) != 1L ||
    is.na(start_year) ||
    !is.finite(start_year)
  ) {
    stop(
      "`start_year` m\u00e5 v\u00e6re ett gyldig \u00e5r.",
      call. = FALSE
    )
  }
  
  start_year <- as.integer(
    start_year
  )
  
  if (start_year > end_year) {
    stop(
      "`start_year` kan ikke v\u00e6re st\u00f8rre enn `end_year`.",
      call. = FALSE
    )
  }
  
  years <- seq.int(
    start_year,
    end_year
  )
  
  peer_data <- get_kostra_peer_group_data(
    unit = unit,
    years = years,
    table = table
  )
  
  selected_unit <- peer_data |>
    dplyr::filter(
      .data$Enhet == unit
    )
  
  if (nrow(selected_unit) == 0L) {
    stop(
      "Fant ikke KOSTRA-enheten: ",
      unit,
      call. = FALSE
    )
  }
  
  selected_names <- selected_unit |>
    dplyr::distinct(
      Enhet_navn
    ) |>
    dplyr::pull(
      Enhet_navn
    )
  
  selected_name <- if (length(selected_names) == 0L) {
    unit
  } else {
    selected_names[[1]]
  }
  
  group_info <- selected_unit |>
    dplyr::distinct(
      KOSTRA_gruppe,
      KOSTRA_gruppe_navn
    )
  
  group_code <- if (nrow(group_info) == 1L) {
    group_info$KOSTRA_gruppe[[1]]
  } else {
    NULL
  }
  
  group_name <- if (nrow(group_info) == 1L) {
    group_info$KOSTRA_gruppe_navn[[1]]
  } else {
    NULL
  }
  
  list(
    data = peer_data,
    unit = unit,
    unit_name = selected_name,
    start_year = start_year,
    end_year = end_year,
    years = years,
    group_code = group_code,
    group_name = group_name,
    table = table
  )
}
