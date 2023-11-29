import pandas as pd
import matplotlib.pyplot as plt
import statistics
import scipy.stats as stats


df = pd.read_csv("MDR_RR_TB_burden_estimates_2023-11-29.csv")

selected_column = df.iloc[:, 3]

mean_value = selected_column.mean()
median_value = selected_column.median()
variance_value = selected_column.var()
stdev_value = selected_column.std()

print(f"Średnia: {mean_value}")
print(f"Mediana: {median_value}")
print(f"Wariancja: {variance_value}")
print(f"Odchylenie standardowe: {stdev_value}")


# 2
with open("Wzrost.csv", "r") as file:
    data_str = file.read()

data_list = [int(value) for value in data_str.split(",")]

growth_data = pd.DataFrame({"Wzrost": data_list})

data_height = growth_data["Wzrost"].tolist()

variance = statistics.variance(data_height)
std_deviation = statistics.stdev(data_height)

print("Wariancja:", variance)
print("Odchylenie standardowe:", std_deviation)

#3
second_selected_column = df.iloc[:, 3]

stats_result = stats.describe(second_selected_column)

print("\nStatystyki opisowe dla  wybranej kolumny:")
print(stats_result)

mode_value, mode_count = stats.mode(second_selected_column)
print(f"Modalna wartość: {mode_value[0]} (liczba wystąpień: {mode_count[0]})")

moment_2 = stats.moment(second_selected_column, moment=2) 
moment_3 = stats.moment(second_selected_column, moment=3)

print(f"Wariancja (moment 2): {moment_2}")
print(f"Skośność (moment 3): {moment_3}")

#4

brain_data = pd.read_csv("brain_size.csv", sep=';')

average_viq = brain_data['VIQ'].mean()
print(f"Średnia dla kolumny VIQ: {average_viq}")

gender_counts = brain_data['Gender'].value_counts()
print("Liczba kobiet i mężczyzn:")
print(gender_counts.to_string(header=False))

plt.figure(figsize=(12, 8))
plt.subplot(2, 2, 1)
plt.hist(brain_data['VIQ'], bins=10, edgecolor='#303952', color='#596275')
plt.title('Histogram VIQ')

plt.subplot(2, 2, 2)
plt.hist(brain_data['PIQ'], bins=10, edgecolor='#303952', color='#596275')
plt.title('Histogram PIQ')

plt.subplot(2, 2, 3)
plt.hist(brain_data['FSIQ'], bins=10, edgecolor='#303952', color='#596275')
plt.title('Histogram FSIQ')

female_data = brain_data[brain_data['Gender'] == 'Female']

plt.figure(figsize=(12, 4))
plt.subplot(1, 3, 1)
plt.hist(female_data['VIQ'], bins=10, edgecolor='#f78fb3', color='#f8a5c2')
plt.title('Histogram VIQ (Kobiety)')

plt.subplot(1, 3, 2)
plt.hist(female_data['PIQ'], bins=10, edgecolor='#574b90', color='#786fa6')
plt.title('Histogram PIQ (Kobiety)')

plt.subplot(1, 3, 3)
plt.hist(female_data['FSIQ'], bins=10, edgecolor='#3dc1d3', color='#63cdda')
plt.title('Histogram FSIQ (Kobiety)')

plt.tight_layout()
plt.show()