
get_kostra_analysis_data <- function(
    table,
    regions,
    years,
    variables
) {
  
  table <- as.character(
    table
  )
  
  if (
    !is.character(regions) ||
    length(regions) == 0L ||
    anyNA(regions) ||
    any(regions == "")
  ) {
    stop(
      "`regions` må være en ikke-tom karaktervektor.",
      call. = FALSE
    )
  }
  
  regions <- sort(
    unique(
      regions
    )
  )
  
  if (
    !is.numeric(years) ||
    length(years) == 0L ||
    anyNA(years) ||
    any(!is.finite(years))
  ) {
    stop(
      "`years` må være en vektor med gyldige år.",
      call. = FALSE
    )
  }
  
  years <- sort(
    unique(
      as.integer(years)
    )
  )
  
  if (
    !is.character(variables) ||
    length(variables) == 0L ||
    anyNA(variables) ||
    any(variables == "")
  ) {
    stop(
      "`variables` må være en ikke-tom karaktervektor.",
      call. = FALSE
    )
  }
  
  variables <- unique(
    variables
  )
  
  metadata <- get_kostra_metadata(
    table = table
  )
  
  missing_variables <- setdiff(
    variables,
    metadata$Variabel
  )
  
  if (length(missing_variables) > 0L) {
    stop(
      "Fant ikke variabelen(e) i KOSTRA-tabell ",
      table,
      ": ",
      paste(
        missing_variables,
        collapse = ", "
      ),
      call. = FALSE
    )
  }
  
  data <- if (table == "12134") {
    
    get_kostra_keyfigures(
      regions = regions,
      years = years
    )
    
  } else {
    
    concepts <- resolve_kostra_concepts(
      table = table,
      variables = variables
    )
    
    switch(
      table,
      
      "12135" = get_kostra_debt_keyfigures(
        regions = regions,
        concepts = concepts,
        years = years
      ),
      
      "12137" = get_kostra_per_capita_keyfigures(
        regions = regions,
        concepts = concepts,
        years = years
      ),
      
      "12143" = get_kostra_financial_keyfigures(
        regions = regions,
        concepts = concepts,
        years = years
      ),
      
      "12333" = get_kostra_investment_financing(
        regions = regions,
        concepts = concepts,
        years = years
      ),
      
      "12364" = get_kostra_financial_foundations(
        regions = regions,
        concepts = concepts,
        years = years
      ),
      
      "12858" = get_kostra_main_accounts(
        regions = regions,
        concepts = concepts,
        years = years
      ),
      
      "13553" = get_kostra_operating_financing(
        regions = regions,
        concepts = concepts,
        years = years
      ),
      
      stop(
        "KOSTRA-tabell `",
        table,
        "` støttes ikke av analyselaget.",
        call. = FALSE
      )
    )
  }
  
  required_columns <- c(
    "Enhet",
    "Enhet_navn",
    "Enhetstype",
    "Aar",
    variables
  )
  
  missing_columns <- setdiff(
    required_columns,
    names(data)
  )
  
  if (length(missing_columns) > 0L) {
    stop(
      "Standardisert KOSTRA-datasett fra tabell ",
      table,
      " mangler kolonner: ",
      paste(
        missing_columns,
        collapse = ", "
      ),
      call. = FALSE
    )
  }
  
  result <- data |>
    dplyr::select(
      dplyr::all_of(
        required_columns
      )
    )
  
  attributes_to_keep <- c(
    "dataset_type",
    "kostra_table",
    "kostra_title"
  )
  
  for (attribute in attributes_to_keep) {
    
    value <- attr(
      data,
      attribute
    )
    
    if (!is.null(value)) {
      attr(
        result,
        attribute
      ) <- value
    }
  }
  
  result
}
