test_that("statfi_url works", {
  expect_type(
    pxweb::pxweb_test_api(
      statfi_url("StatFin"),
      test_type = "touch", verbose = FALSE),
    "list")
})


test_that("url parses and work", {
  expect_type(
    pxweb::pxweb_test_api(
      statfi_parse_url("https://pxweb2.stat.fi/PxWeb/pxweb/fi/StatFin/StatFin__muutl"),
      test_type = "touch", verbose = FALSE),
    "list")
})


test_that("Code print works", {
  expect_output(
    pxweb_print_code_full_query(url = statfi_url("StatFin", "tyokay/statfin_tyokay_pxt_115u.px")),
    "dat")
})
