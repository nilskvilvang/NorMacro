
get_metadata <- function(){
  
  tibble::tribble(
    ~Variabel, ~Beskrivelse, ~Kilde, ~Kilde_url, ~Tabell, ~Enhet, ~Frekvens, ~Startaar, ~Sluttaar, ~Funksjon, ~Kommentar,
    
    "KPI", "Konsumprisindeks", "SSB",
    "https://data.ssb.no/api/v0/no/table/pp/pp04/kpi/SBMENU12006/Kpi11",
    "14711", "2025=100", "Årlig", 1865, NA, "get_kpi",
    "Historisk KPI-serie",
    
    "Inflasjon", "Årsvekst i KPI", "Beregnet",
    NA, "KPI", "Prosent", "Årlig", 1866, NA, "get_kpi",
    "Beregnet som (KPI / lag(KPI) - 1) * 100",
    
    "Befolkning", "Befolkning 1. januar", "SSB",
    "https://data.ssb.no/api/v0/no/table/be/be05/folkemengde/SBMENU5580/FolkHistorie",
    "05803", "Personer", "Årlig", 1735, NA, "get_befolkning",
    "Historisk befolkningsserie",
    
    "Arbeidsstyrke", "Personer i arbeidsstyrken, 15-74 år", "SSB AKU",
    "https://data.ssb.no/api/v0/no/table/al/al03/aku/SBMENU9728/ArbStyrkAar",
    "03780", "Personer", "Årlig", 1972, NA, "get_arbeidsstyrke",
    "Summert menn og kvinner, multiplisert med 1000",
    
    "Arbledige_NAV", "Registrerte helt arbeidsledige", "NAV",
    "https://www.nav.no/_/attachment/download/a5aa83cd-c083-4b88-9359-1c1b3b2f936e:285ebf18c576ff0fd1537a83289401df2498cae4/Tabell%203_Helt%20ledige%20fordelt%20pa%20kjonn.Aarsgjennomsnitt.1948_2025.xls",
    "Tabell 3", "Personer", "Årlig", 1948, 2025, "get_ledighet",
    "Årsgjennomsnitt. Brudd i statistikken dokumentert av NAV",
    
    "Styringsrente", "Norges Banks styringsrente", "Norges Bank",
    "https://data.norges-bank.no/api/data/IR/M.KPRA..?format=csv&lastNObservations=1200&locale=no&bom=include",
    "IR/M.KPRA", "Prosent", "Månedlig til årsgjennomsnitt", 1982, NA, "get_rente",
    "Årsgjennomsnitt beregnet fra månedstall",
    
    "BNP_lopende", "Bruttonasjonalprodukt, løpende priser", "SSB",
    "https://data.ssb.no/api/v0/no/table/nk/nk03/knr/SBMENU5140/NRbnp",
    "NRbnp", "Millioner kroner", "Årlig", 1970, NA, "get_bnp",
    "Nominell BNP-serie",
    
    "BNP_Fastland", "BNP Fastlands-Norge, faste priser", "SSB",
    "https://data.ssb.no/api/v0/no/table/nk/nk03/knr/SBMENU5140/NRMakroHov",
    "NRMakroHov", "Millioner kroner, faste priser", "Årlig", 1970, NA, "get_bnp_fastland",
    "Makrost = bnpb.nr23_9fn, ContentsCode = Faste",
    
    "BNP_Fastland_vekst", "Årsvekst i BNP Fastlands-Norge", "Beregnet",
    NA, "BNP_Fastland", "Prosent", "Årlig", 1971, NA, "get_bnp_fastland",
    "Beregnet som (BNP_Fastland / lag(BNP_Fastland) - 1) * 100",
    
    "Lonn", "Årslønn, påløpt", "SSB",
    "https://data.ssb.no/api/v0/no/table/al/al05/lonnansatt/SBMENU7201/NRArslonnSnitt",
    "09786", "1000 kroner", "Årlig", 1970, NA, "get_lonn",
    "Gjennomsnitt for alle lønnstakere",
    
    "Lonnvekst", "Årslønn, påløpt. Endring fra året før", "SSB",
    "https://data.ssb.no/api/v0/no/table/al/al05/lonnansatt/SBMENU7201/NRArslonnSnitt",
    "09786", "Prosent", "Årlig", 1971, NA, "get_lonn",
    "Direkte fra SSB-tabell"
  )
}