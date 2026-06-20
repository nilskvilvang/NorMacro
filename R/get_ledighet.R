
get_ledighet <- function(){
  
  nav_url <- "https://www.nav.no/_/attachment/download/a5aa83cd-c083-4b88-9359-1c1b3b2f936e:285ebf18c576ff0fd1537a83289401df2498cae4/Tabell%203_Helt%20ledige%20fordelt%20pa%20kjonn.Aarsgjennomsnitt.1948_2025.xls"
  
  nav_raw <- rio::import(
    nav_url,
    skip = 6,
    col_names = FALSE
  )
  
  venstre <- nav_raw |>
    dplyr::select(1, 2, 3, 4, 6, 8)
  
  hoyre <- nav_raw |>
    dplyr::select(10, 11, 12, 13, 15, 17)
  
  names(venstre) <- c(
    "Aar", "Menn_arbledige_NAV", "Kvinner_arbledige_NAV", "Arbledige_NAV",
    "Arbledighetsrate_NAV", "Kvinneandel_arbledige_NAV"
  )
  
  names(hoyre) <- c(
    "Aar", "Menn_arbledige_NAV", "Kvinner_arbledige_NAV", "Arbledige_NAV",
    "Arbledighetsrate_NAV", "Kvinneandel_arbledige_NAV"
  )
  
  dplyr::bind_rows(venstre, hoyre) |>
    dplyr::mutate(
      Aar = readr::parse_number(as.character(Aar)),
      Menn_arbledige_NAV = as.numeric(Menn_arbledige_NAV),
      Kvinner_arbledige_NAV = as.numeric(Kvinner_arbledige_NAV),
      Arbledige_NAV = as.numeric(Arbledige_NAV),
      Arbledighetsrate_NAV = as.numeric(Arbledighetsrate_NAV) * 100,
      Kvinneandel_arbledige_NAV = as.numeric(Kvinneandel_arbledige_NAV) * 100  # <- Her er understreken fikset!
    ) |>
    dplyr::filter(
      !is.na(Aar),
      Aar >= 1948,
      Aar <= 2025
    ) |>
    dplyr::arrange(Aar)
}

