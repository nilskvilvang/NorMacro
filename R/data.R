
#' Eksempeldatasett fra NorMacro
#'
#' Et lite, statisk utsnitt av NorMacro-datasettet for årlige norske
#' makroøkonomiske serier i perioden 2000–2025.
#'
#' Datasettet er laget for bruk i eksempler, vignett(er) og dokumentasjon,
#' slik at disse kan kjøres uten å hente hele NorMacro-datasettet.
#'
#' @format En data.frame med 26 observasjoner og 17 variabler:
#' \describe{
#'   \item{Aar}{År.}
#'   \item{KPI}{Konsumprisindeks.}
#'   \item{Inflasjon}{Årlig prosentvis vekst i KPI.}
#'   \item{Befolkning}{Befolkning.}
#'   \item{Arbeidsstyrke}{Personer i arbeidsstyrken.}
#'   \item{Sysselsatte}{Sysselsatte personer.}
#'   \item{Arbeidsledige_NAV}{Registrerte arbeidsledige hos NAV.}
#'   \item{Arbeidsledighetsrate_NAV}{Registrert arbeidsledighet i prosent.}
#'   \item{Styringsrente}{Norges Banks styringsrente.}
#'   \item{BNP_Fastland}{BNP for Fastlands-Norge.}
#'   \item{BNP_Fastland_vekst}{Årlig vekst i BNP for Fastlands-Norge.}
#'   \item{Lonnvekst}{Årlig lønnsvekst.}
#'   \item{Boligprisindeks}{Boligprisindeks.}
#'   \item{Boligprisvekst}{Årlig vekst i boligprisindeksen.}
#'   \item{Oljepris_USD}{Oljepris i USD per fat.}
#'   \item{Eksport}{Eksport i faste priser.}
#'   \item{Import}{Import i faste priser.}
#' }
#'
#' @source NorMacro. Dataene er et statisk utsnitt av data hentet og
#'   bearbeidet av pakkens ordinære datainnhentingsfunksjoner.
#'
"normacro_example"


#' Metadata for NorMacro-eksempeldatasettet
#'
#' Metadata for variablene i [normacro_example], med én rad per variabel
#' bortsett fra `Aar`.
#'
#' Metadataene inneholder blant annet visningsnavn, variabeltype, kategori,
#' beskrivelse, kilde, enhet, frekvens og analysetype.
#'
#' @format En tibble med 16 observasjoner og 16 variabler:
#' \describe{
#'   \item{Variabel}{Internt variabelnavn i NorMacro.}
#'   \item{Display_navn}{Navn beregnet for visning til bruker.}
#'   \item{Type}{Om serien er original eller beregnet.}
#'   \item{Kategori}{Tematisk kategori.}
#'   \item{Beskrivelse}{Kort beskrivelse av variabelen.}
#'   \item{Kilde}{Datakilde.}
#'   \item{Kilde_url}{URL til datakilden når tilgjengelig.}
#'   \item{Tabell}{Kildetabell eller underliggende variabel.}
#'   \item{Enhet}{Måleenhet.}
#'   \item{Frekvens}{Datafrekvens.}
#'   \item{Startaar}{Første år serien er tilgjengelig.}
#'   \item{Sluttaar}{Siste år dersom serien har avsluttet dekning.}
#'   \item{Funksjon}{NorMacro-funksjonen som henter eller beregner serien.}
#'   \item{Kommentar}{Supplerende informasjon om serien.}
#'   \item{Omraade}{Geografisk område.}
#'   \item{Analyse_type}{Variabelens analysetype, for eksempel nivå, rate eller indeks.}
#' }
#'
#' @source Metadata fra NorMacro.
#'
"normacro_example_metadata"


#' Internasjonalt eksempeldatasett fra NorMacro
#'
#' Et lite, statisk utsnitt av NorMacros internasjonale makrodatasett for
#' Norge, Sverige, Danmark, Finland, Tyskland og Frankrike i perioden
#' 2000–2025.
#'
#' Datasettet er laget for bruk i eksempler, vignetter og dokumentasjon,
#' slik at disse kan kjøres uten å hente data fra eksterne API-er.
#'
#' @format En data.frame med 156 observasjoner og 14 variabler:
#' \describe{
#'   \item{Aar}{År.}
#'   \item{Land}{Landkode.}
#'   \item{HICP}{Harmonisert konsumprisindeks.}
#'   \item{Inflasjon}{Årlig inflasjon.}
#'   \item{Befolkning}{Befolkning.}
#'   \item{Arbeidsledighetsrate}{Arbeidsledighetsrate.}
#'   \item{BNP_faste_priser}{BNP i faste priser.}
#'   \item{BNP_vekst}{Årlig BNP-vekst.}
#'   \item{Sysselsatte}{Sysselsatte personer.}
#'   \item{Arbeidsstyrke}{Personer i arbeidsstyrken.}
#'   \item{Boligprisindeks}{Boligprisindeks.}
#'   \item{Boligprisvekst}{Årlig vekst i boligprisindeksen.}
#'   \item{Eksport}{Eksport av varer og tjenester.}
#'   \item{Import}{Import av varer og tjenester.}
#' }
#'
#' @source NorMacro. Dataene er et statisk utsnitt av data hentet og
#'   bearbeidet av pakkens ordinære internasjonale datainnhentingsfunksjoner.
#'
"normacro_international_example"


#' Metadata for det internasjonale NorMacro-eksempeldatasettet
#'
#' Metadata for variablene i [normacro_international_example], med én rad
#' per økonomisk variabel. Kolonnene `Aar` og `Land` har ikke egne
#' metadata-rader.
#'
#' Metadataene inneholder blant annet visningsnavn, variabeltype, kategori,
#' beskrivelse, kilde, enhet, frekvens og analysetype.
#'
#' @format En tibble med 12 observasjoner og 16 variabler:
#' \describe{
#'   \item{Variabel}{Internt variabelnavn i NorMacro.}
#'   \item{Display_navn}{Visningsnavn for variabelen.}
#'   \item{Type}{Om serien er original eller beregnet.}
#'   \item{Kategori}{Tematisk kategori.}
#'   \item{Beskrivelse}{Kort beskrivelse av variabelen.}
#'   \item{Kilde}{Datakilde.}
#'   \item{Kilde_url}{URL til datakilden når tilgjengelig.}
#'   \item{Tabell}{Kildetabell eller underliggende variabel.}
#'   \item{Enhet}{Måleenhet.}
#'   \item{Frekvens}{Datafrekvens.}
#'   \item{Startaar}{Første år serien er tilgjengelig.}
#'   \item{Sluttaar}{Siste år dersom serien har avsluttet dekning.}
#'   \item{Funksjon}{NorMacro-funksjonen som henter eller beregner serien.}
#'   \item{Kommentar}{Supplerende informasjon om serien.}
#'   \item{Omraade}{Geografisk område.}
#'   \item{Analyse_type}{Variabelens analysetype, for eksempel nivå, rate
#'     eller indeks.}
#' }
#'
#' @source Metadata fra NorMacro.
#'
"normacro_international_example_metadata"


#' KOSTRA-eksempeldatasett fra NorMacro
#'
#' Et lite, statisk KOSTRA-datasett med utvalgte kommunale nøkkeltall
#' for Oslo, Bergen og Trondheim i perioden 2020–2025.
#'
#' Datasettet er laget for bruk i eksempler, vignetter og dokumentasjon,
#' slik at KOSTRA-funksjonene kan demonstreres uten å hente data fra
#' eksterne API-er.
#'
#' Datasettet representerer KOSTRA-tabell 12134, "Utvalgte nøkkeltall
#' for kommuneregnskap".
#'
#' @format En tibble med 18 observasjoner og 7 variabler:
#' \describe{
#'   \item{Enhet}{Kommunens KOSTRA-kode.}
#'   \item{Enhet_navn}{Kommunens navn.}
#'   \item{Enhetstype}{Type geografisk enhet.}
#'   \item{Aar}{År.}
#'   \item{Netto_driftsresultat}{Netto driftsresultat i prosent.}
#'   \item{Langsiktig_gjeld_uten_pensjonsforpliktelser}{
#'     Langsiktig gjeld uten pensjonsforpliktelser i prosent.
#'   }
#'   \item{Frie_inntekter_per_innbygger}{
#'     Frie inntekter per innbygger i kroner.
#'   }
#' }
#'
#' @details
#' Datasettet har attributtene `dataset_type`, `kostra_table` og
#' `kostra_title`. Disse brukes av flere KOSTRA-funksjoner til å
#' identifisere datasettet og hente tilhørende metadata.
#'
#' @source NorMacro. Statisk eksempel basert på KOSTRA-tabell 12134.
#'
"normacro_kostra_example"
