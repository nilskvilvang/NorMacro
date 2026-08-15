
get_bnp_lopende <- function(refresh = FALSE) {
  cache_get(
    name = "bnp_lopende",
    refresh = refresh,
    fun = function() {
      
      bnp <- ssb_get(
        url = paste0(
          "https://data.ssb.no/api/v0/no/table/",
          "nk/nk03/knr/SBMENU5140/NRMakroHov"
        ),
        query = list(
          Makrost = "bnpb.nr23_9",
          ContentsCode = "Priser",
          Tid = "*"
        )
      )
      
      names(bnp) <- c(
        "Makrost",
        "Aar",
        "BNP_lopende"
      )
      
      bnp |>
        dplyr::mutate(
          Aar = as.integer(Aar),
          BNP_lopende = as.numeric(BNP_lopende)
        ) |>
        dplyr::select(
          Aar,
          BNP_lopende
        ) |>
        dplyr::arrange(Aar)
    }
  )
}

