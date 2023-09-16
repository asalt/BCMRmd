library(shiny)
library(plotly)


gene_sets <- list(
  geneset1 = c(1, 2, 3),
  geneset2 = c(4, 5, 6)
)

ui <- fluidPage(
  titlePanel("Interactive Volcano Plots"),
  sidebarLayout(
    sidebarPanel(
      #
      selectInput("browse", "Browse Datasets", choices = basename(list.files(path = "data", pattern = "*.tsv", full.names = TRUE))),
      selectizeInput("data", "Select Plots to View", choices = NULL, multiple = TRUE),
      sliderInput("pValue", "P value cutoff", min = 0, max = 1, value = 0.05, step = 0.01),
      sliderInput("log2_FC", "log2 Fold Change cutoff", min = 0, max = 10, value = 2),
      selectizeInput("gene_sets", "Select Pathways", choices = names(gene_sets), multiple = TRUE),
      actionButton("goButton", "Go"),
    ),
    mainPanel(
      dataTableOutput("browseData"),
      plotlyOutput("volcanoPlot")
    )
  )
)
