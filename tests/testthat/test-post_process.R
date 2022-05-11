test_that("Aggregation of abolished works", {
  expect_equal(agg_abolished_mun(
    data.frame(alue_code = c("SSS", "KU911", "KU541"),
               alue_name = c("K", "A", "B"),
               values = c(3,1,2)))$values,
    c(3,3))
})


test_that("Regional aggregation works", {
  expect_equal(
    agg_regions(
      data.frame(alue_code = c("SSS", "KU049", "KU091", "KU109"),
                 values = c(1,1,1,2)), na.rm = TRUE,
      pass_region_codes = "SSS",
      all_to_regions = FALSE)$values,
    c(1,2,2))
})

test_that("Key aggregation works", {
  expect_equal(
    agg_key(
      data.frame(alue_code = c("SSS", "KU049", "KU091", "KU109"),
                 values = c(1,1,1,2)),
      key =
        data.frame(alue_code = c("SSS", "KU049", "KU091", "KU109"),
                   alue = c("SSS", "alue1", "alue1", "alue2")))$values,
    c(1,2,2))
})

test_that("Key aggregation works", {
  expect_equal(
    agg_key(
      data.frame(alue_code = c("SSS", "KU049", "KU091", "KU109"),
                 values = c(1,NA,1,2)),
      key =
        data.frame(alue_code = c("SSS", "KU049", "KU091", "KU109"),
                   alue = c("SSS", "alue1", "alue1", "alue2")))$values,
    c(1,NA,2))
})

test_that("Key aggregation works", {
  expect_equal(
    agg_key(
      data.frame(alue_code = c("SSS", "KU049", "KU091", "KU109"),
                 values = c(1,NA,1,2)),
      na.rm = TRUE,
      key =
        data.frame(alue_code = c("SSS", "KU049", "KU091", "KU109"),
                   alue = c("SSS", "alue1", "alue1", "alue2")))$values,
    c(1,1,2))
})

test_that("Key aggregation works with weight", {
  expect_equal(
    agg_key(
      data.frame(alue_code = c("SSS", "KU049", "KU091", "KU109"),
                 values = c(1,3,1,2),
                 size = c(1,3,1,1)), na.rm = TRUE,
      .fns = weighted.mean,
      w = size,
      key =
        data.frame(alue_code = c("SSS", "KU049", "KU091", "KU109"),
                   alue = c("SSS", "alue1", "alue1", "alue2")))$values,
    c(1,2.5,2))
})
