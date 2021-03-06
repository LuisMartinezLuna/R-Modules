# There will be only one practice exercise in this module: 
# As we all know, Covid-19 has impacted our sales dramatically in the last month. Let's suppose our current sales figures for BBY are the new baseline. 
# Try to guide the Prophet model to use the most current sales baseline to forecast the next 52 weeks. Do this by adjusting the parameters in the model. 

# Some tips: 
# We could manually add changepoint dates. 
# Explore using different seasonality models. (do we expect high season sales to be additive or multiplicative?)
# A non-linear trend specification and setting bounds could help us in not diving below 0 sales. 
# Could try out modelling on transformed sales columns?

#baseline from tutorial
m <- prophet(seasonality.mode = 'additive',
             growth = "linear", 
             changepoint.range = 1,
             changepoint.prior.scale = 1,
             yearly.seaonality = TRUE,
             weekly.seasonality = FALSE)

m <- suppressMessages(fit.prophet(m, df))

# m1 model with multiplicative seasonality 
df$cap<-max(df$sales)
df$floor<-0

m1 <- prophet(seasonality.mode = 'multiplicative',
              growth = 'logistic',
              changepoint.range = 1,
              changepoint.prior.scale = 1,
             yearly.seaonality = TRUE,
             weekly.seasonality = FALSE)

m1 <- suppressMessages(fit.prophet(m1, df))

#plot the baseline and modified models
options(scipen = 50000000)
plot(m,predict(m, df))+add_changepoints_to_plot(m)
plot(m1,predict(m1, df))+add_changepoints_to_plot(m1)

prophet_plot_components(m,predict(m,df))
prophet_plot_components(m1,predict(m1,df))

#add alternate prediction to df
future$cap<-max(df$sales)
future$floor<-0
future$pred2 = predict(m1, future)$yhat


#plot predictions
par(mfrow=c(2,1))

plot(future[c("ds","sales")],type="l", ylim =c(0,max(future$sales, na.rm=TRUE)))
lines(future[c("ds","pred")], col="blue")

plot(future[c("ds","sales")],type="l", ylim =c(0,max(future$sales, na.rm=TRUE)))
lines(future[c("ds","pred2")], col="red")


sample (c("Dave","Martin", "Athena"), size = 1)