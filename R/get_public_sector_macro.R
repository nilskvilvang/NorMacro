
get_public_sector_macro <- function(
    start_year = 1970,
    end_year = NULL,
    prices = c(
      "real",
      "nominal"
    )
) {
  
  prices <- match.arg(
    prices
  )
  
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
  
  start_year <- as.integer(
    start_year
  )
  
  if (is.null(end_year)) {
    end_year <- as.integer(
      format(
        Sys.Date(),
        "%Y"
      )
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
  
  end_year <- as.integer(
    end_year
  )
  
  if (start_year > end_year) {
    stop(
      "`start_year` kan ikke være større enn `end_year`.",
      call. = FALSE
    )
  }
  
  if (start_year < 1970L) {
    stop(
      "Tabell 09189 har data fra og med 1970.",
      call. = FALSE
    )
  }
  
  url <- "https://data.ssb.no/api/v0/no/table/09189"
  
  content_code <- switch(
    prices,
    real = "Faste",
    nominal = "Priser"
  )
  
  query <- list(
    Makrost = c(
      "bnpb.nr23_9fn",
      "koo.nroff",
      "koo.nr64_",
      "koo.nr65_"
    ),
    ContentsCode = content_code,
    Tid = as.character(
      seq.int(
        start_year,
        end_year
      )
    )
  )
  
  raw <- pxweb::pxweb_get(
    url = url,
    query = query
  ) |>
    as.data.frame(
      column.name.type = "code",
      variable.value.type = "code"
    )
  
  value_column <- if (prices == "real") {
    "Faste"
  } else {
    "Priser"
  }
  
  required_columns <- c(
    "Makrost",
    "Tid",
    value_column
  )
  
  missing_columns <- setdiff(
    required_columns,
    names(raw)
  )
  
  if (length(missing_columns) > 0L) {
    stop(
      "SSB-tabell 09189 returnerte ikke forventede kolonner: ",
      paste(
        missing_columns,
        collapse = ", "
      ),
      call. = FALSE
    )
  }
  
  series_map <- tibble::tribble(
    ~Makrost,        ~Variabel,
    "bnpb.nr23_9fn", "BNP_Fastlands",
    "koo.nroff",     "Offentlig_konsum",
    "koo.nr64_",     "Statlig_konsum",
    "koo.nr65_",     "Kommunalt_konsum"
  )
  
  standardized <- raw |>
    dplyr::left_join(
      series_map,
      by = "Makrost"
    ) |>
    dplyr::transmute(
      Aar = as.integer(
        .data$Tid
      ),
      Variabel = .data$Variabel,
      Verdi = as.numeric(
        .data[[value_column]]
      )
    )
  
  if (anyNA(standardized$Variabel)) {
    stop(
      "Kunne ikke standardisere alle serier fra SSB-tabell 09189.",
      call. = FALSE
    )
  }
  
  result <- standardized |>
    tidyr::pivot_wider(
      names_from = "Variabel",
      values_from = "Verdi"
    ) |>
    dplyr::arrange(
      .data$Aar
    )
  
  expected_variables <- c(
    "BNP_Fastlands",
    "Offentlig_konsum",
    "Statlig_konsum",
    "Kommunalt_konsum"
  )
  
  missing_variables <- setdiff(
    expected_variables,
    names(result)
  )
  
  if (length(missing_variables) > 0L) {
    stop(
      "Standardisert datasett mangler serier: ",
      paste(
        missing_variables,
        collapse = ", "
      ),
      call. = FALSE
    )
  }
  
  attr(
    result,
    "dataset_type"
  ) <- "macro"
  
  attr(
    result,
    "source"
  ) <- "SSB"
  
  attr(
    result,
    "ssb_table"
  ) <- "09189"
  
  attr(
    result,
    "ssb_title"
  ) <- paste0(
    "Makroøkonomiske hovedstørrelser"
  )
  
  attr(
    result,
    "prices"
  ) <- prices
  
  attr(
    result,
    "price_basis"
  ) <- if (prices == "real") {
    "Faste 2023-priser"
  } else {
    "Løpende priser"
  }
  
  attr(
    result,
    "unit"
  ) <- "Millioner kroner"
  
  result
}
