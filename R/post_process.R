#' Aggregate abolished municipalicities
#'
#' @param x A data.frame like object.
#' @export
#'
#' x <- tibble(alue_code = c("KU911", "KU541"), alue_name = c("A", "B"), values = c(1,2))
#'
agg_abolished_mun <- function(x){
  y <- x %>%
    statficlassifications::join_abolished_mun("alue_code") %>%
    select(!alue_name) %>%
    group_by(across(!values)) %>%
    summarise(values = sum(values), .groups = "drop") %>%
    mutate(alue_name = statficlassifications::codes_to_names(alue_code)) %>%
    relocate(names(x))

  y <- add_ptt_attr(x, y)
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
  dat
}
