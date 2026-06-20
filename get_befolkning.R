
get_befolkning <- function(){
  
  query <- list(
    ContentsCode = "Personer",
    Tid = "*"
  )
  
  befolkning <- ssb_get(
    url = "https://data.ssb.no/api/v0/no/table/be/be05/folkemengde/SBMENU5580/FolkHistorie",
    query = query
  )
  
  names(befolkning) <- c("Aar", "Befolkning")
  
  befolkning |>
    dplyr::mutate(
      Aar = as.integer(Aar),
      Befolkning = as.numeric(Befolkning)
    ) |>
    dplyr::arrange(Aar)
  
}