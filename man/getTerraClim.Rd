% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/shortcuts.R
\name{getTerraClim}
\alias{getTerraClim}
\title{Get Terra Climate Data for an Area of Interest}
\usage{
getTerraClim(
  AOI,
  varname = NULL,
  startDate = NULL,
  endDate = NULL,
  verbose = FALSE,
  dryrun = FALSE
)
}
\arguments{
\item{AOI}{an sf point or polygon to extract data for}

\item{varname}{variable name to extract (e.g. tmin)}

\item{startDate}{a start date given as "YYYY-MM-DD" to extract data for}

\item{endDate}{an end date given as "YYYY-MM-DD" to extract data for}

\item{verbose}{Should messages be emited?}

\item{dryrun}{Return summary of data prior to retrieving it}
}
\value{
if AOI is polygon a list of SpatRasters, if AOI is a point then a data.frame of modeled records.
}
\description{
Get Terra Climate Data for an Area of Interest
}
