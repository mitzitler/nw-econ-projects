library(tidyverse)
library(openxlsx)

RESOURCE_ID <- c("CPP_2_PL", NA, NA, "CIG_6_PL", NA, NA, "CSG_2_PL", NA, NA, "PGG_2_PL", NA, NA, NA, NA, "SUT_2_PL", NA, NA, NA, NA, "PGG_2_PKR", NA, NA, "MCC_6_PKR", "CIG_6_PKR")
CONFIGURATION_ID <- c(NA, "CPP_2_PL_1x1", "CPP_2_PL_2x1", NA, "CIG_6_PL_1x1_M1", "CIG_6_PL_1x1_M2", NA, "CSG_2_PL_1x1_M1", "CSG_2_PL_1x1_M2", NA, "PGG_2_PL_1x1_M1", "PGG_2_PL_1x1_M2", "PGG_2_PL_2x1_M1", "PGG_2_PL_2x1_M2", NA, "SUT_2_PL_1x1_M1", "SUT_2_PL_1x1_M2", "SUT_2_PL_2x1_M1", "SUT_2_PL_2x1_M2", NA, "PGG_2_PKR_1x0_M1", "PGG_2_PKR_1x0_M2", NA, NA)
Min_Capacity <- c(150, 150, 310, 30, 30, 51, 100, 100, 153, 54, 54, 55, 68, 109, 180, 180, 241, 350, 501, 20, 20, 46, 50, 21)
Max_Capacity <- c(540, 260, 540, 63, 50, 63, 170, 152, 170, 130, 54, 64, 108, 130, 525, 240, 258, 500, 525, 48, 45, 48, 70, 41)
Min_On_Time <- c(120, 0, 0, 480, 60, 60, 60, 0, 0, 300, 0, 0, 0, 0, 60, 0, 0, 0, 0, 300, 0, 0, 60, 60)
Min_Off_Time <- c(480, 0, 0, 480, 0, 0, 480, 0, 0, 240, 0, 0, 0, 0, 60, 0, 0, 0, 0, 240, 0, 0, 960, 10)
Max_Starts_perDay <- c(2, NA, NA, 2, NA, NA, 2, NA, NA, 2, NA, NA, NA, NA, 2, NA, NA, NA, NA, 2, NA, NA, 2, 2)
GHG_Rate <- c(0.0531, NA, NA, 0.0531, NA, NA, 0.0531, NA, NA, 0.0531, NA, NA, NA, NA, 0.0531, NA, NA, NA, NA, 0.0531, NA, NA, 0.0531, 0.0531)
Worst_OP_Ramp_Rate <- c(NA, 10, 15, NA, 2, 0.01, NA, 5, 0.01, NA, 0.01, 0.01, 4, 0.01, NA, 6, 0.01, 6, 0.01, NA, 3, 0.01, 2, 2)
HRC_MW_1 <- c(NA, 150, 310, NA, 30, 51, NA, 100, 153, NA, 54, 55, 68, 109, NA, 180, 241, 350, 501, NA, 3, 0.01, 2, 2)
HRC_MW_2 <- c(NA, 158, 350, NA, 41, 54, NA, 152, 162, NA, 54, 57, 108, 114, NA, 240, 258, 500, 525, NA, 45, 48, 70, 32)
HRC_MW_3 <- c(NA, 191, 450, NA, 50, 63, NA, NA, 170, NA, NA, 64, NA, 130, NA, NA, NA, NA, NA, NA, NA, NA, NA, 41)
HRC_MW_4 <- c(NA, 232, 525, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA)
HRC_MW_5 <- c(NA, 260, 540, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA)
HRC_HR_1 <- c(NA, 7729, 7812, NA, 9598, 8222, NA, 8650, 8051, NA, 8356, 8357, 9862, 8354, NA, 7994, 7665, 7812, 7541, NA, 12540, 10028, 14000, 11446)
HRC_HR_2 <- c(NA, 7610, 7235, NA, 8622, 8129, NA, 8050, 8105, NA, 8357, 8256, 8355, 7550, NA, 7615, 7701, 7492, 7561, NA, 10029, 9021, 13000, 10507)
HRC_HR_3 <- c(NA, 7268, 6896, NA, 8223, 8245, NA, NA, 8610, NA, NA, 8385, NA, 7875, NA, NA, NA, NA, NA, NA, NA, NA, NA, 10240)
HRC_HR_4 <- c(NA, 7036, 6779, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA)
HRC_HR_5 <- c(NA, 6928, 6769, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA)
NOx_Emmission_Rate_1 <- c(NA, 0.01, 0.01, NA, 0.067, 0.036, NA, 0.06, 0.069, NA, 0.054, 0.054, 0.037, 0.027, NA, 0, 0, 0, 0, NA, 0.125, 0.056, 0, 0.238)
NOx_Emmission_Rate_2 <- c(NA, 0.01, 0.01, NA, 0.053, 0.053, NA, 0.06, 0.059, NA, 0.054, 0.045, 0.021, 0.021, NA, 0, 0, 0, 0, NA, 0.056, 0.052, 0, 0.177)
NOx_Emmission_Rate_3 <- c(NA, 0.01, 0.01, NA, 0.04, 0.032, NA, NA, 0.053, NA, NA, 0.039, NA, 0.019, NA, NA, NA, NA, NA, NA, NA, NA, NA, 0.116)
NOx_Emmission_Rate_4 <- c(NA, 0.01, 0.01, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA)
NOx_Emmission_Rate_5 <- c(NA, 0.006, 0.006, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA)
Cooling_Time_1 <- c(NA, 0, 0, NA, 0, NA, NA, 0, NA, NA, 0, NA, 0, NA, NA, 0, NA, NA, NA, NA, 0, NA, 0, 0)
Cooling_Time_2 <- c(NA, 480, 480, NA, 480, NA, NA, 240, NA, NA, 480, NA, 480, NA, NA, 192, NA, NA, NA, NA, NA, NA, NA, NA)
Cooling_Time_3 <- c(NA, 9600, 9600, NA, 9600, NA, NA, 1200, NA, NA, 9600, NA, 9600, NA, NA, 1152, NA, NA, NA, NA, NA, NA, NA, NA)
Start_Up_Time_1 <- c(NA, 420, 480, NA, 100, NA, NA, 300, NA, NA, 340, NA, 360, NA, NA, 120, NA, NA, NA, NA, 10, NA, 10, 10)
Start_Up_Time_2 <- c(NA, 540, 600, NA, 120, NA, NA, 330, NA, NA, 340, NA, 360, NA, NA, 170, NA, NA, NA, NA, NA, NA, NA, NA)
Start_Up_Time_3 <- c(NA, 600, 550, NA, 170, NA, NA, 360, NA, NA, 320, NA, 360, NA, NA, 320, NA, NA, NA, NA, NA, NA, NA, NA)
Start_Up_AUX_1 <- c(NA, 27, 20, NA, 8, NA, NA, 56, NA, NA, 22, NA, 25, NA, NA, 3, NA, NA, NA, NA, NA, NA, NA, NA)
Start_Up_AUX_2 <- c(NA, 34, 36, NA, 9, NA, NA, 61, NA, NA, 22, NA, 25, NA, NA, 4, NA, NA, NA, NA, NA, NA, NA, NA)
Start_Up_AUX_3 <- c(NA, 37, 39, NA, 12, NA, NA, 66, NA, NA, 23, NA, 25, NA, NA, 5, NA, NA, NA, NA, NA, NA, NA, NA)
Start_Up_Costs_1 <- c(NA, 32600, 55700, NA, 13500, NA, NA, 19500, NA, NA, 14900, NA, 26700, NA, NA, 8420, NA, NA, NA, NA, 3900, NA, 3900, 3900)
Start_Up_Costs_2 <- c(NA, 34700, 59300, NA, 15809, NA, NA, 20100, NA, NA, 18100, NA, 31900, NA, NA, 8420, NA, NA, NA, NA, NA, NA, NA, NA)
Start_Up_Costs_3 <- c(NA, 41400, 69900, NA, 19300, NA, NA, 32100, NA, NA, 20700, NA, 36900, NA, NA, 3900, NA, NA, NA, NA, NA, NA, NA, NA)
Start_Up_Fuel_1 <- c(NA, 5350, 7790, NA, 275, NA, NA, 1600, NA, NA, 495, NA, 759, NA, NA, 2000, NA, NA, NA, NA, 30, NA, 20, 21)
Start_Up_Fuel_2 <- c(NA, 7300, 9880, NA, 275, NA, NA, 2200, NA, NA, 495, NA, 759, NA, NA, 2800, NA, NA, NA, NA, NA, NA, NA, NA)
Start_Up_Fuel_3 <- c(NA, 8450, 10972, NA, 385, NA, NA, 2200, NA, NA, 495, NA, 759, NA, NA, 5800, NA, NA, NA, NA, NA, NA, NA, NA)

####

From_Config <- c("CPP_2_PL_1x1", "CPP_2_PL_2x1", NA, "CIG_6_PL_1x1_M1", "CIG_6_PL_1x1_M2", NA, "CSG_2_PL_1x1_M1", "CSG_2_PL_1x1_M2", NA, "PGG_2_PL_1x1_M1", "PGG_2_PL_1x1_M2", "PGG_2_PL_1x1_M1", "PGG_2_PL_2x1_M1", "PGG_2_PL_2x1_M1", "PGG_2_PL_2x1_M2", NA, "SUT_2_PL_1x1_M1", "SUT_2_PL_1x1_M2", "SUT_2_PL_1x1_M1", "SUT_2_PL_2x1_M1", "SUT_2_PL_2x1_M1", "SUT_2_PL_2x1_M2", NA, "PGG_2_PKR_1x0_M1", "PGG_2_PKR_1x0_M2")
To_Config <-   c("CPP_2_PL_2x1", "CPP_2_PL_1x1", NA, "CIG_6_PL_1x1_M2", "CIG_6_PL_1x1_M1", NA, "CSG_2_PL_1x1_M2", "CSG_2_PL_1x1_M1", NA, "PGG_2_PL_1x1_M2", "PGG_2_PL_1x1_M1", "PGG_2_PL_2x1_M1", "PGG_2_PL_1x1_M1", "PGG_2_PL_2x1_M2", "PGG_2_PL_2x1_M1", NA, "SUT_2_PL_1x1_M2", "SUT_2_PL_1x1_M1", "SUT_2_PL_2x1_M1", "SUT_2_PL_1x1_M1", "SUT_2_PL_2x1_M2", "SUT_2_PL_2x1_M1", NA, "PGG_2_PKR_1x0_M2", "PGG_2_PKR_1x0_M1")
Transition_Costs <- c(25000, NA, NA, NA, NA, NA, NA, NA, NA, 600, NA, 15480, NA, 600, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA)
Transition_Ramp_Time <- c(60, 60, NA, 10, 10, NA, 10, 10, NA, 10, 10, 60, 60, 10, 10, NA, 10, 10, 30, 20, 10, 10, NA, 10, 10)
Notification_Time <- c(60, 60, NA, 10, 10, NA, 10, 10, NA, 10, 10, 60, 60, 10, 10, NA, 20, 20, 60, 30, 20, 20, NA, 10, 10)
Max_Daily_Transitions <- c(2, 2, NA, 12, 12, NA, 12, 12, NA, 12, 12, 2, 2, 12, 12, NA, NA, NA, NA, NA, NA, NA, NA, 12, 12)

GRDT <- data_frame(RESOURCE_ID, CONFIGURATION_ID, Min_Capacity, Max_Capacity, Min_On_Time, Min_Off_Time, 
                 Max_Starts_perDay, GHG_Rate, Worst_OP_Ramp_Rate, HRC_MW_1, HRC_MW_2, HRC_MW_3, HRC_MW_4,
                 HRC_MW_5, HRC_HR_1, HRC_HR_2, HRC_HR_3, HRC_HR_4, HRC_HR_5, NOx_Emmission_Rate_1, 
                 NOx_Emmission_Rate_2, NOx_Emmission_Rate_3, NOx_Emmission_Rate_4, NOx_Emmission_Rate_5,
                 Cooling_Time_1, Cooling_Time_2, Cooling_Time_3, Start_Up_Time_1, Start_Up_Time_2, Start_Up_Time_3,
                 Start_Up_AUX_1, Start_Up_AUX_2, Start_Up_AUX_3, Start_Up_Costs_1, Start_Up_Costs_2, Start_Up_Costs_3,
                 Start_Up_Fuel_1, Start_Up_Fuel_2, Start_Up_Fuel_3)

remove(RESOURCE_ID, CONFIGURATION_ID, Min_Capacity, Max_Capacity, Min_On_Time, Min_Off_Time, 
       Max_Starts_perDay, GHG_Rate, Worst_OP_Ramp_Rate, HRC_MW_1, HRC_MW_2, HRC_MW_3, HRC_MW_4,
       HRC_MW_5, HRC_HR_1, HRC_HR_2, HRC_HR_3, HRC_HR_4, HRC_HR_5, NOx_Emmission_Rate_1, 
       NOx_Emmission_Rate_2, NOx_Emmission_Rate_3, NOx_Emmission_Rate_4, NOx_Emmission_Rate_5,
       Cooling_Time_1, Cooling_Time_2, Cooling_Time_3, Start_Up_Time_1, Start_Up_Time_2, Start_Up_Time_3,
       Start_Up_AUX_1, Start_Up_AUX_2, Start_Up_AUX_3, Start_Up_Costs_1, Start_Up_Costs_2, Start_Up_Costs_3,
       Start_Up_Fuel_1, Start_Up_Fuel_2, Start_Up_Fuel_3)

GRDT_sum <- data_frame(From_Config, To_Config, Transition_Costs, Transition_Ramp_Time, Notification_Time,
                       Max_Daily_Transitions)

remove(From_Config, To_Config, Transition_Costs, Transition_Ramp_Time, Notification_Time,
       Max_Daily_Transitions)

getwd()
setwd("~/SEM/SEM 9:13:18 Uploads")
write.xlsx(GRDT, file = "GRDT.xls")
write.xlsx(GRDT_sum, file = "GRDT Summary.xls")

# For that thing I did 9/13/18

GRDT_subset <- GRDT %>%
  select(10:19)

GRDT_subset <- GRDT_subset %>%
  mutate(., avgMW = rowMeans((GRDT_subset[1:5]), na.rm = TRUE)) %>%
  mutate(avgHR = rowMeans((GRDT_subset[6:10]), na.rm = TRUE)) %>%
  filter(avgMW != "NaN")

GRDT_try <- lm(GRDT_subset$avgHR ~ GRDT_subset$avgMW)
GRDT_try

GRDT_subset <- GRDT_subset %>%
  mutate(try1 = 9723.944 - 6.172*(avgMW))

ggplot(GRDT_subset, aes(x=avgMW, y=avgHR)) + geom_point()

GRDT_try2 <- lm(GRDT_subset$avgHR ~ I(GRDT_subset$avgMW^-2))
summary(GRDT_try2)
confint(GRDT_try2, level=0.95)
plot(fitted(GRDT_try2), residuals(GRDT_try2))      

GRDT_predict <- cbind(GRDT_subset, predict(GRDT_try2, interval = 'confidence'))

ggplot(GRDT_predict, aes(x=avgMW,y=avgHR)) + geom_point() +
  geom_line(aes(x=avgMW, y=fit)) +
  geom_ribbon(aes(ymin=lwr,ymax=upr), alpha=0.3) +
  labs(title = "Effeciency of a y=x^-2 Model for MW vs HR", subtitle = "Mitzi 9/13/18")

# Granular HRC Functions 9/17/18

GRDT_gran <- GRDT %>%
  select(1:2, 10:19) %>%
  filter(!is.na(HRC_MW_1)) %>%
  mutate(GEN_ID = ifelse(!is.na(CONFIGURATION_ID),
                         CONFIGURATION_ID,
                         RESOURCE_ID)) %>%
  select(-RESOURCE_ID, -CONFIGURATION_ID) %>%
  select(GEN_ID, 1:10)

GRDT_gran_CPP1x1 <- GRDT_gran[1,]
GRDT_gran_CPP1x1 <- GRDT_gran_CPP1x1

MW_CPP1x1 <- c(GRDT_gran_CPP1x1[1,2], GRDT_gran_CPP1x1[1,3], GRDT_gran_CPP1x1[1,4], GRDT_gran_CPP1x1[1,5], GRDT_gran_CPP1x1[1,6])
HR_CPP1x1 <- c(GRDT_gran_CPP1x1[1,7], GRDT_gran_CPP1x1[1,8], GRDT_gran_CPP1x1[1,9], GRDT_gran_CPP1x1[1,10], GRDT_gran_CPP1x1[1,11])
G_CPP1x1 <- data_frame(MW_CPP1x1, HR_CPP1x1) %>%
  rename("MW" = "MW_CPP1x1",
         "HR" = "HR_CPP1x1")
G_CPP1x1$MW <- as.numeric(G_CPP1x1$MW)
G_CPP1x1$HR <- as.numeric(G_CPP1x1$HR)

#to do the rest

GRDT_gran_CPP2x1 <- GRDT_gran[2,]

GRDT_gran_CPP2x1 <- GRDT_gran_CPP2x1 %>%
  rename("MW" = "HRC_MW_1",
         "MW" = "HRC_MW_2",
         "MW" = "HRC_MW_3",
         "MW" = "HRC_MW_4",
         "MW" = "HRC_MW_5",
         "HR" = "HRC_HR_1",
         "HR" = "HRC_HR_2",
         "HR" = "HRC_HR_3",
         "HR" = "HRC_HR_4",
         "HR" = "HRC_HR_5")

GRDT_gran_CIG_M1 <- GRDT_gran[3,]
GRDT_gran_CIG_M2 <- GRDT_gran[4,]
GRDT_gran_CSG_M1 <- GRDT_gran[5,]
GRDT_gran_CSG_M2 <- GRDT_gran[6,]
GRDT_gran_PGG1x1_M1 <- GRDT_gran[7,]
GRDT_gran_PGG1x1_M2 <- GRDT_gran[8,]
GRDT_gran_PGG2x1_M1 <- GRDT_gran[9,]
GRDT_gran_PGG2x1_M2 <- GRDT_gran[10,]
GRDT_gran_SUT1x1_M1 <- GRDT_gran[11,]
GRDT_gran_SUT1x1_M2 <- GRDT_gran[12,]
GRDT_gran_SUT2x1_M1 <- GRDT_gran[13,]
GRDT_gran_SUT2x1_M2 <- GRDT_gran[14,]
GRDT_gran_PGG1x0_M1 <- GRDT_gran[15,]
GRDT_gran_PGG1x0_M2 <- GRDT_gran[16,]
GRDT_gran_MCC_PKR <- GRDT_gran[17,]
GRDT_gran_CIG_PKR <- GRDT_gran[18,]


GRDT_gran_1 <- GRDT_gran %>%
  select(GEN_ID, HRC_MW_1, HRC_HR_1) %>%
  rename("MW" = "HRC_MW_1",
         "HR" = "HRC_HR_1")

GRDT_gran_2 <- GRDT_gran %>%
  select(GEN_ID, HRC_MW_2, HRC_HR_2) %>%
  rename("MW" = "HRC_MW_2",
         "HR" = "HRC_HR_2")

GRDT_gran_3 <- GRDT_gran %>%
  select(GEN_ID, HRC_MW_3, HRC_HR_3) %>%
  rename("MW" = "HRC_MW_3",
         "HR" = "HRC_HR_3")

GRDT_gran_4 <- GRDT_gran %>%
  select(GEN_ID, HRC_MW_4, HRC_HR_4) %>%
  rename("MW" = "HRC_MW_4",
         "HR" = "HRC_HR_4")

GRDT_gran_5 <- GRDT_gran %>%
  select(GEN_ID, HRC_MW_5, HRC_HR_5) %>%
  rename("MW" = "HRC_MW_5",
         "HR" = "HRC_HR_5")

GRDT_gran_x <- rbind(GRDT_gran_1, GRDT_gran_2, GRDT_gran_3, GRDT_gran_4, GRDT_gran_5)
GRDT_gran_x <- GRDT_gran_x %>%
  filter(!is.na(MW))

#plots

hrc <- geom_point(aes(x = MW, y = HR)) 
curve <- geom_smooth(aes(x = MW, y = HR))

ggplot(G_CPP1x1) + hrc + labs(title = "CPP 1x1")

ggplot(GRDT_gran_x, aes(x=MW,y=HR)) + geom_point() + facet_wrap(~GEN_ID)

GRDT_gran_x %>%
  filter(GEN_ID == "CIG_6_PKR") %>%
  ggplot() + hrc + labs(title = "CIG 6 PKR")

GRDT_gran_x %>%
  filter(GEN_ID == "CIG_6_PL_1x1_M1") %>%
  ggplot() + hrc + labs(title = "CIG 6 PL 1x1 M1")

GRDT_gran_x %>%
  filter(GEN_ID == "CIG_6_PL_1x1_M2") %>%
  ggplot() + hrc + labs(title = "CIG 6 PL 1x1 M2")

GRDT_gran_x %>%
  filter(GEN_ID == "CPP_2_PL_1x1") %>%
  ggplot() + hrc + labs(title = "CPP 2 PL 1x1")

GRDT_gran_x %>%
  filter(GEN_ID == "CPP_2_PL_2x1") %>%
  ggplot() + hrc + labs(title = "CPP 2 PL 2x1")

GRDT_gran_x %>%
  filter(GEN_ID == "CSG_2_PL_1x1_M1") %>%
  ggplot() + hrc + labs(title = "CSG 2 PL 1x1 M1")

GRDT_gran_x %>%
  filter(GEN_ID == "CSG_2_PL_1x1_M2") %>%
  ggplot() + hrc + labs(title = "CSG 2 PL 1x1 M2")

GRDT_gran_x %>%
  filter(GEN_ID == "MCC_6_PKR") %>%
  ggplot() + hrc + labs(title = "MCC 6 PKR")

GRDT_gran_x %>%
  filter(GEN_ID == "PGG_2_PKR_1x0_M1") %>%
  ggplot() + hrc + labs(title = "PGG 2 PKR 1x0 M1")

GRDT_gran_x %>%
  filter(GEN_ID == "PGG_2_PKR_1x0_M2") %>%
  ggplot() + hrc + labs(title = "PGG 2 PKR 1x0 M2")

GRDT_gran_x %>%
  filter(GEN_ID == "PGG_2_PL_1x1_M1") %>%
  ggplot() + hrc + labs(title = "PGG 2 PL 1x1 M1")

GRDT_gran_x %>%
  filter(GEN_ID == "PGG_2_PL_1x1_M2") %>%
  ggplot() + hrc + labs(title = "PGG 2 PL 1x1 M2")

GRDT_gran_x %>%
  filter(GEN_ID == "PGG_2_PL_2x1_M1") %>%
  ggplot() + hrc + labs(title = "PGG 2 PL 2x1 M1")

GRDT_gran_x %>%
  filter(GEN_ID == "PGG_2_PL_2x1_M2") %>%
  ggplot() + hrc + labs(title = "PGG 2 PL 2x1 M2")

GRDT_gran_x %>%
  filter(GEN_ID == "SUT_2_PL_1x1_M1") %>%
  ggplot() + hrc + labs(title = "SUT 2 PL 1x1 M1")

GRDT_gran_x %>%
  filter(GEN_ID == "SUT_2_PL_1x1_M2") %>%
  ggplot() + hrc + labs(title = "SUT 2 PL 1x1 M2")

GRDT_gran_x %>%
  filter(GEN_ID == "SUT_2_PL_2x1_M1") %>%
  ggplot() + hrc + labs(title = "SUT 2 PL 2x1 M1")

GRDT_gran_x %>%
  filter(GEN_ID == "SUT_2_PL_2x1_M2") %>%
  ggplot() + hrc + labs(title = "SUT 2 PL 2x1 M2")


GRDT_gran_x %>%
  ggplot() + hrc + labs(title = "All Generators") + curve


