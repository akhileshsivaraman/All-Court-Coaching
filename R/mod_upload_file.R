#----- mod_file_upload.R -----

#---- file_upload_UI ----
file_upload_UI <- function(id){
  tagList(
    card(
      fill = FALSE,
      
      fluidRow(
        h3("Upload Group"),
        column(
          12,
          fileInput(
            NS(id, "register_upload"),
            label = "Upload a register",
            multiple = FALSE,
            accept = ".csv",
            buttonLabel = "Upload"
          )
        )
      ),
      
      fluidRow(
        column(
          4,
          numericInput(
            NS(id, "number_rained_off"),
            label = "How many sessions were rained off for the group?",
            value = 0,
            step = 1
          )
        ),
        column(
          4,
          numericInput(
            NS(id, "session_duration"),
            label = "How long is each session?",
            value = 1,
            step = 0.1
          )
        ),
        column(
          4,
          numericInput(
            NS(id, "number_of_courts"),
            label = "How many courts are used for the group?",
            value = 1,
            min = 1,
            step = 1
          )
        )
      ),
      
      fluidRow(
        column(
          12,
          actionButton(
            NS(id, "calculate_group_fees"),
            label = "Calculate group's fees"
          )
        )
      )
    )
  )
}


#---- file_upload_server ----
file_upload_server <- function(id, groups_list, r){
  moduleServer(id, function(input, output, session){
    
    observe({
      req(input$register_upload)
      
      # read file
      ext <- tools::file_ext(input$register_upload$name)
      register <- switch(
        ext,
        csv = read_csv(input$register_upload$datapath),
        validate("Invalid file type. Please upload a csv file.") # TODO: something more helpful and use glue to indicate the type of file that was used
      )
      
      # create new Group object
      new_group <- Group$new(
        register = register,
        session_duration = input$session_duration,
        number_of_courts = input$number_of_courts,
        number_rained_off = input$number_rained_off,
        input_file_name = input$register_upload$name
      )
      
      # TODO: use assign to give the Group object a relevant name? but what is the use case of needing multiple groups in a list
      
      # put the object in a global list
      groups_list$group_one <- new_group
    }) |>
      bindEvent(input$calculate_group_fees)
    
    
    # export input$calculate_group_fees
    observe({
      r$input_calculate_group_fees <- input$calculate_group_fees
    })
  })
}


#---- file_upload_app ----
file_upload_app <- function(){
  ui <- page_fluid(
    file_upload_UI("file_upload")
  )
  
  server <- function(input, output, session){
    r <- reactiveValues()
    groups_list <- reactiveValues()
    file_upload_server("file_upload", groups_list = groups_list, r = r)
  }
  
  shinyApp(ui, server)
}
# file_upload_app()
