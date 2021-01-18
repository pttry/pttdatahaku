#' Add and update PTT database
#'
#' @param db_list A PTT database list
#' @param dp_list_name A database list name
#' @param add A query list to add
#'
#' @export
#'
#' @import dplyr
#'
#' @examples
#'  ptt_add_query(
#'    "test_db",
#'    "test1",
#'    list(
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
#'       )
#'    )
#'
#'  ptt_add_query(
#'    "test_db",
#'    "test2",
#'    list(
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
#'    )
#'
#'
#'
#'  ptt_db_update(db_list_name = "test_db")
#'
#'  test1_dat <- ptt_read_data("test1")
#'


ptt_db_update <- function(db_list_name){
  db_list <- ptt_read_db_list(db_list_name, create = FALSE)
  dat_list <- purrr::map(db_list, ~eval(parse(text = .x$call), envir = .x))
  purrr::imap(dat_list, ~ptt_save_data(.x, .y))
  invisible(NULL)
}


#' @describeIn ptt_db_update

ptt_add_query <- function(db_list_name, name, q_list){

  # read or create db
  db_list <- ptt_read_db_list(db_list_name, create = TRUE)

  db_list[[name]] <- q_list

  ptt_save_db_list(db_list, db_list_name)

}


