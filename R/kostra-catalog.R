
kostra_catalog <- function() {
  tibble::tribble(
    ~Tabell, ~Tema, ~Funksjon,
    "12134", "KOSTRA-n\u00f8kkeltall", "get_kostra_keyfigures",
    "12135", "Gjeldsn\u00f8kkeltall", "get_kostra_debt_keyfigures",
    "12137", "N\u00f8kkeltall per innbygger", "get_kostra_per_capita_keyfigures",
    "12143", "Driftsfinansiering", "get_kostra_operating_financing",
    "12333", "Investeringsfinansiering", "get_kostra_investment_financing",
    "12364", "Finansielle grunnlagsdata", "get_kostra_financial_foundations"
  )
}
