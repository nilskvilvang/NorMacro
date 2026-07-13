


correlate_series <- function(variables,
                             data = NULL,
                             start_year = NULL,
                             end_year = NULL,
                             method = c("pearson", "spearman", "kendall"),
                             include_diagonal = FALSE,
                             format = TRUE) {
  if (is.null(data)) {
    data <- get_normacro()
  }
  
  method <- match.arg(method)
  metadata <- get_metadata(data)
  
  if ("Land" %in% names(data) &&
      dplyr::n_distinct(data$Land) > 1) {
    stop(
      paste0(
        "correlate_series() kan analysere ett land om gangen. ",
        "Filtrer data til ett land først."
      ),
      call. = FALSE
    )
  }
  
  if (length(variables) < 2) {
    stop("Velg minst to variabler.", call. = FALSE)
  }
  
  missing <- setdiff(variables, names(data))
  
  if (length(missing) > 0) {
    stop("Fant ikke variabler i datasettet: ",
         paste(missing, collapse = ", "),
         call. = FALSE)
  }
  
  analysis_data <- data
  
  if (!is.null(start_year)) {
    analysis_data <- analysis_data |>
      dplyr::filter(.data$Aar >= start_year)
  }
  
  if (!is.null(end_year)) {
    analysis_data <- analysis_data |>
      dplyr::filter(.data$Aar <= end_year)
  }
  
  if (nrow(analysis_data) == 0) {
    stop("Fant ingen observasjoner i valgt periode.", call. = FALSE)
  }
  
  combinations <- if (include_diagonal) {
    tidyr::expand_grid(Variabel_x = variables, Variabel_y = variables) |>
      dplyr::filter(match(.data$Variabel_x, variables) <=
                      match(.data$Variabel_y, variables))
  } else {
    utils::combn(variables, 2, simplify = FALSE) |>
      lapply(function(x) {
        tibble::tibble(Variabel_x = x[1], Variabel_y = x[2])
      }) |>
      dplyr::bind_rows()
  }
  
  display_lookup <- tibble::tibble(
    Variabel = variables,
    Display_navn = vapply(variables, get_display_name, character(1), metadata = metadata)
  )
  
  result <- combinations |>
    dplyr::rowwise() |>
    dplyr::mutate(statistics = list({
      pair_data <- analysis_data |>
        dplyr::select(
          Aar,
          x = dplyr::all_of(.data$Variabel_x),
          y = dplyr::all_of(.data$Variabel_y)
        ) |>
        dplyr::filter(!is.na(.data$x), !is.na(.data$y))
      
      n <- nrow(pair_data)
      
      if (n < 3) {
        tibble::tibble(
          Korrelasjon = NA_real_,
          P_verdi = NA_real_,
          Antall_observasjoner = n,
          Startaar = if (n == 0)
            NA_integer_
          else
            min(pair_data$Aar),
          Sluttaar = if (n == 0)
            NA_integer_
          else
            max(pair_data$Aar)
        )
      } else {
        test <- stats::cor.test(pair_data$x,
                                pair_data$y,
                                method = method,
                                exact = FALSE)
        
        tibble::tibble(
          Korrelasjon = unname(test$estimate),
          P_verdi = test$p.value,
          Antall_observasjoner = n,
          Startaar = min(pair_data$Aar),
          Sluttaar = max(pair_data$Aar)
        )
      }
    })) |>
    dplyr::ungroup() |>
    tidyr::unnest(cols = statistics) |>
    dplyr::left_join(
      display_lookup |>
        dplyr::rename(Variabel_x = Variabel, Display_x = Display_navn),
      by = "Variabel_x"
    ) |>
    dplyr::left_join(
      display_lookup |>
        dplyr::rename(Variabel_y = Variabel, Display_y = Display_navn),
      by = "Variabel_y"
    ) |>
    dplyr::mutate(Metode = method) |>
    dplyr::select(
      Variabel_x,
      Display_x,
      Variabel_y,
      Display_y,
      Korrelasjon,
      P_verdi,
      Antall_observasjoner,
      Metode,
      Startaar,
      Sluttaar
    ) |>
    dplyr::arrange(dplyr::desc(abs(.data$Korrelasjon)))
  
  if (format) {
    result <- result |>
      dplyr::mutate(
        Signifikant = dplyr::case_when(
          is.na(.data$P_verdi) ~ NA_character_,
          .data$P_verdi < 0.001 ~ "***",
          .data$P_verdi < 0.01  ~ "**",
          .data$P_verdi < 0.05  ~ "*",
          TRUE ~ ""
        ),
        Korrelasjon = format_number(.data$Korrelasjon, digits = 3),
        P_verdi = format_pvalue(.data$P_verdi)
      )
  }
  
  result |>
    dplyr::select(
      Variabel_x,
      Display_x,
      Variabel_y,
      Display_y,
      Korrelasjon,
      P_verdi,
      Signifikant,
      Antall_observasjoner,
      Metode,
      Startaar,
      Sluttaar
    )
  result
}