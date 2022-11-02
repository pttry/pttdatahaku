#' Filtering and recoding data
#'
#' Filters data based on named vectors or list of them.
#' Filtered series can be recoded at the same time, and
#' also columns are returned as factor with levels in
#' order of filtering information.
#'
#' Gives message for missing filtering levels.
#'
#' @param dat A data.frame to filter and recode.
#' @param ... A (named) vector with a name.
#' @param query A same as ... as a list. Overrides dots.
#' @param droplevels A locigal to droplevels of factors. Default TRUE.
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
#'
#' data.frame(tieto = c("taso kaksi", "taso kaksi", "taso yksi"), tieto2 = c("a", "b", "c")) |>
#'   filter_recode(
#'   tieto = c("Yksi" = "taso yksi",
#'             "Kaksi" = "taso kaksi",
#'             "Kolme" = "taso kolme"),
#'   tieto2 = c("b", "c", "d", "e")) |>
#'   str()

filter_recode <- function(dat, ..., query = NULL, droplevels = TRUE){

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

  # filter
  dat <- dat |>
    filter(
      !!!unname(purrr::imap(filter_list, ~expr(!!sym(.y) %in% !!.x)))
    )

  # Check missing
  lst_check <-
    purrr::imap(filter_list, ~.x[!(.x %in% unique(dat[[.y]]))])


  purrr::imap(lst_check, ~(if (length(.x) > 0) message("From ", .y, " missing: ", paste0(.x, collapse = ", "))))


  # rename
  dat <- dat |>
    mutate(across(all_of(names(name_list)), ~factor(.x,
                                                    name_list[[cur_column()]],
                                                    names(name_list[[cur_column()]]))))
  if (droplevels) {
    dat <- dat |> droplevels()
  }



  dat

}


#' Print full filtering for codes for data
#'
#' Can be used also with robonomist id
#'
#' @param x A data.frame of robonomist id
#' @param conc A locigal whether to copy in clipboard
#' @export
#' @examples
#'   print_full_filter(x = data.frame(tieto = c("taso kaksi", "taso kaksi", "taso yksi"), tieto2 = c("a", "b", "c")), conc = FALSE)
#'   pttrobo::pttrobo_print_filter_recode(x = "luke/02_Maatalous/06_Talous/02_Maataloustuotteiden_tuottajahinnat/08_Tuottajahinnat_Vilja_rypsi_rapsi_v.px", conc = FALSE)

print_full_filter <- function(x, conc = TRUE){

  if (!inherits(x, "data.frame")){
    x <- ptt_data_robo_l(x)
  }

  y <- lapply(x, function(x) {
    if (is.character(x) | is.factor(x)) {
      unique(x)
    }})

  y <- y[!unlist(lapply(y, is.null))]



  out <- paste0(
    "filter(\n  ",
    paste0(purrr::imap(y, ~paste0(.y," %in% c(\"", paste0(as.character(.x), collapse = "\", \""), "\")")), collapse = ",\n  "),
    "\n  )"


  )
  cat(out)
  if (conc) cat(out, file = "clipboard-128")

}

#' @describeIn print_full_filter Code for filter_recode()
#' @export
print_full_filter_recode <- function(x, conc = TRUE){

  if (!inherits(x, "data.frame")){
    x <- ptt_data_robo_l(x)
  }

  y <- lapply(x, function(x) {
    if (is.character(x) | is.factor(x)) {
      unique(x)
    }})

  y <- y[!unlist(lapply(y, is.null))]



  out <- paste0(
    "filter_recode(\n  ",
    paste0(purrr::imap(y, ~paste0(.y," = c(\"", paste0(as.character(.x), collapse = "\", \""), "\")")), collapse = ",\n  "),
    "\n  )"


  )
  cat(out)
  if (conc) cat(out, file = "clipboard-128")

}
