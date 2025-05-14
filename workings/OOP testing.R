# user inputs
register <- read_csv("data/LTA-Youth-Yellow-Squad-Level-1.csv")
number_rained_off <- 1
session_duration <- 1.5
number_of_courts <- 2
file_name <- "LTA-Youth-Yellow-Squad-Level-1.csv"

# init
new_group <- Group$new(
  register = register,
  session_duration = session_duration,
  number_of_courts = number_of_courts,
  number_rained_off = number_rained_off,
  input_file_name = file_name
)

# print
new_group
new_group$price_per_lesson
