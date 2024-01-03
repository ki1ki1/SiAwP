import numpy as np
import pandas as pd
from scipy.stats import shapiro
from scipy.stats import ttest_ind
from scipy.stats import ttest_1samp
from scipy.stats import bartlett
from scipy.stats import ttest_rel

# Zadanie 1
print("\nZadanie 1")
srednia = 2
odchylenie = 30
liczba_elementow = 200

próba = np.random.normal(srednia, odchylenie, liczba_elementow)

hipoteza_test = ttest_1samp(próba, 2.5)

print("\nWyniki testu t:")
print("Statystyka testu t:", hipoteza_test.statistic)
print("Wartość p:", hipoteza_test.pvalue)

alfa = 0.05 
if hipoteza_test.pvalue < alfa:
    print("Odrzucamy hipotezę zerową. Istnieją istotne różnice pomiędzy średnią próbą a wartością oczekiwaną (2.5).")
else:
    print("Nie ma podstaw do odrzucenia hipotezy zerowej. Brak istotnych różnic.")

# Zadanie 2
print("\nZadanie 2")
df = pd.read_csv('napoje.csv', delimiter=';')
df.columns = df.columns.str.strip()

piwo_lech = df['lech']
hipoteza_piwo_lech = ttest_1samp(piwo_lech, 60500)

cola = df['cola']
hipoteza_cola = ttest_1samp(cola, 222000)

piwa_regionalne = df['regionalne']
hipoteza_piwa_regionalne = ttest_1samp(piwa_regionalne, 43500)

print("\nWyniki testu t dla spożycia piwa Lech:")
print("Statystyka testu t:", hipoteza_piwo_lech.statistic)
print("Wartość p:", hipoteza_piwo_lech.pvalue)

print("\nWyniki testu t dla spożycia coli:")
print("Statystyka testu t:", hipoteza_cola.statistic)
print("Wartość p:", hipoteza_cola.pvalue)

print("\nWyniki testu t dla spożycia piw regionalnych:")
print("Statystyka testu t:", hipoteza_piwa_regionalne.statistic)
print("Wartość p:", hipoteza_piwa_regionalne.pvalue)

# Zadanie 3
print("\nZadanie 3")
for column in df.columns[2:]:
    zmienna_do_testu = df[column]
    
    statystyka_shapiro, p_value_shapiro = shapiro(zmienna_do_testu)
    
    print(f"\nStatystyka testu Shapiro-Wilka dla zmiennej '{column}': {statystyka_shapiro}")
    print(f"Wartość p dla zmiennej '{column}': {p_value_shapiro}")
    
    alfa = 0.05
    if p_value_shapiro < alfa:
        print(f"Odrzucamy hipotezę zerową dla zmiennej '{column}'. Zmienna nie pochodzi z rozkładu normalnego.")
    else:
        print(f"Nie ma podstaw do odrzucenia hipotezy zerowej dla zmiennej '{column}'. Zmienna pochodzi z rozkładu normalnego.")

# Zadanie 4
print("\nZadanie 4")
pary = [('okocim', 'lech'), ('fanta', 'regionalne'), ('cola', 'pepsi')]

for para in pary:
    zmienna1, zmienna2 = para
    
    statystyka_t, p_value_t = ttest_ind(df[zmienna1], df[zmienna2], equal_var=False)
    
    print(f"\nWyniki testu t dla pary {para}:")
    print(f"Statystyka testu t: {statystyka_t}")
    print(f"Wartość p: {p_value_t}")
 
    alfa = 0.05
    if p_value_t < alfa:
        print("Odrzucamy hipotezę zerową. Istnieją istotne różnice pomiędzy średnimi.")
    else:
        print("Nie ma podstaw do odrzucenia hipotezy zerowej. Brak istotnych różnic pomiędzy średnimi.")

# Zadanie 5        
print("\nZadanie 5")
pary = [('okocim', 'lech'), ('żywiec', 'fanta'), ('regionalne', 'cola')]

for para in pary:
    zmienna1, zmienna2 = para
    
    statystyka_bartlett, p_value_bartlett = bartlett(df[zmienna1], df[zmienna2])
    
    print(f"\nWyniki testu Bartletta dla pary {para}:")
    print(f"Statystyka testu Bartletta: {statystyka_bartlett}")
    print(f"Wartość p: {p_value_bartlett}")
    
    alfa = 0.05
    if p_value_bartlett < alfa:
        print("Odrzucamy hipotezę zerową. Istnieją istotne różnice w wariancjach.")
    else:
        print("Nie ma podstaw do odrzucenia hipotezy zerowej. Brak istotnych różnic w wariancjach.")

# Zadanie 6        
print("\nZadanie 6")
grupa_2001 = df[df['rok'] == 2001]['regionalne']
grupa_2015 = df[df['rok'] == 2015]['regionalne']

statystyka_t, p_value_t = ttest_ind(grupa_2001, grupa_2015, equal_var=False)

print("\nWyniki testu t dla równości średnich piw regionalnych pomiędzy latami 2001 i 2015:")
print(f"Statystyka testu t: {statystyka_t}")
print(f"Wartość p: {p_value_t}")

alfa = 0.05
if p_value_t < alfa:
    print("Odrzucamy hipotezę zerową. Istnieją istotne różnice pomiędzy średnimi.")
else:
    print("Nie ma podstaw do odrzucenia hipotezy zerowej. Brak istotnych różnic pomiędzy średnimi.")

# Zadanie 7
print("\nZadanie 7")
df_reklama = pd.read_csv('napoje_po_reklamie.csv', delimiter=';')
df_reklama.columns = df_reklama.columns.str.strip()

cola_2016 = df[df['rok'] == 2016]['cola']
fanta_2016 = df[df['rok'] == 2016]['fanta']
pepsi_2016 = df[df['rok'] == 2016]['pepsi']

cola_po_reklamie = df_reklama['cola']
fanta_po_reklamie = df_reklama['fanta']
pepsi_po_reklamie = df_reklama['pepsi']

statystyka_t_cola, p_value_t_cola = ttest_rel(cola_2016, cola_po_reklamie)
statystyka_t_fanta, p_value_t_fanta = ttest_rel(fanta_2016, fanta_po_reklamie)
statystyka_t_pepsi, p_value_t_pepsi = ttest_rel(pepsi_2016, pepsi_po_reklamie)

print("\nWyniki testu t dla równości średnich (dla napoju Cola):")
print(f"Statystyka testu t: {statystyka_t_cola}")
print(f"Wartość p: {p_value_t_cola}")

print("\nWyniki testu t dla równości średnich (dla napoju Fanta):")
print(f"Statystyka testu t: {statystyka_t_fanta}")
print(f"Wartość p: {p_value_t_fanta}")

print("\nWyniki testu t dla równości średnich (dla napoju Pepsi):")
print(f"Statystyka testu t: {statystyka_t_pepsi}")
print(f"Wartość p: {p_value_t_pepsi}")

alfa = 0.05
if p_value_t_cola < alfa:
    print("Odrzucamy hipotezę zerową dla napoju Cola. Istnieją istotne różnice pomiędzy średnimi.")
else:
    print("Nie ma podstaw do odrzucenia hipotezy zerowej dla napoju Cola. Brak istotnych różnic pomiędzy średnimi.")

if p_value_t_fanta < alfa:
    print("Odrzucamy hipotezę zerową dla napoju Fanta. Istnieją istotne różnice pomiędzy średnimi.")
else:
    print("Nie ma podstaw do odrzucenia hipotezy zerowej dla napoju Fanta. Brak istotnych różnic pomiędzy średnimi.")

if p_value_t_pepsi < alfa:
    print("Odrzucamy hipotezę zerową dla napoju Pepsi. Istnieją istotne różnice pomiędzy średnimi.")
else:
    print("Nie ma podstaw do odrzucenia hipotezy zerowej dla napoju Pepsi. Brak istotnych różnic pomiędzy średnimi.")
