% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/transform.R
\name{bbx_reset}
\alias{bbx_reset}
\title{Functions for updating certain coordinates of bbx
These functions can modify a vector of bbx}
\usage{
bbx_reset(bbx, x1 = NULL, y1 = NULL, x2 = NULL, y2 = NULL)
}
\arguments{
\item{bbx}{character vector of bounding boxes to update}

\item{x1}{scalar or numeric vector to update bbx with}

\item{y1}{scalar or numeric vector to update bbx with}

\item{x2}{scalar or numeric vector to update bbx with}

\item{y2}{scalar or numeric vector to update bbx with}
}
\value{
a vector of updated and validated bbxes
}
\description{
Functions for updating certain coordinates of bbx
These functions can modify a vector of bbx
}
\examples{
bbx_reset(bbx=c("100 100 200 200", "300 400 500 600"), x2=800)

}
