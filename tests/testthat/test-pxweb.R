test_that("pxweb_prepare_full_query works", {
  expect_named(pxweb_prepare_full_query("https://statfin.stat.fi/PXWeb/api/v1/fi/StatFin/tyti/statfin_tyti_pxt_137i.px"), c("query", "response"))
})
