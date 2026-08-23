
#' Render a NorMacro macro report
#'
#' Renders a `normacro_report` object to a document.
#'
#' @param report A `normacro_report` object created by [macro_report()].
#' @param format Output format. Supported values are `"html"`, `"docx"` and `"pdf"`.
#' @param output_file Optional output filename.
#' @param output_dir Optional output directory.
#'
#' PDF output requires a working LaTeX installation.
#' TinyTeX is supported and can be installed with
#' `tinytex::install_tinytex()`.
#'
#' @return Invisibly returns the path to the rendered file.
#'
#' @export


render_macro_report <- function(report,
                                format = c("html", "docx", "pdf"),
                                output_file = NULL,
                                output_dir = ".") {
  format <- match.arg(format)
  
  template <- system.file("rmarkdown", "macro_report.Rmd", package = "NorMacro")
  
  css_file <- system.file("rmarkdown", "styles.css", package = "NorMacro")
  
  
  if (!inherits(report, "normacro_report")) {
    stop("`report` m\u00e5 v\u00e6re et `normacro_report`-objekt.",
         call. = FALSE)
  }
  
  if (!requireNamespace("rmarkdown", quietly = TRUE)) {
    stop(
      "Pakken `rmarkdown` m\u00e5 v\u00e6re installert for \u00e5 rendre rapporter.",
      call. = FALSE
    )
  }
  
  if (!requireNamespace("knitr", quietly = TRUE)) {
    stop("Pakken `knitr` m\u00e5 v\u00e6re installert for \u00e5 rendre rapporter.",
         call. = FALSE)
  }
  
  dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
  
  extension <- switch(format,
                      html = "html",
                      docx = "docx",
                      pdf = "pdf")
  
  if (is.null(output_file)) {
    output_file <- paste0("normacro-report-", report$year, ".", extension)
  }
  
  template <- system.file("rmarkdown", "macro_report.Rmd", package = "NorMacro")
  
  if (template == "") {
    stop("Fant ikke intern rapportmal.", call. = FALSE)
  }
  
  output_format <- switch(
    format,
    
    html = rmarkdown::html_document(toc = FALSE, css = css_file),
    
    docx = "word_document",
    
    pdf = "pdf_document"
  )
  
  if (format == "pdf" &&
      Sys.which("pdflatex") == "") {
    if (requireNamespace("tinytex", quietly = TRUE) &&
        tinytex::is_tinytex()) {
      pdflatex_path <- list.files(
        tinytex::tinytex_root(),
        pattern = "^pdflatex$",
        recursive = TRUE,
        full.names = TRUE
      )
      
      if (length(pdflatex_path) > 0L) {
        tinytex_bin <- dirname(pdflatex_path[[1]])
        
        Sys.setenv(PATH = paste(tinytex_bin, Sys.getenv("PATH"), sep = .Platform$path.sep))
      }
    }
    
    if (Sys.which("pdflatex") == "") {
      stop(
        paste0(
          "PDF-rendering krever en LaTeX-installasjon. ",
          "Installer for eksempel TinyTeX med ",
          "`tinytex::install_tinytex()`, eller bruk ",
          "`format = \"html\"` eller `format = \"docx\"`."
        ),
        call. = FALSE
      )
    }
  }
  
  rendered <- rmarkdown::render(
    input = template,
    output_format = output_format,
    output_file = output_file,
    output_dir = output_dir,
    params = list(report = report),
    envir = new.env(parent = globalenv()),
    quiet = TRUE
  )
  invisible(rendered)
}
