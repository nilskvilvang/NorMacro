
get_ordrebeholdning <- function(refresh = FALSE) {
  cache_get(
    name = "ordrebeholdning",
    refresh = refresh,
    fun = function() {
      ordre_raw <- ssb_get(
        url = "https://data.ssb.no/api/v0/no/table/nk/nk02/kbar/KBarAvledIndik",
        query = list(
          PKoder = "P105",
          Justering = "S",
          ContentsCode = "AntArbeidMnd",
          Tid = "*"
        )
      )
      
      ordre_raw |>
        dplyr::transmute(
          Aar = as.integer(substr(kvartal, 1, 4)),
          Ordrebeholdning = as.numeric(
            antall_arbeidsmaneder_dekket_ved_ordrebeholdningen_veid_gjennomsnitt
          )
        ) |>
        dplyr::filter(!is.na(Ordrebeholdning)) |>
        dplyr::group_by(Aar) |>
        dplyr::summarise(Ordrebeholdning = mean(Ordrebeholdning, na.rm = TRUE),
                         .groups = "drop") |>
        dplyr::arrange(Aar)
    }
  )
}