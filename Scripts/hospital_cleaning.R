View(hospital)#Check number of columns,rows in data frame hospital
head(hospital)
tail(hospital)
ncol(hospital)
nrow(hospital)
str(hospital)
#check if there are any NA values in the data frame
sapply(hospital, function(x) sum(is.na(x)))
#Get list of all variable names
names(hospital)
#Select data from New York State only
hospital<-hospital[(hospital$STATE=='NY'),]
#Selects hospitals which are open on the basis of STATUS
hospital<-hospital[(hospital$STATUS=='OPEN'),]
#Drop variables OBJECTID,ID,ADDRESS2,ZIP4,TELEPHONE,NAICS_CODE,NAICS_DESC,SOURCE,SOURCEDATE,VAL_METHOD,VAL_DATE,WEBSITE,STATE_ID,ALT_NAME,ST_FIPS,TTL_STAFF,TRAUMA,DATECREATE

new_hospital<-hospital[c("NAME","ADDRESS","CITY","STATE","ZIP","TYPE","STATUS",
                         "POPULATION","COUNTY","COUNTYFIPS","COUNTRY","LATITUDE","LONGITUDE","OWNER","BEDS","HELIPAD")]
#Count number of hospitals in each zip code
table(new_hospital$ZIP)
#Plot a coordinate density map to show the number of hospitals in new york state
library(readr)
library(ggplot2)
ggplot(data = new_hospital) + aes(LONGITUDE, LATITUDE) + 
  geom_point(pch = 16, alpha = 0.7) + theme_grey() + 
  labs(title = "HOSPITALS IN NEW YORK")
#Plot a bar graph showing count of hospitals in each county
library(ggplot2)
library(forcats)
b <- ggplot(data = new_hospital) + aes(fct_infreq(new_hospital$COUNTY)) 
b + geom_bar() + theme_gray() + 
  xlab('COUNTY NAME') + 
  ylab('Count of HOSPITALS')+  theme(axis.text.x = element_text(angle = 60, hjust = 1))
