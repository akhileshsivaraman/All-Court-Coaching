library(jsonlite)

# pricing json
a <- list(
  sixty_minute = list(
    members = 12.00,
    non_members = 14.50
  ),
  ninety_minute = list(
    members = 14.00,
    non_members = 16.50
  )
)

toJSON(a, pretty = TRUE, auto_unbox = TRUE)
write_json(
  a,
  path = "data/pricing.json",
  pretty = TRUE,
  auto_unbox = TRUE
)


# global inputs
b <- list(
  group_coaching_hourly_court_fee = 4.70,
  individual_coaching_hourly_court_fee = 4.70,
  non_member_fee_per_lesson = 2.50
)

write_json(
  b,
  path = "data/fees.json",
  pretty = TRUE,
  auto_unbox = TRUE
)
