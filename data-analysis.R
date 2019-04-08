# Instalação e chamada dos pacotes necessários
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

# Estações: 1 - AV, 2 - BG, 3 - CA, 4 - CG, 5 - IR, 6 - PG, 7 - SC, 8 - SP

# Importação da base de dados
data = read.csv('data/Dados_horários_do_monitoramento_da_qualidade_do_ar__MonitorAr.csv')

summary(data)

# data1 <-data1[!is.na(data1$light),]

# Retirando os termos NA da base de dados
data[is.na(data)] <- 0
data$EstaÃ.Ã.o <- NULL
data$ï..OBJECTID <- NULL

plot(data$Temp)

# Alterando formato de data para o formato UTC
data$Data<- ymd_hms(data$Data)
data$Data <- as.POSIXct(data$Data,tz="UTC")

# Plotando gráficos da base de dados
myplot1 <- ggplot(data,aes(Data))+geom_line(color="Red",aes(y=Temp))+ylab("Temperature")+xlab("Time")+
                  scale_x_datetime(breaks=date_breaks("1440 min"),labels=date_format("%H:%M"),
                  limits=as.POSIXct(c("2012-01-01 8:00","2012-12-31 9:00"),tz="GMT"))+
                  theme(axis.text.x=element_text(angle=90,hjust=1))
print(myplot1, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))

myplot2 <- ggplot(data,aes(Data))+geom_line(color="Blue",aes(y=SO2))+ylab("SO2")+xlab("Time")+
                  scale_x_datetime(breaks=date_breaks("1440 min"),labels=date_format("%H:%M"),
                  limits=as.POSIXct(c("2012-01-01 8:00","2012-12-31 9:00"),tz="GMT"))+
                  theme(axis.text.x=element_text(angle=90,hjust=1))
print(myplot2, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))

myplot3 <- ggplot(data,aes(Data))+geom_line(color="Green",aes(y=Pres))+ylab("Pres")+xlab("Time")+
                  scale_x_datetime(breaks=date_breaks("1440 min"),labels=date_format("%H:%M"),
                  limits=as.POSIXct(c("2012-01-01 8:00","2012-12-31 9:00"),tz="GMT"))+
                  theme(axis.text.x=element_text(angle=90,hjust=1))
print(myplot3, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))

myplot4 <- ggplot(data,aes(Data))+geom_line(color="Yellow",aes(y=NO2))+ylab("NO2")+xlab("Time")+
                  scale_x_datetime(breaks=date_breaks("1440 min"),labels=date_format("%H:%M"),
                  limits=as.POSIXct(c("2012-01-01 8:00","2012-12-31 9:00"),tz="GMT"))+
                  theme(axis.text.x=element_text(angle=90,hjust=1))
print(myplot4, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))

myplot5 <- ggplot(data,aes(Data))+geom_line(color="Brown",aes(y=Chuva))+ylab("Chuva")+xlab("Time")+
                  scale_x_datetime(breaks=date_breaks("1440 min"),labels=date_format("%H:%M"),
                  limits=as.POSIXct(c("2012-01-01 8:00","2012-12-31 9:00"),tz="GMT"))+
                  theme(axis.text.x=element_text(angle=90,hjust=1))
print(myplot5, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))

myplot6 <- ggplot(data,aes(Data))+geom_line(color="Purple",aes(y=CO))+ylab("CO")+xlab("Time")+
                  scale_x_datetime(breaks=date_breaks("1440 min"),labels=date_format("%H:%M"),
                  limits=as.POSIXct(c("2012-01-01 8:00","2012-12-31 9:00"),tz="GMT"))+
                  theme(axis.text.x=element_text(angle=90,hjust=1))
print(myplot6, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))


myplot1 <- ggplot_gtable(ggplot_build(myplot1))
myplot2 <- ggplot_gtable(ggplot_build(myplot2))
myplot3 <- ggplot_gtable(ggplot_build(myplot3))
myplot4 <- ggplot_gtable(ggplot_build(myplot4))
myplot5 <- ggplot_gtable(ggplot_build(myplot5))
myplot6 <- ggplot_gtable(ggplot_build(myplot6))
maxWidth = unit.pmax(myplot1$widths[2:3],myplot2$widths[2:3], myplot3$widths[2:3],myplot4$widths[2:3], myplot5$widths[2:3],myplot6$widths[2:3])

myplot1$widths[2:3] <- maxWidth
grid.arrange(myplot1, myplot2, myplot3, ncol=1)
grid.arrange(myplot4, myplot5, myplot6, ncol=1)
