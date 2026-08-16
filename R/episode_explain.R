
#' Forklar en historisk makroepisode
#'
#' Viser en kort beskrivelse av en kuratert historisk episode
#' og relevante NorMacro-variabler for perioden.
#'
#' @param episode Episode-ID fra [historical_episodes()].
#' @param data Norsk NorMacro-datasett. Hvis `NULL`, brukes [get_normacro()].
#'
#' @return Usynlig en liste med episodeinformasjon og datauttrekk.
#'
#' @examples
#' episode_explain("finanskrisen_2008", data = normacro_example)
#'
#' @export
episode_explain <- function(
    episode,
    data = NULL
) {
  
  if (
    !is.character(episode) ||
    length(episode) != 1L ||
    is.na(episode) ||
    episode == ""
  ) {
    stop(
      "`episode` maa vaere en gyldig episode-ID.",
      call. = FALSE
    )
  }
  
  if (is.null(data)) {
    data <- suppressMessages(
      get_normacro()
    )
  }
  
  if (!is.data.frame(data)) {
    stop(
      "`data` maa vaere en data.frame eller tibble.",
      call. = FALSE
    )
  }
  
  if (!"Aar" %in% names(data)) {
    stop(
      "Datasettet maa inneholde kolonnen `Aar`.",
      call. = FALSE
    )
  }
  
  info <- historical_episodes(
    episode = episode
  )
  
  variables <- strsplit(
    info$Variabler[[1]],
    ";",
    fixed = TRUE
  )[[1]]
  
  missing_variables <- setdiff(
    variables,
    names(data)
  )
  
  available_variables <- intersect(
    variables,
    names(data)
  )
  
  episode_data <- data |>
    dplyr::filter(
      .data$Aar >= info$Startaar[[1]],
      .data$Aar <= info$Sluttaar[[1]]
    ) |>
    dplyr::select(
      Aar,
      dplyr::all_of(available_variables)
    )
  
  cat("\n")
  cat(info$Episode[[1]], "\n")
  cat(
    paste(
      rep(
        "=",
        nchar(info$Episode[[1]])
      ),
      collapse = ""
    ),
    "\n\n",
    sep = ""
  )
  
  cat(
    "Periode: ",
    info$Startaar[[1]],
    "-",
    info$Sluttaar[[1]],
    "\n",
    sep = ""
  )
  
  cat(
    "Tema:    ",
    info$Tema[[1]],
    "\n\n",
    sep = ""
  )
  
  cat(info$Kort_beskrivelse[[1]], "\n\n")
  
  cat("Relevante variabler\n")
  cat("-------------------\n")
  
  if (length(available_variables) > 0L) {
    cat(
      paste(
        available_variables,
        collapse = ", "
      ),
      "\n\n"
    )
  } else {
    cat("Ingen relevante variabler funnet i datasettet.\n\n")
  }
  
  if (length(missing_variables) > 0L) {
    cat(
      "Mangler i datasettet: ",
      paste(
        missing_variables,
        collapse = ", "
      ),
      "\n\n",
      sep = ""
    )
  }
  
  cat("Data\n")
  cat("----\n")
  
  print(
    episode_data
  )
  
  invisible(
    list(
      episode = info,
      data = episode_data,
      available_variables = available_variables,
      missing_variables = missing_variables
    )
  )
}
