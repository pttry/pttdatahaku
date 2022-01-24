#' Filtering and recoding data
#'
#' Filters data based on named vectors or list of them.
#' Filtered series can be recoded at the same time, and
#' also columns are returned as factor with levels in
#' order of filtering information.
#'
#' @param dat A data.frame to filter and recode.
#' @param ... A (named) vector with a name.
#' @param query A same as ... as a list. Overrides dots.
#'
#' @import dplyr
#' @export
#' @examples
#' data.frame(tieto = c("taso kaksi", "taso kaksi", "taso yksi"), tieto2 = c("a", "b", "c")) |>
#'   filter_recode(
#'   tieto = c("Yksi" = "taso yksi",
#'             "Kaksi" = "taso kaksi"),
#'   tieto2 = c("b", "c")) |>
#'   str()

filter_recode <- function(dat, ..., query = NULL){

  if (is.null(query)){
    filter_list <- list(...)
  } else {
    filter_list <- query
  }


  #naming empty
  name_list <-
    filter_list |>
    purrr::keep(~!is.null(names(.x))) |>
    purrr::map(~purrr::set_names(.x, if_else(nchar(names(.x)) == 0, .x, names(.x))))

  dat |>
    filter(
      !!!unname(purrr::imap(filter_list, ~expr(!!sym(.y) %in% !!.x)))
    ) |>
    mutate(across(all_of(names(name_list)), ~factor(.x,
                                                    name_list[[cur_column()]],
                                                    names(name_list[[cur_column()]]))))
}
