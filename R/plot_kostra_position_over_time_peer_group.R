
plot_kostra_position_over_time_peer_group <- function(
    variable,
    unit,
    start_year = NULL,
    end_year = NULL,
    descending = TRUE,
    metric = c(
      "percentile",
      "rank"
    ),
    table = "12134"
) {
  
  metric <- match.arg(
    metric
  )
  
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
  
  start_year <- as.integer(
    start_year
  )
  
  end_year <- as.integer(
    end_year
  )
  
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
  
  selected_name <- peer_data |>
    dplyr::filter(
      .data$Enhet == unit
    ) |>
    dplyr::distinct(
      Enhet_navn
    ) |>
    dplyr::pull(
      Enhet_navn
    )
  
  if (length(selected_name) == 0L) {
    selected_name <- unit
  } else {
    selected_name <- selected_name[[1]]
  }
  
  group_info <- peer_data |>
    dplyr::filter(
      .data$Enhet == unit
    ) |>
    dplyr::distinct(
      KOSTRA_gruppe,
      KOSTRA_gruppe_navn
    )
  
  p <- plot_kostra_position_over_time(
    variable = variable,
    data = peer_data,
    unit = unit,
    start_year = start_year,
    end_year = end_year,
    descending = descending,
    metric = metric
  )
  
  if (nrow(group_info) == 1L) {
    p <- p +
      ggplot2::labs(
        subtitle = paste0(
          selected_name,
          " - ",
          group_info$KOSTRA_gruppe_navn[[1]],
          " - ",
          start_year,
          "-",
          end_year
        )
      )
  }
  
  attr(
    p,
    "comparison_group"
  ) <- "KOSTRA-gruppe"
  
  attr(
    p,
    "kostra_peer_unit"
  ) <- unit
  
  if (nrow(group_info) == 1L) {
    attr(
      p,
      "kostra_group"
    ) <- group_info$KOSTRA_gruppe[[1]]
    
    attr(
      p,
      "kostra_group_name"
    ) <- group_info$KOSTRA_gruppe_navn[[1]]
  }
  
  p
}
