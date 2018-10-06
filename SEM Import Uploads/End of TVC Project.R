library(tidyverse)
library(openxlsx)
library(lubridate)

setwd('C:/Users/mitzizitler/SEM/SEM Import Uploads/')
imports_stuff <- openxlsx::read.xlsx('Imp Exp Join 10:04.xlsx')


## cost of local thermal generation
setwd('Users/mitzizitler/SEM/TVC 9:30:18/')
gen_load <- read.xlsx('1601-1807_Generation_Load_073118.xlsx',
                      sheet = 2, detectDates = T) 
gen_load2 <- data_frame(gen_load[,1], gen_load[,2], gen_load[,3], gen_load[,4],
                        gen_load[,5], gen_load[,6]) %>%
  rename("Flow.Date" = "gen_load[, 1]",
         "EMS.ID" = "gen_load[, 2]",
         "Hour.Ending" = "gen_load[, 3]",
         "MW.Total" = "gen_load[, 4]",
         "Month" = "gen_load[, 5]",
         "Year" = "gen_load[, 6]")

grdt_full <- read.xlsx('GRDT.xlsx')
smud_therm_dispatch <- read.xlsx('SMUD thermal dispatch prices (1).xlsx',
                                 detectDates = T) %>%
  select(-4)

generators <-c("CPP_2_PL_1x1", "CPP_2_PL_2x1", "CIG_6_PL_1x1_M1", "CIG_6_PL_1x1_M2", 
               "CSG_2_PL_1x1_M1", "CSG_2_PL_1x1_M2", "PGG_2_PL_1x1_M1",
               "PGG_2_PL_1x1_M2", "PGG_2_PL_2x1_M1", "PGG_2_PL_2x1_M2",             
               "SUT_2_PL_1x1_M1", "SUT_2_PL_1x1_M2", "SUT_2_PL_2x1_M1", 
               "SUT_2_PL_2x1_M2", "PGG_2_PKR_1x0_M1", "PGG_2_PKR_1x0_M2")     

generators_sm <-c("CPP2", "CIG6", "CSG2", "PGG2", "SUT2", "MCC6") 
generators_sm_no_sut <-c("CPP2", "CIG6", "CSG2", "PGG2", "MCC") 

generators_all <- c("CIG1", "CIG2", "CIG3", "CPP1", "CPP2", "CPP3", "CSG1",
                    "CSG2", "MCC", "PGG1", "PGG2", "PGG3", "PGG4", "UARP",
                    "SUT1", "LOAD")

gen_load_sm <- gen_load2 %>%
  filter(EMS.ID %in% generators_sm_no_sut) 

therm_gen_load <- full_join(gen_load_sm, smud_therm_dispatch, by = "Flow.Date")

dispatch_prices <- c("CPP2", "CIG6", "CSG2", "PGG2")

therm_gen_load2 <- therm_gen_load %>%
  mutate(Dispatch.Price = ifelse(EMS.ID %in% dispatch_prices,
                                 `CPP,.Carson,.Proctor,.Campbells.Dispatch`,
                                 McClellan.Dispatch)) %>%
  select(-`CPP,.Carson,.Proctor,.Campbells.Dispatch`, -McClellan.Dispatch) %>%
  unite("Date Hour", Flow.Date, Hour.Ending, sep = " ")

filter(gen_load2, EMS.ID != "UARP" & EMS.ID != "LOAD" & MW.Total > 0) %>%
  filter(EMS.ID != "SUT1" & EMS.ID != "CPP1" & EMS.ID != "CPP2" & EMS.ID != "CPP3" & EMS.ID != "PGG3") %>%
  filter(EMS.ID != "CIG2" & EMS.ID != "CIG3") %>%
#  filter(EMS.ID != "MCC" & EMS.ID != "PGG2") %>%
  ggplot(aes(x = MW.Total, col = EMS.ID)) + geom_density()

# filter(gen_load2, EMS.ID != "UARP" & EMS.ID != "LOAD" & MW.Total > 0) %>%
#  filter(gen_load2, EMS.ID == "MCC") %>%
#  filter(gen_load2, EMS.ID == "CPP1") %>%
#  filter(gen_load2, EMS.ID == "CPP2") %>%
  filter(gen_load2, EMS.ID == "CPP3") %>%
#  filter(gen_load2, EMS.ID == "CIG1") %>%
#  filter(gen_load2, EMS.ID == "CIG2") %>%
#  filter(gen_load2, EMS.ID == "CIG3") %>%
#  filter(gen_load2, EMS.ID == "CSG1") %>%
#  filter(gen_load2, EMS.ID == "CSG2") %>%
#  filter(gen_load2, EMS.ID == "PGG1") %>%
#  filter(gen_load2, EMS.ID == "PGG2") %>%
#  filter(gen_load2, EMS.ID == "PGG3") %>%
#  filter(gen_load2, EMS.ID == "PGG4") %>%
#  filter(gen_load2, EMS.ID == "SUT1") %>%
  ggplot() + geom_density(aes(x = MW.Total, col = EMS.ID))
#+
#  geom_vline(xintercept = 180) + geom_vline(xintercept = 240) + geom_vline(xintercept = 258) +
#  geom_vline(xintercept = 350) + geom_vline(xintercept = 500) + geom_vline(xintercept = 525)

### Add in heat rate function, multiply by dispatch price and mw total for left side


### Exogenous Variables
# retail load MWH 

retail_load <- gen_load2 %>%
  filter(EMS.ID == "LOAD") %>%
  group_by(Flow.Date, Hour.Ending) %>%
  mutate(`Retail MW Load` = sum(MW.Total)) %>%
  ungroup()

retail_load_join <- retail_load %>%
  select(Flow.Date, Hour.Ending, `Retail MW Load`)
retail_load_join$`Date Hour` <- paste(retail_load_join$Flow.Date, retail_load_join$Hour.Ending)
retail_load_join <- retail_load_join %>%
  select(`Date Hour`, `Retail MW Load`)

# energy produced MWH by hydro under contract or ownership to SMUD

hourly_hydro_imports <- gen_load2 %>%
  filter(EMS.ID == "UARP") %>%
  rename("Hydro Imports" = "MW.Total",
         "Market" = "EMS.ID") %>%
  select(Flow.Date, Hour.Ending, Market, `Hydro Imports`)
  

# setwd("Users/mitzizitler/SEM/SEM Import Uploads")
imports_all <- read.xlsx("Imports Total 10:01.xlsx", detectDates = T)
hydro_wapa <- imports_all %>%
  filter(Contract.ID == "I355") %>%
  select(-System.Type, -Path.ID, -Company.ID, -Tag.ID, -`MW.*.Price`) %>%
  filter(Price != 0) %>%
  filter(Market == "WAPA") %>%
  group_by(Flow.Date, Trading.Hour) %>%
  mutate(`Hydro Imports` = sum(MW)) %>%
  rename("Hour.Ending" = "Trading.Hour")

hydro_wapa_join <- hydro_wapa %>%
  ungroup() %>%
  select(Flow.Date, Hour.Ending, Market, `Hydro Imports`)

hydro_join <- rbind(hydro_wapa_join, hourly_hydro_imports)
hydro_join$`Date Hour` <- paste(hydro_join$Flow.Date, hydro_join$Hour.Ending)
hydro_join <- hydro_join %>%
  select(`Date Hour`, `Hydro Imports`)

# seller concentration (HHI) at COB (hourly!!)

setwd("Users/mitzizitler/SEM")
all_tot5_time <- read.xlsx('Clean EQR with Time 10:01.xlsx', detectDates = T)

all_tot5_time <- all_tot5_time %>%
  separate(end_time, into = c("Hour.Ending", "Minute"), sep = 2)
all_tot5_time$Hour.Ending <- as.numeric(all_tot5_time$Hour.Ending)

sellers <- c("Avangrid Renewables LLC", "Bonneville Power Administration",
             "Exelon Generation Company LLC", "Hermiston Power LLC",
             "Morgan Stanley Capital Group, Inc.", "Pacific Northwest Generating Cooperative Inc.",
             "PacifiCorp", "Portland General Electric Company", "Powerex Corp.", 
             "Puget Sound Energy, Inc.", "Seattle City Light", "Shell Energy North America (US) L.P.",
             "TransAlta Energy Marketing (U.S.) Inc.", "TransAlta Energy Marketing U.S. Inc.",
             "PUGET SOUND ENERGY, INC.", "AVANGRID RENEWABLES, LLC", 
             "Bonneville Power Administration - Power Business", "Avangrid Renewables, LLC",
             "PORTLAND GENERAL ELECTRIC COMPANY", "PACIFICORP", "Shell Energy North America US L.P.",
             "POWEREX CORP.", "SHELL ENERGY NORTH AMERICA (US) L.P.", "Pacificorp",
             "Transalta Energy Marketing (US) Inc.", "Puget Sound Energy Inc.",
             "TRANSALTA ENERGY MARKETING US INC", "Avangrid Renewables LLC dba Iberdrola Renewables",
             "POWEREX CORP", "Seattle City Light Marketing", "Bonneville Power Administration - Power",
             "AVANGRID RENEWABLES LLC", "Powerex Corporation", "PUGET SOUND ENERGY INC",
             "MORGAN STANLEY CAPITAL GROUP INC.", "TransAlta Energy Marketing (U.S.) Inc.",
             "PACIFIC NORTHWEST GENERATING COOPERATIVE", "SEATTLE CITY LIGHT",
             "Puget Sound Energy", "PNGC Power", "SHELL ENERGY NORTH AMERICA (US), L.P.",
             "EXELON GENERATION COMPANY, LLC", "TRANSALTA ENERGY MARKETING (U.S.) INC.",
             "Portland General Electric Co.", "Avangrid Renewables, LLC dba Iberdrola Renewables, LLC",
             "TransAlta Energy Marketing (U.S.), Inc.", "Pacific Northwest Generating Cooperative",
             "Bonneville Power Administration Transmission", "Bonneville Power Administration Transmis",
             "Puget Sound Energy Transmission", "Bonneville Power Administration - Transmission")

hhi_cob <- all_tot5_time %>%
  select(-Minute, -trade_date) %>%
  filter(point_of_delivery_specific_location == "COB") %>%
  filter(seller_company_name %in% sellers) %>%
  group_by(transaction_end_date, Hour.Ending, seller_company_name) %>%
  mutate(n_transactions = sum(transaction_quantity)) %>%
  ungroup() %>%
  group_by(transaction_end_date, Hour.Ending) %>%
  mutate(tot_transactions = sum(transaction_quantity)) %>%
  mutate(share = n_transactions / tot_transactions) %>%
  distinct(seller_company_name, .keep_all = T) %>%
  select(-n_transactions, -tot_transactions) %>%
  mutate(seller_conc = sum(share^2)) %>%
  rename("Flow.Date" = "transaction_end_date",
         "Seller Concentration at COB" = "seller_conc")

# paste doesnt work

hhi_cob_join <- hhi_cob %>%
  ungroup() %>%
  select(Flow.Date, Hour.Ending, `Seller Concentration at COB`) %>%
  separate(Flow.Date, into = c("year", "month", "day"), sep = c(4, 6), remove = F) %>%
  unite("Date", 2:4, sep = "-") %>%
  select(-Flow.Date) %>%
  unite("Date Hour", 1:2, sep = " ")

# BPA hourly transmission rate increase, dummy (DO LAST)

dates <- seq(as.Date("2016-01-01"), as.Date("2018-07-31"), by="days")
df1 <- data_frame(dates, hour = 1)
df2 <- data_frame(dates, hour = 2)
df3 <- data_frame(dates, hour = 3)
df4 <- data_frame(dates, hour = 4)
df5 <- data_frame(dates, hour = 5)
df6 <- data_frame(dates, hour = 6)
df7 <- data_frame(dates, hour = 7)
df8 <- data_frame(dates, hour = 8)
df9 <- data_frame(dates, hour = 9)
df10 <- data_frame(dates, hour = 10)
df11 <- data_frame(dates, hour = 11)
df12 <- data_frame(dates, hour = 12)
df13 <- data_frame(dates, hour = 13)
df14 <- data_frame(dates, hour = 14)
df15 <- data_frame(dates, hour = 15)
df16 <- data_frame(dates, hour = 16)
df17 <- data_frame(dates, hour = 17)
df18 <- data_frame(dates, hour = 18)
df19 <- data_frame(dates, hour = 19)
df20 <- data_frame(dates, hour = 20)
df21 <- data_frame(dates, hour = 21)
df22 <- data_frame(dates, hour = 22)
df23 <- data_frame(dates, hour = 23)
df24 <- data_frame(dates, hour = 24)

df <- rbind(df1, df2, df3, df4, df5, df6, df7, df8, df9, df10, df11, df12, df13, df14, df15,
            df16, df17, df18, df19, df20, df21, df22, df23, df24)
remove(df1, df2, df3, df4, df5, df6, df7, df8, df9, df10, df11, df12, df13, df14, df15,
       df16, df17, df18, df19, df20, df21, df22, df23, df24)

dates_join <- data_frame(dates)
dates_join <- df %>%
  mutate(`Transmission Rate Increase` = ifelse(dates >= '2017-10-01', 1, 0)) %>%
  unite("Date Hour", 1:2, sep = " ")


# joining them all
#hhi_cob_join, dates_join, hydro_join, retail_load_join, 
#imports_sums_join

a <- left_join(dates_join, imports_sums_join, by = 'Date Hour')
b <- left_join(a, retail_load_join, by = "Date Hour")
c <- left_join(b, hydro_join, by = "Date Hour")
d <- left_join(c, hhi_cob_join, by = "Date Hour")
waiting_for_therm <- d %>%
  distinct(`Date Hour`, .keep_all = T)

openxlsx::write.xlsx(file = "work in progress.xlsx", waiting_for_therm)



