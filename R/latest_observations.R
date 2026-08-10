
#' Vis siste tilgjengelige observasjoner
#'
#' Finner den siste tilgjengelige observasjonen for hver variabel i et
#' NorMacro-datasett og kombinerer resultatet med sentrale metadata.
#'
#' @param data Datasettet som skal undersøkes. Hvis `NULL`, brukes
#'   NorMacros standarddata.
#' @param category Valgfri kategori som resultatet skal begrenses til.
#' @param source Valgfri datakilde som resultatet skal begrenses til.
#'
#' @return En tibble med siste år, siste verdi og metadata for hver
#'   variabel.
#'
#' @examples
#' latest_observations(
#'   data = normacro_example
#' )
#'
#' @export

latest_observations <- function(
    data = NULL,
    category = NULL,
    source = NULL
) {
  
  if (is.null(data)) {
    data <- suppressMessages(
      get_normacro()
    )
  }
  
  if (!"Aar" %in% names(data)) {
    stop(
      "Datasettet m\u00e5 inneholde kolonnen `Aar`.",
      call. = FALSE
    )
  }
  
  has_country <- "Land" %in% names(data)
  
  has_kostra <- all(
    c(
      "Enhet",
      "Enhet_navn",
      "Enhetstype"
    ) %in% names(data)
  )
  
  id_columns <- c(
    "Aar",
    "Land",
    "Enhet",
    "Enhet_navn",
    "Enhetstype"
  )
  
  variable_names <- setdiff(
    names(data),
    id_columns
  )
  
  if (length(variable_names) == 0L) {
    stop(
      "Fant ingen variabler \u00e5 oppsummere.",
      call. = FALSE
    )
  }
  
  metadata <- get_metadata(data)
  
  metadata_columns <- c(
    "Variabel",
    "Display_navn",
    "Kategori",
    "Type",
    "Beskrivelse",
    "Enhet",
    "Kilde",
    "Analyse_type"
  )
  
  metadata_subset <- metadata |>
    dplyr::select(
      dplyr::any_of(
        metadata_columns
      )
    )
  
  # I KOSTRA betyr `Enhet` i data en kommune-/regionkode,
  # mens `Enhet` i metadata betyr måleenhet.
  if (
    has_kostra &&
    "Enhet" %in% names(metadata_subset)
  ) {
    metadata_subset <- metadata_subset |>
      dplyr::rename(
        Maaleenhet = Enhet
      )
  }
  
  # ------------------------------------------------------------
  # KOSTRA-data
  # ------------------------------------------------------------
  
  if (has_kostra) {
    
    result <- data |>
      tidyr::pivot_longer(
        cols = dplyr::all_of(variable_names),
        names_to = "Variabel",
        values_to = "Verdi"
      ) |>
      dplyr::filter(
        !is.na(.data$Verdi)
      ) |>
      dplyr::group_by(
        .data$Enhet,
        .data$Enhet_navn,
        .data$Enhetstype,
        .data$Variabel
      ) |>
      dplyr::slice_max(
        .data$Aar,
        n = 1,
        with_ties = FALSE
      ) |>
      dplyr::ungroup() |>
      dplyr::rename(
        Siste_aar = Aar,
        Siste_verdi = Verdi
      ) |>
      dplyr::left_join(
        metadata_subset,
        by = "Variabel"
      ) |>
      dplyr::arrange(
        .data$Enhetstype,
        .data$Enhet,
        .data$Variabel
      )
    
    # ------------------------------------------------------------
    # Internasjonale data
    # ------------------------------------------------------------
    
  } else if (has_country) {
    
    result <- data |>
      tidyr::pivot_longer(
        cols = dplyr::all_of(variable_names),
        names_to = "Variabel",
        values_to = "Verdi"
      ) |>
      dplyr::filter(
        !is.na(.data$Verdi)
      ) |>
      dplyr::group_by(
        .data$Land,
        .data$Variabel
      ) |>
      dplyr::slice_max(
        .data$Aar,
        n = 1,
        with_ties = FALSE
      ) |>
      dplyr::ungroup() |>
      dplyr::rename(
        Siste_aar = Aar,
        Siste_verdi = Verdi
      ) |>
      dplyr::left_join(
        metadata_subset,
        by = "Variabel"
      )
    
    if ("Kategori" %in% names(result)) {
      result <- result |>
        dplyr::arrange(
          .data$Land,
          .data$Kategori,
          .data$Variabel
        )
    } else {
      result <- result |>
        dplyr::arrange(
          .data$Land,
          .data$Variabel
        )
    }
    
    # ------------------------------------------------------------
    # Norske data / én ferdig filtrert tidsserie
    # ------------------------------------------------------------
    
  } else {
    
    result <- data |>
      tidyr::pivot_longer(
        cols = dplyr::all_of(variable_names),
        names_to = "Variabel",
        values_to = "Verdi"
      ) |>
      dplyr::filter(
        !is.na(.data$Verdi)
      ) |>
      dplyr::group_by(
        .data$Variabel
      ) |>
      dplyr::slice_max(
        .data$Aar,
        n = 1,
        with_ties = FALSE
      ) |>
      dplyr::ungroup() |>
      dplyr::rename(
        Siste_aar = Aar,
        Siste_verdi = Verdi
      ) |>
      dplyr::left_join(
        metadata_subset,
        by = "Variabel"
      )
    
    if ("Kategori" %in% names(result)) {
      result <- result |>
        dplyr::arrange(
          .data$Kategori,
          .data$Variabel
        )
    } else {
      result <- result |>
        dplyr::arrange(
          .data$Variabel
        )
    }
  }
  
  # ------------------------------------------------------------
  # Filtrering
  # ------------------------------------------------------------
  
  if (!is.null(category)) {
    
    if (!"Kategori" %in% names(result)) {
      stop(
        "`category` kan ikke brukes fordi metadata mangler `Kategori`.",
        call. = FALSE
      )
    }
    
    result <- result |>
      dplyr::filter(
        .data$Kategori == category
      )
  }
  
  if (!is.null(source)) {
    
    if (!"Kilde" %in% names(result)) {
      stop(
        "`source` kan ikke brukes fordi metadata mangler `Kilde`.",
        call. = FALSE
      )
    }
    
    result <- result |>
      dplyr::filter(
        .data$Kilde == source
      )
  }
  
  result
}
