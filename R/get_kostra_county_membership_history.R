
get_kostra_county_membership_history <- function(
    start_year,
    end_year
) {
  
  if (
    length(start_year) != 1L ||
    length(end_year) != 1L ||
    is.na(start_year) ||
    is.na(end_year)
  ) {
    stop(
      "`start_year` og `end_year` må angi ett år hver.",
      call. = FALSE
    )
  }
  
  start_year <- as.integer(start_year)
  end_year <- as.integer(end_year)
  
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
      
      membership <- get_kostra_county_membership(
        date = as.Date(
          sprintf(
            "%d-01-01",
            year
          )
        )
      )
      
      membership |>
        dplyr::mutate(
          Aar = year,
          .after = "Enhet_navn"
        )
    }
  )
  
  attr(
    result,
    "start_year"
  ) <- start_year
  
  attr(
    result,
    "end_year"
  ) <- end_year
  
  class(result) <- c(
    "kostra_county_membership_history",
    class(result)
  )
  
  result
}
