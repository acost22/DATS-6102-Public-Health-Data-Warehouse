setwd("~/Documents/Github/DATS-6102-Public-Health-Data-Warehouse/Flat Files")

hos <- read.csv("hosp_clean.csv")
pharm <- read.csv("pharm_clean.csv")
urgent <- read.csv("UCF.csv")
demo <- read.csv("demographic.csv")

str(hos)
# NAME = FACTOR; change to chr
# ADDRESS = FACTOR; change to chr
# CITY = FACTOR; change to chr
# STATE = FACTOR
# TYPE = FACTOR
# POPULATION: INT
# COUNTY = FACTOR
# COUNTY FIPS = INT
# LATITUDE = NUM
# LONGITUDE = NUM
# OWNER = FACTOR
# BEDS = INT
# HELIPAD = FACTOR; change to dummy variable (num)

# Change factor to chr
hos$NAME <- as.character(hos$NAME)
hos$ADDRESS <- as.character(hos$ADDRESS)
hos$CITY <- as.character(hos$CITY)

# Create dummy variable for HELIPAD
hos$heli.dummy <- ifelse(hos$HELIPAD == levels(hos$HELIPAD)[2], 1, 0)

# rename LATITUDE as Y and LONGITUDE as X
colnames(hos)[12] <- "Y"
colnames(hos)[13] <- "X"

# rearrange X before Y
hos <- hos[,c(1:11,13,12,14:17)]

# Remove STATE, ZIP, STATUS, COUNTRY; write final flat file
hos <- hos[, -c(4,5,7,11)]
write.csv(hos, file = "~/Documents/Github/DATS-6102-Public-Health-Data-Warehouse/Flat Files/hospital_final.csv")

str(pharm)
# NAME = FACTOR; change to chr
# ADDRESS = FACTOR; change to chr
# CITY = FACTOR; change to chr
# COUNTY = FACTOR
# FIPS = INT
# X = NUM
# Y = NUM

# Change factor to chr
pharm$NAME <- as.character(pharm$NAME)
pharm$ADDRESS <- as.character(pharm$ADDRESS)
pharm$CITY <- as.character(pharm$CITY)

# Remvoe STATE & ZIP
pharm <- pharm[, -c(4,5)]

write.csv(pharm, file = "~/Documents/Github/DATS-6102-Public-Health-Data-Warehouse/Flat Files/pharmacy_final.csv")

str(urgent)
# NAME = FACTOR; change to chr
# ADDRESS = FACTOR; change to chr
# CITY = FACTOR; change to chr
# COUNTY = FACTOR
# FIPS = INT
# X = NUM
# Y = NUM

# Change factor to chr
urgent$NAME <- as.character(urgent$NAME)
urgent$ADDRESS <- as.character(urgent$ADDRESS)
urgent$CITY <- as.character(urgent$CITY)

# Remove ID, TELEPHONE, STATE, ZIP
urgent <- urgent[, -c(1,3,6,7)]

write.csv(urgent, file = "~/Documents/Github/DATS-6102-Public-Health-Data-Warehouse/Flat Files/urgent_final.csv")

str(demo)
write.csv(demo, file = "~/Documents/Github/DATS-6102-Public-Health-Data-Warehouse/Flat Files/demographic_final.csv")
