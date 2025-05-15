#----- mod_court_fees_table.R -----
library(shiny)
library(bslib)
source("R/Group.R")

# take the Group object and populate a table
# have a table to display the court fees for each group

#---- court_fees_table_UI ----
court_fees_table_UI <- function(id){
  tagList(
    card(
      fill = FALSE,
      
      fluidRow(
        column(
          12,
          actionButton(
            NS(id, "generate_table"),
            label = "Generate court fee table"
          )
        )
      ),
      
      fluidRow(
        column(
          12,
          DT::dataTableOutput(
            NS(id, "group_coaching_table")
          )
        )
      )
    )
  )
}


#---- court_fees_table_server ----
court_fees_table_server <- function(id, groups_list){
  moduleServer(id, function(input, output, session){
    
    # initialise table
    group_coaching_table <- tibble(
      "Group name" = character(),
      "Number of lessons" = numeric(),
      "Number of rained off lessons" = numeric(),
      "Session duration (hours)" = numeric(),
      "Number of courts used" = numeric(),
      "Court fee subtotal" = numeric(),
      "Number of non-members" = numeric(),
      "Non-member fee subtotal" = numeric(),
      "Total fee for group" = numeric()
    )
    
    
    # populate and display table
    output$group_coaching_table <- DT::renderDT({
      
      # TODO: make this work for a longer list
      # this is just a PoC where groups_list has one item!
      # probably build a function that does the below and can be used with map
      
      # generate new row
      new_row <- tibble(
        "Group name" = groups_list[[1]]$group_name,
        "Number of lessons" = groups_list[[1]]$lessons_in_term,
        "Number of rained off lessons" = groups_list[[1]]$number_rained_off,
        "Session duration (hours)" = groups_list[[1]]$session_duration,
        "Number of courts used" = groups_list[[1]]$number_of_courts,
        "Court fee subtotal" = groups_list[[1]]$court_fee,
        "Number of non-members" = groups_list[[1]]$non_member_count,
        "Non-member fee subtotal" = groups_list[[1]]$non_member_group_fee,
        "Total fee for group" = groups_list[[1]]$total_group_fee
      )
      
      # bind new row
      group_coaching_table <- bind_rows(group_coaching_table, new_row)
      
      # render table
      return(group_coaching_table)
     }) |>
      bindEvent(input$generate_table)
  })
}


#---- court_fees_table_app ----
court_fees_table_app <- function(){
  ui <- page_fluid(
    court_fees_table_UI("court_fees_table")
  )
  
  server <- function(input, output, session){
    # create dummy data
    groups_list <- list()
    new_group <- Group$new(
      register = register,
      session_duration = 1.5,
      number_of_courts = 2,
      number_rained_off = 1,
      input_file_name = "LTA-Youth-Yellow-Squad-Level-1.csv"
    )
    groups_list <- append(groups_list, new_group)
    
    court_fees_table_server("court_fees_table", groups_list = groups_list)
  }
  
  shinyApp(ui, server)
}
# court_fees_table_app()
