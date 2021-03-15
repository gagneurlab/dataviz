# General parameters and functions for the lecture
#

#
# PACKAGES
#
library(data.table)
library(magrittr)  # pipe operator %>%
# library(XLConnect)
library(RColorBrewer)
library(plotly)
# library(slidify)
library(htmlwidgets)
library(knitr)
library(ggplot2)
library(dplyr)   # left_join, right_join, etc.
library(rmarkdown)


# params
dir_plotly_libs <- 'assets/fig/plotly_libdir/'

#
# FUNCTIONS
#
save_plotly_as_widget <- function(
    plotly_plot, file, libdir=file.path(getwd(), dir_plotly_libs), ...
){
    htmlwidgets::saveWidget(
        widget=plotly_plot, 
        file=file, 
        selfcontained = F,
        libdir = libdir,
        ...
    )
}

print_plotly_iframe <- function(html_file,  width=800, height=600){
  plotly_iframe <- paste0(
    "<center><iframe scrolling='no' seamless='seamless' style='border:none'",
    " src='", html_file, "' width='",width,"' height='",height,
      "'></iframe></center>"
  )
  plotly_iframe
}


format_plotly_for_slidify <- function(
  plotly_plot, filename, width=800, height=600
  ){
  save_plotly_as_widget(plotly_plot, filename)

  plotly_iframe <- paste0(
    "<center><iframe scrolling='no' seamless='seamless' style='border:none'",
    " src='", filename, "' width='",width,"' height='",height,"'></iframe><center>"
    )
  plotly_iframe
}


insert_file <- function(filename, before="", after="") {
  content = paste(readLines(filename), collapse="\n")
  str = paste(before, content, after, sep="")
  return(str)
}

get_pokemon_url <- function(id){
    paste0(
        "https://assets.pokemon.com/assets/cms2/img/pokedex/full/",
        sprintf("%03i", id),
        ".png"
        )
}


