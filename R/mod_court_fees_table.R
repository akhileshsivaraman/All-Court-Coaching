#----- mod_court_fees_table.R -----
library(shiny)
library(bslib)
source("R/Group.R")


#---- court_fees_table_UI ----
court_fees_table_UI <- function(id){
  tagList(
    card(
      fill = FALSE,
      
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
court_fees_table_server <- function(id, groups_list, r){
  moduleServer(id, function(input, output, session){
    
    # initialise table as a reactiveVal that can be modified within observers
    group_coaching_table <- reactiveVal(
      tibble(
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
    )
    
    # populate table when the user clicks calculate_groups_fees in mod_upload_file
    # TODO: make this work for a longer groups_list? This can already be used to create the court fee table row by row
    # probably build a function that does the below and can be used with map
    observe({
      # generate new row
      new_row <- tibble(
        "Group name" = groups_list$group_one$group_name,
        "Number of lessons" = groups_list$group_one$lessons_in_term,
        "Number of rained off lessons" = groups_list$group_one$number_rained_off,
        "Session duration (hours)" = groups_list$group_one$session_duration,
        "Number of courts used" = groups_list$group_one$number_of_courts,
        "Court fee subtotal" = groups_list$group_one$court_fee,
        "Number of non-members" = groups_list$group_one$non_member_count,
        "Non-member fee subtotal" = groups_list$group_one$non_member_group_fee,
        "Total fee for group" = groups_list$group_one$total_group_fee
      )
      
      # bind new row
      group_coaching_table(
        bind_rows(group_coaching_table(), new_row)
      )
    }) |>
      bindEvent(r$input_calculate_group_fees, ignoreNULL = TRUE)
    
    # display
    output$group_coaching_table <- DT::renderDT({
      group_coaching_table()
     })
  })
}


#---- court_fees_table_app ----
court_fees_table_app <- function(){
  ui <- page_fluid(
    actionButton("button",
                 label = "Calculate group fees"
    ),
    court_fees_table_UI("court_fees_table")
  )
  
  server <- function(input, output, session){
    
    # create dummy data
    groups_list <- reactiveValues()
    new_group <- Group$new(
      register = register,
      session_duration = 1.5,
      number_of_courts = 2,
      number_rained_off = 1,
      input_file_name = "LTA-Youth-Yellow-Squad-Level-1.csv"
    )
    groups_list <- append(groups_list, new_group)
    
    r <- reactiveValues()
    r$input_calculate_group_fees <- input$button
    
    court_fees_table_server("court_fees_table", groups_list = groups_list, r = r)
  }
  
  shinyApp(ui, server)
}
# court_fees_table_app()
