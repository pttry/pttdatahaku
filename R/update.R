#' Update PTT database
#'
#' @export
#'
#' @import dplyr
#'
#' @examples
#'   test_db_list <-
#'     list(
#'       test1 = list(
#'         url = "http://pxnet2.stat.fi/PXWeb/api/v1/fi/StatFin/kou/vkour/statfin_vkour_pxt_12bq.px",
#'         query =
#'           list(
#'             "Vuosi"=c("1970","1975"),
#'              "Alue"=c("SSS","KU020","KU005"),
#'              "Ik\U00E4"=c("SSS","15-19"),
#'              "Sukupuoli"=c("SSS","1","2"),
#'              "Koulutusaste"=c("SSS","3T8"),
#'              "Tiedot"=c("vaesto")),
#'         call = c(
#'           "ptt_get_statfi(url, query)"
#'         )
#'       ),
#'       test2 = list(
#'         url = "http://pxnet2.stat.fi/PXWeb/api/v1/fi/StatFin/kou/vkour/statfin_vkour_pxt_12bq.px",
#'         query =
#'           list(
#'             "Vuosi"=c("1980"),
#'              "Alue"=c("SSS"),
#'              "Ik\U00E4"=c("SSS","15-19"),
#'              "Sukupuoli"=c("SSS","1","2"),
#'              "Koulutusaste"=c("SSS","3T8"),
#'              "Tiedot"=c("vaesto")),
#'         call = c(
#'           "ptt_get_statfi(url, query)"
#'         )
#'       )
#'     )
#'
#'  y <- ptt_db_update(test_db_list)
#'


ptt_db_update <- function(db_list){
  purrr::map(db_list, ~eval(parse(text = .x$call), envir = .x))
}
