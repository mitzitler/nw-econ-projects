library(tidyverse)
library(readr)
library(readxl)
library(openxlsx)
library(xlsx)
install.packages("gdata")
library(gdata)

getwd()
setwd("/Users/mitzizitler/SEM/SEM Dropbox Uploads")

### Total Wind Load
#
#

# 2007
totalwindload_5min_07 <- read.xls(file.path("/Users/mitzizitler/SEM/SEM Dropbox Uploads/TotalWindLoad_5Min_07_02.xls"),
                                 method = "csv")

twl_5min_07_1 <- totalwindload_5min_07 %>%
  select(1:7) %>%
  rename("Wind Generation" = "TOTAL.WIND.GENERATION..IN.BPA.CONTROL.AREA..MW..SCADA.79687.",
         "BPA Generation" = "TOTAL.BPA.CONTROL.AREA.LOAD..MW..SCADA.45583.",
         "Hydro Generation" = "Total.Hydro.Generation..MW..SCADA.79682.",
         "Thermal Generation" = "Total.Thermal.Generation..MW..SCADA.79685.",
         "Net Interchange" = "NET.INTERCHANGE..MW..SCADA.45581.")

twl_5min_07_2 <- totalwindload_5min_07 %>%
  select(8:14) %>%
  rename("Month" = "Month.1",
         "DateTime" = "DateTime.1",
         "Wind Generation" = "TOTAL.WIND.GENERATION..IN.BPA.CONTROL.AREA..MW..SCADA.79687..1",
         "BPA Generation" = "TOTAL.BPA.CONTROL.AREA.LOAD..MW..SCADA.45583..1",
         "Hydro Generation" = "Total.Hydro.Generation..MW..SCADA.79682..1",
         "Thermal Generation" = "Total.Thermal.Generation..MW..SCADA.79685..1",
         "Net Interchange" = "NET.INTERCHANGE..MW..SCADA.45581..1")

twl_5min_07_tot <- twl_5min_07_1 %>%
  rbind(twl_5min_07_2)

twl_5min_07_tot[,"Wind Generation Basepoint Forecast"] <- NA
twl_5min_07_tot <- twl_5min_07_tot %>%
  select(1, 2, 3, 8, 4, 5, 6, 7)

twl_5min_07_sum <- totalwindload_5min_07 %>%
  select(16:20)


# 2008
totalwindload_5min_08 <- read.xls(file.path("/Users/mitzizitler/SEM/SEM Dropbox Uploads/TotalWindLoad_5Min_08_2.xls"),
                                 method = "csv")

twl_5min_08_1 <- totalwindload_5min_08 %>%
  select(1:8) %>%
  rename("Wind Generation" = "TOTAL.WIND.GENERATION..IN.BPA.CONTROL.AREA..MW..SCADA.79687.",
         "Wind Generation Basepoint Forecast" = "TOTAL.WIND.GENERATION..BASEPOINT..FORECAST..IN.BPA.CONTROL.AREA..MW..SCADA.103349.",
         "BPA Generation" = "TOTAL.BPA.CONTROL.AREA.LOAD..MW..SCADA.45583.",
         "Hydro Generation" = "Total.Hydro.Generation..MW..SCADA.79682.",
         "Thermal Generation" = "Total.Thermal.Generation..MW..SCADA.79685.",
         "Net Interchange" = "NET.INTERCHANGE..MW..SCADA.45581.")

twl_5min_08_2 <- totalwindload_5min_08 %>%
  select(9:17) %>%
  rename("Month" = "Month.1",
         "DateTime" = "DateTime.1",
         "Wind Generation" = "TOTAL.WIND.GENERATION..IN.BPA.CONTROL.AREA..MW..SCADA.79687..1",
         "Wind Generation Basepoint Forecast" = "TOTAL.WIND.GENERATION..BASEPOINT..FORECAST..IN.BPA.CONTROL.AREA..MW..SCADA.103349..1",
         "BPA Generation" = "TOTAL.BPA.CONTROL.AREA.LOAD..MW..SCADA.45583..1",
         "Hydro Generation" = "Total.Hydro.Generation..MW..SCADA.79682..1",
         "Thermal Generation" = "Total.Thermal.Generation..MW..SCADA.79685..1",
         "Net Interchange" = "NET.INTERCHANGE..MW..SCADA.45581..1") %>%
  select(2:9)

twl_5min_08_tot <- rbind(twl_5min_08_1, twl_5min_08_2)

twl_5min_08_sum <- totalwindload_5min_08 %>%
  select(19:23)


# 2009
totalwindload_5min_09 <- read.xls(file.path("/Users/mitzizitler/SEM/SEM Dropbox Uploads/TotalWindLoad_5Min_09_3.xls"),
                                  method = "csv")

twl_5min_09_1 <- totalwindload_5min_09 %>%
  select(1:8) %>%
  rename("Wind Generation" = "TOTAL.WIND.GENERATION..IN.BPA.CONTROL.AREA..MW..SCADA.79687.",
         "Wind Generation Basepoint Forecast" = "TOTAL.WIND.GENERATION..BASEPOINT..FORECAST..IN.BPA.CONTROL.AREA..MW..SCADA.103349.",
         "BPA Generation" = "TOTAL.BPA.CONTROL.AREA.LOAD..MW..SCADA.45583.",
         "Hydro Generation" = "TOTAL.HYDRO.GENERATION..MW..SCADA.79682.",
         "Thermal Generation" = "TOTAL.THERMAL.GENERATION..MW..SCADA.79685.",
         "Net Interchange" = "NET.INTERCHANGE..MW..SCADA.45581.")

twl_5min_09_2 <- totalwindload_5min_09 %>%
  select(10:17) %>%
  rename("Month" = "Month.1",
         "DateTime" = "DateTime.1",
         "Wind Generation" = "TOTAL.WIND.GENERATION..IN.BPA.CONTROL.AREA..MW..SCADA.79687..1",
         "Wind Generation Basepoint Forecast" = "TOTAL.WIND.GENERATION..BASEPOINT..FORECAST..IN.BPA.CONTROL.AREA..MW..SCADA.103349..1",
         "BPA Generation" = "TOTAL.BPA.CONTROL.AREA.LOAD..MW..SCADA.45583..1",
         "Hydro Generation" = "TOTAL.HYDRO.GENERATION..MW..SCADA.79682..1",
         "Thermal Generation" = "TOTAL.THERMAL.GENERATION..MW..SCADA.79685..1",
         "Net Interchange" = "NET.INTERCHANGE..MW..SCADA.45581..1") 

twl_5min_09_tot <- rbind(twl_5min_09_1, twl_5min_09_2)
twl_5min_09_tot <- twl_5min_09_tot %>%
  select(1, 2, 4, 3, 5, 6, 7, 8)

twl_5min_08_sum_NEEDTOFIX <- totalwindload_5min_09 %>%
  select(19:29)

# 2010
totalwindload_5min_10 <- read.xls(file.path("/Users/mitzizitler/SEM/SEM Dropbox Uploads/TotalWindLoad_5Min_10_2.xls"),
                                  method = "csv")

twl_5min_10_1 <- totalwindload_5min_10 %>%
  select(1:8) %>%
  rename("Wind Generation" = "TOTAL.WIND.GENERATION..IN.BPA.CONTROL.AREA..MW..SCADA.79687.",
         "Wind Generation Basepoint Forecast" = "TOTAL.WIND.GENERATION..BASEPOINT..FORECAST..IN.BPA.CONTROL.AREA..MW..SCADA.103349.",
         "BPA Generation" = "TOTAL.BPA.CONTROL.AREA.LOAD..MW..SCADA.45583.",
         "Hydro Generation" = "TOTAL.HYDRO.GENERATION..MW..SCADA.79682.",
         "Thermal Generation" = "TOTAL.THERMAL.GENERATION..MW..SCADA.79685.",
         "Net Interchange" = "NET.INTERCHANGE..MW..SCADA.45581.")

twl_5min_10_2 <- totalwindload_5min_10 %>%
  select(10:17) %>%
  rename("Month" = "Month.1",
         "DateTime" = "DateTime.1",
         "Wind Generation" = "TOTAL.WIND.GENERATION..IN.BPA.CONTROL.AREA..MW..SCADA.79687..1",
         "Wind Generation Basepoint Forecast" = "TOTAL.WIND.GENERATION..BASEPOINT..FORECAST..IN.BPA.CONTROL.AREA..MW..SCADA.103349..1",
         "BPA Generation" = "TOTAL.BPA.CONTROL.AREA.LOAD..MW..SCADA.45583..1",
         "Hydro Generation" = "TOTAL.HYDRO.GENERATION..MW..SCADA.79682..1",
         "Thermal Generation" = "TOTAL.THERMAL.GENERATION..MW..SCADA.79685..1",
         "Net Interchange" = "NET.INTERCHANGE..MW..SCADA.45581..1") 

twl_5min_10_tot <- rbind(twl_5min_10_1, twl_5min_10_2)
twl_5min_10_tot <- twl_5min_10_tot %>%
  select(1, 2, 4, 3, 5, 6, 7, 8)

#twl_5min_08_sum_NEEDTOFIX <- totalwindload_5min_09 %>%
#  select(19:29)

twl_5min_2007_to_2010 <- rbind(twl_5min_07_tot, twl_5min_08_tot, twl_5min_09_tot, twl_5min_10_tot) %>%
  select(-1)
twl_5min_2007_to_2010[,"Fossil Biomass Generation"] <- NA
twl_5min_2007_to_2010[,"Nuclear Generation"] <- NA
twl_5min_2007_to_2010 <- twl_5min_2007_to_2010 %>%
  select(1, 3, 2, 4, 5, 6, 8, 9, 7)


### Wind Generation Total Load YTD
#
#

# 2011
totalwindload_5min_11_1 <- read.xls(file.path("/Users/mitzizitler/SEM/SEM Dropbox Uploads/WindGenTotalLoadYTD_2011_2.xls"),
                                  method = "csv", sheet = 1)
totalwindload_5min_11_2 <- read.xls(file.path("/Users/mitzizitler/SEM/SEM Dropbox Uploads/WindGenTotalLoadYTD_2011_2.xls"),
                                  method = "csv", sheet = 2)

twl_5min_11_1 <- totalwindload_5min_11_1 %>%
  select(1:7) %>%
  rename("DateTime" = "Date.Time",
         "Wind Generation" = "TOTAL.WIND.GENERATION..IN.BPA.CONTROL.AREA..MW..SCADA.79687.",
         "Wind Generation Basepoint Forecast" = "TOTAL.WIND.GENERATION..BASEPOINT..FORECAST..IN.BPA.CONTROL.AREA..MW..SCADA.103349.",
         "BPA Generation" = "TOTAL.BPA.CONTROL.AREA.LOAD..MW..SCADA.45583.",
         "Hydro Generation" = "TOTAL.HYDRO.GENERATION..MW..SCADA.79682.",
         "Thermal Generation" = "TOTAL.THERMAL.GENERATION..MW..SCADA.79685.",
         "Net Interchange" = "NET.INTERCHANGE..MW..SCADA.45581.")

twl_5min_11_2 <- totalwindload_5min_11_2 %>%
  select(1:7) %>%
  rename("DateTime" = "Date.Time",
         "Wind Generation" = "TOTAL.WIND.GENERATION..IN.BPA.CONTROL.AREA..MW..SCADA.79687.",
         "Wind Generation Basepoint Forecast" = "TOTAL.WIND.GENERATION..BASEPOINT..FORECAST..IN.BPA.CONTROL.AREA..MW..SCADA.103349.",
         "BPA Generation" = "TOTAL.BPA.CONTROL.AREA.LOAD..MW..SCADA.45583.",
         "Hydro Generation" = "TOTAL.HYDRO.GENERATION..MW..SCADA.79682.",
         "Thermal Generation" = "TOTAL.THERMAL.GENERATION..MW..SCADA.79685.",
         "Net Interchange" = "NET.INTERCHANGE..MW..SCADA.45581.")

twl_5min_11_tot <- rbind(twl_5min_11_1, twl_5min_11_2)
twl_5min_11_tot[,"Fossil Biomass Generation"] <- NA
twl_5min_11_tot[,"Nuclear Generation"] <- NA
twl_5min_11_tot <- twl_5min_11_tot %>%
  select(1, 2, 3, 4, 5, 6, 8, 9, 7)

# 2012
totalwindload_5min_12_1 <- read.xls(file.path("/Users/mitzizitler/SEM/SEM Dropbox Uploads/WindGenTotalLoadYTD_2012_2.xls"),
                                    method = "csv", sheet = 1)
totalwindload_5min_12_2 <- read.xls(file.path("/Users/mitzizitler/SEM/SEM Dropbox Uploads/WindGenTotalLoadYTD_2012_2.xls"),
                                    method = "csv", sheet = 2)

twl_5min_12_1 <- totalwindload_5min_12_1 %>%
  select(1:7) %>%
  rename("DateTime" = "Date.Time",
         "Wind Generation" = "TOTAL.WIND.GENERATION..IN.BPA.CONTROL.AREA..MW..SCADA.79687.",
         "Wind Generation Basepoint Forecast" = "TOTAL.WIND.GENERATION..BASEPOINT..FORECAST..IN.BPA.CONTROL.AREA..MW..SCADA.103349.",
         "BPA Generation" = "TOTAL.BPA.CONTROL.AREA.LOAD..MW..SCADA.45583.",
         "Hydro Generation" = "TOTAL.HYDRO.GENERATION..MW..SCADA.79682.",
         "Thermal Generation" = "TOTAL.THERMAL.GENERATION..MW..SCADA.79685.",
         "Net Interchange" = "NET.INTERCHANGE..MW..SCADA.45581.")

twl_5min_12_2 <- totalwindload_5min_12_2 %>%
  select(1:7) %>%
  rename("DateTime" = "Date.Time",
         "Wind Generation" = "TOTAL.WIND.GENERATION..IN.BPA.CONTROL.AREA..MW..SCADA.79687.",
         "Wind Generation Basepoint Forecast" = "TOTAL.WIND.GENERATION..BASEPOINT..FORECAST..IN.BPA.CONTROL.AREA..MW..SCADA.103349.",
         "BPA Generation" = "TOTAL.BPA.CONTROL.AREA.LOAD..MW..SCADA.45583.",
         "Hydro Generation" = "TOTAL.HYDRO.GENERATION..MW..SCADA.79682.",
         "Thermal Generation" = "TOTAL.THERMAL.GENERATION..MW..SCADA.79685.",
         "Net Interchange" = "NET.INTERCHANGE..MW..SCADA.45581.")

twl_5min_12_tot <- rbind(twl_5min_12_1, twl_5min_12_2)
twl_5min_12_tot[,"Fossil Biomass Generation"] <- NA
twl_5min_12_tot[,"Nuclear Generation"] <- NA
twl_5min_12_tot <- twl_5min_12_tot %>%
  select(1, 2, 3, 4, 5, 6, 8, 9, 7)

# 2013
totalwindload_5min_13_1 <- read.xls(file.path("/Users/mitzizitler/SEM/SEM Dropbox Uploads/WindGenTotalLoadYTD_2013_2.xls"),
                                    method = "csv", sheet = 1)
totalwindload_5min_13_2 <- read.xls(file.path("/Users/mitzizitler/SEM/SEM Dropbox Uploads/WindGenTotalLoadYTD_2013_2.xls"),
                                    method = "csv", sheet = 2)

twl_5min_13_1 <- totalwindload_5min_13_1 %>%
  select(1:7) %>%
  rename("DateTime" = "Date.Time",
         "Wind Generation" = "TOTAL.WIND.GENERATION..IN.BPA.CONTROL.AREA..MW..SCADA.79687.",
         "Wind Generation Basepoint Forecast" = "TOTAL.WIND.GENERATION..BASEPOINT..FORECAST..IN.BPA.CONTROL.AREA..MW..SCADA.103349.",
         "BPA Generation" = "TOTAL.BPA.CONTROL.AREA.LOAD..MW..SCADA.45583.",
         "Hydro Generation" = "TOTAL.HYDRO.GENERATION..MW..SCADA.79682.",
         "Thermal Generation" = "TOTAL.THERMAL.GENERATION..MW..SCADA.79685.",
         "Net Interchange" = "NET.INTERCHANGE..MW..SCADA.45581.")

twl_5min_13_2 <- totalwindload_5min_13_2 %>%
  select(1:7) %>%
  rename("DateTime" = "Date.Time",
         "Wind Generation" = "TOTAL.WIND.GENERATION..IN.BPA.CONTROL.AREA..MW..SCADA.79687.",
         "Wind Generation Basepoint Forecast" = "TOTAL.WIND.GENERATION..BASEPOINT..FORECAST..IN.BPA.CONTROL.AREA..MW..SCADA.103349.",
         "BPA Generation" = "TOTAL.BPA.CONTROL.AREA.LOAD..MW..SCADA.45583.",
         "Hydro Generation" = "TOTAL.HYDRO.GENERATION..MW..SCADA.79682.",
         "Thermal Generation" = "TOTAL.THERMAL.GENERATION..MW..SCADA.79685.",
         "Net Interchange" = "NET.INTERCHANGE..MW..SCADA.45581.")

twl_5min_13_tot <- rbind(twl_5min_13_1, twl_5min_13_2)
twl_5min_13_tot[,"Fossil Biomass Generation"] <- NA
twl_5min_13_tot[,"Nuclear Generation"] <- NA
twl_5min_13_tot <- twl_5min_13_tot %>%
  select(1, 2, 3, 4, 5, 6, 8, 9, 7)

# 2014
totalwindload_5min_14_1 <- read.xls(file.path("/Users/mitzizitler/SEM/SEM Dropbox Uploads/WindGenTotalLoadYTD_2014_2.xls"),
                                    method = "csv", sheet = 1)
totalwindload_5min_14_2 <- read.xls(file.path("/Users/mitzizitler/SEM/SEM Dropbox Uploads/WindGenTotalLoadYTD_2014_2.xls"),
                                    method = "csv", sheet = 2)

twl_5min_14_1 <- totalwindload_5min_14_1 %>%
  select(1:7) %>%
  rename("DateTime" = "Date.Time",
         "Wind Generation" = "TOTAL.WIND.GENERATION..IN.BPA.CONTROL.AREA..MW..SCADA.79687.",
         "Wind Generation Basepoint Forecast" = "TOTAL.WIND.GENERATION..BASEPOINT..FORECAST..IN.BPA.CONTROL.AREA..MW..SCADA.103349.",
         "BPA Generation" = "TOTAL.BPA.CONTROL.AREA.LOAD..MW..SCADA.45583.",
         "Hydro Generation" = "TOTAL.HYDRO.GENERATION..MW..SCADA.79682.",
         "Thermal Generation" = "TOTAL.THERMAL.GENERATION..MW..SCADA.79685.",
         "Net Interchange" = "NET.INTERCHANGE..MW..SCADA.45581.")

twl_5min_14_2 <- totalwindload_5min_14_2 %>%
  select(1:7) %>%
  rename("DateTime" = "Date.Time",
         "Wind Generation" = "TOTAL.WIND.GENERATION..IN.BPA.CONTROL.AREA..MW..SCADA.79687.",
         "Wind Generation Basepoint Forecast" = "TOTAL.WIND.GENERATION..BASEPOINT..FORECAST..IN.BPA.CONTROL.AREA..MW..SCADA.103349.",
         "BPA Generation" = "TOTAL.BPA.CONTROL.AREA.LOAD..MW..SCADA.45583.",
         "Hydro Generation" = "TOTAL.HYDRO.GENERATION..MW..SCADA.79682.",
         "Thermal Generation" = "TOTAL.THERMAL.GENERATION..MW..SCADA.79685.",
         "Net Interchange" = "NET.INTERCHANGE..MW..SCADA.45581.")

twl_5min_14_tot <- rbind(twl_5min_14_1, twl_5min_14_2)
twl_5min_14_tot[,"Fossil Biomass Generation"] <- NA
twl_5min_14_tot[,"Nuclear Generation"] <- NA
twl_5min_14_tot <- twl_5min_14_tot %>%
  select(1, 2, 3, 4, 5, 6, 8, 9, 7)

# 2015
totalwindload_5min_15_1 <- read.xls(file.path("/Users/mitzizitler/SEM/SEM Dropbox Uploads/WindGenTotalLoadYTD_2015_2.xls"),
                                    method = "csv", sheet = 1)
totalwindload_5min_15_2 <- read.xls(file.path("/Users/mitzizitler/SEM/SEM Dropbox Uploads/WindGenTotalLoadYTD_2015_2.xls"),
                                    method = "csv", sheet = 2)

twl_5min_15_1 <- totalwindload_5min_15_1 %>%
  select(1:7) %>%
  rename("DateTime" = "Date.Time",
         "Wind Generation" = "TOTAL.WIND.GENERATION..IN.BPA.CONTROL.AREA..MW..SCADA.79687.",
         "Wind Generation Basepoint Forecast" = "TOTAL.WIND.GENERATION..BASEPOINT..FORECAST..IN.BPA.CONTROL.AREA..MW..SCADA.103349.",
         "BPA Generation" = "TOTAL.BPA.CONTROL.AREA.LOAD..MW..SCADA.45583.",
         "Hydro Generation" = "TOTAL.HYDRO.GENERATION..MW..SCADA.79682.",
         "Thermal Generation" = "TOTAL.THERMAL.GENERATION..MW..SCADA.79685.",
         "Net Interchange" = "NET.INTERCHANGE..MW..SCADA.45581.")

twl_5min_15_2 <- totalwindload_5min_15_2 %>%
  select(1:7) %>%
  rename("DateTime" = "Date.Time",
         "Wind Generation" = "TOTAL.WIND.GENERATION..IN.BPA.CONTROL.AREA..MW..SCADA.79687.",
         "Wind Generation Basepoint Forecast" = "TOTAL.WIND.GENERATION..BASEPOINT..FORECAST..IN.BPA.CONTROL.AREA..MW..SCADA.103349.",
         "BPA Generation" = "TOTAL.BPA.CONTROL.AREA.LOAD..MW..SCADA.45583.",
         "Hydro Generation" = "TOTAL.HYDRO.GENERATION..MW..SCADA.79682.",
         "Thermal Generation" = "TOTAL.THERMAL.GENERATION..MW..SCADA.79685.",
         "Net Interchange" = "NET.INTERCHANGE..MW..SCADA.45581.")

twl_5min_15_tot <- rbind(twl_5min_15_1, twl_5min_15_2)
twl_5min_15_tot[,"Fossil Biomass Generation"] <- NA
twl_5min_15_tot[,"Nuclear Generation"] <- NA
twl_5min_15_tot <- twl_5min_15_tot %>%
  select(1, 2, 3, 4, 5, 6, 8, 9, 7)

# 2016
totalwindload_5min_16_1 <- read.xls(file.path("/Users/mitzizitler/SEM/SEM Dropbox Uploads/WindGenTotalLoadYTD_2016_2.xls"),
                                    method = "csv", sheet = 1)
totalwindload_5min_16_2 <- read.xls(file.path("/Users/mitzizitler/SEM/SEM Dropbox Uploads/WindGenTotalLoadYTD_2016_2.xls"),
                                    method = "csv", sheet = 2)

twl_5min_16_1 <- totalwindload_5min_16_1 %>%
  select(1:7) %>%
  rename("DateTime" = "Date.Time",
         "Wind Generation" = "TOTAL.WIND.GENERATION..IN.BPA.CONTROL.AREA..MW..SCADA.79687.",
         "Wind Generation Basepoint Forecast" = "TOTAL.WIND.GENERATION..BASEPOINT..FORECAST..IN.BPA.CONTROL.AREA..MW..SCADA.103349.",
         "BPA Generation" = "TOTAL.BPA.CONTROL.AREA.LOAD..MW..SCADA.45583.",
         "Hydro Generation" = "TOTAL.HYDRO.GENERATION..MW..SCADA.79682.",
         "Thermal Generation" = "TOTAL.THERMAL.GENERATION..MW..SCADA.79685.",
         "Net Interchange" = "NET.INTERCHANGE..MW..SCADA.45581.")

twl_5min_16_2 <- totalwindload_5min_16_2 %>%
  select(1:7) %>%
  rename("DateTime" = "Date.Time",
         "Wind Generation" = "TOTAL.WIND.GENERATION..IN.BPA.CONTROL.AREA..MW..SCADA.79687.",
         "Wind Generation Basepoint Forecast" = "TOTAL.WIND.GENERATION..BASEPOINT..FORECAST..IN.BPA.CONTROL.AREA..MW..SCADA.103349.",
         "BPA Generation" = "TOTAL.BPA.CONTROL.AREA.LOAD..MW..SCADA.45583.",
         "Hydro Generation" = "TOTAL.HYDRO.GENERATION..MW..SCADA.79682.",
         "Thermal Generation" = "TOTAL.THERMAL.GENERATION..MW..SCADA.79685.",
         "Net Interchange" = "NET.INTERCHANGE..MW..SCADA.45581.")

twl_5min_16_tot <- rbind(twl_5min_16_1, twl_5min_16_2)
twl_5min_16_tot[,"Fossil Biomass Generation"] <- NA
twl_5min_16_tot[,"Nuclear Generation"] <- NA
twl_5min_16_tot <- twl_5min_16_tot %>%
  select(1, 2, 3, 4, 5, 6, 8, 9, 7)

# 2017
totalwindload_5min_17_1 <- read.xls(file.path("/Users/mitzizitler/SEM/SEM Dropbox Uploads/WindGenTotalLoadYTD_2017_2.xls"),
                                    method = "csv", sheet = 1)
totalwindload_5min_17_2 <- read.xls(file.path("/Users/mitzizitler/SEM/SEM Dropbox Uploads/WindGenTotalLoadYTD_2017_2.xls"),
                                    method = "csv", sheet = 2)

twl_5min_17_1 <- totalwindload_5min_17_1 %>%
  select(1:9) %>%
  rename("DateTime" = "Date.Time",
         "Wind Generation" = "TOTAL.WIND.GENERATION..IN.BPA.CONTROL.AREA..MW..SCADA.79687.",
         "Wind Generation Basepoint Forecast" = "TOTAL.WIND.GENERATION..BASEPOINT..FORECAST..IN.BPA.CONTROL.AREA..MW..SCADA.103349.",
         "BPA Generation" = "TOTAL.BPA.CONTROL.AREA.LOAD..MW..SCADA.45583.",
         "Hydro Generation" = "TOTAL.HYDRO.GENERATION..MW..SCADA.79682.",
         "Thermal Generation" = "TOTAL.THERMAL.GENERATION..MW..SCADA.79685.",
         "Fossil Biomass Generation" = "TOTAL.FOSSIL.BIOMASS.GENERATION..MW..SCADA.16377.",
         "Nuclear Generation" = "TOTAL.NUCLEAR.GENERATION..MW..70681.",
         "Net Interchange" = "NET.INTERCHANGE..MW..SCADA.45581.")

twl_5min_17_2 <- totalwindload_5min_17_2 %>%
  select(1:9) %>%
  rename("DateTime" = "Date.Time",
         "Wind Generation" = "TOTAL.WIND.GENERATION..IN.BPA.CONTROL.AREA..MW..SCADA.79687.",
         "Wind Generation Basepoint Forecast" = "TOTAL.WIND.GENERATION..BASEPOINT..FORECAST..IN.BPA.CONTROL.AREA..MW..SCADA.103349.",
         "BPA Generation" = "TOTAL.BPA.CONTROL.AREA.LOAD..MW..SCADA.45583.",
         "Hydro Generation" = "TOTAL.HYDRO.GENERATION..MW..SCADA.79682.",
         "Thermal Generation" = "TOTAL.THERMAL.GENERATION..MW..SCADA.79685.",
         "Fossil Biomass Generation" = "TOTAL.FOSSIL.BIOMASS.GENERATION..MW..SCADA.16377.",
         "Nuclear Generation" = "TOTAL.NUCLEAR.GENERATION..MW..70681.",
         "Net Interchange" = "NET.INTERCHANGE..MW..SCADA.45581.")

twl_5min_17_tot <- rbind(twl_5min_17_1, twl_5min_17_2)


# 2018
totalwindload_5min_18_1 <- read.xls(file.path("/Users/mitzizitler/SEM/SEM Dropbox Uploads/WindGenTotalLoadYTD_2018_2.xls"),
                                    method = "csv", sheet = 1)
totalwindload_5min_18_2 <- read.xls(file.path("/Users/mitzizitler/SEM/SEM Dropbox Uploads/WindGenTotalLoadYTD_2018_2.xls"),
                                    method = "csv", sheet = 2)

twl_5min_18_1 <- totalwindload_5min_18_1 %>%
  select(1:8) %>%
  rename("DateTime" = "Date.Time",
         "Wind Generation" = "TOTAL.WIND.GENERATION..IN.BPA.CONTROL.AREA..MW..SCADA.79687.",
         "Wind Generation Basepoint Forecast" = "TOTAL.WIND.GENERATION..BASEPOINT..FORECAST..IN.BPA.CONTROL.AREA..MW..SCADA.103349.",
         "BPA Generation" = "TOTAL.BPA.CONTROL.AREA.LOAD..MW..SCADA.45583.",
         "Hydro Generation" = "TOTAL.HYDRO.GENERATION..MW..SCADA.79682.",
         "Fossil Biomass Generation" = "TOTAL.FOSSIL.BIOMASS.GENERATION..MW..SCADA.16377.",
         "Nuclear Generation" = "TOTAL.NUCLEAR.GENERATION..MW..70681.",
         "Net Interchange" = "NET.INTERCHANGE..MW..SCADA.45581.")

twl_5min_18_2 <- totalwindload_5min_18_2 %>%
  select(1:8) %>%
  rename("DateTime" = "Date.Time",
         "Wind Generation" = "TOTAL.WIND.GENERATION..IN.BPA.CONTROL.AREA..MW..SCADA.79687.",
         "Wind Generation Basepoint Forecast" = "TOTAL.WIND.GENERATION..BASEPOINT..FORECAST..IN.BPA.CONTROL.AREA..MW..SCADA.103349.",
         "BPA Generation" = "TOTAL.BPA.CONTROL.AREA.LOAD..MW..SCADA.45583.",
         "Hydro Generation" = "TOTAL.HYDRO.GENERATION..MW..SCADA.79682.",
         "Fossil Biomass Generation" = "TOTAL.FOSSIL.BIOMASS.GENERATION..MW..SCADA.16377.",
         "Nuclear Generation" = "TOTAL.NUCLEAR.GENERATION..MW..70681.",
         "Net Interchange" = "NET.INTERCHANGE..MW..SCADA.45581.")

twl_5min_18_tot <- rbind(twl_5min_18_1, twl_5min_18_2)
twl_5min_18_tot[,"Thermal Generation"] <- NA
twl_5min_18_tot <- twl_5min_18_tot %>%
  select(1, 2, 3, 4, 5, 9, 6, 7, 8)


twl_5min_2007_to_2018 <- rbind(twl_5min_2007_to_2010, twl_5min_11_tot, twl_5min_12_tot, 
                               twl_5min_13_tot, twl_5min_14_tot, twl_5min_15_tot, twl_5min_16_tot,
                               twl_5min_17_tot, twl_5min_18_tot)



getwd()
write.xlsx(twl_5min_07_tot, file = "twl_5min_07_tot.xls")
write.xlsx(twl_5min_2007_to_2010, file = "twl_5min_2007_to_2010.xls")
write.xlsx(twl_5min_2007_to_2018, file = "twl_5min_2007_to_2018.xls")

