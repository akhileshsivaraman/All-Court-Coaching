# run OOP testing to generate a table
group_coaching_court_fee <- sum(group_coaching_table[["Court fee subtotal"]])
non_member_court_fee <- sum(group_coaching_table[["Non-member fee subtotal"]])

library(openxlsx2)
# https://janmarvin.github.io/openxlsx2/articles/openxlsx2.html#first-steps

# create workbook
wb <- wb_workbook()


# construct total fees sheet
# make four smaller tables then stitch them together into the worksheet using dims arg
heading_table <- data.frame(
  "Raynes Park Residents LTC" = c(
    "Invoice from the head coach for the court usage and non-member supplement",
    "This invoice is sent at the end of each coaching term and requires payment by the head coach within 21 days of the invoice date."
  ),
  check.names = FALSE
)

fees <- read_json("data/fees.json", simplifyVector = TRUE)
term <- "Summer" # set term programmatically?
inputs_table <- data.frame(
  "Term" = term,
  "Court fee per hour of group coaching" = fees$group_coaching_hourly_court_fee,
  "Court fee per hour of 1-2-1 coaching" = fees$individual_coaching_hourly_court_fee,
  "Fee per non-member per lesson" = fees$non_member_fee_per_lesson,
  check.names = FALSE
)

individual_coaching_court_fee <- 200 # ask user for hours then multiply by relevant fee
sub_totals_table <- data.frame(
  "Group coaching court fee" = group_coaching_court_fee,
  "1-2-1 coaching court fee" = individual_coaching_court_fee,
  "Non-member court fee" = non_member_court_fee,
  check.names = FALSE
)

total_table <- data.frame(
  "Total" = group_coaching_court_fee + individual_coaching_court_fee + non_member_court_fee,
  check.names = FALSE
)


# add in worksheets
wb$
  add_worksheet(sheet = "Total Fees")$
  add_data(
    sheet = "Total Fees",
    x = heading_table,
    dims = "A1"
  )$
  add_data(
    sheet = "Total Fees",
    x = inputs_table,
    dims = "A5"
  )$
  add_data( # TODO: add subtotal header
    sheet = "Total Fees",
    x = sub_totals_table,
    dims = "A9"
  )$
  add_data( # TODO: add total header / make bold
    sheet = "Total Fees",
    x = total_table,
    dims = "A13"
  )$
  add_worksheet(sheet = "Group Coaching")$
  add_data(
    sheet = "Group Coaching",
    x = group_coaching_table
  )

wb_save(wb, file = "workings/test.xlsx")
