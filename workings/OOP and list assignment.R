# user inputs for group 1
register <- read_csv("data/LTA-Youth-Yellow-Squad-Level-1.csv")
number_rained_off <- 0
session_duration <- 1.5
number_of_courts <- 1
file_name <- "LTA-Youth-Yellow-Squad-Level-1.csv"

# create Group 1
group1 <- Group$new(
  register = register,
  session_duration = session_duration,
  number_of_courts = number_of_courts,
  number_rained_off = number_rained_off,
  input_file_name = file_name
)


# user inputs for group 2
register <- read_csv("data/LTA-Youth-Yellow-Squad-Level-1.csv")
number_rained_off <- 3
session_duration <- 1.5
number_of_courts <- 3
file_name <- "LTA-Youth-Yellow-Squad-Level-1.csv"

# create Group 2
group2 <- Group$new(
  register = register,
  session_duration = session_duration,
  number_of_courts = number_of_courts,
  number_rained_off = number_rained_off,
  input_file_name = file_name
)


# list assignment
groups_list <- list()
item_name <- group1$group_name
a <- append(groups_list, setNames(list(group1), item_name))
