
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
    return(base[seq_len(n)])
  }

  if (n <= length(extended)) {
    return(extended[seq_len(n)])
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

