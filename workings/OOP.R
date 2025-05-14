library(R6)
library(tidyverse)
library(stringr)
library(jsonlite)

# a Group object
# one of the properties is price per lesson which can be a named list of two [member_price, non_member_price] and those values are determined by the supplied session_duration
# other properties: the register (supplied), input file name (supplied), group_name (computed), non-member count (calculated), non-member group fee (calculated), number of rained off lessons (supplied), lessons in term (calculated), session duration (supplied), number of courts used (supplied)

Group <- R6Class(
  classname = "Group",
  
  public = list(
    # fields
    session_duration = NULL, # supplied
    number_of_courts = NULL, # supplied
    number_rained_off = NULL, # supplied
    group_name = NULL, # computed
    price_per_lesson = NULL, # computed
    lessons_in_term = NULL, # computed
    non_member_count = NULL, # computed
    non_member_group_fee = NULL, # computed
    court_fee = NULL, # computed
    total_group_fee = NULL, # computed
    
    
    # methods
    initialize = function(register, session_duration, number_of_courts, number_rained_off, input_file_name){
      self$session_duration <- session_duration
      self$number_of_courts <- number_of_courts
      self$number_rained_off <- number_rained_off
      
      private$register <- register
      private$input_file_name <- input_file_name
      private$fees <- read_json("data/fees.json", simplifyVector = TRUE)
      
      private$set_group_name()
      private$set_lessons_in_term()
      private$set_price_per_lesson()
      private$set_non_member_count()
      private$set_non_member_group_fee()
      private$set_court_fee()
      private$set_total_group_fee()
    }
  ),
  
  private = list(
    # fields
    register = NULL, # supplied
    input_file_name = NULL, # supplied
    fees = NULL, # read in
    
    
    # methods for calculating properties/fields
    set_group_name = function(){
      x <- private$input_file_name |>
        str_remove(".csv") |>
        str_replace_all("-", " ")
      self$group_name <- x
    },
    
    set_lessons_in_term = function(){
      date_columns <- colnames(private$register) |>
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
      # add member/non-member flag
      flagged_register <- private$register |>
        mutate(`Cost per lesson` = Amount/self$lessons_in_term) |>
        mutate(Membership = case_when(
          `Cost per lesson` == self$price_per_lesson[["members"]] ~ "member",
          `Cost per lesson` == self$price_per_lesson[["non_members"]] ~ "non-member"
        ))
      # count non-members
      non_member_count <- flagged_register |>
        count(Membership) |>
        filter(Membership == "non-member") |>
        pull(n)
      self$non_member_count <- non_member_count
    },
    
    set_non_member_group_fee = function(){
      self$non_member_group_fee <- self$non_member_count * private$fees[["non_member_fee_per_lesson"]] * self$lessons_in_term
    },
    
    set_court_fee = function(){
      # lessons completed * duration * no. courts * hourly court fee
      self$court_fee <- (self$lessons_in_term - self$number_rained_off) * self$session_duration * self$number_of_courts * private$fees[["group_coaching_hourly_court_fee"]]
    },
    
    set_total_group_fee = function(){
      self$total_group_fee <- self$court_fee + self$non_member_group_fee
    }
  ),
  
  active = list(
    
  )
)
