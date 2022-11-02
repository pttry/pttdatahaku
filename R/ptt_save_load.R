#' Saves and loads data tables
#'
#' For now saves to shared teams
#' Pellervon taloustutkimus - Datapankki/Tietokanta folder.
#' The folder must be synced.
#'
#' @param x A data to save
#' @param x_name A name of data. In saving defaults to a x object name.
#' @param path A path to data folder. NULL saves to default PTT-database.
#' @param region_level A region level(s) to read.
#'
#' @export
#'
#' @examples
#' test_dat <- data.frame(alue_name = factor(c("KOKO MAA", "Uusimaa")),
#'                        alue_code = factor(c("SSS", "MK01")),
#'                        a = c(1,2))
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
  output <- qs::qread(file = file.path(path, paste0(x_name, ".qs")))

  # Potentially apply region level selection
  if(!is.null(region_level)) {
    output <- filter_region_level(output, region_level = region_level)
  }

  # Apply selection with respect to names or codes
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

  # save db
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

#' Create full database lists
#'
#' @param x a vector of urls or a data.frame with urls as first column and information
#'     on the data corresponding to urls in other columns
#' @param db_list_name chr, name of the database
#' @param pxweb_metadata logical whether to add pxweb metadata to the database
#' @param overwrite logical whether to overwrite possibly existing database
#'
#' @export
#'
ptt_create_db_list <- function(x,
                               db_list_name = deparse1(substitute(x)),
                               pxweb_metadata = TRUE,
                               overwrite = FALSE,
                               call = "ptt_get_statfi(url, query)"){
  force(db_list_name)

  if(!overwrite) {
     if(paste0(db_list_name, ".rds") %in% list.files(db_path)) {
        stop(paste("A database list with name", db_list_name, "already exists."))
  } }

  if(is.data.frame(x)) {
    ptt_create_db_list_df(x, db_list_name, call = call)
  } else {
    ptt_create_db_list_vector(x, db_list_name, call = call)
  }

  if(pxweb_metadata) {ptt_add_pxweb_metadata(db_list_name)}

}


#' @describeIn ptt_create_db_list Create full database lists
#' @export
#'
ptt_create_db_list_vector <- function(x,
                                      db_list_name = deparse1(substitute(x)),
                                      pxweb_metadata = TRUE,
                                      call = "ptt_get_statfi(url, query)"){

  invisible(lapply(x, ptt_add_query, db_list_name = db_list_name, call = call))

}

#' @describeIn ptt_create_db_list Create full database lists
#' @export
#'
ptt_create_db_list_df <- function(x,
                                  db_list_name = deparse1(substitute(x)),
                                  pxweb_metadata = TRUE,
                                  call = "ptt_get_statfi(url, query)"){

  urls <- unlist(x[,sapply(x, function(x) {all(grepl(".px", x))})])
  x[,1] <- get_table_code(unlist(x[,1]))
  invisible(lapply(urls, ptt_add_query, db_list_name = db_list_name, call = call))
  ptt_add_manual_metadata(db_list_name, x)

}

#' Filter region level
#'
#' Filters, from a data.frame with a reigon code variable (with standardized region code prefixes)
#' desired region level and renames the the region variables in case of unique region level.
#'
#' @param data data.frame from \code{ptt_read_data}-function with \code{alue_code}-column.
#' @param region_level \code{"kunta"}, \code{"seutukunta"}, \code{"maakunta"} or \code{"suuralue"}.
#'    The desired region level
#'
#' @export
#'
filter_region_level <- function(data, region_level) {

  grepl_regexp <- paste(statficlassifications::name_to_prefix(region_level), collapse = "|")
  output <- dplyr::filter(data, grepl(grepl_regexp, alue_code)) %>%
    dplyr::mutate(alue_code = droplevels(alue_code))

  if("alue_name" %in% names(data)) {
    output <- dplyr::mutate(output, alue_name = droplevels(alue_name))
  }

  if(length(region_level) == 1) {
    output <- output %>%
      dplyr::rename_with(~paste(region_level, "code", sep = "_"), alue_code) %>%
      dplyr::rename_with(~paste(region_level, "name", sep = "_"), alue_name)
  }
  # Return
  output
}
