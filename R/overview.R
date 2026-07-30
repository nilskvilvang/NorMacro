
#' Vis en oversikt over NorMacro-data
#'
#' `overview()` viser en samlet oversikt over NorMacro-databasene.
#'
#' Når et datasett oppgis, identifiserer funksjonen automatisk om det er:
#'
#' - norske makrodata
#' - internasjonale makrodata
#' - KOSTRA-data
#'
#' @param data Et NorMacro-datasett. Hvis `NULL`, vises en samlet oversikt
#'   over norske og internasjonale data.
#' @param print Logisk. Hvis `TRUE`, skrives oversikten til konsollen.
#'
#' @return En liste med informasjon om datasettet, usynlig.
#'
#' @examples
#' \dontrun{
#' overview()
#'
#' normacro <- get_normacro()
#' overview(normacro)
#'
#' international <- get_international_macro()
#' overview(international)
#'
#' kostra <- get_kostra_financial_foundations(
#'   regions = "0301",
#'   concepts = c("AGD23", "KG31"),
#'   years = 2020:2024
#' )
#'
#' overview(kostra)
#' }
#'
#' @export
overview <- function(data = NULL, print = TRUE) {
  
  if (is.null(data)) {
    return(
      overview_all(
        print = print
      )
    )
  }
  
  dataset_type <- identify_overview_dataset(data)
  
  result <- switch(
    dataset_type,
    norway = overview_macro_data(
      data = data,
      dataset_type = "norway",
      print = print
    ),
    international = overview_macro_data(
      data = data,
      dataset_type = "international",
      print = print
    ),
    kostra = overview_kostra_data(
      data = data,
      print = print
    )
  )
  
  invisible(result)
}


# Samlet oversikt ---------------------------------------------------------

overview_all <- function(print = TRUE) {
  
  normacro <- get_normacro()
  international <- get_international_macro()
  
  metadata_norway <- get_normacro_metadata() |>
    dplyr::filter(.data$Omraade == "Norge")
  
  metadata_international <- get_international_metadata()
  
  norway_variables <- setdiff(
    names(normacro),
    "Aar"
  )
  
  international_variables <- setdiff(
    names(international),
    c("Aar", "Land")
  )
  
  metadata_norway_data <- metadata_norway |>
    dplyr::filter(.data$Variabel %in% norway_variables)
  
  metadata_international_data <- metadata_international |>
    dplyr::filter(.data$Variabel %in% international_variables)
  
  result <- list(
    norway = list(
      period = overview_year_range(normacro),
      n_observations = nrow(normacro),
      n_variables = length(norway_variables),
      n_documented_variables = dplyr::n_distinct(
        metadata_norway_data$Variabel
      ),
      n_categories = dplyr::n_distinct(
        metadata_norway_data$Kategori
      )
    ),
    international = list(
      period = overview_year_range(international),
      n_observations = nrow(international),
      n_variables = length(international_variables),
      n_documented_variables = dplyr::n_distinct(
        metadata_international_data$Variabel
      ),
      n_countries = dplyr::n_distinct(
        international$Land,
        na.rm = TRUE
      ),
      n_categories = dplyr::n_distinct(
        metadata_international_data$Kategori
      )
    )
  )
  
  if (print) {
    cat("\n")
    cat("NorMacro\n")
    cat("========\n\n")
    
    cat("Metadata-drevet rammeverk for norske og internasjonale\n")
    cat("makroøkonomiske tidsserier og kommunale KOSTRA-data.\n\n")
    
    cat("Norske data\n")
    cat("-----------\n")
    print_overview_period(result$norway$period)
    cat(
      "Observasjoner:  ",
      result$norway$n_observations,
      "\n",
      sep = ""
    )
    cat(
      "Variabler:      ",
      result$norway$n_variables,
      "\n",
      sep = ""
    )
    cat(
      "Kategorier:     ",
      result$norway$n_categories,
      "\n\n",
      sep = ""
    )
    
    cat("Internasjonale data\n")
    cat("-------------------\n")
    print_overview_period(result$international$period)
    cat(
      "Observasjoner:  ",
      result$international$n_observations,
      "\n",
      sep = ""
    )
    cat(
      "Land:           ",
      result$international$n_countries,
      "\n",
      sep = ""
    )
    cat(
      "Variabler:      ",
      result$international$n_variables,
      "\n",
      sep = ""
    )
    cat(
      "Kategorier:     ",
      result$international$n_categories,
      "\n\n",
      sep = ""
    )
    
    cat("Utforsk databasen\n")
    cat("-----------------\n")
    cat(sprintf(
      "%-32s %s\n",
      "overview(normacro)",
      "Vis norske data"
    ))
    cat(sprintf(
      "%-32s %s\n",
      "overview(international)",
      "Vis internasjonale data"
    ))
    cat(sprintf(
      "%-32s %s\n",
      "overview(kostra)",
      "Vis et KOSTRA-datasett"
    ))
    cat(sprintf(
      "%-32s %s\n",
      "list_categories()",
      "Vis alle kategorier"
    ))
    cat(sprintf(
      "%-32s %s\n",
      "search_variables()",
      "Søk etter variabler"
    ))
  }
  
  invisible(result)
}


# Norske og internasjonale makrodata --------------------------------------

overview_macro_data <- function(
    data,
    dataset_type,
    print = TRUE
) {
  
  if (identical(dataset_type, "international")) {
    dataset_name <- "Internasjonale data"
    id_columns <- c("Aar", "Land")
    metadata <- get_international_metadata()
  } else {
    dataset_name <- "Norske data"
    id_columns <- "Aar"
    
    metadata <- get_normacro_metadata() |>
      dplyr::filter(.data$Omraade == "Norge")
  }
  
  variable_names <- setdiff(
    names(data),
    id_columns
  )
  
  metadata_data <- metadata |>
    dplyr::filter(.data$Variabel %in% variable_names)
  
  documented_variables <- metadata_data |>
    dplyr::distinct(.data$Variabel)
  
  categories <- metadata_data |>
    dplyr::distinct(
      .data$Variabel,
      .data$Kategori
    ) |>
    dplyr::filter(
      !is.na(.data$Kategori),
      .data$Kategori != ""
    ) |>
    dplyr::count(
      .data$Kategori,
      name = "Antall"
    ) |>
    dplyr::arrange(.data$Kategori)
  
  result <- list(
    dataset = dataset_name,
    dataset_type = dataset_type,
    period = overview_year_range(data),
    n_observations = nrow(data),
    n_variables = length(variable_names),
    n_documented_variables = nrow(documented_variables),
    n_categories = nrow(categories),
    categories = categories
  )
  
  if (identical(dataset_type, "international")) {
    result$n_countries <- dplyr::n_distinct(
      data$Land,
      na.rm = TRUE
    )
  }
  
  if (print) {
    cat("\n")
    cat(dataset_name, "\n")
    cat(
      strrep("=", nchar(dataset_name)),
      "\n\n",
      sep = ""
    )
    
    cat("Makroøkonomisk database med årlige indikatorer.\n\n")
    
    cat("Dekning\n")
    cat("-------\n")
    print_overview_period(result$period)
    
    cat(
      "Observasjoner:  ",
      result$n_observations,
      "\n",
      sep = ""
    )
    
    if (identical(dataset_type, "international")) {
      cat(
        "Land:           ",
        result$n_countries,
        "\n",
        sep = ""
      )
    }
    
    cat(
      "Variabler:      ",
      result$n_variables,
      "\n\n",
      sep = ""
    )
    
    cat("Metadata\n")
    cat("--------\n")
    cat(
      "Dokumenterte variabler: ",
      result$n_documented_variables,
      "\n",
      sep = ""
    )
    cat(
      "Kategorier:             ",
      result$n_categories,
      "\n\n",
      sep = ""
    )
    
    if (nrow(categories) > 0L) {
      cat("Kategorier\n")
      cat("----------\n")
      
      for (i in seq_len(nrow(categories))) {
        cat(sprintf(
          "%-30s %3s\n",
          categories$Kategori[i],
          categories$Antall[i]
        ))
      }
      
      cat("\n")
    }
  }
  
  invisible(result)
}


# KOSTRA-data -------------------------------------------------------------

overview_kostra_data <- function(
    data,
    print = TRUE
) {
  
  id_columns <- c(
    "Enhet",
    "Enhet_navn",
    "Enhetstype",
    "Aar"
  )
  
  variable_names <- setdiff(
    names(data),
    id_columns
  )
  
  kostra_table <- attr(
    data,
    "kostra_table"
  )
  
  kostra_title <- attr(
    data,
    "kostra_title"
  )
  
  units <- data |>
    dplyr::filter(!is.na(.data$Enhet)) |>
    dplyr::distinct(
      .data$Enhet,
      .data$Enhet_navn,
      .data$Enhetstype
    )
  
  unit_types <- units |>
    dplyr::mutate(
      Enhetstype = dplyr::if_else(
        is.na(.data$Enhetstype) |
          .data$Enhetstype == "",
        "Ukjent",
        .data$Enhetstype
      )
    ) |>
    dplyr::count(
      .data$Enhetstype,
      name = "Antall"
    ) |>
    dplyr::arrange(.data$Enhetstype)
  
  attr(unit_types, "dataset_type") <- NULL
  attr(unit_types, "kostra_table") <- NULL
  attr(unit_types, "kostra_title") <- NULL
  
  result <- list(
    dataset = "KOSTRA-data",
    dataset_type = "kostra",
    kostra_table = kostra_table,
    kostra_title = kostra_title,
    period = overview_year_range(data),
    n_observations = nrow(data),
    n_units = nrow(units),
    n_variables = length(variable_names),
    unit_types = unit_types,
    variables = variable_names
  )
  
  if (print) {
    cat("\n")
    cat("KOSTRA-data\n")
    cat("===========\n\n")
    
    if (!is.null(result$kostra_table)) {
      cat(
        "Tabell: ",
        result$kostra_table,
        "\n",
        sep = ""
      )
    }
    
    if (!is.null(result$kostra_title)) {
      cat(
        "Tema:   ",
        result$kostra_title,
        "\n",
        sep = ""
      )
    }
    
    if (
      !is.null(result$kostra_table) ||
      !is.null(result$kostra_title)
    ) {
      cat("\n")
    }
    
    cat("Kommunale og regionale nøkkeltall fra KOSTRA.\n\n")
    
    cat("Dekning\n")
    cat("-------\n")
    print_overview_period(result$period)
    
    cat(
      "Observasjoner:  ",
      result$n_observations,
      "\n",
      sep = ""
    )
    
    cat(
      "Enheter:        ",
      result$n_units,
      "\n",
      sep = ""
    )
    
    cat(
      "Variabler:      ",
      result$n_variables,
      "\n\n",
      sep = ""
    )
    
    if (nrow(unit_types) > 0L) {
      cat("Enhetstyper\n")
      cat("-----------\n")
      
      for (i in seq_len(nrow(unit_types))) {
        cat(sprintf(
          "%-30s %3s\n",
          unit_types$Enhetstype[i],
          unit_types$Antall[i]
        ))
      }
      
      cat("\n")
    }
  }
  
  invisible(result)
}


# Identifisering av datasett ----------------------------------------------

identify_overview_dataset <- function(data) {
  
  if (!is.data.frame(data)) {
    cli::cli_abort(
      "{.arg data} må være en data.frame eller tibble."
    )
  }
  
  if (
    all(
      c(
        "Enhet",
        "Enhet_navn",
        "Enhetstype",
        "Aar"
      ) %in% names(data)
    )
  ) {
    return("kostra")
  }
  
  if (
    all(c("Land", "Aar") %in% names(data))
  ) {
    return("international")
  }
  
  if ("Aar" %in% names(data)) {
    return("norway")
  }
  
  cli::cli_abort(
    c(
      "Ukjent datastruktur.",
      "i" = paste0(
        "Datasettet må inneholde {.field Aar}, ",
        "{.field Land} og {.field Aar}, eller KOSTRA-kolonnene ",
        "{.field Enhet}, {.field Enhet_navn}, ",
        "{.field Enhetstype} og {.field Aar}."
      )
    )
  )
}


# Hjelpefunksjoner --------------------------------------------------------

overview_year_range <- function(data) {
  
  if (
    !"Aar" %in% names(data) ||
    nrow(data) == 0L ||
    all(is.na(data$Aar))
  ) {
    return(c(NA_integer_, NA_integer_))
  }
  
  range(
    data$Aar,
    na.rm = TRUE
  )
}


print_overview_period <- function(period) {
  
  if (
    length(period) != 2L ||
    any(is.na(period))
  ) {
    cat("Periode:        Ikke tilgjengelig\n")
    return(invisible(NULL))
  }
  
  cat(
    "Periode:        ",
    period[1],
    "-",
    period[2],
    "\n",
    sep = ""
  )
  
  invisible(NULL)
}

