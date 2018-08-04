##App Codes
library(shiny)
library(shinydashboard)
library(dygraphs)

ui <- dashboardPage(skin = "blue",
                    dashboardHeader(title = "Forecasting Stock Price"),
                    dashboardSidebar(
                      
                      
                      textInput("company", "Symbol","AAPL"),
                      
                      dateInput("datez",
                                label = "Enter date from when the forecast should start.",
                                value = "2000-06-01", format = "yyyy-mm-dd"),
                      
                      numericInput("ahead", "Select number of days to be forecasted", 800),
                      
                      submitButton("Update Prediction"),
                      br(),br(),br(),
                      dateInput("date",
                                label = "Enter date after current date up to which forecating is needed.",
                                value = Sys.Date() + 15, format = "yyyy-mm-dd"),
                      
                      numericInput("mdays", "Select number of days for SMA",26),
                      numericInput("bdays", "Select number of days for Bollinger Bands",30),
                      numericInput("macdzdays", "Select number of days for MACD",50),
                      numericInput("edays", "Select number of days for EMA",26),
                      submitButton("Get Point Predictions")
                    ),
                    body<-dashboardBody(
                      tags$style(".content {background-color: white;}"),
                      
                      h3(textOutput("caption")),
                      fluidRow(
                        box(plotOutput("arimaForecastPlot")),
                        box(dataTableOutput("Predictiontable")),
                        box(dataTableOutput("Predictiontablecomparison")),
                        box(dygraphOutput("RSI")),
                        box(dygraphOutput("BBANDS")),
                        box(dygraphOutput("MACD")),
                        box(dygraphOutput("SMA")),
                        box(dygraphOutput("EMA"))
                      )
                    )
                    
                    
)


library(tidyr)
library(forecast)
library(quantmod)


server <- function(input, output, session) {
  
  getDataset <- reactive({
    
    Stock_Symbols<-input$company
    Stock_Close_Price <- NULL
    print(Stock_Symbols)
    
    
    dates<-input$datez
    Stock_Close_Price <- NULL
    print(Stock_Symbols)
    
    df <- getSymbols(Stock_Symbols,from = dates,
                     to = Sys.Date(), auto.assign = FALSE)
    Close <- df[,4] 
    Close <- na.approx(Close)
    return(Close)
  })
  
  getDays<-reactive({as.numeric(round(returnValue(extract_numeric(data.frame(difftime(as.Date(input$date), as.Date(Sys.Date()),
                                                                                      units = c("days")))))))
  })
  
  output$caption <- renderText({
    paste("Company:", input$company)
  })
  
  output$arimaForecastPlot <- renderPlot({

    # f <- forecast(auto.arima(getDataset()),h=getDays(), level=95)
    # plot(f)
    # print("Accuracy using Plain ARIMA is : ")
    #print(accuracy(f))

 
    #Fourier Series Added to Improve the Accuracy of the ARIMA model
    
     m<-input$ahead
     y=ts(rnorm(getDataset()), f=365.25)
     fit <- auto.arima(y, xreg = fourier(y, K = 2))
     fc <- forecast(fit,h=2*m,xreg = fourier(y, K = 2, h = 2*m))
     plot(fc)
     print("Accuracy using ARIMA with Fourier Regressor is : ")
     print(accuracy(fc))
     outliers <- tsoutliers(y)
     print(outliers)
  })
  
  
  
  
  output$Predictiontable<-renderDataTable({
    
    f <- forecast(auto.arima(getDataset()),h=getDays())
    format(returnValue(data.frame(f)), digits = 2, nsmall  = 2)
    print(f)
  })
  
  
  
  
  output$RSI <- renderDygraph({
    RSI <- RSI(getDataset())
    dygraph(RSI)
  })
  
  output$MACD <- renderDygraph({
    macddays<-input$macdzdays
    macd<-MACD(getDataset(),nFast=12,nSlow=macddays,nSig = 9,maType = SMA,percent = FALSE)
    dygraph(macd)
  })
  
  output$SMA <- renderDygraph({
    smadays<-input$mdays
    sma<-SMA(getDataset(),n=smadays,maType = SMA,percent = FALSE)
    dygraph(sma)
  })
  
  output$BBANDS <- renderDygraph({
    bbdays<-input$bdays
    bbands <- BBands(getDataset(),n=bbdays)
    dygraph(bbands)
  })
  
  output$EMA <- renderDygraph({
    emadays<-input$edays
    ema <- EMA(getDataset(),n=emadays)
    dygraph(ema)
  })
  
  
  
  output$RSItable <- renderTable({
    
    tail(RSI(getDataset()))
  })
  
  
  
  
  
  
  
}

shinyApp(ui, server)
