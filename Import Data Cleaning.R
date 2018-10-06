library(tidyverse)
library(openxlsx)
library(lubridate)

getwd()
setwd("/Users/mitzizitler/SEM/SEM Import Uploads")
imports16 <- read.xlsx("1601-1612 SMUD Imports.xlsx", sheet = 2, detectDates = T)
imports17_18 <- read.xlsx("1701-1804 SMUD Imports_052218.xlsx", sheet = 10,
                          detectDates = T) %>%
  select(-X13, -X14, -X15) %>%
  rename("Transaction.Term" = "Term")
imports18 <- read.xlsx("1805 -1807_SMUD Purchases-Sales_073118.xlsx", detectDates = T) %>%
  rename("System.Type" = "Commodity")

terms <- c("DA", "HA")

imports_all <- rbind(imports16, imports17_18, imports18)

imports_tot <- imports_all %>%
  filter(Transaction.Term %in% terms) %>%
  filter(Market != "SOTP") %>%
  filter(Price != 0) %>%
  select(-`MW.*.Price`)
  # filter the hubs
  
imports_tot$Flow.Date <- as.Date(imports_tot$Flow.Date)
imports_tot$Price <- as.numeric(imports_tot$Price)

openxlsx::write.xlsx(file = "Imports Total 10:01.xlsx", imports_tot)
openxlsx::write.xlsx(file = "Imports Not Cleaned 10:03.xlsx", imports_all)
# negative MW are imports

imports_sums <- imports_tot %>%
  mutate(Total.CostbyHour = Price*MW) %>%
  group_by(Flow.Date, Market) %>%
  mutate(agg_price = sum(Price),
         agg_quandt = sum(MW),
         agg_cost = sum(Total.CostbyHour)) %>%
  ungroup() %>%
  group_by(Market) %>%
  mutate(revenues = ifelse(MW > 0, MW, 0)) %>%
  group_by(Flow.Date, Market) %>%
  mutate(daily_revenues = sum(revenues)) %>%
  distinct(Flow.Date, .keep_all = T) %>%
  ungroup() %>%
  mutate(`Net Exports` = agg_cost - daily_revenues) %>%
  select(-System.Type, -Path.ID, -Company.ID, -Contract.ID, -Tag.ID, -Total.CostbyHour, -revenues) %>%
  rename("Date" = "Flow.Date",
         "Hour" = "Trading.Hour",
         "Term" = "Transaction.Term",
         "Aggregate Daily Price" = "agg_price",
         "Aggregate Daily MW" = "agg_quandt",
         "Aggregate Daily Cost per Hour" = "agg_cost",
         "Aggregate Daily Revenues" = "daily_revenues")

imports_sums_caiso <- imports_sums %>%
  filter(Market == "CAISO")

imports_sums_cob <- imports_sums %>%
  filter(Market == "COB")

imports_sums_wapa <- imports_sums %>%
  filter(Market == "WAPA")

imports_sums_tracy <- imports_sums %>%
  filter(Market == "TRACY")

openxlsx::write.xlsx(file = "Imports Summary 9:27.xlsx", imports_sums)
openxlsx::write.xlsx(file = "Imports Summary CAISO 9:27.xlsx", imports_sums_caiso)
openxlsx::write.xlsx(file = "Imports Summary COB 9:27.xlsx", imports_sums_cob)
openxlsx::write.xlsx(file = "Imports Summary TRACY 9:27.xlsx", imports_sums_tracy)
openxlsx::write.xlsx(file = "Imports Summary WAPA 9:27.xlsx", imports_sums_wapa)

openxlsx::write.xlsx(file = "Imports Summary 9:30.xlsx", imports_sums)
openxlsx::write.xlsx(file = "Imports Summary CAISO 9:30.xlsx", imports_sums_caiso)
openxlsx::write.xlsx(file = "Imports Summary COB 9:30.xlsx", imports_sums_cob)
openxlsx::write.xlsx(file = "Imports Summary TRACY 9:30.xlsx", imports_sums_tracy)
openxlsx::write.xlsx(file = "Imports Summary WAPA 9:30.xlsx", imports_sums_wapa)


# start over with this
mw_negative_price_positive <- imports_tot %>%
  filter(MW < 0 & Price > 0)
mw_negative_price_negative <- imports_tot %>%
  filter(MW < 0 & Price < 0)
mw_positive_price_positive <- imports_tot %>%
  filter(MW > 0 & Price > 0)
mw_positive_price_negative <- imports_tot %>%
  filter(MW > 0 & Price < 0)


exports_new_thing <- rbind(mw_negative_price_positive, mw_positive_price_negative)
imports_new_thing <- rbind(mw_positive_price_positive, mw_negative_price_negative)

imports_new_thing <- imports_new_thing %>%
  mutate(`Import Costs` = abs(MW)*abs(Price)) %>%
  select(1:2, 8, 11:12) %>%
  unite("Date Hour", Flow.Date, Trading.Hour, sep = " ") %>%
  rename("Import Price" = "Price",
         "Import MW" = "MW")

exports_new_thing <- exports_new_thing %>%
  mutate(`Export Costs` = abs(MW)*abs(Price)) %>%
  select(1:2, 8, 11:12) %>%
  unite("Date Hour", Flow.Date, Trading.Hour, sep = " ") %>%
  rename("Export Price" = "Price",
         "Export MW" = "MW")

 imp_exp <- full_join(exports_new_thing, imports_new_thing, by = "Date Hour")
 imp_exp <- imp_exp %>%
   mutate("Export.Price" = ifelse(is.na(`Export Price`), 0, `Export Price`),
          "Export.MW" = ifelse(is.na(`Export MW`), 0, `Export MW`),
          "Export.Revenues" = ifelse(is.na(`Export Costs`), 0, `Export Costs`),
          "Import.Price" = ifelse(is.na(`Import Price`), 0, `Import Price`),
          "Import.MW" = ifelse(is.na(`Import MW`), 0, `Import MW`),
          "Import.Costs" = ifelse(is.na(`Import Costs`), 0, `Import Costs`)) %>%
   select(-`Export Price`, -`Export MW`, -`Export Costs`, -`Import Price`, -`Import MW`,   
          -`Import Costs`) %>%
   select(`Date Hour`, Import.Price, Import.MW, Import.Costs, Export.Price, Export.MW, Export.Revenues) %>%
   group_by(`Date Hour`) %>%
   mutate(`Import Cost Minus Export Rev` = Import.Costs - Export.Revenues) %>%
   ungroup()

openxlsx::write.xlsx(file = "Imports Exports 10:04.xlsx", imp_exp)

imp_exp <- imp_exp %>%
  group_by(`Date Hour`) %>%
  mutate(`Import Cost Minus Export Revenue` = sum(`Import Cost Minus Export Rev`)) %>%
  distinct(`Date Hour`, .keep_all = T)

imp_exp_join <- imp_exp %>%
  select(`Date Hour`, Import.Costs, Export.Revenues, `Import Cost Minus Export Revenue`)

openxlsx::write.xlsx(file = "Imp Exp Join 10:04.xlsx", imp_exp_join)


