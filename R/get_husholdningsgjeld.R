

get_husholdningsgjeld <- function(refresh = FALSE) {
  cache_get(
    name = "husholdningsgjeld",
    refresh = refresh,
    fun = function() {
      gjeldsrate_raw <- ssb_get(url = "https://data.ssb.no/api/v0/no/table/nk/nk01/finsek/div_finsek_mappe/FinansSektReg9",
                                query = list(
                                  Justering = "U",
                                  ContentsCode = c(
                                    "Gjeldsrate",
                                    "Fordringsrate",
                                    "Nettofordringsrate",
                                    "Gjeldsvekst"
                                  ),
                                  Tid = "*"
                                ))
      
      gjeldsrate_raw |>
        dplyr::transmute(
          Aar = as.integer(substr(kvartal, 1, 4)),
          Husholdningsgjeldsrate = as.numeric(gjeldsrate),
          Husholdningsfordringsrate = as.numeric(fordringsrate),
          Husholdningsnettofordringsrate = as.numeric(nettofordringsrate),
          Husholdningsgjeldsvekst = as.numeric(gjeldsvekst)
        ) |>
        dplyr::group_by(Aar) |>
        dplyr::summarise(dplyr::across(
          c(
            Husholdningsgjeldsrate,
            Husholdningsfordringsrate,
            Husholdningsnettofordringsrate,
            Husholdningsgjeldsvekst
          ),
          ~ mean(.x, na.rm = TRUE)
        ), .groups = "drop") |>
        dplyr::arrange(Aar)
    }
  )
}