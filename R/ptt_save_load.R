#' Saves and loads data tables
#'
#' @param x A data to save
#'
#' @examples
#' test_dat <- data.frame(a = c(1,2))
#' ptt_save_data(test_dat)
#' test_dat2 <- ptt_read_data("test_dat")

ptt_save_data <- function(x){
  qs::qsave(x, file = here::here("data", paste0(deparse1(substitute(x)), ".qs")))
}

#'
#' @describeIn ptt_save_data
#'
ptt_read_data <- function(x_name){
  qs::qread(file = here::here("data", paste0(x_name, ".qs")))
}
