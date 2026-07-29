
if (.Platform$OS.type == "windows") {
  try(Sys.setlocale("LC_CTYPE", ".UTF-8"), silent = TRUE)
}


retry_download <- function(expr,
                           retries = 5,
                           wait = 5,
                           label = "Nedlasting") {
  for (i in seq_len(retries)) {
    result <- tryCatch(
      force(expr),
      error = function(e)
        e
    )
    
    if (!inherits(result, "error")) {
      return(result)
    }
    
    if (i < retries) {
      msg <- sprintf("%s feilet. Prøver igjen om %s sekunder (forsøk %s av %s).",
                     label,
                     wait,
                     i + 1,
                     retries)
      message(msg)
      Sys.sleep(wait)
    } else {
      stop(conditionMessage(result), call. = FALSE)
    }
  }
}




