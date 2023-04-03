#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#
# The following script assumes that '.Rprofile' has been sourced.
#
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

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

# 2 Install the 'parallelly' package and identify number of CPUs available ----

# The parallelly package allows the number of CPUs available to a Posit
# Workbench session running in Kubernetes to be correctly identified.

# Remove 'parallelly' if it is already installed
remove.packages("parallelly")

# Install the 'parallelly' package
install.packages("parallelly", repos = getOption("repos")[["binaries"]])

# Identify number of CPUs available
ncpus <- as.numeric(parallelly::availableCores())

# 3 Install geospatial package dependencies that can be installed as binaries ----

# Get list of geospatial package dependencies that can be installed as binaries
geo_deps_bin <- sort(setdiff(geo_deps, geo_pkgs))

# Remove packages that are already installed from the list of geospatial package dependencies
geo_deps_bin <- sort(setdiff(geo_deps_bin, as.data.frame(installed.packages())$Package))

# Install these as binaries
install.packages(pkgs = geo_deps_bin,
                 repos = getOption("repos")[["binaries"]],
                 Ncpus = ncpus)

# 4 Install geospatial packages from source ----

geo_config_args <- c("--with-gdal-config=/usr/gdal34/bin/gdal-config",
                     "--with-proj-include=/usr/proj81/include",
                     "--with-proj-lib=/usr/proj81/lib",
                     "--with-geos-config=/usr/geos310/bin/geos-config")

## 4.1 Install the 'sf' package ----

install.packages("sf",
                 configure.args = geo_config_args,
                 INSTALL_opts = "--no-test-load",
                 repos = getOption("repos")[["source"]],
                 Ncpus = ncpus)

## 4.2 Install the 'terra' package ----

install.packages("terra",
                 configure.args = geo_config_args,
                 INSTALL_opts = "--no-test-load",
                 repos = getOption("repos")[["source"]],
                 Ncpus = ncpus)

## 4.3 Install the 'sp' package ----

install.packages("sp",
                 configure.args = geo_config_args,
                 INSTALL_opts = "--no-test-load",
                 repos = getOption("repos")[["source"]],
                 Ncpus = ncpus)

## 4.4 Install the 'raster' package ----

install.packages("https://packagemanager.rstudio.com/cran/latest/src/contrib/Archive/raster/raster_2.5-8.tar.gz",
                 repos = NULL,
                 type = "source",
                 configure.args = geo_config_args,
                 INSTALL_opts = "--no-test-load",
                 Ncpus = ncpus)

## 4.5 Install the 'rgdal' package ----

install.packages("https://packagemanager.rstudio.com/cran/latest/src/contrib/Archive/rgdal/rgdal_1.5-25.tar.gz",
                 repos = NULL,
                 type = "source",
                 configure.args = geo_config_args,
                 INSTALL_opts = "--no-test-load",
                 Ncpus = ncpus)

## 4.6 Install the 'leaflet' package ----

install.packages("leaflet",
                 repos = getOption("repos")[["binaries"]],
                 Ncpus = ncpus)

# 5 Load geospatial libraries ----

dyn.load("/usr/gdal34/lib/libgdal.so")
dyn.load("/usr/geos310/lib64/libgeos_c.so", local = FALSE)
library(sf)
library(terra)
library(sp)
library(raster)
library(rgdal)
library(leaflet)
