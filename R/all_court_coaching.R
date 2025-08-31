#----- all_court_coaching -----
library(shiny)
library(bslib)
library(openxlsx2)

#---- app function ----
b64 <- base64enc::dataURI(file = "www/JMACC_Black_Logo.png", mime = "image/png")

all_court_coaching <- function(){
  
  #---- UI ----
  ui <- page_navbar(
    title = div(
      img(
        src = b64,
        alt = "All Court Coaching Logo",
        style = "max-width: 15%; height: auto;"
      )
    ),
    
    nav_panel(
      title = "Court Fees",
      value = "Court Fees",
      file_upload_UI("file_upload"),
      court_fees_table_UI("court_fees_table"),
      create_invoice_UI("create_invoice")
    )
  )
  
  
  #---- server ----
  server <- function(input, output, session){
    
    #--- initialise global reactive values ---
    # initialise global petit r
    r <- reactiveValues()
    
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
    
    # initialise global groups_list
    groups_list <- reactiveValues()
    
    
    #--- call servers ---
    title_panel_UI("title_panel")
    file_upload_server("file_upload", groups_list = groups_list, r = r)
    court_fees_table_server("court_fees_table", groups_list = groups_list, r = r, group_coaching_table = group_coaching_table)
    create_invoice_server("create_invoice", group_coaching_table = group_coaching_table)
  }
  
  
  #---- app ----
  shinyApp(ui, server)
}

# all_court_coaching()
