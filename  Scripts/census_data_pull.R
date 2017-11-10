install.packages("acs")
install.packages("XML")
library(acs)

api.key.install(key = "73052a1c27ab4747c96d838a03b24f4989364dd8")

# create a geo.set using using the geo.make() function
# optionally acs.lookup() function to explore variables that are of interest
# use acs.fetch() to download data for your new geography

# create new york counties geographies
newyork <- geo.make(state = "NY", county = "*")

#----------------Identify Tables-------------------#

# Tables for Public Transportation 
transportation <- acs.lookup(2015, span = 5, dataset = "acs",
                            keyword = "transportation",
                            case.sensitive = F)
# check data structure to extract results
str(transportation)
# transportation results
transportation.var <- transportation@results

# Sex of Workers by Means of Transportation to Work
# MEANS OF TRANSPORTATION TO WORK BY AGE 
# MEANS OF TRANSPORTATION TO WORK BY RACE
# MEANS OF TRANSPORTATION TO WORK BY CITIZENSHIP STATUS
# MEANS OF TRANSPORTATION TO WORK BY LANGUAGE SPOKEN AT HOME AND ABILITY TO SPEAK ENGLISH
# Means of Transportation to Work by Workers' Earnings
# MEANS OF TRANSPORTATION TO WORK BY POVERTY STATUS IN THE PAST 12 MONTHS
# MEANS OF TRANSPORTATION TO WORK BY OCCUPATION
# Means of Transportation to Work by Travel Time to Work
# MEANS OF TRANSPORTATION TO WORK BY VEHICLES AVAILABLE
transportation.gender <- transportation.var[1:13,]
transportation.age <- transportation.var[14:21,]
transportation.race <- transportation.var[23:31,]
transportation.citizenship.status <- transportation.var[32:36,]
transportation.language <- transportation.var[37:44,]
transportation.income <- transportation.var[45:53,]
transportation.occupation <- transportation.var[62:68,]
transportation.poverty.status <- transportation.var[55:58,]
transportation.time <- transportation.var[123:132,]
transportation.vehicle.available <- transportation.var[170:174,]

# Tables for Income Level
median.income <- acs.lookup(2015, span = 5, dataset = "acs",
                     keyword = "household income",
                     case.sensitive = F)
median.income <- median.income@results
median.income <- median.income[1,]

# Tables for Car Ownership
car.ownership <- acs.lookup(2015, span = 5, dataset = "acs",
                  keyword = "vehicle",
                  case.sensitive = F)

car.ownership <- car.ownership@results
car.ownership <- car.ownership[20:23,]

# Tables for Internet Access
# this table comes form the 2016 ACS 1-year estimates
internet.access <- acs.lookup(2016, span = 1, dataset = "acs",
                       table.number = "B28011")
internet.access <- internet.access@results
internet.access <- internet.access[1:8,]

# Table for Computer Access
# this table comes form the 2016 ACS 1-year estimates
computer.access <- acs.lookup(2016, span = 1, dataset = "acs",
                       table.number = "B28001")
computer.access <- computer.access@results
computer.access <- computer.access[1:11,]

# Table for Citizenship Status 
citizenship.status <- acs.lookup(2015, span = 5, dataset = "acs",
                          table.number = "B05001")
citizenship.status <- citizenship.status@results

# Table for Limited English Speaking Households
limited.english <- acs.lookup(2015, span = 5, dataset = "acs",
                              keyword = "spanish",
                              case.sensitive = F)
limited.english <- limited.english@results
limited.english <- limited.english[72:74,]

# combine variables of interest into data frame
variables <- rbind(transportation.gender, transportation.age,
                   transportation.race, transportation.citizenship.status,
                   transportation.language, transportation.income,
                   transportation.occupation, transportation.poverty.status,
                   transportation.time, transportation.vehicle.available,
                   median.income, car.ownership, internet.access,
                   computer.access, citizenship.status, limited.english)

#---------------Download data------------------------

# Download Car Ownership Data
#B08141 - Means of Transportation to Work By Vehicles Available
cars.table <- acs.fetch(endyear = 2015, span = 5, geography = newyork,
                        table.number = "B08141")

#B081410001 Total; B08141002 No Vehicle Available; B08141003 1 Vehicle Available
#B08141004 2 Vehicles Available; B08141005 3 or More Vehicles Available
str(cars.table)
cars.geo <- cars.table@geography
cars.est <- cars.table@estimate[,2:5]
cars.se <- cars.table@standard.error[,2:5]
cars.df <- cbind(cars.geo, cars.est, cars.se)

# rename column headers
colnames(cars.df)[4] <- paste0(names(cars.df[4]), "est")
colnames(cars.df)[5] <- paste0(names(cars.df[5]), "est")
colnames(cars.df)[6] <- paste0(names(cars.df[6]), "est")
colnames(cars.df)[7] <- paste0(names(cars.df[7]), "est")

colnames(cars.df)[8] <- paste0(names(cars.df[8]), "se")
colnames(cars.df)[9] <- paste0(names(cars.df[9]), "se")
colnames(cars.df)[10] <- paste0(names(cars.df[10]), "se")
colnames(cars.df)[11] <- paste0(names(cars.df[11]), "se")

# Download Limited English Data
#B16002_002: English Only Households
#B16002_003: Household Language by Household Limited English Speaking Status: Spanish Total
#B16002_004: Spanish: Limited English speaking household; No one 14 and over speaks English only or speaks english very well
#B16002_005: Spanish: Not a limited English speaking household; At least one person 14 and over speaks English only or speaks English very well

lang.table <- acs.fetch(endyear = 2015, span = 5, geography = newyork,
                            table.number = "B16002")
lang.geo <- lang.table@geography
lang.est <- lang.table@estimate[,2:5]
lang.se <- lang.table@standard.error[,2:5]
lang.df <- cbind(lang.geo, lang.est, lang.se)

# rename column headers
colnames(lang.df)[4] <- paste0(names(lang.df[4]), "est")
colnames(lang.df)[5] <- paste0(names(lang.df[5]), "est")
colnames(lang.df)[6] <- paste0(names(lang.df[6]), "est")
colnames(lang.df)[7] <- paste0(names(lang.df[7]), "est")

colnames(lang.df)[8] <- paste0(names(lang.df[8]), "se")
colnames(lang.df)[9] <- paste0(names(lang.df[9]), "se")
colnames(lang.df)[10] <- paste0(names(lang.df[10]), "se")
colnames(lang.df)[11] <- paste0(names(lang.df[11]), "se")

# Download Citizenship Status Data
#B05001_002: US citizen, born in the US
#B05001_003: US citizen, born in Puerto Rico or US Island Areas
#B05001_004: US citizen, born abroad of American parents
#B05001_005: US citizen by naturalization
#B05001_006: Not a US citizen
citizen.table <- acs.fetch(endyear = 2015, span = 5, geography = newyork,
                           table.number = "B05001")
citizen.geo <- citizen.table@geography
citizen.est <- citizen.table@estimate
citizen.se <- citizen.table@standard.error
