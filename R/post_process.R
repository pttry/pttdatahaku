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
#' @param pass_region_codes Region codes to be passed true. For example whole
#'        country "SSS". Does not affect aggregation. Default NULL.
#' @param na.rm	logical. Should missing values (including NaN) be removed?
#' @param all_to_regions logical. Should all to regions included
#'        even if not in data.


#' @export
#'
#' @import dplyr
#' @examples
#' x <- data.frame(alue_code = c("SSS", "KU049", "KU091", "KU109"), values = c(1,1,1,2))
#' agg_regions(x, na.rm = TRUE)
#' agg_regions(x, na.rm = TRUE, pass_region_codes = "SSS")
#' agg_regions(x, na.rm = TRUE, pass_region_codes = "SSS", all_to_regions = FALSE)
#' z <- dplyr::mutate(x, values2 = c(3,4,5,6))
#' agg_regions(z, na.rm = TRUE, value_cols = c("values", "values2"))
agg_regions <- function(x, from = "kunta", to = "maakunta",
                        value_cols = c("values"),
                        pass_region_codes = NULL, na.rm = FALSE,
                        all_to_regions = TRUE){

  region_key <- statficlassifications::get_regionkey(from, to)
  names(region_key) <- c("from_name", "to_name", "alue_code", "to_code")
  region_key["from_name"] <- NULL

  y <- x %>%
    mutate(check = 1) |>
    right_join(region_key, by = "alue_code") %>%
    {if (!all_to_regions) filter(., !is.na(check)) else .} %>%
    select(-check) |>
    select(-any_of(c("alue_name", "alue_code"))) %>%
    rename(alue_code = to_code, alue_name = to_name) %>%
    group_by(across(!all_of(value_cols))) %>%
    summarise(across(all_of(value_cols), sum, na.rm = na.rm), .groups = "drop") %>%
    relocate(names(x))

  if (!is.null(pass_region_codes)){
    y <- bind_rows(
      filter(x, alue_code %in% pass_region_codes),
      y
    ) |>
      droplevels()
  }

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
