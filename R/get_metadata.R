
#' Hent metadata for et NorMacro-datasett
#'
#' Returnerer metadata som passer til datasettet som oppgis. Dersom
#' `data` ikke oppgis, returneres metadata for de norske makrodataene.
#'
#' @param data Valgfritt NorMacro-datasett. Datastrukturen brukes til å
#'   identifisere riktig metadataområde.
#'
#' @return En tibble med metadata for variablene i datasettet.
#'
#' @examples
#' get_metadata()
#'
#' get_metadata(
#'   normacro_international_example
#' )
#'
#' @export

get_metadata <- function(data = NULL) {

  if (is.null(data)) {
    return(
      dplyr::bind_rows(
        get_normacro_metadata() |>
          dplyr::filter(.data$Omraade == "Norge"),
        get_international_metadata()
      )
    )
  }

  dataset_type <- attr(
    data,
    "dataset_type"
  )

  has_kostra_structure <- all(
    c(
      "Enhet",
      "Enhet_navn",
      "Enhetstype",
      "Aar"
    ) %in% names(data)
  )

  if (
    identical(dataset_type, "kostra") ||
    has_kostra_structure
  ) {
    return(
      get_kostra_metadata(
        data = data
      )
    )
  }

  if (
    all(
      c(
        "Land",
        "Aar"
      ) %in% names(data)
    )
  ) {
    variable_names <- setdiff(
      names(data),
      c(
        "Land",
        "Aar"
      )
    )

    return(
      get_international_metadata() |>
        dplyr::filter(
          .data$Variabel %in% variable_names
        )
    )
  }

  if ("Aar" %in% names(data)) {
    variable_names <- setdiff(
      names(data),
      "Aar"
    )

    return(
      get_normacro_metadata() |>
        dplyr::filter(
          .data$Omraade == "Norge",
          .data$Variabel %in% variable_names
        )
    )
  }

  stop(
    "`data` har en ukjent struktur.",
    call. = FALSE
  )
}
