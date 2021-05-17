#' Aggregate abolished municipalicities
#'
#' @param x A data.frame like object.
#' @export
#'
#' @examples
#' x <- data.frame(
#'   alue_code = c("KU911", "KU541"),
#'    alue_name = c("A", "B"), values = c(1,2))
#' agg_abolished_mun(x)
#'
agg_abolished_mun <- function(x){
  y <- x %>%
    statficlassifications::join_abolished_mun("alue_code") %>%
    select(!alue_name) %>%
    group_by(across(!values)) %>%
    summarise(values = sum(values), .groups = "drop") %>%
    mutate(alue_name = statficlassifications::codes_to_names(alue_code)) %>%
    relocate(names(x))

  y <- add_ptt_attr(y, x)
  y
}


#' Aggregate to other region level
#'
#' @param x A data.frame like object.
#' @param from A name of reginal classification.
#' @param to A name of reginal classification.
#' @export
#'
#'
agg_regions <- function(x, from = "kunta", to = "maakunta"){

  region_key <- statficlassifications::get_regionkey(from, to)
  names(region_key) <- c("from_name", "to_name", "alue_code", "to_code")
  region_key["from_name"] <- NULL

  y <- x %>%
    right_join(region_key, by = "alue_code") %>%
    select(-all_of(c("alue_name", "alue_code"))) %>%
    rename(alue_code = to_code, alue_name = to_name) %>%
    group_by(across(!values)) %>%
    summarise(values = sum(values), .groups = "drop") %>%
    relocate(names(x))

  y <- add_ptt_attr(y, x)
  y
}

#' Add regional aggragation
#'
#' @describeIn agg_regions
#'
#' @export

add_regional_agg <- function(x, from = "kunta", to = "maakunta"){

  y <- bind_rows(x, agg_regions(x, from = from, to = to)) %>%
    droplevels()
  y
}

#' Re-add ptt attributes back
#'
#' @param to A df to put attributes
#' @param from A df to get attributes froms
#'
#' @return

add_ptt_attr <- function(to, from){
  attr(to, "citation") <- attr(from, "citation")
  attr(to, "codes_names") <- attr(from, "codes_names")
  to
}


#' Aggregate to yearly data
#'
#' Time variable have to be Date in time column.
#'
#' @param x A data.frame like object.
#' @export
#'
#'
agg_yearly <- function(x){

  y <- x %>%
    mutate(time = lubridate::ymd(lubridate::year(time), truncated = 2)) %>%
    group_by(across(!values)) %>%
    summarise(values = sum(values), .groups = "drop") %>%
    relocate(names(x))

  y <- add_ptt_attr(y, x)
  y
}
