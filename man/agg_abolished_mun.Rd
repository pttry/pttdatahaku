% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/post_process.R
\name{agg_abolished_mun}
\alias{agg_abolished_mun}
\title{Aggregate abolished municipalicities}
\usage{
agg_abolished_mun(x, value_cols = c("values"), n_col = FALSE, na.rm = FALSE)
}
\arguments{
\item{x}{A data.frame like object.}

\item{value_cols}{A character vector of name of columns to aggregate.}

\item{n_col}{A locigal to include number of observations in aggragation}

\item{na.rm}{logical. Should missing values (including NaN) be removed?}
}
\description{
Aggregate abolished municipalicities
}
\examples{
x <- data.frame(
  alue_code = c("KU911", "KU541"),
   alue_name = c("A", "B"), values = c(1,2))
agg_abolished_mun(x)
agg_abolished_mun(x, n_col = TRUE)

}
