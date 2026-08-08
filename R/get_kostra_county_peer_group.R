
get_kostra_county_peer_group <- function(
    unit,
    date = Sys.Date()
) {
  
  county <- get_kostra_county(
    unit = unit,
    date = date
  )
  
  membership <- get_kostra_county_membership(
    date = date
  )
  
  county_code <- county$Fylke[[1]]
  
  result <- membership |>
    dplyr::filter(
      .data$Fylke == county_code
    ) |>
    dplyr::arrange(
      .data$Enhet
    )
  
  attr(
    result,
    "county"
  ) <- county_code
  
  attr(
    result,
    "county_name"
  ) <- county$Fylke_navn[[1]]
  
  attr(
    result,
    "date"
  ) <- attr(
    membership,
    "date"
  )
  
  class(result) <- c(
    "kostra_county_peer_group",
    class(result)
  )
  
  result
}
