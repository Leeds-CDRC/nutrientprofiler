% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/npm-scoring.R
\name{NPM_score_function}
\alias{NPM_score_function}
\title{The NPM scoring dispatch function}
\usage{
NPM_score_function(value, type, ...)
}
\arguments{
\item{value, }{a numeric value or vector of values to score against}

\item{type, }{a character string that specifies the type of the value passed to control scoring logic}

\item{..., }{option named arguments to pass to adjuster functions, most commonly \code{adjusted_weight}}
}
\value{
a numeric score value or vector of scores
}
\description{
This function serves as the main entry point for getting
nutrient profiling model scores. It takes a value (or vector of values) and a type
using the type it determines which scoring function to use based on constant thresholds.
Adjustments to the value passed are also performed for all types except \code{fvn}.
These adjustments take into account the adjusted_weight of the product (specific gravity transformations)
and calculate a new value which is applied to the scoring thresholds.
\code{...} is provided to allow the passing of additional arguments for adjuster functions.
This code is based off the logic within https://github.com/Leeds-CDRC/NPM-Calculator/blob/main/server.R
}
