test_that("pxweb_prepare_full_query works", {
  expect_named(pxweb_prepare_full_query("https://pxnet2.stat.fi/PXWeb/api/v1/fi/StatFin/vrm/tyokay/statfin_tyokay_pxt_115u.px"), c("query", "response"))
})
