#read and attach GPA file- Data available at https://www.rdocumentation.org/packages/Stat2Data/versions/1.6/topics/FirstYearGPA

attach(gpa)

#We will not require all the columns. So, we will take only the GPA column.
gpa<-gpa[,2]

#Plotting the histogram of the data
hist(GPA)

#We don't know the distribution of the data. So, we first calculate the distribution using the emperical CDF.
library(ACSWR)

gpa.ecdf<-ecdf(gpa)
plot(gpa.ecdf,main="Plot of ECDF",xlab="GPA",ylab = "ECDF")

#Consructing a 95% confidence interval around the emperical cdf function and plotting it

alpha=0.05
n=length(gpa)
epsilon=sqrt(log(2/alpha)/(2*n))
grid=seq(1.5,4.5,length.out=1000)
lines(grid,pmin(gpa.ecdf(grid)+epsilon,1))
lines(grid,pmax(gpa.ecdf(grid)-epsilon,0))

P_g3.5=gpa.ecdf(4.0)-gpa.ecdf(3.5)
#There is a 21% probability of getting a GPA greater than 3.5 


#Calculating the standard error and a 95% CI for the mean of the data using non-parametric bootstrap
mean.hat=mean(gpa)
mean.bootstrap=vector("numeric",3200)
for(i in 1:3200)
{
  resample=sample(gpa,n,replace = T) 
  mean.bootstrap[i]=mean(resample)  
}

#Calculating the standard error of the bootstrapped means
se.mean=sd(mean.bootstrap)
# 0.03

#Plotting the histogram of bootstrap
hist(mean.bootstrap, probability = T, main = "Histogram of bootstrapped means", xlab = "Bootstrapped mean values", 
     ylab = "Pobability density")


#Calculating the 95% confidence interval for the mean using the Normal method (assuming that the distribution is normal)
nbootstrap_ci.mean=c(mean.hat-2*se.mean, mean.hat+2*se.mean)
#3.03,3.16



#Calculating the standard error and a 95% CI for the median of the data using non-parametric bootstrap
median.hat=median(gpa)
#3.15
median.bootstrap=vector("numeric",3200)
for(i in 1:3200)
{
  resample=sample(gpa,n,replace = T) 
  median.bootstrap[i]=median(resample)  
}

#Calculating the standard error of the bootstrapped means
se.median=sd(median.bootstrap)
# 0.044

#Plotting the histogram of bootstrap
hist(median.bootstrap, probability = T, main = "Histogram of bootstrapped medians", xlab = "Bootstrapped median values", 
     ylab = "Pobability density")


#Calculating the 95% confidence interval for the median using the Percentile method
nbootstrap_ci.median=quantile(median.bootstrap,c(0.025,0.975))
#3.06,3.23



#MLE
#Calculating the MLE for mean and standard deviation under the assumption that the data is distributed normally. 
hist(gpa)
mu.hat=mean(gpa)
sigma.hat=sqrt((1/n)*sum((gpa-mean(gpa))^2))
tau.hat=mu.hat+qnorm(0.50)*sigma.hat
#3.09

#Parametric bootstrap
tau.bootstrap=vector("numeric",3200)

for(i in 1:3200)
{
  X_i=rnorm(n,mu.hat,sigma.hat)
  tau.bootstrap[i]=mean(X_i)+qnorm(0.50)*sqrt((1/n)*sum((X_i-mean(X_i))^2))
  
}
tau.bootstrap_se=sd(tau.bootstrap)

#Calculating the 95% confidence interval of the median.
tau.ci95=c(tau.hat-2*tau.bootstrap_se,tau.hat+2*tau.bootstrap_se)
#3.03   3.16


#WALD TEST
#Assuming that the mean GPA is 3.1 and conducting a Wald test for confirmation
mu0=3.15
xbar=mean(gpa)
secap=sd(gpa)/sqrt(n)
modw=abs((xbar-mu0)/secap)
zalpha=qnorm(0.025,lower.tail = F)

#Since, modw less than zalpha, we cannot reject the Null hypothesis that the population mean is 3.15


#BAYESIAN ANALYSIS
#We assume that the proportion of students who get GPA's less that 3.0 is a constant which follows a Beta distribution of Beta(1,1)
p.prior=rbeta(100,1,1)
plot(p.prior,dbeta(p.prior,1,1), main = "Distribution of the prior and posteriors", xlab = "Value of the proportions", ylab = "PDF",type = "line",xlim=c(0.05,0.6),ylim = c(0,15))

#Computing values of posteriors by adding 40 rows each time and looking at the number of people who got below 3.0

#Taking the first 40 rows.
gpa_140=gpa[c(1:40)]
#Calculating the number of people who got less than 3.0
s_140=length(subset(gpa_140,gpa_140<3.0))
#s_140 is 11. Hence, the posterior distribution will be Beta(12,30)
p.posterior140=rbeta(100,12,30)
lines(sort(p.posterior140),dbeta(sort(p.posterior140),12,30))

#Taking the second 40 rows.
gpa_240=gpa[c(41:80)]
#Calculating the number of people who got less than 3.0
s_240=length(subset(gpa_240,gpa_240<3.0))
#s_140 is 16. Hence, the posterior distribution will be Beta(28,54)
p.posterior240=rbeta(100,28,54)
lines(sort(p.posterior240),dbeta(sort(p.posterior240),28,54))


#Taking the third 40 rows.
gpa_340=gpa[c(81:120)]
#Calculating the number of people who got less than 3.0
s_340=length(subset(gpa_340,gpa_340<3.0))
#s_140 is 12. Hence, the posterior distribution will be Beta(40,82)
p.posterior340=rbeta(100,40,82)
lines(sort(p.posterior340),dbeta(sort(p.posterior340),28,54))


#Taking the fourth 40 rows.
gpa_440=gpa[c(121:160)]
#Calculating the number of people who got less than 3.0
s_440=length(subset(gpa_440,gpa_440<3.0))
#s_140 is 17. Hence, the posterior distribution will be Beta(40,82)
p.posterior440=rbeta(100,57,104)
lines(sort(p.posterior440),dbeta(sort(p.posterior440),57,104))


#Taking the final set of rows.
gpa_540=gpa[c(161:219)]
#Calculating the number of people who got less than 3.0
s_540=length(subset(gpa_540,gpa_540<3.0))
#s_140 is 30. Hence, the posterior distribution will be Beta(87,134)
p.posterior540=rbeta(100,87,134)
lines(sort(p.posterior540),dbeta(sort(p.posterior540),87,134))
