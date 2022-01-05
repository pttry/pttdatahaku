#' Translates code columns to name columns
#'
#' @param .data A data.frame or similar.
#' @param codes_names A named (column codes) list of named (codes) vectors (names).
#'        For example from [px_code_name()].
#' @param to_name A columns to name. Default are names from [codes_names] list.
#'
#' @export
#'
#' @return A modified data.frame or similar.
#'
#' @examples
#'
#' x <- data.frame(a = c("a1", "a2"), b = c("b1", "b2"))
#' cn <- list(a = c("a1" = "first", "a2" = "second"),
#'            b = c("b1" = "other", "b2" = "something"))
#' codes2names(x, cn)
#' codes2names(x, cn, "a")

codes2names <- function(.data, codes_names, to_name = names(codes_names)){
  .data <- dplyr::mutate(.data, across(any_of(to_name) & where(is.character),
                       ~factor(.x,
                               levels = names(codes_names[[cur_column()]]),
                               labels = codes_names[[cur_column()]]),
                       .names = "{.col}_name"))

  .data <- dplyr::rename_with(.data, .cols = any_of(to_name) & where(is.character), ~paste0(.x, "_code"))
  dplyr::mutate(.data, across(contains("_code"), ~forcats::as_factor(.x)))
}


#' Get codes-names key
#'
#' Note that a list is only sensible form of having code-name keys for different
#' variables as different variables have a different number of these keys. Thus,
#' this function produces lists of named vectors for many variables and named
#' vectors for one variable.
#'
#' @param x chr, table_code or url. If table code function requires db_list_name
#' @param db_list_name chr, db_list_name
#' @param variable chr, (statfitools::make_names-cleaned) variable name
#' @param offline logical, whether to try look for pxweb_metadata in the db_list_offline
#'
#' @return A named (column codes) list of named (codes) vectors (names).
#' @export
#'
#'
get_codes_names <- function(x, db_list_name = NULL, variable = NULL, offline = TRUE){

  if(is.null(db_list_name)) {offline <- FALSE}

  if(!offline) {
    pxweb_metadata <- ptt_get_pxweb_metadata(x, db_list_name = db_list_name)
  } else {
    pxweb_metadata <- ptt_read_db_list(db_list_name)[[x]]$pxweb_metadata
  }

  cn <- pxweb_metadata_to_codes_names(pxweb_metadata)
  names(cn) <- statfitools::make_names(names(cn))

  if(!is.null(variable)) {cn <- cn[[variable]]}

  cn
}

#' @describeIn Get codes-names key
#' @export
pxweb_metadata_to_codes_names <- function(pxweb_metadata) {

  purrr::map(rlang::set_names(pxweb_metadata$variables,
                                        sapply(pxweb_metadata$variables, "[[", "code")),
                       ~rlang::set_names(.x$valueTexts, .x$values))

}



