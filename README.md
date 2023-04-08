# Financial Data Analysis & Forecasting using HHT - Empirical Mode Decomposition & Ensemble Forecasting.

Performed Analysis & Prediction on Financial Stock Market data using using Hilbert–Huang Transform (HHT) - Empirical Mode Decomposition (EMD) along with Ensemble Forecasts on Intrinsic Mode Functions (IMFs) using ARIMA (Auto Regressive Integrated Moving Average) and BSTS (Bayesian Structural Time Series) in R.


The four forecast error statistics are computed as follows :

1)	Mean Absolute Error (MAE) 
The MAE is defined by making each error positive by taking its absolute value and then averaging the results. MAE measures the average magnitude of errors without considering their direction of a set of predictions

2)	Mean Absolute Percentage Error (MAPE) MAPE produces a measure of relative overall fit. It is not scale-dependent. The mean absolute percentage error is the mean or average of the sum of all the percentage errors for a give data set taken without regard to sign. 

3)	Root Mean Square Error (RMSE) The RMSE is a quadratic scoring rule which measures the average magnitude of the error. It consists of the square root of the average of squared differences between prediction and actual observation

4)	Mean Squared Error (MSE) The mean squared error is a measure of accuracy computed by squaring the individual error for each value in a data set and then finding the mean value of the sum of those squares. It gives greater weight to large errors than to small errors because the errors are squared before being summed up

Once we have determined the parameters (p,d,q) we estimate the accuracy of the ARIMA model on a training data set and then use the fitted model to forecast the values of the test data set using a forecasting function. In the end, we cross check whether our forecasted values are in line with the actual values.
