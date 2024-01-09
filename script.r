source('./r_files/flatten_HTML.r')

# install.packages("ggplot2", repos = "http://cran.us.r-project.org")
# install.packages("forecast", repos = "http://cran.us.r-project.org")
# install.packages("tseries", repos = "http://cran.us.r-project.org")
# install.packages("dygraphs", repos = "http://cran.us.r-project.org")

libraryRequireInstall("ggplot2");
libraryRequireInstall("forecast");
libraryRequireInstall("tseries");
libraryRequireInstall("dygraphs");


dataset= cbind(dateOfTransfer,price)


dataset = dataset[order(dataset[,1]),]
newdataset = dataset
names(newdataset) =c('Month_of_Transfer','Mean_Price')


freq = 12
if(is.null(forecastMonths)){
forecastMonths = 12
}else{
forecastMonths = forecastMonths[1,1]
}

ts_data = ts(newdataset$Mean_Price,frequency=freq,start = c(2019,1))


arima_model <- auto.arima(ts_data,approximation = TRUE,D=1)
forecast_values <- forecast(arima_model, h = forecastMonths, level = c(80, 95), fan = FALSE,
                            lambda = NULL, biasadj = FALSE, )


interval_value_formatter = "function(num, opts, seriesName, g, row, col) {
  value = g.getValue(row, col);
  if(value[0] != value[2]) {
    lower = Dygraph.numberValueFormatter(value[0], opts);
    upper = Dygraph.numberValueFormatter(value[2], opts);
    return '[' + lower + ', ' + upper + ']';
  } else {
    return Dygraph.numberValueFormatter(num, opts);
  }
}"

gr = {cbind(actuals=forecast_values$x, forecast_mean=forecast_values$mean,
         lower_95=forecast_values$lower[,"95%"], upper_95=forecast_values$upper[,"95%"],
         lower_80=forecast_values$lower[,"80%"], upper_80=forecast_values$upper[,"80%"])} %>%

  dygraph(ylab = "Average Price") %>%
  dyCSS(textConnection(".graphDiv{ background-color: rgba(0, 0, 0, 0.5); } !important")) %>%
  dyAxis("y", valueFormatter = interval_value_formatter) %>%
  dySeries("actuals", color = "black") %>%
  dySeries("forecast_mean", color = "blue", label = "forecast") %>%
  dySeries(c("lower_80", "forecast_mean", "upper_80"),
           label = "80%", color = "blue") %>%
  dySeries(c("lower_95", "forecast_mean", "upper_95"),
           label = "95%", color = "blue") %>%
  dyLegend(labelsSeparateLines=TRUE) %>%
  dyRangeSelector() %>%
  dyOptions(digitsAfterDecimal = 1) %>%
  dyCSS(textConnection(".dygraph-legend {background-color: rgba(192, 192, 192, 0.5) !important;, font-size: 14px; }"))
  #dyCSS(textConnection(".dygraph-legend {background-color: rgba(0, 0, 0, 0.5) !important; }"))



internalSaveWidget(gr, 'out.html');

ReadFullFileReplaceString('out.html', 'out.html', ',"padding":[0-9]*,', ',"padding":0,')
