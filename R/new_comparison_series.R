

new_comparison_series <- function(x,
                                  normalized = FALSE,
                                  base_year = NULL,
                                  transformation = "level",
                                  transformation_periods = NULL,
                                  transformation_base_value = NULL) {
  if (!inherits(x, "data.frame")) {
    stop("`x` m\u00e5 v\u00e6re en data.frame eller tibble.", call. = FALSE)
  }
  
  required_columns <- c(
    "Aar",
    "Serie_id",
    "Datasett",
    "Land",
    "Variabel",
    "Display_navn",
    "Verdi",
    "Enhet",
    "Kilde"
  )
  
  missing_columns <- setdiff(required_columns, names(x))
  
  if (length(missing_columns) > 0) {
    stop(
      "Mangler n\u00f8dvendige kolonner: ",
      paste(missing_columns, collapse = ", "),
      ".",
      call. = FALSE
    )
  }
  
  if (!is.logical(normalized) ||
      length(normalized) != 1 ||
      is.na(normalized)) {
    stop("`normalized` m\u00e5 v\u00e6re TRUE eller FALSE.", call. = FALSE)
  }
  
  if (!is.null(base_year)) {
    if (!is.numeric(base_year) ||
        length(base_year) != 1 ||
        is.na(base_year) ||
        base_year != floor(base_year)) {
      stop("`base_year` m\u00e5 v\u00e6re ett gyldig heltallig \u00e5rstall.", call. = FALSE)
    }
    
    base_year <- as.integer(base_year)
  }
  
  if (!is.null(transformation_base_value)) {
    if (!is.numeric(transformation_base_value) ||
        length(transformation_base_value) != 1 ||
        is.na(transformation_base_value) ||
        !is.finite(transformation_base_value) ||
        transformation_base_value == 0) {
      stop(
        paste0(
          "`transformation_base_value` m\u00e5 v\u00e6re ",
          "ett endelig numerisk tall ulik null."
        ),
        call. = FALSE
      )
    }
  }
  
  if (normalized && is.null(base_year)) {
    stop("`base_year` m\u00e5 oppgis n\u00e5r `normalized = TRUE`.", call. = FALSE)
  }
  
  valid_transformations <- c("level", "indexed", "growth_percent", "growth_absolute")
  
  if (!is.character(transformation) ||
      length(transformation) != 1 ||
      is.na(transformation) ||
      !transformation %in% valid_transformations) {
    stop(
      "`transformation` m\u00e5 v\u00e6re en av: ",
      paste(valid_transformations, collapse = ", "),
      ".",
      call. = FALSE
    )
  }
  
  if (!is.null(transformation_periods)) {
    if (!is.numeric(transformation_periods) ||
        length(transformation_periods) != 1 ||
        is.na(transformation_periods) ||
        transformation_periods < 1 ||
        transformation_periods != floor(transformation_periods)) {
      stop("`transformation_periods` m\u00e5 v\u00e6re et positivt heltall.",
           call. = FALSE)
    }
    
    transformation_periods <- as.integer(transformation_periods)
  }
  
  if (identical(transformation, "indexed") &&
      is.null(base_year)) {
    stop("`base_year` m\u00e5 oppgis for indekserte serier.", call. = FALSE)
  }
  
  if (identical(transformation, "indexed") &&
      is.null(transformation_base_value)) {
    stop(
      paste0(
        "`transformation_base_value` m\u00e5 oppgis ",
        "for indekserte serier."
      ),
      call. = FALSE
    )
  }
  
  if (!identical(transformation, "indexed") &&
      !is.null(transformation_base_value)) {
    stop(
      paste0(
        "`transformation_base_value` skal bare ",
        "brukes for `transformation = \"indexed\"`."
      ),
      call. = FALSE
    )
  }
  
  if (transformation %in% c("growth_percent", "growth_absolute") &&
      is.null(transformation_periods)) {
    stop(
      paste0(
        "`transformation_periods` m\u00e5 oppgis for ",
        "vekst- og endringstransformasjoner."
      ),
      call. = FALSE
    )
  }
  
  if (transformation %in% c("level", "normalized") &&
      !is.null(transformation_periods)) {
    stop(
      paste0(
        "`transformation_periods` skal v\u00e6re NULL for ",
        "`level` og `normalized`."
      ),
      call. = FALSE
    )
  }
  
  if (normalized && transformation != "normalized") {
    stop(
      paste0(
        "`normalized = TRUE` krever ",
        "`transformation = \"normalized\"`."
      ),
      call. = FALSE
    )
  }
  
  if (transformation == "normalized" &&
      !normalized) {
    stop(
      paste0(
        "`transformation = \"normalized\"` krever ",
        "`normalized = TRUE`."
      ),
      call. = FALSE
    )
  }
  
  x <- tibble::as_tibble(x)
  
  attr(x, "normalized") <- normalized
  attr(x, "base_year") <- base_year
  attr(x, "transformation") <- transformation
  attr(x, "transformation_periods") <-
    transformation_periods
  attr(x, "transformation_base_value") <-
    transformation_base_value
  
  
  class(x) <- c("comparison_series", class(x))
  
  x
}
