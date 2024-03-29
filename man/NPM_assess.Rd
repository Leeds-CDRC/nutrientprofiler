% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/npm-assess.R
\name{NPM_assess}
\alias{NPM_assess}
\title{NPM Assess function}
\usage{
NPM_assess(NPM_score, type)
}
\arguments{
\item{NPM_score, }{a numeric value for the NPM score}

\item{type, }{a character value of either "food" or "drink" to determine how to assess the score}
}
\value{
a character value of either "PASS" or "FAIL"
}
\description{
This function takes an NPM score and returns either "PASS" or "FAIL"
depending on the \code{type} argument. Where \code{type} is either "food" or "drink".
}
