# Stock Analysis & Prediction Using ARIMA Model Modified with Fourier Series in R

Stock analysis is a method for investors and traders to make buying and selling decisions. By studying and evaluating past and current data, investors and traders attempts to gain an edge in the markets by making informed decisions. Stock market prediction and analysis is a classic problem which has been analyzed extensively using tools and techniques of Machine Learning. Forecasting stock market prices has always been challenging task for many business analysts and researchers. In fact, stock market price prediction is an interesting area of research for investors. For successful investment lot many investors are interested in knowing about future situation of market. Effective prediction systems indirectly help traders by providing supportive information such as the future market direction. Data mining techniques are effective for forecasting future by applying various algorithms over data.

ARIMA Model :

Box and Jenkins in 1970 introduced the ARIMA model. It also referred to as Box-Jenkins methodology composed of set of activities for identifying, estimating and diagnosing ARIMA models with time series data. The model is most prominent methods in financial forecasting. ARIMA models have shown efficient capability to generate short-term forecasts. It constantly outperformed complex structural models in short-term prediction. In the ARIMA model, the future value of a variable is a linear combination of past values and past errors.

ARIMA stands for auto-regressive integrated moving average and is specified by these three order parameters: (p, d, q). The process of fitting an ARIMA model is sometimes referred to as the Box-Jenkins method.
An auto regressive (AR(p)) component is referring to the use of past values in the regression equation for the series Y. The auto-regressive parameter p specifies the number of lags used in the model. For example, AR(2) or, equivalently, ARIMA(2,0,0)

The d represents the degree of differencing in the integrated (I(d)) component. Differencing a series involves simply subtracting its current and previous values d times. Often, differencing is used to stabilize the series when the stationarity assumption is not met.
A moving average (MA(q)) component represents the error of the model as a combination of previous error terms et. 

ARIMA models can be also specified through a seasonal structure. In this case, the model is specified by two sets of order parameters: (p, d, q) as described above and (P, D, Q)m parameters describing the seasonal component of m periods.
ARIMA methodology does have its limitations. These models directly rely on past values, and therefore work best on long and stable series. ARIMA also simply approximates historical patterns.


ARIMA WITH FOURIER SERIES :

Forecasting with long seasonal periods
Fit an ARIMA or ETS model with data having a long seasonal period such as 365 for daily data or 48 for half-hourly data. Generally, seasonal versions of ARIMA and ETS models are designed for shorter periods such as 12 for monthly data or 4 for quarterly data.

The ets() function in the forecast package restricts seasonality to be a maximum period of 24 to allow hourly data but not data with a larger seasonal frequency. The problem is that there are m−1 parameters to be estimated for the initial seasonal states where m is the seasonal period. So for large m, the estimation becomes almost impossible.

The arima() function will allow a seasonal period up to m=350 but in practice will usually run out of memory whenever the seasonal period is more than about 200.Theoretically it would be possible to have any length of seasonality as the number of parameters to be estimated does not depend on the seasonal order. 

However, seasonal differencing of very high order does not make a lot of sense — for daily data it involves comparing what happened today with what happened exactly a year ago and there is no constraint that the seasonal pattern is smooth.
For such data a Fourier series approach where the seasonal pattern is modelled using Fourier terms with short-term time series dynamics allowed in the error.


The four forecast error statistics are computed as follows :

1)	Mean Absolute Error (MAE) 
The MAE is defined by making each error positive by taking its absolute value and then averaging the results. MAE measures the average magnitude of errors without considering their direction of a set of predictions

2)	Mean Absolute Percentage Error (MAPE) MAPE produces a measure of relative overall fit. It is not scale-dependent. The mean absolute percentage error is the mean or average of the sum of all the percentage errors for a give data set taken without regard to sign. 

3)	Root Mean Square Error (RMSE) The RMSE is a quadratic scoring rule which measures the average magnitude of the error. It consists of the square root of the average of squared differences between prediction and actual observation

4)	Mean Squared Error (MSE) The mean squared error is a measure of accuracy computed by squaring the individual error for each value in a data set and then finding the mean value of the sum of those squares. It gives greater weight to large errors than to small errors because the errors are squared before being summed up

Once we have determined the parameters (p,d,q) we estimate the accuracy of the ARIMA model on a training data set and then use the fitted model to forecast the values of the test data set using a forecasting function. In the end, we cross check whether our forecasted values are in line with the actual values.
