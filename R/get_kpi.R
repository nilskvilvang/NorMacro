
get_kpi <- function(refresh = FALSE) {
  cache_get(
    name = "kpi",
    refresh = refresh,
    fun = function() {
      query <- list(ContentsCode = "KpiAar", Tid = "*")
      
      kpi <- ssb_get(url = "https://data.ssb.no/api/v0/no/table/pp/pp04/kpi/SBMENU12006/Kpi11", query = query)
      
      names(kpi) <- c("Aar", "KPI")
      
      kpi |>
        dplyr::mutate(Aar = as.integer(Aar), KPI = as.numeric(KPI)) |>
        dplyr::arrange(Aar) |>
        dplyr::mutate(Inflasjon = (KPI / dplyr::lag(KPI) - 1) * 100)
    }
  )
}

