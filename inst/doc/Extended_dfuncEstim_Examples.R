## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

## -----------------------------------------------------------------------------
library(Rdistance)
data("sparrowDetectionData")
data("sparrowSiteData")

## -----------------------------------------------------------------------------
dfunc <- dfuncEstim(formula = dist ~ 1
                  , detectionData = sparrowDetectionData
                  , w.hi = units::set_units(100, "m"))
dfunc
plot(dfunc, col="grey")

## -----------------------------------------------------------------------------
dfunc <- dfuncEstim(formula = dist ~ groupsize(groupsize)
                  , detectionData = sparrowDetectionData
                  , w.hi = units::set_units(100, "m"))
dfunc
plot(dfunc, col="grey")

## -----------------------------------------------------------------------------
dfuncObs <- dfuncEstim(formula = dist ~ observer
                     , detectionData = sparrowDetectionData
                     , siteData = sparrowSiteData
                     , w.hi = units::set_units(100, "m")
                     , control=RdistanceControls(maxIter=1000))
dfuncObs
plot(dfuncObs, col="grey")

## -----------------------------------------------------------------------------
dfuncObs <- dfuncEstim(formula = dist ~ observer + groupsize(groupsize)
                     , likelihood = "hazrate"
                     , detectionData = sparrowDetectionData
                     , siteData = sparrowSiteData
                     , w.hi = units::set_units(100, "m"))
dfuncObs
plot(dfuncObs, col="grey")

## -----------------------------------------------------------------------------
dfunc <- dfuncEstim(formula = dist ~ observer + groupsize(groupsize)
                     , likelihood = "hazrate"
                     , detectionData = sparrowDetectionData
                     , siteData = sparrowSiteData
                     , w.lo = units::set_units(20, "m")
                     , x.scl = units::set_units(20, "m")
                     , w.hi = units::set_units(100, "m"))
dfunc
plot(dfunc, col="grey")

## -----------------------------------------------------------------------------
dfunc <- dfuncEstim(formula = dist ~ observer + groupsize(groupsize)
                     , likelihood = "hazrate"
                     , detectionData = sparrowDetectionData
                     , siteData = sparrowSiteData
                     , g.x.scl = 0.8)
dfunc
plot(dfunc, col="grey")

