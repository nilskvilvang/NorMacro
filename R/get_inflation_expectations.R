
get_inflation_expectations <- function(refresh = FALSE) {
  cache_get(
    name = "inflation_expectations",
    refresh = refresh,
    fun = function() {
      page_url <- paste0(
        "https://www.norges-bank.no/tema/pengepolitikk/",
        "forventningsundersokinga/"
      )

      xlsx_href <- rvest::read_html(page_url) |>
        rvest::html_elements("a") |>
        rvest::html_attr("href") |>
        (\(x) x[
          grepl(
            "forventningsundersoekelse.*\\.xlsx($|\\?)",
            x,
            ignore.case = TRUE
          )
        ])() |>
        unique()

      if (length(xlsx_href) != 1L) {
        stop(
          "Fant ikke \u00e9n entydig XLSX-fil for forventningsunders\u00f8kelsen.",
          call. = FALSE
        )
      }

      xlsx_url <- paste0(
        "https://www.norges-bank.no",
        xlsx_href
      )

      tmp <- tempfile(
        fileext = ".xlsx"
      )
      on.exit(
        unlink(tmp),
        add = TRUE
      )

      utils::download.file(
        xlsx_url,
        tmp,
        mode = "wb",
        quiet = TRUE
      )

      prisvekst <- readxl::read_excel(
        tmp,
        sheet = "PRISVEKST",
        col_names = FALSE
      )

      normalize_match <- function(x) {
        x |>
          as.character() |>
          trimws() |>
          stringi::stri_trans_general(
            "Latin-ASCII"
          )
      }

      fill_right <- function(x) {
        x <- as.character(x)

        for (i in seq_along(x)) {
          if (
            i > 1L &&
            (
              is.na(x[i]) ||
              x[i] == ""
            )
          ) {
            x[i] <- x[i - 1L]
          }
        }

        x
      }

      row1 <- normalize_match(
        unlist(
          prisvekst[1, ],
          use.names = FALSE
        )
      )

      row2 <- normalize_match(
        unlist(
          prisvekst[2, ],
          use.names = FALSE
        )
      )

      row4 <- normalize_match(
        unlist(
          prisvekst[4, ],
          use.names = FALSE
        )
      )

      row5 <- normalize_match(
        unlist(
          prisvekst[5, ],
          use.names = FALSE
        )
      )

      row1 <- fill_right(row1)
      row2 <- fill_right(row2)

      candidate_cols <- which(
        row1 == "PRISVEKST OM 5 AR" &
          row2 == "OKONOMER" &
          row4 == "Okonomer" &
          row5 == "Gjennomsnitt"
      )

      if (length(candidate_cols) != 1L) {
        stop(
          "Fant ikke \u00e9n entydig serie for ",
          "\u00f8konomenes fem\u00e5rsforventninger.",
          call. = FALSE
        )
      }

      expectation_col <- candidate_cols[[1]]

      quarterly <- tibble::tibble(
        Periode = as.character(
          prisvekst[[1]]
        ),
        Inflasjonsforventninger_5aar =
          suppressWarnings(
            as.numeric(
              prisvekst[[expectation_col]]
            )
          )
      ) |>
        dplyr::filter(
          grepl(
            "^\\d\\. kv\\. \\d{4}$",
            .data$Periode
          ),
          !is.na(
            .data$Inflasjonsforventninger_5aar
          )
        )

      quarterly |>
        dplyr::mutate(
          Aar = as.integer(
            stringr::str_extract(
              .data$Periode,
              "\\d{4}$"
            )
          )
        ) |>
        dplyr::group_by(
          .data$Aar
        ) |>
        dplyr::summarise(
          Inflasjonsforventninger_5aar =
            mean(
              .data$Inflasjonsforventninger_5aar
            ),
          N_kvartaler = dplyr::n(),
          .groups = "drop"
        ) |>
        dplyr::filter(
          .data$N_kvartaler == 4L
        ) |>
        dplyr::select(
          "Aar",
          "Inflasjonsforventninger_5aar"
        ) |>
        dplyr::arrange(
          .data$Aar
        )
    }
  )
}
