#' Saves and loads data tables
#'
#' For now saves to shared teams
#' Pellervon taloustutkimus - Datapankki/Tietokanta folder.
#' The foldet must be synced.
#'
#' @param x A data to save
#' @param x_name A name of data. In saving defaults to a x object name.
#' @param path A path to data folder. NULL saves to default PTT-database.
#' @param region_level A region level(s) to read.
#'
#' @export
#'
#' @examples
#' test_dat <- data.frame(a = c(1,2))
#' ptt_save_data(test_dat)
#' test_dat2 <- ptt_read_data("test_dat")

ptt_save_data <- function(x, x_name = deparse1(substitute(x)), path = NULL){
  if (is.null(path)) path <- db_path
  qs::qsave(x, file = file.path(path, paste0(x_name, ".qs")))
}

#'
#' @describeIn ptt_save_data Read data
#' @export
#'
ptt_read_data <- function(x_name, region_level = NULL, path = NULL,
                          only_names = FALSE, only_codes = FALSE){

  if (is.null(path)) path <- db_path

  # path.expand(path)
  output_data <- qs::qread(file = file.path(path, paste0(x_name, ".qs")))

  if(is.null(region_level)) {
    output <- output_data
  } else {
    # region_level <- tolower(region_level)
    grepl_regexp <- paste(statficlassifications::name_to_prefix(region_level), collapse = "|")
    output <- dplyr::filter(output_data, grepl(grepl_regexp, alue_code)) %>%
      dplyr::mutate(alue_code = droplevels(alue_code),
                    alue_name = droplevels(alue_name))
    if(length(region_level) == 1) {
      output <- output %>%
        dplyr::rename_with(~paste(region_level, "code", sep = "_"), alue_code) %>%
        dplyr::rename_with(~paste(region_level, "name", sep = "_"), alue_name)
    }
  }

  if(only_codes) {output <- dplyr::select(output, -contains("name"))}
  if(only_names) {output <- dplyr::select(output, -contains("code"))}

  output
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

#' @describeIn ptt_save_db_list Read database list.
#' @export
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
