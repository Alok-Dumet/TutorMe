SimpleCov.start "rails" do
  # Track all Ruby files in app/ and lib/, even if not yet required.
  track_files "{app,lib}/**/*.rb"

  # Exclude non-application files from coverage percentages.
  add_filter "/bin/"
  add_filter "/db/"
  add_filter "/config/"
  add_filter "/spec/"
  add_filter "/features/"
  add_filter "/vendor/"

  # Coverage groups (sidebar sections in the HTML report).
  add_group "Models",      "app/models"
  add_group "Controllers", "app/controllers"
  add_group "Helpers",     "app/helpers"
  add_group "Jobs",        "app/jobs"
  add_group "Mailers",     "app/mailers"
  add_group "Libraries",   "lib"

  # Allow enough time for multiple suites (RSpec + Cucumber) to run
  # and have their results merged.
  merge_timeout 3600 # seconds

  # Only enforce the 80% minimum after the combined coverage
  if ENV["COVERAGE_ENFORCE"]
    minimum_coverage 80
  end
end