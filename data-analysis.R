base = read.csv('plano-saude2.csv')



# Descrição do dataset

# Dados do programa de monitoramento da qualidade do ar da Prefeitura da Cidade do Rio de Janeiro – MonitorAr. 
# Inclui as estações fixas de qualidade do ar, localização das campanhas móveis e série histórica (2011 - 2018) de dados horários 
# dos poluentes atmosféricos e de meteorologia das estações fixas e das campanhas móveis.
# Parâmetros monitorados nas estações fixas:• Centro (CA): O3, CO, PM10• Copacabana (AV): SO2, O3, CO, PM10• 
# São Cristóvão (SC): SO2, O3, CO, PM10• Tijuca (SP): SO2, NOx, O3, CO, PM10• Irajá (IR): SO2, NOx, O3, CO, HC, PM2.5, PM10
# • Bangu (BG): SO2, NOx, O3, CO, HC, PM10• Campo Grande (CG): SO2, NOx, O3, CO, HC, PM10• Pedra de Guaratiba (PG): O3, PM10
# Parâmetros monitorados nas campanhas móveis:• Estação móvel: SO2, NOx, O3, CO, PM2.5
# As concentrações de Monóxido de Carbono (CO) e Hidrocarbonetos (HC) são medidas em partes por milhão [ppm] , 
# enquanto as demais são medidas em microgramas por metro cúbico de ar [µg/m3]. O analisador de Óxidos de Nitrogênio (NOx) realiza 
# medidas de concentração dos gases Monóxido de Nitrogênio (NO), Dióxido de Nitrogênio (NO2) e Óxidos de Nitrogênio (NO+NO2=NOX). 
# O analisador de Hidrocarbonetos (HC) realiza medidas de concentração dos gases Hidrocarbonetos Não-Metano (HCNM), Metano (CH4) e 
# Hidrocarbonetos Totais (HCT). Além dos poluentes atmosféricos, as estações de monitoramento do ar da Prefeitura do Rio de Janeiro 
# realizam o monitoramento de variáveis meteorológicas. São elas:• Velocidade do Vento [m/s]• Direção do Vento [°]
# • Radiação Solar [w/m2]• Precipitação Pluviométrica [mm]• Umidade Relativa do Ar [%]• Temperatura [°C]• Pressão Atmosférica [mbar]

# Estações fixas: 1 - Copacabana (AV), 2 - Bangu (BG), 3 - Centro (CA), 4 - Campo Grande (CG), 5 - Irajá (IR), 
# 6 - Pedra de Guaratiba (PG), 7 - São Cristóvão (SC), 8 - Tijuca (SP)

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
install.packages('miscTools')

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
library(miscTools)

# Importação da base de dados
data = read.csv('data/Dados_horários_do_monitoramento_da_qualidade_do_ar__MonitorAr.csv')

summary(data)

# data <- data[!is.na(data),]

# Eliminando colunas desnecessárias
data$Estação <- NULL
data$OBJECTID <- NULL

data$X_UTM_Sirgas2000 <- NULL
data$Y_UTM_Sirgas2000 <- NULL
data$Lat <- NULL
data$Lon <- NULL

data$EstaÃ.Ã.o <- NULL
data$ï..OBJECTID <- NULL

# Alterando formato de data para o formato UTC
data$Data<- ymd_hms(data$Data)
data$Data <- as.POSIXct(data$Data,tz="UTC")

mean(data$Chuva, na.rm = TRUE)
mean(data$Temp, na.rm = TRUE)

boxplot(data$UR)
mean(data$UR, na.rm = TRUE)

# Retirando os termos NA da base de dados
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

# 1 - AV - SO2, O3, CO, PM10
# 2 - BG - SO2, NOx, O3, CO, HC, PM10
# 3 - CA - O3, CO, PM1
# 4 - CG - SO2, NOx, O3, CO, HC, PM10
# 5 - IR - SO2, NOx, O3, CO, HC, PM2.5, PM10
# 6 - PG - O3, PM10
# 7 - SC - SO2, O3, CO, PM10
# 8 - SP - SO2, NOx, O3, CO, PM10

# data$Temp = ifelse(data$Temp >= 100, mean(data$Temp, na.rm = TRUE), data$Temp)
divide = split(data, data$CodNum)
data1 = divide[["1"]]
data2 = divide[["2"]]
data3 = divide[["3"]]
data4 = divide[["4"]]
data5 = divide[["5"]]
data6 = divide[["6"]]
data7 = divide[["7"]]
data8 = divide[["8"]]

data1$CodNum = NULL
data2$CodNum = NULL
data3$CodNum = NULL
data4$CodNum = NULL
data5$CodNum = NULL
data6$CodNum = NULL
data7$CodNum = NULL
data8$CodNum = NULL

# Correlações Estação 1
cor(data1$Pres, data1$Temp) # 3 5
cor(data1$RS, data1$Temp) # 4 5
cor(data1$RS, data1$UR) # 4 6
cor(data1$Temp, data1$UR) # 5 6
cor(data1$SO2, data1$CO) # 9 14

cor(data1$Pres, data1$SO2) # -0.08887305 (Baixa)

regressor = randomForest(x = data1[9], y = data1$CO, ntree = 10)
summary(regressor)

previsoes = predict(regressor, newdata = data1[9])

cc = rSquared(data1[['CO']], resid = data1[['CO']] - previsoes)
x_teste = seq(min(data1$SO2), max(data1$SO2), 0.1)

previsoes2 = predict(regressor, newdata = data.frame(SO2 = x_teste))

ggplot() + geom_point(aes(x = data1$SO2, y = data1$CO), colour = 'blue') +
  geom_line(aes(x = x_teste, y = previsoes2), colour = 'red')

#Correlações Estação 2
cor(data2$Pres, data2$Temp) # 3 5
cor(data2$RS, data2$Temp) # 4 5
cor(data2$RS, data2$UR) # 4 6
cor(data2$RS, data2$O3) # 4 17
cor(data2$Temp, data2$O3) # 5 17
cor(data2$UR, data2$Temp) # 6 5
cor(data2$UR, data2$O3) # 6 17
cor(data2$NO2, data2$HCNM) # 10 11
cor(data2$NO2, data2$CO) # 10 14
cor(data2$NO2, data2$NO) # 10 15
cor(data2$NO2, data2$NOx) # 10 16
cor(data2$NO2, data2$PM10) # 10 18
cor(data2$HCNM, data2$HCT) # 11 12
cor(data2$HCNM, data2$CH4) # 11 13
cor(data2$HCNM, data2$CO) # 11 14
cor(data2$HCNM, data2$NO) # 11 15
cor(data2$HCNM, data2$NOx) # 11 16
cor(data2$HCT, data2$CH4) # 12 13
cor(data2$HCT, data2$CO) # 12 14
cor(data2$HCT, data2$NO) # 12 15
cor(data2$HCT, data2$NOx) # 12 16
cor(data2$CH4, data2$NO) # 13 15
cor(data2$CH4, data2$NOx) # 13 16
cor(data2$CO, data2$NO) # 14 15
cor(data2$CO, data2$PM10) # 14 18
cor(data2$NO, data2$NOx) # 15 16
cor(data2$NOx, data2$NO2) # 16 10
cor(data2$NOx, data2$HCNM) # 16 11
cor(data2$NOx, data2$HCT) # 16 12
cor(data2$NOx, data2$CH4) # 16 13
cor(data2$NOx, data2$CO) # 16 14
cor(data2$NOx, data2$NO) # 16 15
cor(data2$NOx, data2$PM10) # 16 18

#Correlações Estação 3
cor(data3$Pres, data3$Temp) # 3 5
cor(data3$RS, data3$Temp) # 4 5
cor(data3$RS, data3$UR) # 4 6
cor(data3$RS, data3$Vel_Vento) # 4 8
cor(data3$RS, data3$O3) # 4 17
cor(data3$UR, data3$Temp) # 6 5
cor(data3$Dir_Vento, data3$Vel_Vento) # 7 8
cor(data3$Vel_Vento, data3$O3) # 8 17

#Correlações Estação 4
cor(data4$Pres, data4$Temp) # 3 5
cor(data4$RS, data4$Temp) # 4 5
cor(data4$RS, data4$UR) # 4 6
cor(data4$RS, data4$O3) # 4 17
cor(data4$Temp, data4$UR) # 5 6
cor(data4$Temp, data4$O3) # 5 17
cor(data4$NO2, data4$HCNM) # 10 11
cor(data4$NO2, data4$CO) # 10 14
cor(data4$NO2, data4$NO) # 10 15
cor(data4$NO2, data4$NOx) # 10 16
cor(data4$NO2, data4$PM10) # 10 18
cor(data4$HCNM, data4$HCT) # 11 12
cor(data4$HCNM, data4$CH4) # 11 13
cor(data4$HCNM, data4$CO) # 11 14
cor(data4$HCNM, data4$NOx) # 11 16
cor(data4$HCNM, data4$PM10) # 11 18
cor(data4$HCT, data4$CH4) # 12 13
cor(data4$HCT, data4$CO) # 12 14
cor(data4$HCT, data4$NOx) # 12 16
cor(data4$CO, data4$NOx) # 14 16
cor(data4$CO, data4$PM10) # 14 18
cor(data4$NO, data4$NOx) # 15 16

#Correlações Estação 5
cor(data5$Pres, data5$Temp) # 3 5
cor(data5$RS, data5$Temp) # 4 5
cor(data5$RS, data5$UR) # 4 6
cor(data5$RS, data5$O3) # 4 17
cor(data5$Temp, data5$UR) # 5 6
cor(data5$Temp, data5$O3) # 5 17
cor(data5$UR, data5$O3) # 6 17
cor(data5$NO2, data5$CO) # 10 14
cor(data5$NO2, data5$NO) # 10 15
cor(data5$NO2, data5$NOx) # 10 16
cor(data5$NO2, data5$PM10) # 10 18
cor(data5$NO2, data5$PM2_5) # 10 19
cor(data5$HCNM, data5$HCT) # 11 12
cor(data5$HCNM, data5$CH4) # 11 13
cor(data5$HCNM, data5$CO) # 11 14
cor(data5$HCNM, data5$NO) # 11 15
cor(data5$HCNM, data5$NOx) # 11 16
cor(data5$HCT, data5$NO2) # 12 10
cor(data5$HCT, data5$HCNM) # 12 11
cor(data5$HCT, data5$CH4) # 12 13
cor(data5$HCT, data5$CO) # 12 14
cor(data5$HCT, data5$NO) # 12 15
cor(data5$HCT, data5$NOx) # 12 16
cor(data5$HCT, data5$PM10) # 12 18
cor(data5$HCT, data5$PM2_5) # 12 19
cor(data5$CH4, data5$CO) # 13 14
cor(data5$CH4, data5$NO) # 13 15
cor(data5$CH4, data5$NOx) # 13 16
cor(data5$CH4, data5$PM10) # 13 18
cor(data5$CH4, data5$PM2_5) # 13 19
cor(data5$CO, data5$NO) # 14 15
cor(data5$CO, data5$NOx) # 14 16
cor(data5$CO, data5$PM10) # 14 18
cor(data5$CO, data5$PM2_5) # 14 19
cor(data5$NO, data5$NOx) # 15 16
cor(data5$NO, data5$PM10) # 15 18
cor(data5$NO, data5$PM2_5) # 15 19
cor(data5$NOx, data5$PM10) # 16 18
cor(data5$NOx, data5$PM2_5) # 16 19
cor(data5$PM10, data5$PM2_5) # 18 19

#Correlações Estação 6
cor(data6$Pres, data6$Temp) # 3 5
cor(data6$RS, data6$Temp) # 4 5
cor(data6$RS, data6$UR) # 4 6
cor(data6$RS, data6$O3) # 4 17
cor(data6$Temp, data6$UR) # 5 6
cor(data6$Temp, data6$O3) # 5 17

#Correlações Estação 7
cor(data7$Pres, data7$Temp) # 3 5
cor(data7$RS, data7$Temp) # 4 5
cor(data7$RS, data7$UR) # 4 6
cor(data7$RS, data7$Vel_Vento) # 4 8
cor(data7$RS, data7$O3) # 4 17
cor(data7$Temp, data7$UR) # 5 6
cor(data7$Temp, data7$Vel_Vento) # 5 8
cor(data7$Temp, data7$O3) # 5 17
cor(data7$UR, data7$Vel_Vento) # 6 8
cor(data7$UR, data7$O3) # 6 17
cor(data7$Vel_Vento, data7$O3) # 8 17
cor(data7$SO2, data7$PM10) # 9 18
cor(data7$CO, data7$PM10) # 14 18

#Correlações Estação 8
cor(data8$Pres, data8$Temp) # 3 5
cor(data8$RS, data8$Temp) # 4 5
cor(data8$RS, data8$UR) # 4 6
cor(data8$RS, data8$O3) # 4 17
cor(data8$Temp, data8$UR) # 5 6
cor(data8$Temp, data8$O3) # 5 17
cor(data8$UR, data8$O3) # 6 17
cor(data8$Vel_Vento, data8$O3) # 8 17
cor(data8$SO2, data8$PM10) # 9 18
cor(data8$NO2, data8$NO) # 10 15
cor(data8$NO2, data8$NOx) # 10 16
cor(data8$NO, data8$NOx) # 15 16


# plot(data$Temp)
# points(data$Temp, col = 'dark red')

# Verificando as maiores correlações
for(i in 3:19) {
  for(j in 3:19) {
    # if(cor(data1[,i], data1[,j]) >= 0.4) {
      print(i);print(j);print(cor(data8[,i], data8[,j]))
    # }
  }
}

# Correlações moderadas ou altas
cor(data$RS, data$O3)
cor(data$Temp, data$UR)
cor(data$Temp, data$RS)
cor(data$Temp, data$O3)
cor(data$Vel_Vento, data$O3)
cor(data$NO, data$NOx)
cor(data$NO, data$NO2)
cor(data$NOx, data$NO2)
cor(data$HCT, data$HCNM)
cor(data$HCT, data$NO)
cor(data$HCT, data$NOx)
cor(data$NOx, data$HCNM)
cor(data$HCT, data$CH4)
cor(data$CH4, data$HCNM)
cor(data$CH4, data$NO)
cor(data$CH4, data$NOx)

cor1 = ggplot()+geom_point(aes(x = data$NO, y = data$NO2))
cor2 = ggplot()+geom_point(aes(x = data$RS, y=data$O3))         
cor3 = ggplot()+geom_point(aes(x = data$Temp, y=data$UR))
cor4 = ggplot()+geom_point(aes(x = data$Temp, y=data$RS))
cor5 = ggplot()+geom_point(aes(x = data$Temp, y=data$O3))
cor6 = ggplot()+geom_point(aes(x = data$Vel_Vento, y=data$O3))
cor7 = ggplot()+geom_point(aes(x = data$NO, y=data$NOx))
cor8 = ggplot()+geom_point(aes(x = data$NO2, y=data$NOx))
cor9 = ggplot()+geom_point(aes(x = data$HCT, y=data$HCNM))
cor10 = ggplot()+geom_point(aes(x = data$HCT, y=data$NO))
cor11 = ggplot()+geom_point(aes(x = data$HCT, y=data$NOx))
cor12 = ggplot()+geom_point(aes(x = data$NOx, y=data$HCNM))
cor13 = ggplot()+geom_point(aes(x = data$HCT, y=data$CH4))
cor14 = ggplot()+geom_point(aes(x = data$CH4, y=data$HCNM))
cor15 = ggplot()+geom_point(aes(x = data$CH4, y=data$NO))
cor16 = ggplot()+geom_point(aes(x = data$CH4, y=data$NOx))

cor1 <- ggplot_gtable(ggplot_build(cor1))
cor2 <- ggplot_gtable(ggplot_build(cor2))
cor3 <- ggplot_gtable(ggplot_build(cor3))
cor4 <- ggplot_gtable(ggplot_build(cor4))
cor5 <- ggplot_gtable(ggplot_build(cor5))
cor6 <- ggplot_gtable(ggplot_build(cor6))
cor7 <- ggplot_gtable(ggplot_build(cor7))
cor8 <- ggplot_gtable(ggplot_build(cor8))
cor9 <- ggplot_gtable(ggplot_build(cor9))
cor10 <- ggplot_gtable(ggplot_build(cor10))
cor11 <- ggplot_gtable(ggplot_build(cor11))
cor12 <- ggplot_gtable(ggplot_build(cor12))
cor13 <- ggplot_gtable(ggplot_build(cor13))
cor14 <- ggplot_gtable(ggplot_build(cor14))
cor15 <- ggplot_gtable(ggplot_build(cor15))
cor16 <- ggplot_gtable(ggplot_build(cor16))

grid.arrange(cor1)

maxWidth_cor = unit.pmax(cor1$widths[2:3],
                         cor2$widths[2:3], 
                         cor3$widths[2:3], 
                         cor4$widths[2:3], 
                         cor5$widths[2:3],
                         cor6$widths[2:3])

grid.arrange(cor1,cor2, cor3, cor4, cor5, cor6, ncol=2)

maxWidth_cor = unit.pmax(cor7$widths[2:3],
                         cor8$widths[2:3], 
                         cor9$widths[2:3], 
                         cor10$widths[2:3], 
                         cor11$widths[2:3],
                         cor12$widths[2:3])

grid.arrange(cor7,cor8, cor9, cor10, cor11, cor12, ncol=2)

maxWidth_cor = unit.pmax(cor13$widths[2:3],
                         cor14$widths[2:3], 
                         cor15$widths[2:3], 
                         cor16$widths[2:3])

grid.arrange(cor13, cor14, cor15, cor16, ncol=2) 

# Plotando gr?ficos da base de dados
myplot1 <- ggplot(data,aes(Data))+geom_line(color="Red",aes(y=Temp))+ylab("Temperature")+xlab("Time")+
                  scale_x_datetime(labels=date_format("%H:%M"),
                  limits=as.POSIXct(c("2012-01-01 08:00:00","2012-02-01 08:00:00"),tz="UTC"))
#print(myplot1, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))

myplot2 <- ggplot(data,aes(Data))+geom_line(color="Blue",aes(y=Chuva))+ylab("Chuva")+xlab("Time")+
                  scale_x_datetime(labels=date_format("%H:%M"),
                  limits=as.POSIXct(c("2012-01-01 08:00:00","2012-02-01 08:00:00"),tz="UTC"))
#print(myplot2, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))

myplot3 <- ggplot(data,aes(Data))+geom_line(color="Green",aes(y=Pres))+ylab("Pres")+xlab("Time")+
                  scale_x_datetime(labels=date_format("%H:%M"),
                  limits=as.POSIXct(c("2012-01-01 08:00:00","2012-02-01 08:00:00"),tz="UTC"))
#print(myplot3, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))

myplot4 <- ggplot(data,aes(Data))+geom_line(color="Yellow",aes(y=RS))+ylab("RS")+xlab("Time")+
                  scale_x_datetime(labels=date_format("%H:%M"),
                  limits=as.POSIXct(c("2012-01-01 08:00:00","2012-02-01 08:00:00"),tz="UTC"))
#print(myplot4, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))

myplot5 <- ggplot(data,aes(Data))+geom_line(color="Brown",aes(y=UR))+ylab("UR")+xlab("Time")+
                  scale_x_datetime(labels=date_format("%H:%M"),
                  limits=as.POSIXct(c("2012-01-01 08:00:00","2012-02-01 08:00:00"),tz="UTC"))
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
                  scale_x_datetime(labels=date_format("%H:%M:%S"),
                  limits=as.POSIXct(c("2013-01-01 08:00:00","2013-02-01 08:00:00"),tz="UTC"))
#print(myplot6, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))
  
myplot7 <- ggplot(data,aes(Data))+geom_line(color="Blue",aes(y=Vel_Vento))+ylab("Vel_Vento")+xlab("Time")+
                  scale_x_datetime(labels=date_format("%H:%M:%S"),
                  limits=as.POSIXct(c("2013-01-01 08:00:00","2013-02-01 08:00:00"),tz="UTC"))
# print(myplot7, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))
  
myplot6 <- ggplot_gtable(ggplot_build(myplot6))
myplot7 <- ggplot_gtable(ggplot_build(myplot7))
  
maxWidth = unit.pmax(myplot6$widths[2:3],myplot7$widths[2:3])
  
myplot1$widths[2:3] <- maxWidth
grid.arrange(myplot6, myplot7, ncol=1)

myplot8 <- ggplot(data,aes(Data))+geom_line(color="Red",aes(y=SO2))+ylab("SO2")+xlab("Time")+
  scale_x_datetime(labels=date_format("%H:%M"),
                   limits=as.POSIXct(c("2012-01-01 08:00:00","2012-07-01 08:00:00"),tz="UTC"))
#print(myplot1, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))

myplot9 <- ggplot(data,aes(Data))+geom_line(color="Blue",aes(y=NO2))+ylab("NO2")+xlab("Time")+
  scale_x_datetime(labels=date_format("%H:%M"),
                   limits=as.POSIXct(c("2012-01-01 08:00:00","2012-07-01 08:00:00"),tz="UTC"))
#print(myplot2, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))

myplot10 <- ggplot(data,aes(Data))+geom_line(color="Green",aes(y=HCNM))+ylab("HCNM")+xlab("Time")+
  scale_x_datetime(labels=date_format("%H:%M"),
                   limits=as.POSIXct(c("2012-01-01 08:00:00","2012-07-01 08:00:00"),tz="UTC"))
#print(myplot3, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))

myplot11 <- ggplot(data,aes(Data))+geom_line(color="Yellow",aes(y=HCT))+ylab("HCT")+xlab("Time")+
  scale_x_datetime(labels=date_format("%H:%M"),
                   limits=as.POSIXct(c("2012-01-01 08:00:00","2012-07-01 08:00:00"),tz="UTC"))
#print(myplot4, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))

myplot12 <- ggplot(data,aes(Data))+geom_line(color="Brown",aes(y=CH4))+ylab("CH4")+xlab("Time")+
  scale_x_datetime(labels=date_format("%H:%M"),
                   limits=as.POSIXct(c("2012-01-01 08:00:00","2012-07-01 08:00:00"),tz="UTC"))
#print(myplot5, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))

myplot13 <- ggplot(data,aes(Data))+geom_line(color="Orange",aes(y=CO))+ylab("CO")+xlab("Time")+
  scale_x_datetime(labels=date_format("%H:%M"),
                   limits=as.POSIXct(c("2012-01-01 08:00:00","2012-07-01 08:00:00"),tz="UTC"))
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
                   limits=as.POSIXct(c("2012-01-01 08:00:00","2012-02-01 08:00:00"),tz="UTC"))
#print(myplot1, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))

myplot15 <- ggplot(data,aes(Data))+geom_line(color="Blue",aes(y=NOx))+ylab("NOx")+xlab("Time")+
  scale_x_datetime(labels=date_format("%H:%M"),
                   limits=as.POSIXct(c("2012-01-01 08:00:00","2012-02-01 08:00:00"),tz="UTC"))
#print(myplot2, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))

myplot16 <- ggplot(data,aes(Data))+geom_line(color="Green",aes(y=O3))+ylab("O3")+xlab("Time")+
  scale_x_datetime(labels=date_format("%H:%M"),
                   limits=as.POSIXct(c("2012-01-01 08:00:00","2012-02-01 08:00:00"),tz="UTC"))
#print(myplot3, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))

myplot17 <- ggplot(data,aes(Data))+geom_line(color="Yellow",aes(y=PM10))+ylab("PM10")+xlab("Time")+
  scale_x_datetime(labels=date_format("%H:%M"),
                   limits=as.POSIXct(c("2012-01-01 08:00:00","2012-02-01 08:00:00"),tz="UTC"))
#print(myplot4, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))

myplot18 <- ggplot(data,aes(Data))+geom_line(color="Brown",aes(y=PM2_5))+ylab("PM2_5")+xlab("Time")+
  scale_x_datetime(labels=date_format("%H:%M"),
                   limits=as.POSIXct(c("2012-01-01 08:00:00","2012-02-01 08:00:00"),tz="UTC"))
#print(myplot5, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))


myplot14 <- ggplot_gtable(ggplot_build(myplot14))
myplot15 <- ggplot_gtable(ggplot_build(myplot15))
myplot16 <- ggplot_gtable(ggplot_build(myplot16))
myplot17 <- ggplot_gtable(ggplot_build(myplot17))
myplot18 <- ggplot_gtable(ggplot_build(myplot18))

maxWidth = unit.pmax(myplot14$widths[2:3],myplot15$widths[2:3], myplot16$widths[2:3],myplot17$widths[2:3], myplot18$widths[2:3])

myplot1$widths[2:3] <- maxWidth

grid.arrange(myplot14, myplot15, myplot16, myplot17, myplot18, ncol=2)


