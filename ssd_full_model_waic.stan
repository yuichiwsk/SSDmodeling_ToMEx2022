data {
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
} } 
