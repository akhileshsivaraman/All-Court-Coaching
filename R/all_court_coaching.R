#----- all_court_coaching -----
library(shiny)
library(bslib)
library(R6)
library(tidyverse)
library(stringr)
library(jsonlite)
source("R/Group.R")
source("R/mod_court_fees_table.R")
source("R/mod_upload_file.R")


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
    
    # initialise global groups_list
    groups_list <- reactiveValues()
    
    file_upload_server("file_upload", groups_list = groups_list)
    court_fees_table_server("court_fees_table", groups_list = groups_list)
  }
  
  
  #---- app ----
  shinyApp(ui, server)
}

all_court_coaching()
