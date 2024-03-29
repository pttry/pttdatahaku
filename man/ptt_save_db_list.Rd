% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ptt_save_load.R
\name{ptt_save_db_list}
\alias{ptt_save_db_list}
\alias{ptt_read_db_list}
\title{Save and read database list}
\usage{
ptt_save_db_list(db_list, db_list_name = deparse1(substitute(db_list)))

ptt_read_db_list(db_list_name, create = FALSE)
}
\arguments{
\item{db_list}{A database list.}

\item{db_list_name}{A database list name.}

\item{create}{A logical whether to create in non exits}
}
\description{
Save and read database list
}
\section{Functions}{
\itemize{
\item \code{ptt_read_db_list()}: Read database list.

}}
\examples{
  db_t <- ptt_read_db_list("test_db")

}
