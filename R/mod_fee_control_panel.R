#----- mod_fee_control_panel.R -----
library(jsonlite)

#---- fee_control_panel_UI ----
fee_control_panel_UI <- function(id){
  tagList(
    card(
      fill = FALSE,
      
      fluidRow(
        h3("Lesson prices and court fees")
      ),
      
      fluidRow(
        column(
          12,
          h5("60-minute lesson hourly prices")
        ),
        fluidRow(
          column(
            6,
            uiOutput(
              NS(id, "sixty_minute_member_fee_UI")
            )
          ),
          column(
            6,
            uiOutput(
              NS(id, "sixty_minute_non_member_fee_UI")
            )
          )
        )
      ),
      
      fluidRow(
        column(
          12,
          h5("90-minute lesson hourly prices")
        ),
        fluidRow(
          column(
            6,
            uiOutput(
              NS(id, "ninety_minute_member_fee_UI")
            )
          ),
          column(
            6,
            uiOutput(
              NS(id, "ninety_minute_non_member_fee_UI")
            )
          )
        )
      ),
      
      fluidRow(
        column(
          12,
          h5("Fees"),
          fluidRow(
            column(
              4,
              uiOutput(
                NS(id, "group_coaching_court_fee_UI")
              )
            ),
            column(
              4,
              uiOutput(
                NS(id, "individual_coaching_court_fee_UI")
              )
            ),
            column(
              4,
              uiOutput(
                NS(id, "non_member_fee_UI")
              )
            )
          )
        )
      ),
      
      fluidRow(
        column(
          12,
          actionButton(
            NS(id, "update_fees"),
            label = "Save changes to fees"
          )
        )
      )
    )
  )
}

#---- fee_control_panel_server ----
fee_control_panel_server <- function(id){
  moduleServer(id, function(input, output, session){
    pricing <- read_json("data/pricing.json", simplifyVector = TRUE)
    fees <- read_json("data/fees.json", simplifyVector = TRUE)
    
    output$sixty_minute_member_fee_UI <- renderUI({
      numericInput(
        inputId = session$ns("sixty_minute_member_fee_input"),
        label = "Member Fee",
        value = pricing[["sixty_minute"]][["members"]]
      )
    })
    
    output$sixty_minute_non_member_fee_UI <- renderUI({
      numericInput(
        inputId = session$ns("sixty_minute_non_member_fee_input"),
        label = "Member Fee",
        value = pricing[["sixty_minute"]][["non_members"]]
      )
    })
    
    output$ninety_minute_member_fee_UI <- renderUI({
      numericInput(
        inputId = session$ns("ninety_minute_member_fee_input"),
        label = "Member Fee",
        value = pricing[["ninety_minute"]][["members"]]
      )
    })
    
    output$ninety_minute_non_member_fee_UI <- renderUI({
      numericInput(
        inputId = session$ns("ninety_minute_non_member_fee_input"),
        label = "Member Fee",
        value = pricing[["ninety_minute"]][["non_members"]]
      )
    })
    
    output$group_coaching_court_fee_UI <- renderUI({
      numericInput(
        inputId = session$ns("group_coaching_court_fee_input"),
        label = "Court fee per hour for group coaching",
        value = fees[["group_coaching_hourly_court_fee"]]
      )
    })
    
    output$individual_coaching_court_fee_UI <- renderUI({
      numericInput(
        inputId = session$ns("individual_coaching_court_fee_input"),
        label = "Court fee per hour for 1-to-1 coaching",
        value = fees[["individual_coaching_hourly_court_fee"]]
      )
    })
    
    output$non_member_fee_UI <- renderUI({
      numericInput(
        inputId = session$ns("non_member_fee_input"),
        label = "Fee per non-member per lesson",
        value = fees[["non_member_fee_per_lesson"]]
      )
    })
    
    observe({
      updated_prices <- list(
        sixty_minute = list(
          members = input$sixty_minute_member_fee_input,
          non_members = input$sixty_minute_non_member_fee_input
        ),
        ninety_minute = list(
          members = input$ninety_minute_member_fee_input,
          non_members = input$ninety_minute_non_member_fee_input
        )
      )
      
      write_json(
        updated_prices,
        path = "data/pricing.json",
        pretty = TRUE,
        auto_unbox = TRUE
      )
      
      updated_fees <- list(
        group_coaching_hourly_court_fee = input$group_coaching_court_fee_input,
        individual_coaching_hourly_court_fee = input$individual_coaching_court_fee_input,
        non_member_fee_per_lesson = input$non_member_fee_input
      )
      
      write_json(
        updated_fees,
        path = "data/fees.json",
        pretty = TRUE,
        auto_unbox = TRUE
      )
    }) |>
      bindEvent(input$update_fees)
  })
}


#---- fee_control_panel_app ----
fee_control_panel_app <- function(){
  ui <- page_fluid(
    fee_control_panel_UI("fee_control_panel")
  )
  
  server <- function(input, output, session){
    fee_control_panel_server("fee_control_panel")
  }
  
  shinyApp(ui, server)
}

# fee_control_panel_app()
