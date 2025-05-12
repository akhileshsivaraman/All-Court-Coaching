#---- group coaching court fee calculations ----
library(tidyverse)
library(stringr)

register <- read_csv("data/LTA-Youth-Yellow-Squad-Level-1.csv")



#---- global inputs ----
# stored in JSON - have an area/panel for the user to change these global values
group_coaching_hourly_court_fee <- 4.70
individial_coaching_hourly_court_fee <- 4.70
non_member_fee_per_lesson <- 2.50

# encapsulate these into a higher level name-value pair {group_coaching: ...} or an object?
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
# regex to get the strings formatted as dates
date_columns <- colnames(register) |>
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
player_one <- register[1,]
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

# manipulate register to add a non-member flag rather than iterating over each entry
# mutate to get amount per lesson, case when amount per lesson is equal to ninety_minute_lesson_prices[["non-members"]] mark as non-member, etc
x <- register |>
  mutate(`Cost per lesson` = Amount/lessons_in_term) |>
  mutate(Membership = case_when(
    `Cost per lesson` == ninety_minute_lesson_prices[["members"]] ~ "member",
    `Cost per lesson` == ninety_minute_lesson_prices[["non_members"]] ~ "non-member"
  ))

# what about late signups?
# e.g. a non-member who ends up having a cost per lesson that is the same as the member fee per lesson. There's no way to tell without the register being filled out as the term goes on to know the true number of sessions the player has signed up for
# additionally, without knowing the true number of sessions the player has signed up for, we cannot correctly calculate their non-member fee (we have no number of lessons to multiply the non-member fee per lesson rate by)
# default to member for the time being

# count number of non-members and calculate non-member fee ---
non_member_count <- x |>
  count(Membership) |>
  filter(Membership == "non-member") |>
  pull(n)
non_member_count * ninety_minute_lesson_prices[["non_members"]] # have the prices per lesson as a property in the object

# create row for output table in group coaching ---
# might be nicer to have an R6 object that does some of the calculations and a method to populate a table/build a row