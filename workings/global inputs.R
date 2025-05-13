library(jsonlite)
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
  path = "data/price_per_lesson.json",
  pretty = TRUE,
  auto_unbox = TRUE
)
