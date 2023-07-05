# The following R and Stan program code was used for a Bayesian species sensitivity distribution (SSD) model. 
# The SSD model with all the predictor variables is provided as an example.

## Necessary packages 
library(rstan); library(loo); library(openxlsx)
library(bayesplot) # For illustration
# Some settings
rstan_options(auto_write = T); options(mc.cores = parallel::detectCores())

# Read the dataset
d <- read.xlsx("Data_SSDmodeling_ToMEx2022_v1.xlsx", sheet = "Data")

# Data
list.data <- list(
  N = nrow(d),
  Log10_tox = log10(d$NOEC_mass),
  Log10_size = log10(d$Particle_Length_um),
  Media_type = as.numeric(d$Environment == "Freshwater"),
  Shape_Fragment = as.numeric(d$Shape == "Fragment"),
  Shape_Fiber = as.numeric(d$Shape == "Fiber"),
  Polymer_PS = as.numeric(d$Polymer == "Polystyrene"),
  Polymer_PE = as.numeric(d$Polymer == "Polyethylene")
  )

# Make “.stan” file
cat("data {
  int<lower = 0> N; // number of data
  real Log10_tox[N]; // log10-transformed chronic NOECs
  real Log10_size[N]; // log10-transformed particle length
  int<lower = 0, upper = 1> Media_type[N]; // binary-dummy variable representing type of medium (marine: 0, freshwater: 1)
  int<lower = 0, upper = 1> Polymer_PS[N]; // binary-dummy variable representing polymer type (PS or not)
  int<lower = 0, upper = 1> Polymer_PE[N]; // binary-dummy variable representing polymer type (PE or not)
  int<lower = 0, upper = 1> Shape_Fragment[N]; // binary-dummy variable representing shape (Fragment or not)
  int<lower = 0, upper = 1> Shape_Fiber[N]; // binary-dummy variable representing shape (Fiber or not)
}

parameters {
  real alpha;
  real beta[6];
  real<lower = 0> sigma;
}

transformed parameters {
  real mu[N];

  for (n in 1:N) {
    mu[n] = alpha + 
beta[1] * Log10_size[n] + 
		beta[2] * Media_type[n] + 
		beta[3] * Shape_Fragment[n] +
		beta[4] * Shape_Fiber[n]+
		beta[5] * Polymer_PS[n] +
		beta[6] * Polymer_PE[n];
  }
}

model {
  for (n in 1:N) {
    Log10_tox[n] ~ normal(mu[n], sigma);
  }

for (j in 1:6) {
  beta[j] ~ cauchy(0, 5);
  }
alpha ~ cauchy(0, 10);
sigma ~ cauchy(0, 5);
}

generated quantities {
  vector[N] log_lik;
  
  for (n in 1:N) {
    log_lik[n] = normal_lpdf(Log10_tox[n] | mu[n], sigma);
} }","\n", file = "ssd_full_model_waic.stan")
# You can see "ssd_full_model_waic.stan" file is now in your directory

stanmodel <- stan_model(file = 'ssd_full_model_waic.stan')

#Start sampling
fit1 <- sampling(
  stanmodel,
  data = list.data,
  pars = c('alpha', 'beta', 'sigma', 'log_lik'),
  chains = 3,
  iter = 30000,
  warmup = 10000,
  thin = 10,
  control = list(adapt_delta = 0.9),
  seed = 1010
  )


## See the results of fitting
print(fit1, par = c("alpha", "beta", "sigma"), probs = c(0.025, 0.5, 0.975))

# R-hat
mcmc_rhat(rhat(fit1)) 

# Trace plots
stan_trace(fit1, inc_warmup = T)
# Check individually...
mcmc_combo(fit1, pars = c("alpha")) # alpha
mcmc_combo(fit1, pars = c("beta[1]")) # beta1
mcmc_combo(fit1, pars = c("sigma")) 

## WAIC
tmp   <- extract_log_lik(fit1, parameter_name = "log_lik", merge_chains = TRUE)
WAIC <- waic(tmp)
WAIC$estimates[3,1] #   159.3971


# Visualize Median and 95% Bayesian credible intervals for parameters
samples <- as.array(fit1)
gg1 <- mcmc_intervals(samples, regex_pars = c("alpha", "beta", "sigma"), prob = 0.95, prob_outer = 0.95, point_est = "median", 
				point_size = 5, inner_size = 2) + 
				theme_bw(base_size = 25) 
gg1

