test_that("databases funktions work", {

  # creating
  expect_message(
    ptt_add_query(
      "test_db",
      "test2",
      url = "https://pxnet2.stat.fi/PXWeb/api/v1/fi/StatFin/kou/vkour/statfin_vkour_pxt_12bq.px",
      query =
        list(
          "Vuosi"=c("1980"),
          "Alue"=c("SSS"),
          "Ik\U00E4"=c("SSS","15-19"),
          "Sukupuoli"=c("SSS","1","2"),
          "Koulutusaste"=c("SSS","3T8"),
          "Tiedot"=c("vaesto")),
      call = c("ptt_get_statfi(url, query)")
    ), "test2 query added to test_db")

  # Fail to remove non existing
  expect_error(
    ptt_remove_query("test_db", "asdflkmoi")
  )

  expect_message(
    ptt_remove_query("test_db", "test2"),
    "test2 removed from the test_db"
  )

})
