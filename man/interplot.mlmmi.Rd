% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/Interplot_mlmmi.R
\name{interplot.mlmmi}
\alias{interplot.mlmmi}
\title{Plot Conditional Coefficients in Mixed-Effects Models with Imputed Data and Interaction Terms}
\usage{
\method{interplot}{mlmmi}(m, var1, var2, plot = TRUE, point = FALSE,
  sims = 5000, xmin = NA, xmax = NA)
}
\arguments{
\item{m}{A model object including an interaction term, or, alternately, a data frame recording conditional coefficients.}

\item{var1}{The name (as a string) of the variable of interest in the interaction term; its conditional coefficient estimates will be plotted.}

\item{var2}{The name (as a string) of the other variable in the interaction term.}

\item{plot}{A logical value indicating whether the output is a plot or a dataframe including the conditional coefficient estimates of var1, their upper and lower bounds, and the corresponding values of var2.}

\item{point}{A logical value determining the format of plot. By default, the function produces a line plot when var2 takes on ten or more distinct values and a point (dot-and-whisker) plot otherwise; option TRUE forces a point plot.}

\item{sims}{Number of independent simulation draws used to calculate upper and lower bounds of coefficient estimates: lower values run faster; higher values produce smoother curves.}

\item{xmin}{A numerical value indicating the minimum value shown of x shown in the graph. Rarely used.}

\item{xmax}{A numerical value indicating the maximum value shown of x shown in the graph. Rarely used.}
}
\value{
The function returns a \code{ggplot} object.
}
\description{
\code{interplot.mlmmi} is a method to calculate conditional coefficient estimates from the results of multilevel (mixed-effects) regression models with interaction terms and multiply imputed data.
}
\details{
\code{interplot.mlmmi} is a S3 method from the \code{interplot}. It works on lists of mixed-effects objects with class \code{lmerMod} and \code{glmerMod} generated by \code{mitools} and \code{lme4}.

Because the output function is based on \code{\link[ggplot2]{ggplot}}, any additional arguments and layers supported by \code{ggplot2} can be added with the \code{+}.
}

