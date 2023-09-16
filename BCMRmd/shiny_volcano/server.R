library(shiny)
library(plotly)
library(magrittr)
source("ui.R")


volcanoplot <- function(.df, p_cutoff = 0.05, log2_fc_cutoff = 1, selected_genes) {
  .df <- .df[.df$pValue <= p_cutoff & abs(.df$log2_FC) >= fc_cutoff, ]
  # .df$highlight <- ifelse(.df$GeneID %in% selected_genes, "Yes", "No")

  .p <- ggplot2::ggplot(.df, aes(x = log2_FC, y = -log10(pValue))) +
    ggplot2::geom_point()
  ggplotly(.p)
}


server <- function(input, output, session) {

  # Reactive expression to read in the data
  data <- reactive({
    # List all TSV files in the directory
    files <- list.files(path = "data", pattern = "*.tsv", full.names = TRUE)

    data_list <- lapply(files, function(file) {
      readr::read_tsv(file)
    })
    names(data_list) <- basename(files) # Assign names to the list elements based on the file names
    data_list
  })


  # Update the choices for the checkboxGroupInput
  observe({
    choices <- names(data())
    updateCheckboxGroupInput(session, "data", choices = choices)
  })


  observeEvent(input$goButton, {
    selectedPlots <- input$plots
    p_cutoff <- input$pValue
    fc_cutoff <- input$log2_FC
    # selected_genes <- unlist(geneSets[input$geneSets])

    plot_list <- lapply(selectedPlots, function(plot) {
      df <- data()[[plot]]
      volcanoplot(df, p_cutoff, fc_cutoff, selected_genes)
    })

    output$browseData <- renderDataTable(
      {
        readr::read_tsv(paste0("data/", input$browse))
      },
      options = list(pageLength = 10)
    )


    output$volcanoPlot <- renderPlotly({
      subplot(plot_list, nrows = length(plot_list), shareX = TRUE, shareY = TRUE)
    })
  })


  # # Render the Plotly plot
  # output$volcanoPlot <- renderPlotly({
  #   # Get the selected plots
  #   selectedPlots <- input$plots
  #   if (is.null(selectedPlots)) return(NULL)
  #
  #   # Subset the data and generate the plots
  #   plot_list <- lapply(selectedPlots, function(plot) {
  #     df <- data()[[plot]]
  #     volcanoplot(df)
  #     # Generate the volcanoplot using the df
  #     # df %>%
  #   })

  #   subplot(plot_list, nrows = length(plot_list), shareX = TRUE, shareY = TRUE)
}

# shinyApp(ui = ui, server = server)
