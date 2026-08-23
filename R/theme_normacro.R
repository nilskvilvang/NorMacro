
# R/theme_normacro.R

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

get_normacro_palette <- function(n) {
  base <- unname(
    .normacro_palette[
      c(
        "blue",
        "vermillion",
        "bluish_green",
        "orange",
        "sky_blue",
        "reddish_purple",
        "black"
      )
    ]
  )

  extended <- c(
    base,
    .normacro_palette[["grey"]]
  )

  if (n <= length(base)) {
    return(
      base[seq_len(n)]
    )
  }

  if (n <= length(extended)) {
    return(
      extended[seq_len(n)]
    )
  }

  stop(
    paste0(
      "NorMacro-paletten st\u00f8tter opptil ",
      length(extended),
      " tydelig adskilte serier."
    ),
    call. = FALSE
  )
}

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

scale_colour_normacro <- function(
    n = 7,
    ...
) {
  ggplot2::scale_colour_manual(
    values = get_normacro_palette(n),
    ...
  )
}

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

