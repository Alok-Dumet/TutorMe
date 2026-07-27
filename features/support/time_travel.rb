require "active_support/testing/time_helpers"

# Allow scenarios to freeze the clock via the @time_travel tag.
World(ActiveSupport::Testing::TimeHelpers)

# Some scenarios use hard-coded calendar dates (e.g. 2026-03-10) as "upcoming"
# sessions. Freeze "now" to just before them so they stay in the future
# regardless of the real date the suite runs on.
Before("@time_travel") do
  travel_to Time.zone.parse("2026-03-01T00:00:00Z")
end

After("@time_travel") do
  travel_back
end
