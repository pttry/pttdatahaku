#' Add and update PTT database
#'
#' @param db_list A PTT database list.
#' @param dp_list_name A database list name.
#' @param table_name A name of table to add.
#' @param url A url of table in statfin
#' @param query_list A query list from \code{\link{pxweb_print_full_query}}.
#' @param tables A character vector of tables to update.
#'
#' @export
#'
#' @import dplyr
#'
#' @examples
#'
#'  ptt_add_query(
#'    "test_db",
#'    "test2",
#'    url = "http://pxnet2.stat.fi/PXWeb/api/v1/fi/StatFin/kou/vkour/statfin_vkour_pxt_12bq.px",
#'    query_list =
#'           list(
#'             "Vuosi"=c("1980"),
#'              "Alue"=c("SSS"),
#'              "Ik\U00E4"=c("SSS","15-19"),
#'              "Sukupuoli"=c("SSS","1","2"),
#'              "Koulutusaste"=c("SSS","3T8"),
#'              "Tiedot"=c("vaesto")),
#'    call = c("ptt_get_statfi(url, query)")
#'    )
#'
#'  ptt_db_update(db_list_name = "test_db")
#'
#'  test1_dat <- ptt_read_data("test1")
#'


ptt_db_update <- function(db_list_name, tables = "all"){
  db_list <- ptt_read_db_list(db_list_name, create = FALSE)

  if (tables != "all") db_list <- db_list[tables]

  dat_list <- purrr::map(db_list, ~eval(parse(text = .x$call), envir = .x))
  purrr::imap(dat_list, ~ptt_save_data(.x, .y))
  invisible(NULL)
}


#' @describeIn ptt_db_update Add to query

ptt_add_query <- function(db_list_name, table_name, url, query_list,
                          call = "ptt_get_statfi(url, query)"){

  # read or create db
  db_list <- ptt_read_db_list(db_list_name, create = TRUE)

  db_list[[table_name]] <- list(url = url, query = query_list, call = call)

  ptt_save_db_list(db_list, db_list_name)

}


