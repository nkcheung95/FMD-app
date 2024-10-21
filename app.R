library(shiny)

# Function to create a new Shiny app from a script source
create_shiny_app_from_script <- function(script_url) {
  # Source the script to load the app definition
  source(script_url, local = TRUE)
  # Create and return the app
  shinyApp(ui = ui, server = server)
}

ui <- fluidPage(
  titlePanel("Context Selection"),
  sidebarLayout(
    sidebarPanel(
      h3("Select Context"),
      actionButton("brachial_tools", "Brachial Tools"),
      actionButton("vessel", "Vessel")
    ),
    mainPanel(
      h4("Launch Analysis"),
      textOutput("selected_context")
    )
  )
)

server <- function(input, output, session) {
  
  observeEvent(input$brachial_tools, {
    output$selected_context <- renderText({ "Launching Brachial Tools..." })
    # Create the Brachial Tools app from the script URL
    tryCatch({
      app <- create_shiny_app_from_script("https://github.com/nkcheung95/FMD-brachialtools-analyzer/blob/main/FMDBTOOLSAnalysis-loader.R?raw=TRUE")
      runApp(app, launch.browser = TRUE)  # Launch the app
    }, error = function(e) {
      output$selected_context <- renderText({ paste("Error launching Brachial Tools:", e$message) })
    })
  })
  
  observeEvent(input$vessel, {
    output$selected_context <- renderText({ "Launching Vessel..." })
    # Create the Vessel app from the script URL
    tryCatch({
      app <- create_shiny_app_from_script("https://github.com/nkcheung95/FMD-Vessel-Analyzer/blob/main/FMDVesselAnalysis-loader.R?raw=TRUE")
      runApp(app, launch.browser = TRUE)  # Launch the app
    }, error = function(e) {
      output$selected_context <- renderText({ paste("Error launching Vessel:", e$message) })
    })
  })
}

shinyApp(ui, server)