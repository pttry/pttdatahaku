#' Saves and loads data tables
#'
#' For now saves to shared teams
#' Pellervon taloustutkimus - Datapankki/Tietokanta folder.
#' The foldet must be synced.
#'
#' @param x A data to save
#' @param x_name A name of data. In saving defaults to a x object name.
#'
#' @export
#'
#' @examples
#' test_dat <- data.frame(a = c(1,2))
#' ptt_save_data(test_dat)
#' test_dat2 <- ptt_read_data("test_dat")

ptt_save_data <- function(x, x_name = deparse1(substitute(x))){
  qs::qsave(x, file = file.path(db_path, paste0(x_name, ".qs")))
}

#'
#' @describeIn ptt_save_data
#'
ptt_read_data <- function(x_name){

  # path.expand(path)
  qs::qread(file = file.path(db_path, paste0(x_name, ".qs")))
}


db_path <- "~/../Pellervon Taloustutkimus PTT ry/Pellervon taloustutkimus - Datapankki/Tietokanta"


#' Save and read database list
#'
#'
#' @param db_list A database list.
#' @param db_list_name A database list name.
#' @param create A logical whether to create in non exits
#'
#' @export
#'
#' @examples
#'   db_t <- ptt_read_db_list("test_db")
#'
ptt_save_db_list <- function(db_list, db_list_name = deparse1(substitute(db_list))){

  # read or create db
  db_file = file.path(db_path, paste0(db_list_name, ".rds"))
  saveRDS(db_list, db_file)

}

#' @describeIn ptt_save_db_list
#'
ptt_read_db_list <- function(db_list_name, create = FALSE){

  # read or create db
  db_file = file.path(db_path, paste0(db_list_name, ".rds"))
  if (file.exists(db_file)){
    db_list <- readRDS(db_file)
  } else if (create) {
    db_list <- list()
    message("A new database list created")
  } else {
    stop("File for ", db_list_name, " does not exist.")
  }

  db_list
}
