# Instala??o e chamada dos pacotes necess?rios
install.packages('ggplot2')
install.packages('lubridate')
install.packages('gridExtra')
install.packages('scales')
install.packages('rattle')
install.packages('randomForest')
install.packages('caret')
install.packages('Hmisc')
install.packages('e1071')
install.packages('corrplot')
install.packages('dplyr')

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
library(dplyr)

# Esta??es: 1 - AV, 2 - BG, 3 - CA, 4 - CG, 5 - IR, 6 - PG, 7 - SC, 8 - SP

# Importa??o da base de dados
data = read.csv('data/Dados_horários_do_monitoramento_da_qualidade_do_ar__MonitorAr.csv')

summary(data)

# data <- data[!is.na(data),]

# Eliminando colunas desnecessárias
data$Estação <- NULL
data$OBJECTID <- NULL

# Alterando formato de data para o formato UTC
data$Data<- ymd_hms(data$Data)
data$Data <- as.POSIXct(data$Data,tz="UTC")

mean(data$Chuva, na.rm = TRUE)
mean(data$Temp, na.rm = TRUE)

boxplot(data$UR)
mean(data$UR, na.rm = TRUE)

# Retirando os termos NA da base de dados e outliers
data$Chuva = ifelse(is.na(data$Chuva), mean(data$Chuva, na.rm = TRUE), data$Chuva)
data$Pres = ifelse(is.na(data$Pres), mean(data$Pres, na.rm = TRUE), data$Pres)
data$RS = ifelse(is.na(data$RS), mean(data$RS, na.rm = TRUE), data$RS)
data$Temp = ifelse(is.na(data$Temp), mean(data$Temp, na.rm = TRUE), data$Temp)
data$UR = ifelse(is.na(data$UR), mean(data$UR, na.rm = TRUE), data$UR)
data$Dir_Vento = ifelse(is.na(data$Dir_Vento), mean(data$Dir_Vento, na.rm = TRUE), data$Dir_Vento)
data$Vel_Vento = ifelse(is.na(data$Vel_Vento), mean(data$Vel_Vento, na.rm = TRUE), data$Vel_Vento)
data$SO2 = ifelse(is.na(data$SO2), mean(data$SO2, na.rm = TRUE), data$SO2)
data$NO2 = ifelse(is.na(data$NO2), mean(data$NO2, na.rm = TRUE), data$NO2)
data$HCNM = ifelse(is.na(data$HCNM), mean(data$HCNM, na.rm = TRUE), data$HCNM)
data$HCT = ifelse(is.na(data$HCT), mean(data$HCT, na.rm = TRUE), data$HCT)
data$CH4 = ifelse(is.na(data$CH4), mean(data$CH4, na.rm = TRUE), data$CH4)
data$CO = ifelse(is.na(data$CO), mean(data$CO, na.rm = TRUE), data$CO)
data$NO = ifelse(is.na(data$NO), mean(data$NO, na.rm = TRUE), data$NO)
data$NOx = ifelse(is.na(data$NOx), mean(data$NOx, na.rm = TRUE), data$NOx)
data$O3 = ifelse(is.na(data$O3), mean(data$O3, na.rm = TRUE), data$O3)
data$PM10 = ifelse(is.na(data$PM10), mean(data$PM10, na.rm = TRUE), data$PM10)
data$PM2_5 = ifelse(is.na(data$PM2_5), mean(data$PM2_5, na.rm = TRUE), data$PM2_5)

# data$Temp = ifelse(data$Temp >= 100, mean(data$Temp, na.rm = TRUE), data$Temp)

plot(data$Temp)

# Plotando gr?ficos da base de dados
myplot1 <- ggplot(data,aes(Data))+geom_line(color="Red",aes(y=Temp))+ylab("Temperature")+xlab("Time")+
                  scale_x_datetime(labels=date_format("%H:%M"),
                  limits=as.POSIXct(c("2012-01-01 8:00","2012-02-01 9:00"),tz="GMT"))
#print(myplot1, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))

myplot2 <- ggplot(data,aes(Data))+geom_line(color="Blue",aes(y=Chuva))+ylab("Chuva")+xlab("Time")+
                  scale_x_datetime(labels=date_format("%H:%M"),
                  limits=as.POSIXct(c("2012-01-01 8:00","2012-02-01 9:00"),tz="GMT"))
#print(myplot2, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))

myplot3 <- ggplot(data,aes(Data))+geom_line(color="Green",aes(y=Pres))+ylab("Pres")+xlab("Time")+
                  scale_x_datetime(labels=date_format("%H:%M"),
                  limits=as.POSIXct(c("2012-01-01 8:00","2012-02-01 9:00"),tz="GMT"))
#print(myplot3, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))

myplot4 <- ggplot(data,aes(Data))+geom_line(color="Yellow",aes(y=RS))+ylab("RS")+xlab("Time")+
                  scale_x_datetime(labels=date_format("%H:%M"),
                  limits=as.POSIXct(c("2012-01-01 8:00","2012-02-01 9:00"),tz="GMT"))
#print(myplot4, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))

myplot5 <- ggplot(data,aes(Data))+geom_line(color="Brown",aes(y=UR))+ylab("UR")+xlab("Time")+
                  scale_x_datetime(labels=date_format("%H:%M"),
                  limits=as.POSIXct(c("2012-01-01 8:00","2012-02-01 9:00"),tz="GMT"))
#print(myplot5, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))

myplot1 <- ggplot_gtable(ggplot_build(myplot1))
myplot2 <- ggplot_gtable(ggplot_build(myplot2))
myplot3 <- ggplot_gtable(ggplot_build(myplot3))
myplot4 <- ggplot_gtable(ggplot_build(myplot4))
myplot5 <- ggplot_gtable(ggplot_build(myplot5))

maxWidth = unit.pmax(myplot1$widths[2:3],myplot2$widths[2:3], myplot3$widths[2:3],myplot4$widths[2:3], myplot5$widths[2:3])

myplot1$widths[2:3] <- maxWidth
#grid.arrange(myplot1, myplot2, myplot3, ncol=1)
#grid.arrange(myplot4, myplot5, myplot6, ncol=1)

grid.arrange(myplot1, myplot2, myplot3, myplot4, myplot5, ncol=2)

myplot6 <- ggplot(data,aes(Data))+geom_line(color="Red",aes(y=Dir_Vento))+ylab("Dir_Vento")+xlab("Time")+
                  scale_x_datetime(labels=date_format("%H:%M"),
                  limits=as.POSIXct(c("2012-01-01 8:00","2012-12-31 9:00"),tz="GMT"))
#print(myplot6, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))
  
myplot7 <- ggplot(data,aes(Data))+geom_line(color="Blue",aes(y=Vel_Vento))+ylab("Vel_Vento")+xlab("Time")+
                  scale_x_datetime(labels=date_format("%H:%M"),
                  limits=as.POSIXct(c("2012-01-01 8:00","2012-12-31 9:00"),tz="GMT"))
# print(myplot7, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))
  
myplot6 <- ggplot_gtable(ggplot_build(myplot6))
myplot7 <- ggplot_gtable(ggplot_build(myplot7))
  
maxWidth = unit.pmax(myplot6$widths[2:3],myplot7$widths[2:3])
  
myplot1$widths[2:3] <- maxWidth
grid.arrange(myplot6, myplot7, ncol=1)

myplot8 <- ggplot(data,aes(Data))+geom_line(color="Red",aes(y=SO2))+ylab("SO2")+xlab("Time")+
  scale_x_datetime(labels=date_format("%H:%M"),
                   limits=as.POSIXct(c("2012-01-01 8:00","2012-02-01 9:00"),tz="GMT"))
#print(myplot1, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))

myplot9 <- ggplot(data,aes(Data))+geom_line(color="Blue",aes(y=NO2))+ylab("NO2")+xlab("Time")+
  scale_x_datetime(labels=date_format("%H:%M"),
                   limits=as.POSIXct(c("2012-01-01 8:00","2012-02-01 9:00"),tz="GMT"))
#print(myplot2, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))

myplot10 <- ggplot(data,aes(Data))+geom_line(color="Green",aes(y=HCNM))+ylab("HCNM")+xlab("Time")+
  scale_x_datetime(labels=date_format("%H:%M"),
                   limits=as.POSIXct(c("2012-01-01 8:00","2012-02-01 9:00"),tz="GMT"))
#print(myplot3, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))

myplot11 <- ggplot(data,aes(Data))+geom_line(color="Yellow",aes(y=HCT))+ylab("HCT")+xlab("Time")+
  scale_x_datetime(labels=date_format("%H:%M"),
                   limits=as.POSIXct(c("2012-01-01 8:00","2012-02-01 9:00"),tz="GMT"))
#print(myplot4, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))

myplot12 <- ggplot(data,aes(Data))+geom_line(color="Brown",aes(y=CH4))+ylab("CH4")+xlab("Time")+
  scale_x_datetime(labels=date_format("%H:%M"),
                   limits=as.POSIXct(c("2012-01-01 8:00","2012-02-01 9:00"),tz="GMT"))
#print(myplot5, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))

myplot13 <- ggplot(data,aes(Data))+geom_line(color="Orange",aes(y=CO))+ylab("CO")+xlab("Time")+
  scale_x_datetime(labels=date_format("%H:%M"),
                   limits=as.POSIXct(c("2012-01-01 8:00","2012-02-01 9:00"),tz="GMT"))
#print(myplot5, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))


myplot8 <- ggplot_gtable(ggplot_build(myplot8))
myplot9 <- ggplot_gtable(ggplot_build(myplot9))
myplot10 <- ggplot_gtable(ggplot_build(myplot10))
myplot11 <- ggplot_gtable(ggplot_build(myplot11))
myplot12 <- ggplot_gtable(ggplot_build(myplot12))
myplot13 <- ggplot_gtable(ggplot_build(myplot13))
maxWidth = unit.pmax(myplot8$widths[2:3],myplot9$widths[2:3], myplot10$widths[2:3],myplot11$widths[2:3], myplot12$widths[2:3], myplot13$widths[2:3])

myplot1$widths[2:3] <- maxWidth

grid.arrange(myplot8, myplot9, myplot10, myplot11, myplot12, myplot13, ncol=2)

myplot14 <- ggplot(data,aes(Data))+geom_line(color="Red",aes(y=NO))+ylab("NO")+xlab("Time")+
  scale_x_datetime(labels=date_format("%H:%M"),
                   limits=as.POSIXct(c("2012-01-01 8:00","2012-02-01 9:00"),tz="GMT"))
#print(myplot1, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))

myplot15 <- ggplot(data,aes(Data))+geom_line(color="Blue",aes(y=NOx))+ylab("NOx")+xlab("Time")+
  scale_x_datetime(labels=date_format("%H:%M"),
                   limits=as.POSIXct(c("2012-01-01 8:00","2012-02-01 9:00"),tz="GMT"))
#print(myplot2, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))

myplot16 <- ggplot(data,aes(Data))+geom_line(color="Green",aes(y=O3))+ylab("O3")+xlab("Time")+
  scale_x_datetime(labels=date_format("%H:%M"),
                   limits=as.POSIXct(c("2012-01-01 8:00","2012-02-01 9:00"),tz="GMT"))
#print(myplot3, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))

myplot17 <- ggplot(data,aes(Data))+geom_line(color="Yellow",aes(y=PM10))+ylab("PM10")+xlab("Time")+
  scale_x_datetime(labels=date_format("%H:%M"),
                   limits=as.POSIXct(c("2012-01-01 8:00","2012-02-01 9:00"),tz="GMT"))
#print(myplot4, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))

myplot18 <- ggplot(data,aes(Data))+geom_line(color="Brown",aes(y=PM2_5))+ylab("PM2_5")+xlab("Time")+
  scale_x_datetime(labels=date_format("%H:%M"),
                   limits=as.POSIXct(c("2012-01-01 8:00","2012-02-01 9:00"),tz="GMT"))
#print(myplot5, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))


myplot14 <- ggplot_gtable(ggplot_build(myplot14))
myplot15 <- ggplot_gtable(ggplot_build(myplot15))
myplot16 <- ggplot_gtable(ggplot_build(myplot16))
myplot17 <- ggplot_gtable(ggplot_build(myplot17))
myplot18 <- ggplot_gtable(ggplot_build(myplot18))

maxWidth = unit.pmax(myplot14$widths[2:3],myplot15$widths[2:3], myplot16$widths[2:3],myplot17$widths[2:3], myplot18$widths[2:3])

myplot1$widths[2:3] <- maxWidth

grid.arrange(myplot14, myplot15, myplot16, myplot17, myplot18, ncol=2)


