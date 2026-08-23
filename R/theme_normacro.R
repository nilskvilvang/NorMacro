
.normacro_palette <- c(
  blue = "#0072B2",
  vermillion = "#D55E00",
  bluish_green = "#009E73",
  orange = "#E69F00",
  sky_blue = "#56B4E9",
  reddish_purple = "#CC79A7",
  black = "#000000",
  yellow = "#F0E442",
  grey = "#999999"
)

#' NorMacro plot theme
#'
#' Standard ggplot2 theme used by NorMacro plots.
#'
#' The theme is based on [ggplot2::theme_minimal()] with a small number
#' of adjustments for consistent titles, captions, grid lines and legends.
#'
#' @param base_size Base font size.
#' @param base_family Base font family.
#'
#' @return A ggplot2 theme object.
#'
#' @export



theme_normacro <- function(
    base_size = 11,
    base_family = ""
) {
  ggplot2::theme_minimal(
    base_size = base_size,
    base_family = base_family
  ) +
    ggplot2::theme(
      plot.title.position = "plot",
      plot.caption.position = "plot",

      panel.grid.major = ggplot2::element_line(
        colour = "#E5E5E5",
        linewidth = 0.4
      ),
      panel.grid.minor = ggplot2::element_blank(),

      legend.position = "right",

      plot.title = ggplot2::element_text(
        face = "bold",
        size = ggplot2::rel(1.1)
      ),

      plot.subtitle = ggplot2::element_text(
        margin = ggplot2::margin(
          b = 8
        )
      ),

      plot.caption = ggplot2::element_text(
        hjust = 1,
        size = ggplot2::rel(0.85)
      )
    )
}

#' NorMacro discrete colour scale
#'
#' Discrete colour scale used by NorMacro for categorical series.
#'
#' The scale uses a colour-blind-friendly palette inspired by the
#' Okabe-Ito colour universal design palette. Up to eight distinct
#' series are supported.
#'
#' @param n Number of discrete series.
#' @param ... Additional arguments passed to [ggplot2::scale_colour_manual()].
#'
#' @return A ggplot2 discrete colour scale.
#'
#' @export

scale_colour_normacro <- function(
    n = 7,
    ...
) {
  ggplot2::scale_colour_manual(
    values = get_normacro_palette(n),
    ...
  )
}

#' NorMacro diverging fill scale
#'
#' Diverging fill scale for variables with a meaningful midpoint at zero,
#' such as correlations.
#'
#' Negative values are shown in blue, values around zero in a neutral
#' light tone, and positive values in vermillion.
#'
#' @param ... Additional arguments passed to [ggplot2::scale_fill_gradient2()].
#'
#' @return A ggplot2 continuous fill scale.
#'
#' @export

scale_fill_normacro_diverging <- function(...) {
  ggplot2::scale_fill_gradient2(
    low = .normacro_palette[["blue"]],
    mid = "#F2F2F2",
    high = .normacro_palette[["vermillion"]],
    midpoint = 0,
    limits = c(-1, 1),
    ...
  )
}

