
get_ledighet <- function(refresh = FALSE) {
  cache_get(
    name = "ledighet",
    refresh = refresh,
    fun = function() {
      nav_url <- "https://www.nav.no/_/attachment/download/a5aa83cd-c083-4b88-9359-1c1b3b2f936e:285ebf18c576ff0fd1537a83289401df2498cae4/Tabell%203_Helt%20ledige%20fordelt%20pa%20kjonn.Aarsgjennomsnitt.1948_2025.xls"
      
      nav_raw <- retry_download(
        suppressMessages(rio::import(
          nav_url, skip = 6, col_names = FALSE
        )),
        retries = 5,
        wait = 5,
        label = "NAV-kall"
      )
      
      venstre <- nav_raw |>
        dplyr::select(1, 2, 3, 4, 6, 8)
      
      hoyre <- nav_raw |>
        dplyr::select(10, 11, 12, 13, 15, 17)
      
      names(venstre) <- c(
        "Aar",
        "Menn_arbeidsledige_NAV",
        "Kvinner_arbeidsledige_NAV",
        "Arbeidsledige_NAV",
        "Arbeidsledighetsrate_NAV",
        "Kvinneandel_arbeidsledige_NAV"
      )
      
      names(hoyre) <- names(venstre)
      
      dplyr::bind_rows(venstre, hoyre) |>
        dplyr::mutate(
          Aar = readr::parse_number(as.character(Aar)),
          Menn_arbeidsledige_NAV = as.numeric(Menn_arbeidsledige_NAV),
          Kvinner_arbeidsledige_NAV = as.numeric(Kvinner_arbeidsledige_NAV),
          Arbeidsledige_NAV = as.numeric(Arbeidsledige_NAV),
          Arbeidsledighetsrate_NAV =
            as.numeric(Arbeidsledighetsrate_NAV) * 100,
          Kvinneandel_arbeidsledige_NAV =
            as.numeric(Kvinneandel_arbeidsledige_NAV) * 100
        ) |>
        dplyr::filter(
          !is.na(Aar),
          Aar >= 1948,
          Aar <= 2025
        ) |>
        dplyr::arrange(Aar)
    }
  )
}
