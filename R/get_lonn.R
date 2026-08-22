
get_lonn <- function(refresh = FALSE) {
  cache_get(
    name = "lonn",
    refresh = refresh,
    fun = function() {
      
      lonn_raw <- suppressWarnings(
        ssb_get(
          url = "https://data.ssb.no/api/v0/no/table/09786",
          query = list(
            ContentsCode = c(
              "Arslonn",
              "ArslonnEndring"
            ),
            Tid = "*"
          )
        )
      )
      
      lonn_raw |>
        dplyr::rename(
          Aar = ar,
          Lonn = arslonn_palopt_1_000_kr,
          Lonnvekst =
            arslonn_palopt_endring_fra_aret_for_i_prosent
        ) |>
        dplyr::mutate(
          Aar = as.integer(.data$Aar),
          Lonn = as.numeric(.data$Lonn),
          Lonnvekst = as.numeric(.data$Lonnvekst)
        ) |>
        dplyr::arrange(.data$Aar)
    }
  )
}
