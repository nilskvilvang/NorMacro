
#' Historiske makroøkonomiske episoder
#'
#' Returnerer en kuratert katalog over utvalgte historiske
#' makroøkonomiske episoder i Norge. Episodene er valgt for å
#' knytte sentrale økonomiske hendelser til relevante variabler
#' i NorMacro.
#'
#' @param episode Valgfri tegnvektor med episode-ID-er. Hvis `NULL`,
#'   returneres alle episoder.
#' @param theme Valgfri tekst for filtrering på tema.
#'
#' @return En tibble med episode-ID, navn, periode, tema,
#'   kort beskrivelse og relevante NorMacro-variabler.
#'
#' @examples
#' historical_episodes()
#'
#' historical_episodes(
#'   episode = "finanskrisen_2008"
#' )
#'
#' historical_episodes(
#'   theme = "inflasjon"
#' )
#'
#' @export

historical_episodes <- function(
    episode = NULL,
    theme = NULL
) {
  
  episodes <- tibble::tribble(
    ~Episode_id,
    ~Episode,
    ~Startaar,
    ~Sluttaar,
    ~Tema,
    ~Kort_beskrivelse,
    ~Variabler,
    
    "bankkrisen_1988",
    "Bankkrisen 1988-1993",
    1988L,
    1993L,
    "Finanskrise og konjunkturnedgang",
    paste0(
      "Bankkrise, svak \u00f8konomisk aktivitet og kraftig ",
      "\u00f8kning i arbeidsledigheten."
    ),
    paste(
      c(
        "BNP_Fastland_vekst",
        "Arbeidsledighetsrate_NAV",
        "Styringsrente"
      ),
      collapse = ";"
    ),
    
    "finanskrisen_2008",
    "Finanskrisen 2008-2009",
    2008L,
    2009L,
    "Internasjonal finanskrise",
    paste0(
      "Global finanskrise med kraftig svekkelse i aktivitet, ",
      "eksport og finansmarkeder."
    ),
    paste(
      c(
        "BNP_Fastland_vekst",
        "Eksport",
        "Valutakurs_I44",
        "Styringsrente"
      ),
      collapse = ";"
    ),
    
    "oljeprisfallet_2014",
    "Oljeprisfallet 2014-2016",
    2014L,
    2016L,
    "Olje og norsk \u00f8konomi",
    paste0(
      "Kraftig fall i oljeprisen ble fulgt av svakere aktivitet, ",
      "kronesvekkelse og \u00f8kt arbeidsledighet."
    ),
    paste(
      c(
        "Oljepris_USD",
        "Valutakurs_I44",
        "BNP_Fastland_vekst",
        "Arbeidsledighetsrate_NAV"
      ),
      collapse = ";"
    ),
    
    "pandemien_2020",
    "Pandemien 2020-2021",
    2020L,
    2021L,
    "Pandemi og \u00f8konomisk nedstenging",
    paste0(
      "Kraftig fall i \u00f8konomisk aktivitet under pandemien ",
      "ble etterfulgt av en rask gjeninnhenting."
    ),
    paste(
      c(
        "BNP_Fastland_vekst",
        "Privat_konsum_vekst",
        "Arbeidsledighetsrate_AKU",
        "Styringsrente"
      ),
      collapse = ";"
    ),
    
    "inflasjonssjokket_2021",
    "Inflasjonssjokket 2021-2023",
    2021L,
    2023L,
    "Inflasjon, reall\u00f8nn og pengepolitikk",
    paste0(
      "Kraftig \u00f8kning i prisveksten svekket reall\u00f8nnsutviklingen ",
      "og ble fulgt av betydelige rente\u00f8kninger."
    ),
    paste(
      c(
        "Inflasjon",
        "Lonnvekst",
        "Reallonnsvekst",
        "Styringsrente"
      ),
      collapse = ";"
    )
  )
  
  if (!is.null(episode)) {
    
    if (
      !is.character(episode) ||
      anyNA(episode) ||
      any(episode == "")
    ) {
      stop(
        "`episode` m\u00e5 v\u00e6re en tegnvektor med gyldige episode-ID-er.",
        call. = FALSE
      )
    }
    
    missing_episodes <- setdiff(
      episode,
      episodes$Episode_id
    )
    
    if (length(missing_episodes) > 0L) {
      stop(
        "Fant ikke episode: ",
        paste(missing_episodes, collapse = ", "),
        ".",
        call. = FALSE
      )
    }
    
    episodes <- episodes |>
      dplyr::filter(
        .data$Episode_id %in% episode
      )
  }
  
  if (!is.null(theme)) {
    
    if (
      !is.character(theme) ||
      length(theme) != 1L ||
      is.na(theme) ||
      theme == ""
    ) {
      stop(
        "`theme` m\u00e5 v\u00e6re en tekstverdi.",
        call. = FALSE
      )
    }
    
    episodes <- episodes |>
      dplyr::filter(
        grepl(
          tolower(theme),
          tolower(.data$Tema),
          fixed = TRUE
        )
      )
  }
  
  episodes
}
