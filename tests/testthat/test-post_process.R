test_that("Aggregation of abolished works", {
  expect_equal(agg_abolished_mun(
    data.frame(alue_code = c("KU911", "KU541"),
               alue_name = c("A", "B"), values = c(1,2)))$values,
    3)
})
