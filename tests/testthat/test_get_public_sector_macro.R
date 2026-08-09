
testthat::test_that(
  "get_public_sector_macro returns standardized real data",
  {
    skip_if_not_live_api()
    
    result <- get_public_sector_macro(
      start_year = 2020,
      end_year = 2025,
      prices = "real"
    )
    
    testthat::expect_equal(
      names(result),
      c(
        "Aar",
        "Offentlig_konsum",
        "Statlig_konsum",
        "Kommunalt_konsum",
        "BNP_Fastlands"
      )
    )
    
    testthat::expect_equal(
      result$Aar,
      2020:2025
    )
    
    testthat::expect_equal(
      nrow(result),
      6L
    )
    
    testthat::expect_equal(
      attr(result, "ssb_table"),
      "09189"
    )
    
    testthat::expect_equal(
      attr(result, "prices"),
      "real"
    )
    
    testthat::expect_equal(
      attr(result, "price_basis"),
      "Faste 2023-priser"
    )
  }
)

testthat::test_that(
  "get_public_sector_macro supports nominal prices",
  {
    skip_if_not_live_api()
    
    result <- get_public_sector_macro(
      start_year = 2020,
      end_year = 2025,
      prices = "nominal"
    )
    
    testthat::expect_equal(
      attr(result, "prices"),
      "nominal"
    )
    
    testthat::expect_equal(
      attr(result, "price_basis"),
      "Løpende priser"
    )
    
    testthat::expect_equal(
      result$Aar,
      2020:2025
    )
  }
)

testthat::test_that(
  "get_public_sector_macro validates years and prices",
  {
    testthat::expect_error(
      get_public_sector_macro(
        start_year = 2025,
        end_year = 2020
      ),
      "`start_year`.*`end_year`"
    )
    
    testthat::expect_error(
      get_public_sector_macro(
        start_year = 1969
      ),
      "1970"
    )
    
    testthat::expect_error(
      get_public_sector_macro(
        prices = "invalid"
      )
    )
  }
)

