
kostra_timeseries_benchmark_peer_group <- function(
    variable,
    unit,
    start_year = NULL,
    end_year = NULL,
    descending = TRUE,
    table = "12134"
) {
  
  current_year <- as.integer(
    format(
      Sys.Date(),
      "%Y"
    )
  )
  
  if (is.null(end_year)) {
    end_year <- current_year
  }
  
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
      "`start_year` må være ett gyldig år.",
      call. = FALSE
    )
  }
  
  if (
    !is.numeric(end_year) ||
    length(end_year) != 1L ||
    is.na(end_year) ||
    !is.finite(end_year)
  ) {
    stop(
      "`end_year` må være ett gyldig år.",
      call. = FALSE
    )
  }
  
  start_year <- as.integer(start_year)
  end_year <- as.integer(end_year)
  
  if (start_year > end_year) {
    stop(
      "`start_year` kan ikke være større enn `end_year`.",
      call. = FALSE
    )
  }
  
  peer_data <- get_kostra_peer_group_data(
    unit = unit,
    years = seq.int(
      start_year,
      end_year
    ),
    table = table
  )
  
  result <- kostra_timeseries_benchmark(
    variable = variable,
    data = peer_data,
    unit = unit,
    start_year = start_year,
    end_year = end_year,
    descending = descending
  )
  
  group_info <- peer_data |>
    dplyr::filter(
      .data$Enhet == unit
    ) |>
    dplyr::distinct(
      KOSTRA_gruppe,
      KOSTRA_gruppe_navn
    )
  
  if (nrow(group_info) == 1L) {
    attr(
      result,
      "kostra_group"
    ) <- group_info$KOSTRA_gruppe[[1]]
    
    attr(
      result,
      "kostra_group_name"
    ) <- group_info$KOSTRA_gruppe_navn[[1]]
  }
  
  attr(
    result,
    "comparison_group"
  ) <- "KOSTRA-gruppe"
  
  attr(
    result,
    "kostra_peer_unit"
  ) <- unit
  
  class(result) <- c(
    "kostra_timeseries_benchmark_peer_group",
    class(result)
  )
  
  result
}