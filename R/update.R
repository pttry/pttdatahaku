#' Add and update PTT database
#'
#' @param db_list A PTT database list.
#' @param dp_list_name A database list name.
#' @param table_code A name of table to add. If NULL (default) the name is
#'                   constructed from url.
#' @param url A url of table in statfin
#' @param query A query list from \code{\link{pxweb_print_full_query}}.
#' @param tables A character vector of tables to update.
#'
#' @return A named list with update: names of updated tables and
#'         error: names of tables with an error.
#'
#' @export
#'
#' @import dplyr
#' @import tidyr
#'
#' @examples
#'
#'  ptt_add_query(
#'    "test_db",
#'    "test2",
#'    url = "http://pxnet2.stat.fi/PXWeb/api/v1/fi/StatFin/kou/vkour/statfin_vkour_pxt_12bq.px",
#'    query =
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

  dat_list <- purrr::map(db_list,
                         purrr::safely(
                           function(x) eval(parse(text = x$call), envir = x),
                           otherwise = data.frame()))

  results <- purrr::map_lgl(dat_list, ~is.null(.x$error))
  res_list <- dat_list[results]
  err_list <- dat_list[!results]

  purrr::imap(res_list, ~ptt_save_data(.x$result, .y))

  message("Updated: ", paste0(names(res_list), collapse = ", "))
  if (length(err_list) > 0) {
    message("Error: \n", purrr::imap_chr(err_list, ~paste0(.y, ": ", .x$error, "\n")))
  }

  invisible(list(updated = names(res_list),
                 error = names(err_list)))
}


#' @describeIn ptt_db_update Add to query
#' @export

ptt_add_query <- function(db_list_name, url, query, table_code = NULL,
                          call = "ptt_get_statfi(url, query)"){

  # read or create db
  db_list <- ptt_read_db_list(db_list_name, create = TRUE)

  if (is.null(table_code)) table_code <- get_table_code(url)

  db_list[[table_code]] <- list(url = url, query = query, call = call)

  ptt_save_db_list(db_list, db_list_name)
  message(table_code, " query added to ", db_list_name)

}


