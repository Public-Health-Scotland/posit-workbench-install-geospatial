#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#
# The following script assumes that '.Rprofile' has been sourced.
#
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

# 0 Create flag for whether 'renv' is enabled or not ----
renv_enabled = FALSE
capture.output(tmp <- renv::status()$lockfile, file = "/dev/null")
if(length(tmp) > 0){
  renv_enabled = TRUE
}
rm(tmp)

# 1 Remove geospatial packages and their dependencies ----

# List of geospatial packages that will be installed
geo_pkgs <- c("leaflet", "rgdal", "raster", "sp", "terra", "sf")

# List of geospatial package dependencies
geo_deps <- unique(
  unlist(tools::package_dependencies(packages = geo_pkgs,
                                     recursive = TRUE)))

# Remove geospatial packages and their dependencies
pkgs_to_remove <- unique(unlist(c(geo_pkgs, geo_deps)))
remove.packages(pkgs_to_remove)

# If 'renv' is enabled, purge the cache
if(renv_enabled == TRUE){
  lapply(pkgs_to_remove, renv::purge, prompt = FALSE)
}

# 2 Install the 'parallelly' package and identify number of CPUs available ----

# The parallelly package allows the number of CPUs available to a Posit
# Workbench session running in Kubernetes to be correctly identified.

# Remove 'parallelly' if it is already installed
remove.packages("parallelly")

# If 'renv' is enabled, purge the cache
if(renv_enabled == TRUE){
  renv::purge("parallelly", prompt = FALSE)
}

# Install the 'parallelly' package
install.packages("parallelly", repos = getOption("repos")[["binaries"]])

# If 'renv' is enabled, update the lockfile
if(renv_enabled == TRUE){
  renv::snapshot(repos = getOption("repos")[["binaries"]],
                 packages = c("parallelly"),
                 update = TRUE,
                 prompt = FALSE)
}

# Identify number of CPUs available
ncpus <- as.numeric(parallelly::availableCores())

# 3 Install geospatial package dependencies that can be installed as binaries ----

# Get list of geospatial package dependencies that can be installed as binaries
geo_deps_bin <- sort(setdiff(geo_deps, geo_pkgs))

# Install these as binaries
install.packages(pkgs = geo_deps_bin,
                 repos = getOption("repos")[["binaries"]],
                 Ncpus = ncpus)

# If 'renv' is enabled, update the lockfile
if(renv_enabled == TRUE){
  renv::snapshot(repos = getOption("repos")[["binaries"]],
                 packages = geo_deps_bin,
                 update = TRUE,
                 prompt = FALSE)
}

# 4 Install geospatial packages from source ----

geo_config_args <- c("--with-gdal-config=/usr/gdal34/bin/gdal-config",
                     "--with-proj-include=/usr/proj81/include",
                     "--with-proj-lib=/usr/proj81/lib",
                     "--with-geos-config=/usr/geos311/bin/geos-config")

## 4.1 Install the 'sf' package ----

install.packages("sf",
                 configure.args = geo_config_args,
                 INSTALL_opts = "--no-test-load",
                 repos = getOption("repos")[["source"]],
                 Ncpus = ncpus)

# If 'renv' is enabled, update the lockfile
if(renv_enabled == TRUE){
  renv::snapshot(repos = getOption("repos")[["source"]],
                 packages = c("sf"),
                 update = TRUE,
                 prompt = FALSE)
}

## 4.2 Install the 'terra' package ----

install.packages("terra",
                 configure.args = geo_config_args,
                 INSTALL_opts = "--no-test-load",
                 repos = getOption("repos")[["source"]],
                 Ncpus = ncpus)

# If 'renv' is enabled, update the lockfile
if(renv_enabled == TRUE){
  renv::snapshot(repos = getOption("repos")[["source"]],
                 packages = c("terra"),
                 update = TRUE,
                 prompt = FALSE)
}

## 4.3 Install the 'sp' package ----

install.packages("sp",
                 configure.args = geo_config_args,
                 INSTALL_opts = "--no-test-load",
                 repos = getOption("repos")[["source"]],
                 Ncpus = ncpus)

# If 'renv' is enabled, update the lockfile
if(renv_enabled == TRUE){
  renv::snapshot(repos = getOption("repos")[["source"]],
                 packages = c("sp"),
                 update = TRUE,
                 prompt = FALSE)
}

## 4.4 Install the 'raster' package ----

install.packages("https://packagemanager.rstudio.com/cran/latest/src/contrib/Archive/raster/raster_2.5-8.tar.gz",
                 repos = NULL,
                 type = "source",
                 configure.args = geo_config_args,
                 INSTALL_opts = "--no-test-load",
                 Ncpus = ncpus)

# If 'renv' is enabled, update the lockfile
if(renv_enabled == TRUE){
  renv::snapshot(repos = getOption("repos")[["source"]],
                 packages = c("raster"),
                 update = TRUE,
                 prompt = FALSE)
}

## 4.5 Install the 'rgdal' package ----

install.packages("https://packagemanager.rstudio.com/cran/latest/src/contrib/Archive/rgdal/rgdal_1.5-25.tar.gz",
                 repos = NULL,
                 type = "source",
                 configure.args = geo_config_args,
                 INSTALL_opts = "--no-test-load",
                 Ncpus = ncpus)

# If 'renv' is enabled, update the lockfile
if(renv_enabled == TRUE){
  renv::snapshot(repos = getOption("repos")[["source"]],
                 packages = c("rgdal"),
                 update = TRUE,
                 prompt = FALSE)
}

## 4.6 Install the 'leaflet' package ----

install.packages("leaflet",
                 repos = getOption("repos")[["binaries"]],
                 Ncpus = ncpus)

# If 'renv' is enabled, update the lockfile
if(renv_enabled == TRUE){
  renv::snapshot(repos = getOption("repos")[["binaries"]],
                 packages = c("leaflet"),
                 update = TRUE,
                 prompt = FALSE)
}

# 5 Load geospatial libraries ----

dyn.load("/usr/gdal34/lib/libgdal.so")
dyn.load("/usr/geos311/lib64/libgeos_c.so", local = FALSE)
library(sf)
library(terra)
library(sp)
library(raster)
library(rgdal)
library(leaflet)
