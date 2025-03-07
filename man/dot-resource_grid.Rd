% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{.resource_grid}
\alias{.resource_grid}
\title{Extract grid metadata from NC Pointer}
\usage{
.resource_grid(nc, X_name = NULL, Y_name = NULL, stopIfNotEqualSpaced = TRUE)
}
\arguments{
\item{nc}{"NetCDF" object which points to the NetCDF dataset. Found with RNetCDF::open.nc.}

\item{X_name}{Name of X diminsion. If NULL it is found}

\item{Y_name}{Name of Y diminsion. If NULL it is found}

\item{stopIfNotEqualSpaced}{stop if not equal space grid}
}
\value{
list
}
\description{
Extract grid metadata from NC Pointer
}
