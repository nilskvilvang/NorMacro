
kostra_test_data <- tibble::tibble(
  Enhet = rep(
    c(
      "0301",
      "4601",
      "5001"
    ),
    each = 6
  ),
  Enhet_navn = rep(
    c(
      "Oslo",
      "Bergen",
      "Trondheim"
    ),
    each = 6
  ),
  Enhetstype = "kommune",
  Aar = rep(
    2020:2025,
    times = 3
  ),
  Netto_driftsresultat = c(
    3.7, 4.5, 5.4, -0.8, -0.9, 3.7,
    2.4, 4.6, 4.0, 1.8, -2.4, 1.0,
    4.0, 6.6, 2.0, 0.7, -0.9, 6.0
  ),
  Langsiktig_gjeld_uten_pensjonsforpliktelser = c(
    83.4, 82.0, 86.5, 93.8, 106.7, 110.6,
    91.0, 94.0, 96.0, 101.0, 108.0, 100.8,
    95.0, 98.0, 100.0, 105.0, 112.0, 113.5
  ),
  Frie_inntekter_per_innbygger = c(
    70761, 73500, 76000, 80000, 84000, 88853,
    56346, 59000, 62000, 66000, 70000, 73396,
    52670, 55000, 58000, 61000, 65000, 68789
  )
)

attr(
  kostra_test_data,
  "dataset_type"
) <- "kostra"

attr(
  kostra_test_data,
  "kostra_table"
) <- "12134"

attr(
  kostra_test_data,
  "kostra_title"
) <- "Utvalgte nøkkeltall for kommuneregnskap"