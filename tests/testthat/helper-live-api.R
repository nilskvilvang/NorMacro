
skip_if_not_live_api <- function() {
  
  if (
    Sys.getenv(
      "NORMACRO_RUN_LIVE_TESTS",
      unset = "false"
    ) != "true"
  ) {
    testthat::skip(
      paste0(
        "Live API-test kjøres bare når ",
        "NORMACRO_RUN_LIVE_TESTS=true."
      )
    )
  }
  
  invisible(NULL)
}