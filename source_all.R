
## ============================================================================
## Package setup and basic utilities
## ============================================================================

source("R/utils.R")
source("R/NorMacro-package.R")

source("R/install_dependencies.R")
source("R/cache_get.R")
source("R/formatting.R")
source("R/series_coverage.R")


## ============================================================================
## Data-source helpers
## ============================================================================

source("R/source_ssb.R")
source("R/source_nav.R")


## ============================================================================
## Metadata
## ============================================================================

source("R/read_metadata_csv.R")

source("R/get_normacro_metadata.R")
source("R/get_international_metadata.R")
source("R/get_metadata.R")

source("R/check_metadata.R")
source("R/validate_metadata.R")

source("R/get_display_name.R")


## ============================================================================
## Norwegian source series
## ============================================================================

source("R/get_kpi.R")
source("R/get_befolkning.R")
source("R/get_arbeidsstyrke.R")
source("R/get_ledighet.R")
source("R/get_rente.R")
source("R/get_valutakurs.R")

source("R/get_bnp_lopende.R")
source("R/get_bnp_fastland.R")
source("R/get_lonn.R")
source("R/get_sysselsatte.R")

source("R/get_boligpriser.R")
source("R/get_oljepris.R")
source("R/get_strompris.R")
source("R/get_oseax.R")

source("R/get_utenrikshandel.R")
source("R/get_offentlig_finans.R")
source("R/get_offentlige_utgifter.R")
source("R/get_offentlige_investeringer.R")

source("R/get_kreditt.R")
source("R/get_boliginvesteringer.R")
source("R/get_husholdningsgjeld.R")
source("R/get_disponibel_inntekt.R")

source("R/get_konsum.R")
source("R/get_sparing.R")
source("R/get_fastlandsinvesteringer.R")

source("R/get_industriproduksjon.R")
source("R/get_byggeaktivitet.R")
source("R/get_detaljhandel.R")
source("R/get_tjenesteproduksjon.R")

source("R/get_kapasitetsutnytting.R")
source("R/get_konjunkturindikator.R")
source("R/get_ressursknapphet.R")
source("R/get_ordrebeholdning.R")

source("R/get_pengemarkedsrente.R")
source("R/get_statsrente.R")


## ============================================================================
## Norwegian database construction
## ============================================================================

source("R/create_derived_variables.R")
source("R/check_normacro.R")
source("R/build_database.R")
source("R/get_normacro.R")


## ============================================================================
## International source series
## ============================================================================

source("R/get_standard_countries.R")
source("R/get_eurostat_data.R")

source("R/get_hicp.R")
source("R/get_unemployment.R")
source("R/get_population.R")

source("R/get_gdp.R")
source("R/get_gdp_constant.R")

source("R/get_industrial_production.R")
source("R/get_employment.R")
source("R/get_labour_force.R")

source("R/get_government_debt.R")
source("R/get_house_price_index.R")
source("R/get_retail_trade.R")

source("R/get_exports.R")
source("R/get_imports.R")

source("R/get_private_consumption.R")
source("R/get_public_consumption.R")
source("R/get_investment.R")
source("R/get_long_interest_rate.R")


## ============================================================================
## International database construction
## ============================================================================

source("R/create_international_derived_variables.R")
source("R/build_international_database.R")
source("R/get_international_macro.R")


## ============================================================================
## Data discovery, summaries and reporting
## ============================================================================

source("R/search_variables.R")
source("R/describe_variable.R")
source("R/list_categories.R")
source("R/list_variables.R")

source("R/coverage.R")
source("R/latest_observations.R")
source("R/missing_data.R")
source("R/overview.R")
source("R/summary_normacro.R")
source("R/variable_summary.R")

source("R/leading_indicators.R")
source("R/conjuncture_dashboard.R")

source("R/about.R")
source("R/macro_report.R")


## ============================================================================
## General series utilities
## ============================================================================

source("R/find_first_common_year.R")
source("R/normalize_series.R")

source("R/growth_rate.R")
source("R/growth_table.R")
source("R/compare_periods.R")


## ============================================================================
## Comparison-series class and constructors
## ============================================================================

source("R/new_comparison_series.R")
source("R/combine_series.R")

source("R/print.comparison_series.R")
source("R/summary.comparison_series.R")
source("R/print.comparison_series_summary.R")


## ============================================================================
## Comparison-series transformations
## ============================================================================

source("R/index.R")
source("R/index.comparison_series.R")

source("R/normalize.R")
source("R/normalize_comparison_series.R")

source("R/growth.R")
source("R/growth_comparison_series.R")


## ============================================================================
## Comparison-series plotting
## ============================================================================

source("R/create_comparison_subtitle.R")
source("R/plot.comparison_series.R")

source("R/plot_series.R")
source("R/compare_series.R")
source("R/scatter_series.R")


## ============================================================================
## Series correlation and dependence
## ============================================================================

source("R/correlate.R")
source("R/correlate_series.R")
source("R/correlate.comparison_series.R")
source("R/print.comparison_series_correlation.R")

source("R/correlation_matrix.R")
source("R/correlation_matrix.default.R")
source("R/plot_correlation_matrix.R")

source("R/autocorrelate.R")
source("R/autocorrelate.comparison_series.R")
source("R/print.comparison_series_autocorrelation.R")


## ============================================================================
## Regression
## ============================================================================

source("R/regress.R")
source("R/regress.comparison_series.R")

source("R/print.comparison_series_regression.R")
source("R/summary.comparison_series_regression.R")
source("R/print.comparison_series_regression_summary.R")

source("R/regression_methods.R")
source("R/regression_plot_data.R")
source("R/plot.comparison_series_regression.R")
source("R/augment.comparison_series_regression.R")

source("R/model_metrics.R")
source("R/model_metrics.comparison_series_regression.R")

source("R/diagnose.R")
source("R/diagnose.comparison_series_regression.R")
source("R/print.comparison_series_regression_diagnosis.R")


## ============================================================================
## Business-cycle analysis
## ============================================================================

source("R/business_cycle_score.R")
source("R/business_cycle.R")
source("R/business_cycle_explain.R")

source("R/recession_periods.R")
source("R/recession_period_explain.R")


## ============================================================================
## Generic KOSTRA infrastructure
## ============================================================================

source("R/set_kostra_attributes.R")
source("R/get_px_variable.R")
source("R/kostra_metadata.R")

source("R/clean_kostra_unit_name.R")
source("R/get_kostra_group_membership.R")
source("R/get_kostra_group.R")
source("R/get_kostra_peer_group.R")
source("R/filter_kostra_peer_group.R")
source("R/prepare_kostra_peer_analysis.R")
source("R/get_kostra_group_membership_history.R")
source("R/get_kostra_peer_group_history.R")
source("R/filter_kostra_peer_group_history.R")
source("R/get_kostra_peer_group_data.R")
source("R/get_kostra_county_membership.R")
source("R/get_kostra_county.R")
source("R/get_kostra_county_peer_group.R")
source("R/get_kostra_county_membership_history.R")
source("R/get_kostra_county_peer_group_history.R")
source("R/get_kostra_county_peer_group_data.R")
source("R/prepare_kostra_comparison.R")


source("R/get_kostra_table.R")
source("R/get_kostra_regions.R")

source("R/clean_kostra_unit_name.R")
source("R/standardize_kostra_wide_table.R")
source("R/standardize_kostra_long_table.R")


## ============================================================================
## KOSTRA table 12134: key figures
## ============================================================================

source("R/kostra_table_12134.R")
source("R/kostra_indicators_12134.R")
source("R/get_kostra_regions_12134.R")

source("R/standardize_kostra_keyfigures.R")
source("R/get_kostra_keyfigures.R")


## ============================================================================
## KOSTRA table 12143: financial key figures
## ============================================================================

source("R/kostra_table_12143.R")
source("R/kostra_indicators_12143.R")
source("R/get_kostra_regions_12143.R")

source("R/standardize_kostra_financial_keyfigures.R")
source("R/get_kostra_financial_keyfigures.R")


## ============================================================================
## KOSTRA table 12135: debt key figures
## ============================================================================

source("R/kostra_table_12135.R")
source("R/kostra_indicators_12135.R")
source("R/get_kostra_regions_12135.R")

source("R/standardize_kostra_debt_keyfigures.R")
source("R/get_kostra_debt_keyfigures.R")


## ============================================================================
## KOSTRA table 12137: key figures per capita
## ============================================================================

source("R/kostra_table_12137.R")
source("R/kostra_indicators_12137.R")
source("R/get_kostra_regions_12137.R")

source("R/standardize_kostra_per_capita_keyfigures.R")
source("R/get_kostra_per_capita_keyfigures.R")


## ============================================================================
## KOSTRA table 12333: investment financing
## ============================================================================

source("R/kostra_table_12333.R")
source("R/kostra_indicators_12333.R")
source("R/get_kostra_regions_12333.R")

source("R/standardize_kostra_investment_financing.R")
source("R/get_kostra_investment_financing.R")


## ============================================================================
## KOSTRA table 12364: financial foundations
## ============================================================================

source("R/kostra_table_12364.R")
source("R/kostra_indicators_12364.R")
source("R/get_kostra_regions_12364.R")

source("R/standardize_kostra_financial_foundations.R")
source("R/get_kostra_financial_foundations.R")


## ============================================================================
## KOSTRA table 13553: operating financing
## ============================================================================

source("R/kostra_table_13553.R")
source("R/kostra_indicators_13553.R")
source("R/get_kostra_regions_13553.R")

source("R/standardize_kostra_operating_financing.R")
source("R/get_kostra_operating_financing.R")


## ============================================================================
## KOSTRA table 12858: main accounts
## ============================================================================

source("R/kostra_table_12858.R")
source("R/kostra_indicators_12858.R")
source("R/kostra_accounts_12858.R")
source("R/get_kostra_regions_12858.R")

source("R/standardize_kostra_main_accounts.R")
source("R/get_kostra_main_accounts.R")


## ============================================================================
## KOSTRA metadata API
## ============================================================================

source("R/get_kostra_metadata.R")


## ============================================================================
## KOSTRA cross-sectional analysis
## ============================================================================

source("R/rank_kostra.R")
source("R/kostra_change.R")
source("R/compare_kostra_units.R")
source("R/kostra_summary.R")
source("R/benchmark_kostra.R")
source("R/kostra_timeseries_benchmark.R")
source("R/benchmark_kostra_peer_group.R")
source("R/kostra_timeseries_benchmark_peer_group.R")


## ============================================================================
## KOSTRA plotting
## ============================================================================

source("R/plot_kostra_benchmark.R")
source("R/plot_kostra_ranking.R")
source("R/plot_kostra_timeseries_benchmark.R")
source("R/plot_kostra_position_over_time.R")
source("R/plot_kostra_timeseries_benchmark_peer_group.R")
source("R/plot_kostra_position_over_time_peer_group.R")
