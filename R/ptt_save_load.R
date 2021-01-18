#' Saves and loads data tables
#'
#' For now saves to shared teams
#' Pellervon taloustutkimus - Datapankki/Tietokanta folder.
#' The foldet must be synced.
#'
#' @param x A data to save
#' @param x_name A name of data.
#'
#' @examples
#' test_dat <- data.frame(a = c(1,2))
#' ptt_save_data(test_dat)
#' test_dat2 <- ptt_read_data("test_dat")

ptt_save_data <- function(x){
  qs::qsave(x, file = file.path(db_path, paste0(deparse1(substitute(x)), ".qs")))
}

#'
#' @describeIn ptt_save_data
#'
ptt_read_data <- function(x_name){

  # path.expand(path)
  qs::qread(file = file.path(db_path, paste0(x_name, ".qs")))
}


db_path <- "~/../Pellervon Taloustutkimus PTT ry/Pellervon taloustutkimus - Datapankki/Tietokanta"
