# user inputs
register <- read_csv("data/LTA-Youth-Yellow-Squad-Level-1.csv")
number_rained_off <- 0
session_duration <- 1.5
number_of_courts <- 1
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

# list
groups_list <- list()
groups_list <- append(groups_list, new_group)
groups_list[[1]]$group_name

# put into a table
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

new_row <- tibble(
  "Group name" = new_group$group_name,
  "Number of lessons" = new_group$lessons_in_term,
  "Number of rained off lessons" = new_group$number_rained_off,
  "Session duration (hours)" = new_group$session_duration,
  "Number of courts used" = new_group$number_of_courts,
  "Court fee subtotal" = new_group$court_fee,
  "Number of non-members" = new_group$non_member_count,
  "Non-member fee subtotal" = new_group$non_member_group_fee,
  "Total fee for group" = new_group$total_group_fee
)

group_coaching_table <- bind_rows(group_coaching_table, new_row)
