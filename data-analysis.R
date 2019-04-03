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

# Importação da base de dados
data = read.csv('data/Dados_horários_do_monitoramento_da_qualidade_do_ar__MonitorAr.csv')

summary(data)

# data1 <-data1[!is.na(data1$light),]

# Retirando os termos NA da base de dados
data[is.na(data)] <- 0

plot(data$Temp)

# Alterando formato de data para o formato UTC
data$Data<- ymd_hms(data$Data)
data$Data <- as.POSIXct(data$Data,tz="UTC")

myplot1 <- ggplot(data,aes(Data))+geom_line(color="Red",aes(y=Temp))+ylab("Temperature")+xlab("Time")+
           scale_x_datetime(breaks=date_breaks("1440 min"),labels=date_format("%H:%M"),
           limits=as.POSIXct(c("2011-01-01 8:00","2011-12-31 9:00"),tz="GMT"))+
           theme(axis.text.x=element_text(angle=90,hjust=1))
print(myplot1, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))
