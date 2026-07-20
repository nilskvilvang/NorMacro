
#' Augment a comparison-series regression
#'
#' @param x A `comparison_series_regression` object.
#' @param ... Additional arguments. Currently unused.
#'
#' @return A tibble containing model data, fitted values and residuals.
#'
#' @importFrom broom augment
#' @export
augment.comparison_series_regression <- function(
    x,
    ...
) {
  
  dots <- list(...)
  
  if (length(dots) > 0L) {
    warning(
      "Ekstra argumenter i `...` brukes ikke.",
      call. = FALSE
    )
  }
  
  regression_plot_data(
    x
  ) |>
    tibble::as_tibble()
  
}