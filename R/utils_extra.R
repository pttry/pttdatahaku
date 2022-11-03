#' To copy to the clipboard aka Ctrl + c
#'
#' To copy an object to the clipboard.
#'
#' To mimic ctrl + c. Currently defined as \code{conc <- function(x)
#' write.table(x, "clipboard-128", sep="\t", dec=",", col.names=NA, row.names =
#' if (is.ts(x)) gsub('\.',",",as.character(time(x))) else TRUE)}
#' @param x An object
#' @export
#' @keywords manip utilities
#' @seealso \code{\link{write.table}}
#' @examples
#'   \dontrun{
#'    x <- data.frame(a = c(1,2), b = c(3,4))
#'    conc(x)
#'   }
conc <- function(x){
  write.table(x, "clipboard-128", sep="\t", dec=",", col.names=NA, row.names = if (is.ts(x)) gsub('\\.',",",as.character(time(x))) else TRUE)
}


#' List of levels of all factors in object
#'
#' Work at least for data.frames
#'
#' @param x an object
#' @export
#' @return Namede list of factory levels.
#' @keywords utilities
alevels <- function(x){
  y <- lapply(x[sapply(x, is.factor)], levels)
  y
}


#' Mutate all character variables to factor with as_factor().
#'
#' @param .data
#'
#' @export
#' @examples
#' df <- data.frame(a = c("a", "b"), b = c(1,2))
#' df <- factor_all(df)
#' str(df)
#'
factor_all <- function(.data){
  dplyr::mutate(.data, dplyr::across(where(is.character), forcats::as_factor))
}

#' Rebase (or base) index
#'
#'
#' @param x a numeric vector. An index to rebase
#' @param time a time variable in a Date format.
#' @param baseyear a numeric year or vector of years.
#' @param basevalue index base values. if NULL value of x at base year.
#'
#' @export
rebase <- function(x, time, baseyear, basevalue = 100) {
  time_year <- if (lubridate::is.Date(time)) lubridate::year(time) else time
  if (is.null(basevalue)) basevalue <- mean(x[time_year %in% baseyear])
  y <- basevalue * x / mean(x[time_year %in% baseyear])
  y
}

#' Calculate percentage change
#'
#' @param x A numeric vector
#' @param n Positive integer of length 1, giving the number of positions to lead or lag by
#' @param order_by Override the default ordering to use another vector or column
#'
#' @export
#' @examples
#' df <- data.frame(time = c(1,2,3,4), x = c(100,101,100,98))
#' dplyr::mutate(df, d = pc(x, 1, time))
#' dplyr::mutate(df, d = pc(x, 1))
pc <- function(x, n, order_by = NULL){
  y <- 100 * (x / dplyr::lag(x, n = n, order_by = order_by) -1)
  y
}



#' Deflate nominal series to real ones
#'
#' Gets a price index and aggregates it, if needed. Then
#' divides the series with the price index and rebase result to base year.
#'
#' Price index available:
#'
#'  * eki Elinkustannusindeksi
#'  * thi Tuottajahintaideksi
#'
#'  For thi index and class have be specified:
#'
#'  index, one of: "Teollisuuden tuottajahintaindeksi",
#'  "Teollisuuden tuottajahintaindeksi, kotimaiset tavarat",
#'  "Teollisuuden tuottajahintaindeksi, vientitavarat",
#'  "Vientihintaindeksi",
#'   "Tuontihintaindeksi",
#'    "Kotimarkkinoiden perushintaindeksi",
#'    "Kotimarkkinoiden perushintaindeksi, kotimaiset tavarat",
#'     "Kotimarkkinoiden perushintaindeksi, tuontitavarat",
#'     "Verollinen kotimarkkinoiden perushintaindeksi",
#'     "Verollinen kotimarkkinoiden perushintaindeksi, kotimaiset tavarat",
#'     "Verollinen kotimarkkinoiden perushintaindeksi, tuontitavarat"
#'
#'   class one of Tuotteet toimialoittain (CPA 2015, MIG) classification
#'
#' @param x A series to deflate
#' @param time A time vector.
#' @param deflator A name of the deflatior. "eki" or "thi".
#' @param series A name of index series for thi.
#' @param class A name of classification for thi
#' @param freq A frequency of `x`.
#' @param baseyear A base year to rebase.
#'
#' @import dplyr
#' @return A numeric vector
#' @export
#'
#' @examples
#' pttrobo::ptt_data_robo("StatFin/ati/statfin_ati_pxt_11zt.px") |>
#'   filter_recode(
#'     tiedot = c("Ansiotaso" = "Ansiotasoindeksi 1964=100")
#'   ) |>
#'     mutate(real = deflate(value, time, deflator = "eki", freq = "q", baseyear = 2015)) |>
#'     tail()
#'
#'  pttrobo::ptt_data_robo(
#'    "tulli/uljas_sitc",
#'    dl_filter = list(
#'      "Tavaraluokitus SITC2" = c("01 (2002--.) Liha ja lihatuotteet"),
#'      "Maa" = "AA",
#'      "Suunta" = c("Tuonti alkuperämaittain"),
#'      "Indikaattorit" = c("Tilastoarvo (euro)"))) |>
#'      mutate(real = deflate(value, time, deflator = "thi",
#'                      index = "Tuontihintaindeksi",
#'                      class = "10.1 Säilötty liha ja lihavalmisteet")) |>
#'    tail()

deflate <- function(x, time, deflator = "eki", index = NULL, class = NULL,
                    freq = "m",
                    baseyear = 2015) {

  series <- list(
    eki = function(index, class) {
      pttrobo::ptt_data_robo("StatFin/khi/statfin_khi_pxt_11xl.px") |>
        filter_recode(tiedot = c("Pisteluku")) |>
        select(time, p_ind = value)
    },
    thi = function(index, class) {
      pttrobo::ptt_data_robo("StatFin/thi/statfin_thi_pxt_118g.px") |>
        filter_recode(
          tuotteet_toimialoittain_cpa_2015_mig = class,
          indeksisarja = c(index),
          tiedot = c("Pisteluku (2015=100)")
        ) |>
        select(time, p_ind = value)
    }
  )

  price_dat <- series[[deflator]](index, class)

  freq_funs <- list(
    m = function(x) x,
    q = function(x){
      x |>
        mutate(time = lubridate::quarter(time, type = "date_first")) |>
        group_by(time) |>
        summarise(p_ind = mean(p_ind)) |>
        ungroup()
    },
    y = function(x){
      x |>
        mutate(time = as.Date(paste0(lubridate::year(time), "-01-01"))) |>
        group_by(time) |>
        summarise(p_ind = mean(p_ind)) |>
        ungroup()

    }
  )

  price_dat <- freq_funs[[freq]](price_dat)

  y = tibble::tibble(value = x, time = time) |>
    dplyr::left_join(price_dat, by = "time") |>
    mutate(value = value / p_ind) |>
    mutate(value =
             rebase(value, time, baseyear = baseyear,
                    basevalue = mean(value[lubridate::year(time) == baseyear])))

  y$value
}

