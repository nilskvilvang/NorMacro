
get_strompris <- function(refresh = FALSE){
  
  cache_get(
    name = "strompris",
    refresh = refresh,
    fun = function(){
      
      strom_raw <- ssb_get(
        url = "https://data.ssb.no/api/v0/no/table/ei/ei01/elkraftpris/SBMENU4023/KraftPrisNettLeiAar",
        query = list(
          ContentsCode = "KraftOgNettIA",
          Tid = "*"
        )
      )
      
      strom_raw |>
        dplyr::transmute(
          Aar = as.integer(ar),
          Strompris = as.numeric(
            kraft_og_nett_i_alt_inkl_avgifter_ore_k_wh
          )
        ) |>
        dplyr::arrange(Aar) |>
        dplyr::mutate(
          Stromprisvekst =
            (Strompris / dplyr::lag(Strompris) - 1) * 100
        )
    }
  )
}