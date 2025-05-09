#---- group coaching court fee calculations ----
library(tidyverse)
library(stringr)

x <- read_csv("data/LTA-Youth-Yellow-Squad-Level-1.csv")



#---- global inputs ----
# stored in JSON - have an area/panel for the user to change these global values
group_coaching_hourly_court_fee <- 4.70
individial_coaching_hourly_court_fee <- 4.70
non_member_fee_per_lesson <- 2.50
sixty_minute_lesson_prices <- list(
  members = 12.00,
  non_members = 14.50
)
ninety_minute_lesson_prices <- list(
  members = 14.00,
  non_members = 16.50
)


#---- per group calculation method overview ----
# extract group name ---
# group name will be taken from the upload file's title
file_name <- "LTA-Youth-Yellow-Squad-Level-1.csv"
group_name <- file_name |>
  str_remove(".csv") |>
  str_replace_all("-", " ")


# extract number of lessons ---
# number of columns where colnames are dates/formatted as dates
column_names <- colnames(x)
# regex to get the strings formatted as dates
date_columns <- colnames(x) |>
  str_detect(regex("\\d{1,2}/\\d{1,2}/\\d{2,4}"))
# count number of trues
lessons_in_term <- sum(date_columns, na.rm = TRUE)


# ask user for number of rained off lessons ---
number_rained_off <- 1 # user supplied value


# ask user for session duration ---
session_duration <- 1.5 # user supplied value in hours


# ask user for number of courts used
number_of_courts <- 2 # user supplied value


# identify number of non-members ---
# get cost per lesson depending on session_duration
# then for each entry divide Amount by lessons_in_term
# if result matches non_members value flag as non-member
player_one <- x[1,]
amount_per_lesson <- player_one[["Amount"]]/lessons_in_term
if(session_duration == 1){
  if(amount_per_lesson == sixty_minute_lesson_prices[["members"]]){
    print("member")
  } else if(amount_per_lesson == sixty_minute_lesson_prices[["non_members"]]){
    print("non_member")
  } else {
    print("there is an error") # TODO: what does the app do when there is an error here?
  }
} else if(session_duration == 1.5){
  if(amount_per_lesson == ninety_minute_lesson_prices[["members"]]){
    print("member")
  } else if(amount_per_lesson == ninety_minute_lesson_prices[["non_members"]]){
    print("non_member")
  } else {
    print("there is an error") # TODO: what does the app do when there is an error here?
  }
}

# build a function to do this and a non-member flag onto the df
identify_non_members <- function(register, session_duration, lessons_in_term, sixty_minute_lesson_prices, ninety_minute_lesson_prices){
  
} # convert to method that just pulls internal values set for the object



# create row for output table in group coaching ---
# might be nicer to have an R6 object that does some of the calculations and a method to populate a table/build a row