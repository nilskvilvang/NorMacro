
plot_kostra_timeseries_benchmark_peer_group <- function(
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
  
  # ------------------------------------------------------------
  # Hent historisk korrekt KOSTRA-gruppedatasett
  # ------------------------------------------------------------
  
  peer_data <- get_kostra_peer_group_data(
    unit = unit,
    years = seq.int(
      start_year,
      end_year
    ),
    table = table
  )
  
  # ------------------------------------------------------------
  # Navn på valgt kommune
  # ------------------------------------------------------------
  
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
  
  # ------------------------------------------------------------
  # KOSTRA-gruppe
  # ------------------------------------------------------------
  
  group_info <- peer_data |>
    dplyr::filter(
      .data$Enhet == unit
    ) |>
    dplyr::distinct(
      KOSTRA_gruppe,
      KOSTRA_gruppe_navn
    )
  
  # ------------------------------------------------------------
  # Lag ordinært tidsseriebenchmark-plott
  # ------------------------------------------------------------
  
  p <- plot_kostra_timeseries_benchmark(
    variable = variable,
    data = peer_data,
    unit = unit,
    start_year = start_year,
    end_year = end_year,
    descending = descending
  )
  
  # ------------------------------------------------------------
  # Tilpass undertittel til KOSTRA-gruppen
  # ------------------------------------------------------------
  
  if (nrow(group_info) == 1L) {
    
    subtitle <- paste0(
      selected_name,
      " - ",
      group_info$KOSTRA_gruppe_navn[[1]],
      " - ",
      start_year,
      "-",
      end_year
    )
    
  } else {
    
    subtitle <- paste0(
      selected_name,
      " - ",
      start_year,
      "-",
      end_year
    )
  }
  
  p <- p +
    ggplot2::labs(
      subtitle = subtitle
    )
  
  # ------------------------------------------------------------
  # Metadata på selve ggplot-objektet
  # ------------------------------------------------------------
  
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
