% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{merge_across_time}
\alias{merge_across_time}
\title{Merge List of SpatRaster's across time}
\usage{
merge_across_time(data)
}
\arguments{
\item{data}{list of names SpatRasters}
}
\value{
data.frame with (varname, X_name, Y_name, T_name)
}
\description{
Given a list of SpatRasters with possibly shared names, merge across time
}
