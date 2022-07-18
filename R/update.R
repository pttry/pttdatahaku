#' Add and update PTT database
#'
#' `ptt_update_db` updates the database according to the contents of a database list.
#'
#' @param db_list_name A database list name.
#' @param table_code A name of table to add. If NULL (default) the name is
#'                   constructed from url.
#' @param url A url of table in statfin
#' @param query A query list from \code{\link{pxweb_print_full_query}}.
#' @param tables A character vector of tables to update.
#' @param call A call to run query.
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
#'    url = "https://pxweb2.stat.fi/PxWeb/pxweb/fi/StatFin/StatFin__vkour/statfin_vkour_pxt_12bq.px/",
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
#'  test1_dat <- ptt_read_data("test2")
#'
#'  ptt_add_query("test_db",
#'                url = "https://pxweb2.stat.fi/PxWeb/pxweb/fi/StatFin/StatFin__vkour/statfin_vkour_pxt_12bq.px/",
#'                query = NULL,
#'                call = "ptt_get_statfi_robonomist(url)")
#'
#'  ptt_db_update("test_db", tables = "vkour_12bq")
#'
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


#' @describeIn ptt_db_update Add a query to the database.
#' @export

ptt_add_query <- function(db_list_name, url, query = NULL, table_code = NULL,
                          call = "ptt_get_statfi(url, query)"){

  url <- statfi_parse_url(url)

  # read or create db
  db_list <- ptt_read_db_list(db_list_name, create = TRUE)

  if(is.null(query)) {query <- pxweb_full_query_as_list(url)}
  if (is.null(table_code)) table_code <- get_table_code(url)

  db_list[[table_code]][c("url", "query", "call")] <- list(url = url, query = query, call = call)

  # save
  ptt_save_db_list(db_list, db_list_name)
  message(table_code, " query added to ", db_list_name)

}


#' Get pxweb metadata from pxweb api
#'
#' Given either a url or a table code and db list name retrieves pxweb_metadata.
#'
#' @param x chr, table_code or url. If table code, function requires db_list_name
#' @param db_list_name chr
#'
#' @return pxweb_metadata
#' @export
#'
ptt_get_pxweb_metadata <- function(x, db_list_name = NULL) {

  if(!is.null(db_list_name)) {x <- table_code_to_url(x, db_list_name = db_list_name)}
  pxweb::pxweb_get(statfi_parse_url(x))

}

#' Add metadata to databases
#'
#' Adds pxweb metadata to a db list entry.
#'
#' @param db_list_name chr, name of database
#' @param table_code chr, code of table
#'
#' @export
#'
ptt_add_pxweb_metadata <- function(db_list_name, table_code = NULL) {

  db_list <- ptt_read_db_list(db_list_name)

  # If no table code given add metadata for all tables in db.
  if(is.null(table_code)) {
     invisible(lapply(names(db_list), ptt_add_pxweb_metadata, db_list_name = db_list_name))
  } else {
    db_list[[table_code]][c("pxweb_metadata")] <- list(pxweb_metadata = ptt_get_pxweb_metadata(table_code, db_list_name))
    ptt_save_db_list(db_list, db_list_name)
    message("pxweb metadata added to table ", table_code, " in database ", db_list_name)
  }
}


#' Add manual metadata to databases
#'
#' @param db_list_name chr, name of database
#' @param x data.frame of manual metadata
#' @param table_code chr, code of table
#'
#' @export
#'
ptt_add_manual_metadata <- function(db_list_name, x, table_code = NULL) {

  db_list <- ptt_read_db_list(db_list_name)

  if(is.null(table_code)) {
    table_vector <- unlist(x[,1])
    table_info_list <- split(x[,-1], 1:nrow(x))
    invisible(
      mapply(function(y,z) {ptt_add_manual_metadata(db_list_name = db_list_name,
                                                    x = z,
                                                    table_code = y)},
             table_vector, table_info_list)
    )

  } else {

    db_list[[table_code]]["manual_metadata"] <- setNames(list(x), "manual_metadata")
    #db_list[[table_code]] <- append(db_list[[table_code]], setNames(list(x), "manual_metadata"))
    ptt_save_db_list(db_list, db_list_name)
    message("manual_metadata added to table ", table_code, " in database ", db_list_name)
  }
}

#' @describeIn ptt_db_update Remove a query from the database.
#' @export
ptt_remove_query <- function(db_list_name, table_code){

  # read or create db
  db_list <- ptt_read_db_list(db_list_name, create = FALSE)

  if (table_code %in% names(db_list)){
    db_list[[table_code]] <- NULL

    ptt_save_db_list(db_list, db_list_name)
    message(table_code, " removed from the ", db_list_name)
  } else {
    stop("The query ", table_code, " not found in the database ", db_list_name, ".")
  }

}


