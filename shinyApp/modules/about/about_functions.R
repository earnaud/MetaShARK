# about_functions.R

renderBibliography <- function(bib){
  NoCite(bib, "*")
  renderUI(
    withProgress(message = "Loading bibtex ...", value = 0, {
      HTML(
        paste(
          capture.output(
            invisible(
              sapply(bib,
                     function(b){
                       incProgress(1/length(bib))
                       PrintBibliography(b,
                                         .opts = list(style = "html")
                                         )
                     }
                     )
              )
            ),
          collapse = "")
        )
      })
    )
}