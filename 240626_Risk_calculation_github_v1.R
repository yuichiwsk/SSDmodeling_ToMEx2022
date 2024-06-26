# A quick note about how we can estimate the risk

# If you have measured MP data that includes information about 
# particle length (um: length.um), fiber (binary: fiber = 1, not fiber = 0), 
# and mass concentration (ug/L: conc.mass) for individual MP particles, 
# here is the R code to calculate the cumulative impact by assuming concentration addition.

# SSD mean for individual MP particles
ssd.mean <- -1.248266 + 0.6624 * log10(length.um) - 1.759852 * fiber
ssd.sd <- 1.749068

# Calculating the cumulative impact by assuming concentration addition
ssd.mean.max <- -1.248266 + 0.6624 * log10(5000) - 1.759852 * 0
dif <- ssd.mean - ssd.mean.max
log.conc.mass <- log10(conc.mass)
cov.conc.mass <- sum(10^(log.conc.mass + dif))
total_impact <- pnorm(log10(cov.conc.mass), mean = ssd.mean.max, sd = ssd.sd)

# Printing the cumulative impact
print(total_impact)
