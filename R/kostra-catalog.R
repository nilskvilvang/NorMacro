
kostra_catalog <- function() {
  tibble::tribble(
    ~Tabell, ~Tema, ~Funksjon,
    "12134", "KOSTRA-nøkkeltall", "get_kostra_keyfigures",
    "12135", "Gjeldsnøkkeltall", "get_kostra_debt_keyfigures",
    "12137", "Nøkkeltall per innbygger", "get_kostra_per_capita_keyfigures",
    "12143", "Driftsfinansiering", "get_kostra_operating_financing",
    "12333", "Investeringsfinansiering", "get_kostra_investment_financing",
    "12364", "Finansielle grunnlagsdata", "get_kostra_financial_foundations"
  )
}
