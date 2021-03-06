#' Plot Conditional Coefficients in (Generalized) Linear Models with Imputed Data and Interaction Terms
#' 
#' \code{interplot.mi} is a method to calculate conditional coefficient estimates from the results of (generalized) linear regression models with interaction terms and multiply imputed data.
#' 
#' @param m A model object including an interaction term, or, alternately, a data frame recording conditional coefficients.
#' @param var1 The name (as a string) of the variable of interest in the interaction term; its conditional coefficient estimates will be plotted.
#' @param var2 The name (as a string) of the other variable in the interaction term.
#' @param plot A logical value indicating whether the output is a plot or a dataframe including the conditional coefficient estimates of var1, their upper and lower bounds, and the corresponding values of var2.
#' @param point A logical value determining the format of plot. By default, the function produces a line plot when var2 takes on ten or more distinct values and a point (dot-and-whisker) plot otherwise; option TRUE forces a point plot.
#' @param sims Number of independent simulation draws used to calculate upper and lower bounds of coefficient estimates: lower values run faster; higher values produce smoother curves.
#' @param xmin A numerical value indicating the minimum value shown of x shown in the graph. Rarely used.
#' @param xmax A numerical value indicating the maximum value shown of x shown in the graph. Rarely used.
#' 
#' @details \code{interplot} is a S3 method from the \code{interplot}. It can visualize the changes in the coefficient of one term in a two-way interaction conditioned by the other term. This function can work on interactions from results in the class of \code{list}.
#' 
#' Because the output function is based on \code{\link[ggplot2]{ggplot}}, any additional arguments and layers supported by \code{ggplot2} can be added with the \code{+}. 
#' 
#' @return The function returns a \code{ggplot} object.
#' 
#' @import  abind
#' @import  arm
#' @import  ggplot2
#' 
#' 
#' @export

# Coding function for non-mlm mi objects
interplot.lmmi <- function(m, var1, var2, plot = TRUE, point = FALSE, sims = 5000, 
                           xmin = NA, xmax = NA) {
    set.seed(324)
    
    class(m) <- "list"
    m.list <- m
    m <- m.list[[1]]
    m.class <- class(m)
    m.sims.list <- lapply(m.list, function(i) arm::sim(i, sims))
    m.sims <- m.sims.list[[1]]
    
    for (i in 2:length(m.sims.list)) {
        m.sims@coef <- rbind(m.sims@coef, m.sims.list[[i]]@coef)
    }
    
    ifelse(var1 == var2, var12 <- paste0("I(", var1, "^2)"), var12 <- paste0(var2, 
        ":", var1))
    
    if (!var12 %in% names(m$coef)) 
        var12 <- paste0(var1, ":", var2)
    if (!var12 %in% names(m$coef)) 
        stop(paste("Model does not include the interaction of", var1, "and", 
            var2, "."))
    if (is.na(xmin)) 
        xmin <- min(m$model[var2], na.rm = T)
    if (is.na(xmax)) 
        xmax <- max(m$model[var2], na.rm = T)

    steps <- eval(parse(text = paste0("length(unique(na.omit(m$model$",var2,")))")))
    if (steps > 100) steps <- 100 # avoid redundant calculation

    coef <- data.frame(fake = seq(xmin, xmax, length.out = steps), coef1 = NA, 
        ub = NA, lb = NA)
    
    for (i in 1:steps) {
        coef$coef1[i] <- mean(m.sims@coef[, match(var1, names(m$coef))] + 
            coef$fake[i] * m.sims@coef[, match(var12, names(m$coef))])
        coef$ub[i] <- quantile(m.sims@coef[, match(var1, names(m$coef))] + 
            coef$fake[i] * m.sims@coef[, match(var12, names(m$coef))], 0.975)
        coef$lb[i] <- quantile(m.sims@coef[, match(var1, names(m$coef))] + 
            coef$fake[i] * m.sims@coef[, match(var12, names(m$coef))], 0.025)
    }
    
    if (plot == TRUE) {
        interplot.plot(m = coef, point = point)
    } else {
        names(coef) <- c(var2, "coef", "ub", "lb")
        return(coef)
    }
}


interplot.glmmi <- function(m, var1, var2, plot = TRUE, point = FALSE, sims = 5000, 
                            xmin = NA, xmax = NA) {
    set.seed(324)
    
    class(m) <- "list"
    m.list <- m
    m <- m.list[[1]]
    m.class <- class(m)
    m.sims.list <- lapply(m.list, function(i) arm::sim(i, sims))
    m.sims <- m.sims.list[[1]]
    
    for (i in 2:length(m.sims.list)) {
        m.sims@coef <- rbind(m.sims@coef, m.sims.list[[i]]@coef)
    }
    
    ifelse(var1 == var2, var12 <- paste0("I(", var1, "^2)"), var12 <- paste0(var2, 
        ":", var1))
    
    if (!var12 %in% names(m$coef)) 
        var12 <- paste0(var1, ":", var2)
    if (!var12 %in% names(m$coef)) 
        stop(paste("Model does not include the interaction of", var1, "and", 
            var2, "."))
    if (is.na(xmin)) 
        xmin <- min(m$model[var2], na.rm = T)
    if (is.na(xmax)) 
        xmax <- max(m$model[var2], na.rm = T)
    
    steps <- eval(parse(text = paste0("length(unique(na.omit(m$model$",var2,")))")))
    if (steps > 100) steps <- 100 # avoid redundant calculation

    coef <- data.frame(fake = seq(xmin, xmax, length.out = steps), coef1 = NA, 
        ub = NA, lb = NA)
    
    for (i in 1:steps) {
        coef$coef1[i] <- mean(m.sims@coef[, match(var1, names(m$coef))] + 
            coef$fake[i] * m.sims@coef[, match(var12, names(m$coef))])
        coef$ub[i] <- quantile(m.sims@coef[, match(var1, names(m$coef))] + 
            coef$fake[i] * m.sims@coef[, match(var12, names(m$coef))], 0.975)
        coef$lb[i] <- quantile(m.sims@coef[, match(var1, names(m$coef))] + 
            coef$fake[i] * m.sims@coef[, match(var12, names(m$coef))], 0.025)
    }
    
    if (plot == TRUE) {
        interplot.plot(m = coef, point = point)
    } else {
        names(coef) <- c(var2, "coef", "ub", "lb")
        return(coef)
    }
} 
