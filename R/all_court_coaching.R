#----- all_court_coaching -----

#---- app function ----
all_court_coaching <- function(){
  
  #---- UI ----
  ui <- page_fluid(
    title = "All Court Coaching",
    
    file_upload_UI("file_upload"),
    court_fees_table_UI("court_fees_table")
  )
  
  
  #---- server ----
  server <- function(input, output, session){
    
    # initialise global reactives
    r <- reactiveValues()
    
    # initialise global groups_list
    groups_list <- reactiveValues()
    
    file_upload_server("file_upload", groups_list = groups_list, r = r)
    court_fees_table_server("court_fees_table", groups_list = groups_list, r = r)
  }
  
  
  #---- app ----
  shinyApp(ui, server)
}

# all_court_coaching()
