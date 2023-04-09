# Financial Data Analysis & Forecasting using HHT - Empirical Mode Decomposition & Ensemble Forecasting.

Performed Analysis & Prediction on Financial Stock Market data using using Hilbert–Huang Transform (HHT) - Empirical Mode Decomposition (EMD) along with Ensemble Forecasts on Intrinsic Mode Functions (IMFs) using BSTS (Bayesian Structural Time Series) in R.

The Empirical Mode Decomposition method divides the signal into a finite collection of approximately orthogonal oscillating components. (IMFs). The local peaks and local minima of the data serve as the IMFs' characteristic time scales of oscillations, which are retrieved by the data itself without the imposition of any functional form.

The IMF's components oscillate locally about zero and are locally stationary. In fact, starting from high frequencies, the EMD may be thought of as a highly flexible and granular detrending method where each IMF component's local trend is contained within the cycle of the following component. Also, each IMF has a distinctive oscillation period that, in turn, gives each component a distinctive time horizon and time scale. The fundamental idea behind using EMD for forecasting is that by breaking a signal down into IMF components, the residual component can reduce the complexity of the time series by separating trends and oscillations at different scales, thus increasing the forecasting accuracy at particular time horizons.

IMFs are defined by several features. They must be locally-symmetric around zero and contain the same number of extrema as zero-crossings (or differ by no more than 1). 

We can compute the instantaneous amplitude, frequency and phase of our IMF using the Hilbert transform. This is a function which creates an ‘analytic’ form of a signal that is extremely useful for extracting dynamic information from a signal. 

This means that we can use the Hilbert transform to estimate instantaneous frequencies directly from our IMFs. We don’t need to use the Fourier transform for this and so can avoid adding harmonic components into our results.

Here we use the IMF components from EMD as input for forecasting with BSTS. This approach attempts to forecast each IMF component and the residue independently and then finally combine them together to predict the future value of the signal.

