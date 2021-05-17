test_that("url parses and work", {
  expect_type(
    pxweb::pxweb_test_api(
      statfi_parse_url("https://pxnet2.stat.fi/PXWeb/pxweb/fi/StatFin/StatFin__vrm__muutl"),
      test_type = "touch", verbose = FALSE),
    "list")
})


test_that("Code print works", {
  expect_output(
    pxweb_print_code_full_query(url = statfi_url("StatFin", "vrm/tyokay/statfin_tyokay_pxt_115u.px")),
    "dat")
})
