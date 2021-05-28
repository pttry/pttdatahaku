test_that("Aggregation of abolished works", {
  expect_equal(agg_abolished_mun(
    data.frame(alue_code = c("SSS", "KU911", "KU541"),
               alue_name = c("K", "A", "B"),
               values = c(3,1,2)))$values,
    c(3,3))
})
