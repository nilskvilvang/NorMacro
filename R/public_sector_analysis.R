
public_sector_analysis <- function(
    start_year = 1970,
    end_year = NULL,
    measure = c(
      "level",
      "index",
      "share_gdp",
      "share_public"
    ),
    base_year = NULL
) {

  measure <- match.arg(
    measure
  )

  if (
    !is.numeric(start_year) ||
    length(start_year) != 1L ||
    is.na(start_year) ||
    !is.finite(start_year)
  ) {
    stop(
      "`start_year` m\u00e5 v\u00e6rere ett gyldig \u00e5r.",
      call. = FALSE
    )
  }

  start_year <- as.integer(
    start_year
  )

  if (!is.null(end_year)) {

    if (
      !is.numeric(end_year) ||
      length(end_year) != 1L ||
      is.na(end_year) ||
      !is.finite(end_year)
    ) {
      stop(
        "`end_year` m\u00e5 v\u00e6rere ett gyldig \u00e5r.",
        call. = FALSE
      )
    }

    end_year <- as.integer(
      end_year
    )

    if (start_year > end_year) {
      stop(
        "`start_year` kan ikke v\u00e6rere st\u00f8rre enn `end_year`.",
        call. = FALSE
      )
    }
  }

  prices <- if (
    measure %in% c(
      "level",
      "index"
    )
  ) {
    "real"
  } else {
    "nominal"
  }

  data <- get_public_sector_macro(
    start_year = start_year,
    end_year = end_year,
    prices = prices
  )

  if (nrow(data) == 0L) {
    stop(
      "Ingen data tilgjengelig for valgt periode.",
      call. = FALSE
    )
  }

  end_year <- max(
    data$Aar,
    na.rm = TRUE
  )

  if (measure == "level") {

    result <- data |>
      tidyr::pivot_longer(
        cols = c(
          "BNP_Fastlands",
          "Offentlig_konsum",
          "Statlig_konsum",
          "Kommunalt_konsum"
        ),
        names_to = "Variabel",
        values_to = "Verdi"
      )

  } else if (measure == "index") {

    if (is.null(base_year)) {
      base_year <- start_year
    }

    if (
      !is.numeric(base_year) ||
      length(base_year) != 1L ||
      is.na(base_year) ||
      !is.finite(base_year)
    ) {
      stop(
        "`base_year` m\u00e5 v\u00e6rere ett gyldig \u00e5r.",
        call. = FALSE
      )
    }

    base_year <- as.integer(
      base_year
    )

    if (
      base_year < start_year ||
      base_year > end_year
    ) {
      stop(
        "`base_year` m\u00e5 ligge innenfor valgt periode.",
        call. = FALSE
      )
    }

    result <- data |>
      tidyr::pivot_longer(
        cols = c(
          "BNP_Fastlands",
          "Offentlig_konsum",
          "Statlig_konsum",
          "Kommunalt_konsum"
        ),
        names_to = "Variabel",
        values_to = "Nivaa"
      ) |>
      dplyr::group_by(
        .data$Variabel
      ) |>
      dplyr::mutate(
        Basisverdi = .data$Nivaa[
          .data$Aar == base_year
        ][[1]],
        Verdi =
          .data$Nivaa /
          .data$Basisverdi *
          100
      ) |>
      dplyr::ungroup() |>
      dplyr::select(
        Aar,
        Variabel,
        Verdi
      )

  } else if (measure == "share_gdp") {

    result <- data |>
      dplyr::transmute(
        Aar = .data$Aar,
        Offentlig_konsum =
          .data$Offentlig_konsum /
          .data$BNP_Fastlands *
          100,
        Statlig_konsum =
          .data$Statlig_konsum /
          .data$BNP_Fastlands *
          100,
        Kommunalt_konsum =
          .data$Kommunalt_konsum /
          .data$BNP_Fastlands *
          100
      ) |>
      tidyr::pivot_longer(
        cols = -Aar,
        names_to = "Variabel",
        values_to = "Verdi"
      )

  } else {

    result <- data |>
      dplyr::transmute(
        Aar = .data$Aar,
        Kommunalt_konsum =
          .data$Kommunalt_konsum /
          .data$Offentlig_konsum *
          100,
        Statlig_konsum =
          .data$Statlig_konsum /
          .data$Offentlig_konsum *
          100
      ) |>
      tidyr::pivot_longer(
        cols = -Aar,
        names_to = "Variabel",
        values_to = "Verdi"
      )
  }

  result <- result |>
    dplyr::arrange(
      .data$Variabel,
      .data$Aar
    )

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
    "measure"
  ) <- measure

  attr(
    result,
    "prices"
  ) <- prices

  attr(
    result,
    "start_year"
  ) <- start_year

  attr(
    result,
    "end_year"
  ) <- end_year

  attr(
    result,
    "base_year"
  ) <- if (measure == "index") {
    base_year
  } else {
    NULL
  }

  attr(
    result,
    "unit"
  ) <- switch(
    measure,
    level = "Millioner kroner, faste 2023-priser",
    index = "Indeks",
    share_gdp = "Prosent av BNP Fastlands-Norge",
    share_public = "Prosent av offentlig konsum"
  )

  result
}
