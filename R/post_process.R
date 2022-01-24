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
#' @param custom_key A data.frame. Custom classification key in same form as
#'        as key from \code{\link[statficlassifications]{get_regionkey}}.


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
#' agg_regions(x, na.rm = TRUE,
#'             custom_key = data.frame(
#'                kunta_code = c("SSS", "KU049", "KU091", "KU109"),
#'                kunta_name = c("SSS", "KU049", "KU091", "KU109"),
#'                maakunta_code = as.factor(c("SSS", "MK1", "MK1", "MK2")),
#'                maakunta_name = as.factor(c("SSS", "Maakunta1", "Maakunta1", "Maakunta2")))
#'                )
agg_regions <- function(x, from = "kunta", to = "maakunta",
                        value_cols = c("values"),
                        pass_region_codes = NULL, na.rm = FALSE,
                        all_to_regions = TRUE,
                        custom_key = NULL){

  if (is.null(custom_key)){
    region_key <- statficlassifications::get_regionkey(from, to)
  } else {
    region_key <- custom_key
  }

  region_key[paste0(from, "_name")] <- NULL
  region_key <-
    region_key |>
    rename_with(~gsub(paste0("^", from, "_"), "alue_", .x)) |>
    rename_with(~gsub(paste0("^", to, "_"), "to_", .x))


  y <- x %>%
    mutate(check = 1) |>
    right_join(region_key, by = "alue_code") %>%
    {if (!all_to_regions) filter(., !is.na(check)) else .} %>%
    select(-check) |>
    select(-any_of(c("alue_name", "alue_code"))) %>%
    rename(alue_code = to_code, alue_name = to_name) %>%
    group_by(across(!all_of(value_cols))) %>%
    summarise_at(value_cols, sum, na.rm = na.rm) %>%
    ungroup() |>
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
    ungroup() |>
    relocate(names(x))

  y <- add_ptt_attr(y, x)
  y
}


#' Remove columns with unique value.
#'
#'
#' @param data a data.frame with columns with unique values
#'
#' @return data.frame
#' @export
#'
#' @examples
#'  data <- data.frame(var1 = letters[1:10],
#'                     var2 = rnorm(10),
#'                     var3 = "a")
#'
#'  data <- rm_empty_cols(data)
rm_empty_cols <- function(data) {

  data[,sapply(names(data), function(x) {length(unique(data[[x]])) > 1})]

}

#' Select columns and filter SSS from columns not selected
#'
#' Only removes columns that contain variable SSS. Note that the data has
#' to have codes.
#'
#' @param data data.frame to modify
#' @param ... chr, column names to select
#' @param SSS logical, whether to leave SSS to selected columns
#'
#' @return data.frame
#' @export
#'
#' @examples
#' data <- cbind(tidyr::crossing(var1 = c("SSS", 1, 2),
#'                        var2 = c("SSS", "a", "b"),
#'                        var3 = c("SSS", "c", "d")),
#'               value = rnorm(27))
#' data |> ptt_select(var3, value)
#' data |> ptt_select(var2, var3, value)
#'
ptt_select <- function(data, ..., SSS = FALSE) {

  sel_cols <- sapply(substitute(list(...)), deparse)[-1]

  if(any(!sel_cols %in% names(data))) {
    stop(paste(sel_cols[!sel_cols %in% names(data)], "not in the data."))
  }

  not_sel_cols <- names(data)[!names(data) %in% sel_cols]

  for(col in not_sel_cols[!not_sel_cols %in% c("time", "value")]) {
    data <- data[data[[col]] == "SSS",]
  }

  if(!SSS) {
    for(col in sel_cols[!sel_cols %in% c("time", "value")]) {
      data <- data[data[[col]] != "SSS",]
    }
  }

  rm_empty_cols(data)
}


#' Aggregate based on key
#'
#' @param x A data.frame like object.
#' @param by A character vector of variables to join by.
#' @param na.rm	logical. Should missing values (including NaN) be removed?
#' @param key A data.frame. A classification key in same form as
#'        as key from \code{\link[statficlassifications]{get_regionkey}}.
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
#' agg_key(x, na.rm = TRUE,
#'             key = data.frame(
#'                alue_code = c("SSS", "KU049", "KU091", "KU109"),
#'                maakunta_name = c("SSS", "Maakunta1", "Maakunta1", "Maakunta2"))
#'                )
agg_key <- function(x, by = NULL,
                        value_cols = c("values", "value"),
                         na.rm = FALSE,
                        all_to_regions = TRUE,
                        key = NULL){

# Value_cols
  value_cols <- intersect(value_cols, names(x))
  if (is.null(value_cols)) rlang::abort("values_cols must be specified")


# by = NULL, copied from dplyr standardise_join_by
  if (is.null(by)) {
    by <- intersect(names(x), names(key))
    if (length(by) == 0) {
      rlang::abort(c("`by` must be supplied when `x` and `key` have no common variables.",
              i = "use by = character()` to perform a cross-join."))
    }

  }

  # region_key[paste0(from, "_name")] <- NULL
  # region_key <-
  #   region_key |>
  #   rename_with(~gsub(paste0("^", from, "_"), "alue_", .x)) |>
  #   rename_with(~gsub(paste0("^", to, "_"), "to_", .x))

# join
  y <- x %>%
    mutate(check = 1) |>
    right_join(key, by = by)

#check join
    check_na <- which(is.na(y[["check"]]))
    if (any(check_na)) {
      message("Data includes classes not in key. Key missing for rows: ",
              paste(check_na, collapse = ", "))
      }

  y <- y |>
    select(-check) |>
    select(-all_of(by)) |>
    group_by(across(!any_of(value_cols))) |>
    summarise_at(value_cols, sum, na.rm = na.rm) |>
    ungroup()

  # if (!is.null(pass_codes)){
  #   y <- bind_rows(
  #     filter(x, alue_code %in% pass_codes),
  #     y
  #   ) |>
  #     droplevels()
  # }

  y <- add_ptt_attr(y, x)
  y
}
