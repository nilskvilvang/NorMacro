
#' @export
#' 
print.summary_normacro_report <- function(
    x,
    ...
) {
  cat(
    paste(
      x$text,
      collapse = "\n\n"
    ),
    "\n"
  )
  
  invisible(
    x
  )
}
