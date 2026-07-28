
test_data <-
  tibble::tibble(
    Aar = rep(2015:2024, times = 2),
    Serie_id = rep(
      c(
        "Faktisk",
        "Forklaringsvariabel"
      ),
      each = 10
    ),
    Datasett = "test",
    Land = "Norge",
    Variabel = rep(
      c(
        "Faktisk",
        "Forklaringsvariabel"
      ),
      each = 10
    ),
    Display_navn = rep(
      c(
        "Faktisk",
        "Forklaringsvariabel"
      ),
      each = 10
    ),
    Verdi = c(
      10.0,
      11.2,
      12.1,
      13.4,
      14.1,
      15.3,
      16.2,
      17.4,
      18.0,
      19.1,
      8.1,
      9.0,
      9.8,
      10.7,
      11.5,
      12.4,
      13.1,
      14.0,
      14.8,
      15.6
    ),
    Enhet = "Indeks",
    Kilde = "Testdata"
  )

test_series <-
  new_comparison_series(
    test_data
  )

price_model <-
  regress(
    test_series,
    formula = Faktisk ~ Forklaringsvariabel
  )

model_diagnosis <-
  diagnose(
    price_model
  )
