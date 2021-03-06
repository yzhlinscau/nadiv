% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/LRTest.R
\name{LRTest}
\alias{LRTest}
\title{log-Likelihood Ratio Test}
\usage{
LRTest(full, reduced, df = 1, boundaryCorrection = FALSE)
}
\arguments{
\item{full}{A numeric variable indicating the log-likelihood of the full
model}

\item{reduced}{A numeric variable indicating the log-likelihood of the
reduced model}

\item{df}{The number of degrees of freedom to use, representing the
difference between the full and reduced model in the number of parameters
estimated}

\item{boundaryCorrection}{A logical argument indicating whether a boundary
correction under one degree of freedom should be included. If the parameter
that is dropped from the reduced model is estimated at the boundary of its
parameter space in the full model, the boundary correction is often
required. See Details for more.}
}
\value{
a \code{list}:
  \describe{
    \item{lambda }{a numeric log-likelihood ratio test statistic}
    \item{Pval }{a numeric p-value given the \code{lambda} tested against a
      chi-squared distribution with the number of degrees of freedom as
      specified. May have had a boundary correction applied.} 
    \item{corrected.Pval }{a logical indicating if the p-value was derived 
      using a boundary correction. See \code{Details}}
  }
}
\description{
Test the null hypothesis that the two models fit the data equally well.
}
\details{
Boundary correction should be applied if the parameter that is dropped from
the full model was on the boundary of its parameter space. In this instance,
the distribution of the log-likelihood ratio test statistic is approximated
by a mix of chi-square distributions (Self and Liang 1987). A \code{TRUE}
value will implement the boundary correction for a one degree of freedom
test. This is equivalent to halving the p-value from a test using a
chi-square distribution with one degree of freedom (Dominicus et al. 2006).

Currently, the test assumes that both log-likelihoods are negative or both
are positive and will stop if they are of opposite sign. The interpretation
is that the model with a greater negative log-likelihood (closer to zero) or
greater positive log-likelihood provides a better fit to the data.
}
\examples{

# No boundary correction
(noBC <- LRTest(full = -2254.148, reduced = -2258.210,
	df = 1, boundaryCorrection = FALSE))
# No boundary correction
(withBC <- LRTest(full = -2254.148, reduced = -2258.210,
	df = 1, boundaryCorrection = TRUE))
stopifnot(noBC$Pval == 2*withBC$Pval)

}
\references{
Self, S. G., and K. Y. Liang. 1987. Asymptotic properties of
maximum likelihood estimators and likelihood ratio tests under nonstandard
conditions. Journal of the American Statistical Association 82:605-610.

Dominicus, A., A. Skrondal, H. K. Gjessing, N. L. Pedersen, and J. Palmgren.
2006. Likelihood ratio tests in behavioral genetics: problems and solutions.
Behavior Genetics 36:331-340.
}
\seealso{
\code{\link{constrainFun}}
}
\author{
\email{matthewwolak@gmail.com}
}
