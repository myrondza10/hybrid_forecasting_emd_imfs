library(quantmod);
library(tseries);
library(timeSeries);
library(forecast);
library(xts);

startdate <- as.Date("2017-01-1")
enddate <- as.Date("2018-07-4")

getSymbols("COLPAL.NS", src = "yahoo", from =startdate, to = enddate)
share_prices = COLPAL.NS[,4]
share_prices = na.approx(share_prices)
plot(share_prices,type='l', main='returns plot')
print(adf.test(share_prices))
breakpoint = floor(nrow(share_prices)*(1/2))
par(mfrow = c(1,1))
acf.stock = acf(share_prices[c(1:breakpoint),], main='ACF Plot', lag.max=100)
pacf.stock = pacf(share_prices[c(1:breakpoint),], main='PACF Plot', lag.max=100)

actualshare = xts(0,as.Date("2017-01-1","%Y-%m-%d"))

forecastedshare = data.frame(Forecasted = numeric())

for (b in breakpoint:(nrow(share_prices)-1)) {
  
  share_train = share_prices[1:b, ]
  share_test = share_prices[(b+1):nrow(share_prices), ]
  
  fit = auto.arima(share_train, seasonal=FALSE,stepwise=FALSE,approx=FALSE)
  summary(fit)
  accuracy(fit)
  acf(fit$residuals,main="Residuals plot")
  
  arima.forecast = forecast(fit, h = 10)
  summary(arima.forecast)
  
  par(mfrow=c(1,1))
  plot(arima.forecast, main = "ARIMA Forecast")
  
  forecastedshare = rbind(forecastedshare,arima.forecast$mean[1])
  colnames(forecastedshare) = c("Forecasted")
  
  Actual_return = share_prices[(b+1),]
  actualshare = c(actualshare,xts(Actual_return))
  rm(Actual_return)
  
  print(share_prices[(b+1),])
  
}

actualshare = actualshare[-1]

forecastedshare = xts(forecastedshare,index(actualshare))


plot(actualshare,type='l',main='Actual Returns Vs Forecasted Returns')
lines(forecastedshare,lwd=1.5,col='red')

comparsion = merge(actualshare,forecastedshare)


comparsion$Accuracy = round(comparsion$actualshare)==round(comparsion$Forecasted)
print(comparsion)

Accuracy_percentage = sum(comparsion$Accuracy == 1)*100/length(comparsion$Accuracy)

print(Accuracy_percentage)


summary(arima.forecast)

accuracy(fit)

# 
# lines(meanf(actualshare)$mean)
# lines(meanf(actualshare)$mean, col=4)
# legenddate("topleft", lty=1, col=c(4), legenddate=c("Mean method"),bty="n")
# 
# lines(rwf(actualshare)$mean, col=2)
# lines(rwf(actualshare,drift=TRUE)$mean, col=3)
# 
# lines(snaive(actualshare)$mean, col=5)
# legenddate("topleft", lty=1, col=c(4,2,3,5),legenddate=c("Mean method","Naive method","Drift method", "Seasonal naive method"),bty="n")
# 
# accuracy(meanf(actualshare))
# accuracy(rwf(actualshare))
# 
# accuracy(rwf(actualshare,drift=TRUE))
# accuracy(snaive(actualshare))

rsconnect::deployApp('/Users/myron/Desktop/Stock Market Analysis - Myron Zibreel/Technical Analysis ARIMA - Myron Zibreel')
rsconnect::setAccountInfo(name='stockmarketanalysis-myronzibreel',
                          +                           token='D82B180DD75688A318C89BF659FA31F8',
                          +                           secret='YPxP7BUnAnMEug/uvO7Xk8rkcgMzzNo1yFr6k4B7')
