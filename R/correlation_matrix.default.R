
correlation_matrix.default <- function(
    variables,
    data = NULL,
    start_year = NULL,
    end_year = NULL,
    country = NULL,
    unit = NULL,
    use = "pairwise.complete.obs",
    method = "pearson",
    ...
) {
  
  if (is.null(data)) {
    data <- suppressMessages(
      get_normacro()
    )
  }
  
  if (!is.data.frame(data)) {
    stop(
      "`data` må være en data.frame eller tibble.",
      call. = FALSE
    )
  }
  
  if (!"Aar" %in% names(data)) {
    stop(
      "Datasettet må inneholde kolonnen `Aar`.",
      call. = FALSE
    )
  }
  
  if (length(variables) < 2L) {
    stop(
      "`correlation_matrix()` krever minst to variabler.",
      call. = FALSE
    )
  }
  
  missing <- setdiff(
    variables,
    names(data)
  )
  
  if (length(missing) > 0L) {
    stop(
      "Fant ikke variabler i datasettet: ",
      paste(missing, collapse = ", "),
      call. = FALSE
    )
  }
  
  # ------------------------------------------------------------
  # Valider år
  # ------------------------------------------------------------
  
  validate_year <- function(
    value,
    argument
  ) {
    if (is.null(value)) {
      return(
        invisible(NULL)
      )
    }
    
    if (
      !is.numeric(value) ||
      length(value) != 1L ||
      is.na(value) ||
      !is.finite(value)
    ) {
      stop(
        "`",
        argument,
        "` må være ett endelig numerisk år.",
        call. = FALSE
      )
    }
    
    invisible(NULL)
  }
  
  validate_year(
    start_year,
    "start_year"
  )
  
  validate_year(
    end_year,
    "end_year"
  )
  
  if (
    !is.null(start_year) &&
    !is.null(end_year) &&
    start_year > end_year
  ) {
    stop(
      "`start_year` kan ikke være større enn `end_year`.",
      call. = FALSE
    )
  }
  
  # ------------------------------------------------------------
  # Identifiser datasettstype
  # ------------------------------------------------------------
  
  has_country <- "Land" %in% names(data)
  
  has_kostra <- all(
    c(
      "Enhet",
      "Enhet_navn",
      "Enhetstype"
    ) %in% names(data)
  )
  
  # ------------------------------------------------------------
  # Internasjonale data
  # ------------------------------------------------------------
  
  if (has_country) {
    
    available_countries <- unique(
      data$Land[
        !is.na(data$Land)
      ]
    )
    
    if (!is.null(country)) {
      
      if (
        length(country) != 1L ||
        is.na(country)
      ) {
        stop(
          "`country` må angi nøyaktig ett land.",
          call. = FALSE
        )
      }
      
      if (!country %in% available_countries) {
        stop(
          "Fant ikke landet i datasettet: ",
          country,
          call. = FALSE
        )
      }
      
      data <- data |>
        dplyr::filter(
          .data$Land == country
        )
      
    } else if (
      length(available_countries) > 1L
    ) {
      stop(
        paste0(
          "Datasettet inneholder flere land. ",
          "Velg ett land med `country =` før ",
          "korrelasjonsmatrisen beregnes."
        ),
        call. = FALSE
      )
    }
  }
  
  # ------------------------------------------------------------
  # KOSTRA-data
  # ------------------------------------------------------------
  
  if (has_kostra) {
    
    available_units <- unique(
      data$Enhet[
        !is.na(data$Enhet)
      ]
    )
    
    if (!is.null(unit)) {
      
      if (
        length(unit) != 1L ||
        is.na(unit)
      ) {
        stop(
          "`unit` må angi nøyaktig én KOSTRA-enhet.",
          call. = FALSE
        )
      }
      
      if (!unit %in% available_units) {
        stop(
          "Fant ikke KOSTRA-enheten i datasettet: ",
          unit,
          call. = FALSE
        )
      }
      
      data <- data |>
        dplyr::filter(
          .data$Enhet == unit
        )
      
    } else if (
      length(available_units) > 1L
    ) {
      stop(
        paste0(
          "Datasettet inneholder flere KOSTRA-enheter. ",
          "Velg én enhet med `unit =` før ",
          "korrelasjonsmatrisen beregnes."
        ),
        call. = FALSE
      )
    }
  }
  
  # ------------------------------------------------------------
  # Velg analyseperiode og variabler
  # ------------------------------------------------------------
  
  data_subset <- data |>
    dplyr::select(
      Aar,
      dplyr::all_of(variables)
    )
  
  if (!is.null(start_year)) {
    data_subset <- data_subset |>
      dplyr::filter(
        .data$Aar >= start_year
      )
  }
  
  if (!is.null(end_year)) {
    data_subset <- data_subset |>
      dplyr::filter(
        .data$Aar <= end_year
      )
  }
  
  if (nrow(data_subset) == 0L) {
    stop(
      "Fant ingen observasjoner i valgt periode.",
      call. = FALSE
    )
  }
  
  # ------------------------------------------------------------
  # Korrelasjonsmatrise
  # ------------------------------------------------------------
  
  result <- data_subset |>
    dplyr::select(
      -Aar
    ) |>
    stats::cor(
      use = use,
      method = method
    )
  
  # ------------------------------------------------------------
  # Attributter
  # ------------------------------------------------------------
  
  attr(
    result,
    "method"
  ) <- method
  
  attr(
    result,
    "use"
  ) <- use
  
  attr(
    result,
    "start_year"
  ) <- start_year
  
  attr(
    result,
    "end_year"
  ) <- end_year
  
  if (has_country) {
    attr(
      result,
      "country"
    ) <- unique(data$Land)
  }
  
  if (has_kostra) {
    attr(
      result,
      "kostra_unit"
    ) <- unique(data$Enhet)
    
    attr(
      result,
      "kostra_unit_name"
    ) <- unique(data$Enhet_navn)
  }
  
  result
}