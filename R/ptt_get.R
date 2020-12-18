#' Get PTT data from statfi
#'
#' @param url
#' @param query
#'
#' @importFrom pxweb as.data.frame.pxweb_data
#' @import dplyr
#' @export
#'
#' @example
#'   url = "http://pxnet2.stat.fi/PXWeb/api/v1/fi/StatFin/kou/vkour/statfin_vkour_pxt_12bq.px"
#'   query <-
#'     list("Vuosi"=c("1970","1975"),
#'          "Alue"=c("SSS","KU020","KU005"),
#'          "Ikä"=c("SSS","15-19"),
#'          "Sukupuoli"=c("SSS","1","2"),
#'          "Koulutusaste"=c("SSS","3T8"),
#'          "Tiedot"=c("vaesto"))
#'
#'   pp <- ptt_get_statfi(url, query)
#'
ptt_get_statfi <- function(url, query){
  px_data <- pxweb::pxweb_get(url = url, query = query)
  px_df <- as.data.frame(px_data, column.name.type = "code",
                         variable.value.type = "code")
  # Täytyy korvata
  px_df <- statfitools::clean_times(px_df)

  px_df <- px_df %>%
    mutate(across(where(is.character),
                  ~forcats::as_factor(pxweb:::pxd_values_to_valuetexts(px_data,
                                                    variable_code = cur_column(),
                                                    .x)),
                  .names = "{.col}_name"))

  px_df
}
