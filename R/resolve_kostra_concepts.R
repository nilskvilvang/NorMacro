
resolve_kostra_concepts <- function(
    table,
    variables
) {
  
  table <- as.character(
    table
  )
  
  if (
    !is.character(variables) ||
    length(variables) == 0L ||
    anyNA(variables) ||
    any(variables == "")
  ) {
    stop(
      "`variables` m\u00e5 v\u00e6re en ikke-tom karaktervektor.",
      call. = FALSE
    )
  }
  
  metadata <- get_kostra_metadata(
    table = table
  )
  
  if (!"Variabel" %in% names(metadata)) {
    stop(
      "KOSTRA-metadata for tabell `",
      table,
      "` mangler kolonnen `Variabel`.",
      call. = FALSE
    )
  }
  
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
  
  concept_columns <- setdiff(
    names(metadata),
    c(
      "Variabel",
      "Display_navn",
      "Enhet",
      "Analyse_type"
    )
  )
  
  if (length(concept_columns) != 1L) {
    stop(
      "Kunne ikke identifisere konseptdimensjonen for KOSTRA-tabell `",
      table,
      "`.",
      call. = FALSE
    )
  }
  
  concept_column <- concept_columns[[1]]
  
  concepts <- metadata |>
    dplyr::filter(
      .data$Variabel %in% variables
    ) |>
    dplyr::pull(
      dplyr::all_of(
        concept_column
      )
    ) |>
    unique()
  
  as.character(
    concepts
  )
}
