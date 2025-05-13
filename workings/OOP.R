library(R6)
library(tidyverse)
library(stringr)
library(jsonlite)

# a Group object
# one of the properties is price per lesson which can be a named list of two [member_price, non_member_price] and those values are determined by the supplied session_duration
# other properties: the register (supplied), input file name (supplied), group_name (computed), non-member count (calculated), non-member group fee (calculated), number of rained off lessons (supplied), lessons in term (calculated), session duration (supplied), number of courts used (supplied)

# TODO: a print method to display various properties

Group <- R6Class(
  classname = "Group",
  
  public = list(
    # fields
    register = NULL, # supplied
    session_duration = NULL, # supplied
    number_of_courts = NULL, # supplied
    number_rained_off = NULL, # supplied
    group_name = NULL, # computed
    price_per_lesson = NULL, # computed
    lessons_in_term = NULL, # computed
    non_member_count = NULL, # computed - TODO
    non_member_group_fee = NULL, # computed - TODO
    
    
    initialize = function(register, session_duration, number_of_courts, number_rained_off, input_file_name){
      self$register <- register
      self$session_duration <- session_duration
      self$number_of_courts <- number_of_courts
      self$number_rained_off <- number_rained_off
      
      private$input_file_name <- input_file_name
      private$set_group_name()
      private$set_lessons_in_term()
      private$set_price_per_lesson()
    }
  ),
  
  private = list(
    input_file_name = NULL,
    
    # methods for calculating properties/fields
    set_group_name = function(){
      x <- private$input_file_name |>
        str_remove(".csv") |>
        str_replace_all("-", " ")
      self$group_name <- x
    },
    
    set_lessons_in_term = function(){
      date_columns <- colnames(self$register) |>
        str_detect(regex("\\d{1,2}/\\d{1,2}/\\d{2,4}"))
      lessons_in_term <- sum(date_columns, na.rm = TRUE)
      self$lessons_in_term <- lessons_in_term
    },
    
    set_price_per_lesson = function(){
      pricing <- read_json("data/pricing.json", simplifyVector = TRUE)
      if(self$session_duration == 1){
        session_duration_minutes <- "sixty_minute"
      } else if(self$session_duration == 1.5){
        session_duration_minutes <- "ninety_minute"
      } else{
        print("there is an error") # TODO: decide what the app needs to do
      }
      self$price_per_lesson <- pricing[[session_duration_minutes]]
    },
    
    set_non_member_count = function(){
      NULL
    }
    
    set_non_member_group_fee = function(){
      NULL
    }
  ),
  
  active = list(
    
  )
)
