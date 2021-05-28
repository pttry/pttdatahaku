test_that("multiplication works", {
  df <- data.frame(a = c("a", "b"), b = c(1,2))
  expect_s3_class(factor_all(df)$a, "factor")
})
