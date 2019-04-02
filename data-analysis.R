install.packages('ggplot2')

library(lubridate)
library(ggplot2)
library(grid)
library(gridExtra)
library(scales)
library(rattle)
library(randomForest)
library(caret)
library(Hmisc)
library(e1071)
library(corrplot)

summary(data1)

# data1 <-data1[!is.na(data1$light),]

data1[is.na(data1)] <- 0

plot(data1$Temp)

data1$Data<- ymd_hms(data1$Data)
data1$Data <- as.POSIXct(data1$Data,tz="UTC")

myplot1 <- ggplot(data1,aes(Data))+geom_line(color="Red",aes(y=Temp))+ylab("Temperature")+xlab("Time")+
           scale_x_datetime(breaks=date_breaks("1440 min"),labels=date_format("%H:%M"),
           limits=as.POSIXct(c("2011-01-01 8:00","2011-12-31 9:00"),tz="GMT"))+
           theme(axis.text.x=element_text(angle=90,hjust=1))
print(myplot1, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))
