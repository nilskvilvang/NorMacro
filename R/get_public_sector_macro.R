
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
      "`start_year` m\u00e5 v\u00e6re ett gyldig \u00e5r.",
      call. = FALSE
    )
  }

  start_year <- as.integer(
    start_year
  )

  if (start_year < 1970L) {
    stop(
      "Tabell 09189 har data fra og med 1970.",
      call. = FALSE
    )
  }

  url <- "https://data.ssb.no/api/v0/no/table/09189"

  # ------------------------------------------------------------
  # Finn tilgjengelige år
  # ------------------------------------------------------------

  metadata <- pxweb::pxweb_get(
    url
  )

  time_index <- which(
    vapply(
      metadata$variables,
      function(x) {
        identical(
          x$code,
          "Tid"
        )
      },
      logical(1)
    )
  )

  if (length(time_index) != 1L) {
    stop(
      "Fant ikke entydig \u00e5rsvariabel i SSB-tabell 09189.",
      call. = FALSE
    )
  }

  available_years <- as.integer(
    metadata$variables[[time_index]]$values
  )

  available_years <- available_years[
    !is.na(available_years)
  ]

  if (length(available_years) == 0L) {
    stop(
      "Fant ingen tilgjengelige \u00e5r i SSB-tabell 09189.",
      call. = FALSE
    )
  }

  latest_year <- max(
    available_years
  )

  # ------------------------------------------------------------
  # Sluttår
  # ------------------------------------------------------------

  if (is.null(end_year)) {

    end_year <- latest_year

  } else {

    if (
      !is.numeric(end_year) ||
      length(end_year) != 1L ||
      is.na(end_year) ||
      !is.finite(end_year)
    ) {
      stop(
        "`end_year` m\u00e5 v\u00e6re ett gyldig \u00e5r.",
        call. = FALSE
      )
    }

    end_year <- as.integer(
      end_year
    )

    if (end_year > latest_year) {
      stop(
        "`end_year` er ",
        end_year,
        ", men siste tilgjengelige \u00e5r i SSB-tabell 09189 er ",
        latest_year,
        ".",
        call. = FALSE
      )
    }
  }

  if (start_year > end_year) {
    stop(
      "`start_year` kan ikke v\u00e6re st\u00f8rre enn `end_year`.",
      call. = FALSE
    )
  }

  # ------------------------------------------------------------
  # SSB query
  # ------------------------------------------------------------

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

  # ------------------------------------------------------------
  # Standardisering
  # ------------------------------------------------------------

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

  # ------------------------------------------------------------
  # Attributter
  # ------------------------------------------------------------

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
  ) <- "Makro\u00f8konomiske hovedst\u00f8rrelser"

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
    "L\u00f8pende priser"
  }

  attr(
    result,
    "unit"
  ) <- "Millioner kroner"

  attr(
    result,
    "start_year"
  ) <- start_year

  attr(
    result,
    "end_year"
  ) <- end_year

  result
}
