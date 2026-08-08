
get_kostra_group_membership_history <- function(
    start_year = 2020,
    end_year = as.integer(format(Sys.Date(), "%Y"))
) {
  
  validate_year <- function(
    value,
    argument
  ) {
    if (
      !is.numeric(value) ||
      length(value) != 1L ||
      is.na(value) ||
      !is.finite(value)
    ) {
      stop(
        "`",
        argument,
        "` må være ett gyldig år.",
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
  
  start_year <- as.integer(
    start_year
  )
  
  end_year <- as.integer(
    end_year
  )
  
  if (start_year > end_year) {
    stop(
      "`start_year` kan ikke være større enn `end_year`.",
      call. = FALSE
    )
  }
  
  years <- seq.int(
    start_year,
    end_year
  )
  
  result <- purrr::map_dfr(
    years,
    function(year) {
      
      date <- as.Date(
        paste0(
          year,
          "-01-01"
        )
      )
      
      membership <- get_kostra_group_membership(
        date = date
      )
      
      membership |>
        dplyr::mutate(
          Aar = year,
          .after = Enhet_navn
        )
    }
  )
  
  result <- result |>
    dplyr::select(
      Enhet,
      Enhet_navn,
      Aar,
      KOSTRA_gruppe,
      KOSTRA_gruppe_navn
    ) |>
    dplyr::arrange(
      .data$Enhet,
      .data$Aar
    )
  
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
    "source_classification"
  ) <- 112L
  
  attr(
    result,
    "target_classification"
  ) <- 131L
  
  class(result) <- c(
    "kostra_group_membership_history",
    class(result)
  )
  
  result
}
