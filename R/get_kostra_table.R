
get_kostra_table <- function(
    url,
    query
) {
  query <- lapply(
    query,
    as.character
  )
  
  px_data <- pxweb::pxweb_get(
    url = url,
    query = query
  )
  
  suppressWarnings(
    as.data.frame(
      px_data,
      column.name.type = "code",
      variable.value.type = "code"
    )
  )
}
