#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#
# Everything from here onwards should be included and run in any project using
# geospatial R packages
#
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

# 1 Define repos to install packages from ----

options(repos = c(binaries = "https://ppm.publichealthscotland.org/all-r/__linux__/centos7/latest",
                  source = "https://ppm.publichealthscotland.org/all-r/latest"))

# 2 Set environment variables to point to installations of geospatial libraries ----

## 2.1 Amend 'LD_LIBRARY_PATH' ----

# Get the existing value of 'LD_LIBRARY_PATH'
old_ld_path <- Sys.getenv("LD_LIBRARY_PATH") 

# Append paths to GDAL and PROJ to 'LD_LIBRARY_PATH'
Sys.setenv(LD_LIBRARY_PATH = paste(old_ld_path,
                                   "/usr/gdal34/lib",
                                   "/usr/proj81/lib",
                                   sep = ":"))

## 2.2 Specify additional proj path in which pkg-config should look for .pc files ----

Sys.setenv("PKG_CONFIG_PATH" = "/usr/proj81/lib/pkgconfig")

## 2.3 Specify the path to GDAL data ----

Sys.setenv("GDAL_DATA" = "/usr/gdal34/share/gdal")


