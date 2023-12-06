import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import bernoulli, binom, poisson, describe, kurtosis, skew, norm

values = np.array([1, 2, 3, 4, 5, 6])
probabilities = np.array([1/6, 1/6, 1/6, 1/6, 1/6, 1/6])

def calculate_statistics_from_table(values, probabilities):
    samples = np.random.choice(values, size=100, p=probabilities)
    mean_val = np.mean(samples)
    variance_val = np.var(samples)
    kurtosis_val = kurtosis(samples)
    skewness_val = skew(samples)
    
    print("\nZmienne losowe z tabeli:")
    print(f"Średnia: {mean_val}")
    print(f"Wariancja: {variance_val}")
    print(f"Kurtoza: {kurtosis_val}")
    print(f"Skośność: {skewness_val}")

calculate_statistics_from_table(values, probabilities)

n_samples = 100
bernoulli_samples = bernoulli.rvs(p=probabilities[0], size=n_samples)
binomial_samples = binom.rvs(n=10, p=probabilities[0], size=n_samples)
poisson_samples = poisson.rvs(mu=np.sum(values * probabilities), size=n_samples)

def calculate_statistics(samples, distribution_name):
    mean_val = np.mean(samples)
    variance_val = np.var(samples)
    kurtosis_val = kurtosis(samples)
    skewness_val = skew(samples)
    
    print(f"\nRozkład {distribution_name}:")
    print(f"Średnia: {mean_val}")
    print(f"Wariancja: {variance_val}")
    print(f"Kurtoza: {kurtosis_val}")
    print(f"Skośność: {skewness_val}")

plt.figure(figsize=(15, 5))

plt.subplot(1, 3, 1)
plt.bar([0, 1], bernoulli.pmf([0, 1], p=probabilities[0]), align='center', alpha=0.7, edgecolor='#f78fb3', color='#f8a5c2')
plt.title('Rozkład Bernoulliego')
plt.xlabel('Wartość')
plt.ylabel('Prawdopodobieństwo')

plt.subplot(1, 3, 2)
plt.bar(np.arange(0, 11), binom.pmf(np.arange(0, 11), n=10, p=probabilities[0]), align='center', alpha=0.7, edgecolor='#574b90', color='#786fa6')
plt.title('Rozkład Dwumianowy')
plt.xlabel('Wartość')
plt.ylabel('Prawdopodobieństwo')

plt.subplot(1, 3, 3)
plt.bar(np.arange(0, np.max(values) + 1), poisson.pmf(np.arange(0, np.max(values) + 1), mu=np.sum(values * probabilities)), align='center', alpha=0.7, edgecolor='#3dc1d3', color='#63cdda')
plt.title('Rozkład Poissona')
plt.xlabel('Wartość')
plt.ylabel('Prawdopodobieństwo')

plt.tight_layout()
plt.show()

calculate_statistics(bernoulli_samples, "Bernoulliego")
calculate_statistics(binomial_samples, "Dwumianowy")
calculate_statistics(poisson_samples, "Poissona")

n_trials = 20
prob_success = 0.4

binomial_values = np.arange(0, n_trials + 1)
binomial_probs = binom.pmf(binomial_values, n=n_trials, p=prob_success)

sum_probs = np.sum(binomial_probs)

print("Rozkład prawdopodobieństwa dla rozkładu Dwumianowego:")
for k, prob in zip(binomial_values, binomial_probs):
    print(f'P(X={k}) = {prob:.4f}')

print(f"\nSuma prawdopodobieństw: {sum_probs}")

if np.isclose(sum_probs, 1.0):
    print("Suma prawdopodobieństw jest równa 1.")
else:
    print("Uwaga! Suma prawdopodobieństw nie jest równa 1.")

mean_value = 0
std_dev = 2
sample_size = 100

normal_data = np.random.normal(loc=mean_value, scale=std_dev, size=sample_size)

desc_stats = describe(normal_data)

print(f"\nStatystyki opisowe dla rozkładu normalnego (n={sample_size}):")
print(f"Średnia: {desc_stats.mean}")
print(f"Wariancja: {desc_stats.variance}")
print(f"Kurtoza: {desc_stats.kurtosis}")
print(f"Skośność: {desc_stats.skewness}")

theoretical_mean = mean_value
theoretical_variance = std_dev**2
theoretical_kurtosis = 0 
theoretical_skewness = 0

print("\nPorównanie z teoretycznymi wartościami:")
print(f"Średnia - Teoretyczna: {theoretical_mean}, Obliczona: {desc_stats.mean}")
print(f"Wariancja - Teoretyczna: {theoretical_variance}, Obliczona: {desc_stats.variance}")
print(f"Kurtoza - Teoretyczna: {theoretical_kurtosis}, Obliczona: {desc_stats.kurtosis}")
print(f"Skośność - Teoretyczna: {theoretical_skewness}, Obliczona: {desc_stats.skewness}")

larger_sample_size = 1000
larger_normal_data = np.random.normal(loc=mean_value, scale=std_dev, size=larger_sample_size)
larger_desc_stats = describe(larger_normal_data)

print(f"\nStatystyki opisowe dla rozkładu normalnego (n={larger_sample_size}):")
print(f"Średnia: {larger_desc_stats.mean}")
print(f"Wariancja: {larger_desc_stats.variance}")
print(f"Kurtoza: {larger_desc_stats.kurtosis}")
print(f"Skośność: {larger_desc_stats.skewness}")

mean1 = 1
std_dev1 = 2

mean_standard = 0
std_dev_standard = 1

mean2 = -1
std_dev2 = 0.5

data1 = np.random.normal(loc=mean1, scale=std_dev1, size=1000)

data_standard = np.random.normal(loc=mean_standard, scale=std_dev_standard, size=1000)

data2 = np.random.normal(loc=mean2, scale=std_dev2, size=1000)

plt.hist(data1, bins=30, density=True, alpha=0.5, edgecolor='#3dc1d3', color='#63cdda', label='Średnia=1, Odchylenie=2')
plt.hist(data_standard, bins=30, density=True, alpha=0.5, edgecolor='#574b90', color='#786fa6', label='Rozkład standardowy')

x_range = np.linspace(-5, 3, 1000)
density_curve = norm.pdf(x_range, loc=mean2, scale=std_dev2)
plt.plot(x_range, density_curve, label='Średnia=-1, Odchylenie=0.5', color='#f8a5c2')

plt.legend()
plt.title('Histogramy i Wykres Gęstości')
plt.xlabel('Wartość')
plt.ylabel('Gęstość prawdopodobieństwa')

plt.show()