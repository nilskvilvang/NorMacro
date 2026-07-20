
ssb_get <- function(url, query) {
  pxweb::pxweb_get(url = url, query = query) |>
    as.data.frame(column.name.type = "text",
                  variable.value.type = "text") |>
    janitor::clean_names()
  
}

