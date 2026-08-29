
# Regenerate the NorMacro test fixture.
#
# Run this script deliberately when changes to the main NorMacro database
# require the test fixture to be updated. Live data sources must be available.

devtools::load_all(helpers = FALSE)

normacro_fixture <- get_normacro()

saveRDS(
  normacro_fixture,
  "tests/testthat/fixtures/normacro.rds",
  version = 3
)
