
#### -----------------------------Header---------------------####
# Program Name : data.r
# Program Purpose : Data Analysis.
# Created By : Deepak Saini
# Created Date : Oct-2020
#
#

#-----------------------------------------------------------------

rm(list = ls())

library(tidyverse)
library(sqldf)

# df <- read.csv("https://raw.githubusercontent.com/RamiKrispin/coronavirus/master/csv/coronavirus.csv", stringsAsFactors = FALSE)

df <- read.csv("https://api.covid19india.org/csv/latest/district_wise.csv")

df <- df %>%
  mutate(Active = as.numeric(Active)) %>%
  mutate(Confirmed = as.numeric(Confirmed)) %>%
  mutate(Recovered = as.numeric(Recovered)) %>%
  mutate(Deceased = as.numeric(Deceased)) %>%
  mutate(Active = Confirmed - Recovered - Deceased - Migrated_Other) %>%
  select(State_Code, State, District, Confirmed, Recovered, Active, Deceased) %>%
  arrange(-Confirmed)

state_wise_daily <- read.csv("https://api.covid19india.org/csv/latest/state_wise_daily.csv")

df1 <- state_wise_daily %>%
  mutate(Date = as.Date(Date, format = "%d-%b-%y")) %>%
  pivot_longer(
    cols = c("TT", "AN", "AP", "AR", "AS", "BR", "CH", "CT", "DN", "DD", "DL", "GA", "GJ", "HR", "HP", "JK", "JH", "KA", "KL", "LA", "LD", "MP", "MH", "MN", "ML", "MZ", "NL", "OR", "PY", "PB", "RJ", "SK", "TN", "TG", "TR", "UP", "UT", "WB", "UN"),
    names_to = "State_Code",
    values_to = "cases"
  ) %>%
  arrange(Date, State_Code, Status) %>%
  mutate(cases = if_else(cases < 0, abs(cases), cases))

# summary(df1)


df1_daily <- sqldf("select a.*,b.State from df1 as a left join (select distinct State,State_Code from df) as b
                     on a.State_Code = b.State_Code")

df1_daily <- df1_daily %>%
  pivot_wider(
    values_from = cases,
    names_from = Status
  ) %>%
  group_by(State) %>%
  mutate(Cumulative_Confirmed = cumsum(Confirmed)) %>%
  mutate(Cumulative_Recovered = cumsum(Recovered)) %>%
  mutate(Cumulative_Deceased = cumsum(Deceased)) %>%
  pivot_longer(
    cols = c("Confirmed", "Recovered", "Deceased", "Cumulative_Confirmed", "Cumulative_Recovered", "Cumulative_Deceased"),
    values_to = "cases",
    names_to = "Status"
  )


state_choices <- sort(unique(df1_daily$State))

# for Summary Button

summary <- sqldf('select Date,case when Status="Cumulative_Confirmed"
   then "Confirmed" when Status="Cumulative_Recovered" then  "Recovered"
when Status="Cumulative_Deceased" then "Deceased" end as Status,cases from df1_daily where State_Code = "TT" and Status in
                   ("Cumulative_Confirmed","Cumulative_Recovered","Cumulative_Deceased")   ')
# for Comparison Button

comparison <- df1_daily %>%
  filter(Date == max(Date) & Status == "Cumulative_Confirmed" & State != "NA") %>%
  arrange(-cases) %>%
  head(10)

comparison1 <- sqldf('select *  from df1_daily where State in (select distinct State from comparison)
                        and Status in ("Cumulative_Confirmed","Cumulative_Recovered","Cumulative_Deceased")
                        ')

comparison1 <- comparison1 %>%
  mutate(
    Status = if_else(Status == "Cumulative_Confirmed", "Confirmed", Status),
    Status = if_else(Status == "Cumulative_Recovered", "Recovered", Status),
    Status = if_else(Status == "Cumulative_Deceased", "Deceased", Status)
  ) %>%
  filter(Date == max(Date))

df_compare <- comparison1 %>%
  dplyr::group_by(State, Status) %>%
  dplyr::summarise(total = sum(cases)) %>%
  tidyr::pivot_wider(
    names_from = Status,
    values_from = total
  ) %>%
  dplyr::arrange(Confirmed) %>%
  dplyr::ungroup()

# Group by Sate Overall

df_total <- sqldf("select distinct State,'All Districts' as District,sum(Confirmed) as Confirmed,sum(Recovered) as Recovered,
                   sum(Active) as Active,sum(Deceased) as Deceased
                   from df 
                   group by State
                   order by Confirmed desc")

df <- df %>% select(-State_Code)
df_final <- rbind(df, df_total) %>%
  arrange(State, -Confirmed)



# Vbox

vbox <- sqldf("select sum(Confirmed) as Confirmed,sum(Active) as Active
              ,sum(Recovered) as Recovered,sum(Deceased) as Deceased from df ")

# Coordinate

india <- read_csv("data/Indian Cities Database.csv", col_types = cols())
india <- india %>%
  mutate(State = if_else(State == "Daman and Diu", "Dadra and Nagar Haveli and Daman and Diu", State)) %>%
  rename(District = City) %>%
  distinct(State, .keep_all = TRUE)

map <- sqldf("select a.*,b.Lat,b.Long from df_total a left join india b on a.State=b.State")

cv_data_for_plot <- map %>%
  select(-District) %>%
  pivot_longer(
    cols = c("Confirmed", "Recovered", "Active", "Deceased"),
    names_to = "type",
    values_to = "cases"
  ) %>%
  mutate(log_cases = 2 * log(cases))

cv_data_for_plot.split <- cv_data_for_plot %>% split(cv_data_for_plot$type)
