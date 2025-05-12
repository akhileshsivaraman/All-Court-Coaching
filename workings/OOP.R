library(R6)

# a Group object
# one of the properties is price per lesson which can be a named list of two [member_price, non_member_price] and those values are determined by the supplied session_duration
# other properties: the register (df), name, non-member count, non-member group fee, number of rained off lessons, lessons in term, session duration, number of courts used