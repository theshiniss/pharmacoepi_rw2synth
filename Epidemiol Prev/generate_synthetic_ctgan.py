# -*- coding: utf-8 -*-
"""
Created on Tue May 27 10:40:00 2025

Training of the CTGAN model from Synthetic Data Vault (SDV) library : https://docs.sdv.dev/sdv
using the COVID-19 related dataset from Ferroni E. et al (2020) https://doi.org/10.2147/CLEP.S271763

@author: Giorgia Stendardo
"""

# Import required libraries
import pandas as pd
import torch
import matplotlib.pyplot as plt
from sdv.single_table import CTGANSynthesizer
from sdv.metadata import Metadata
import time


# Check if a CUDA-enabled GPU is available; if so, use it
device = 'cuda' if torch.cuda.is_available() else 'cpu'
print(f'Using device: {device}')

# Load the dataset as a pandas Dataframe
df=pd.read_csv('DATASET/coorte_mortalita_selez_art.csv')

# Detect and validate metadata
metadata = Metadata.detect_from_dataframe(df)
metadata.validate()

# Instantiate the CTGAN synthesizer (model) and setting the training parameters (default are used)
synthesizer = CTGANSynthesizer(
    metadata,
    generator_dim=(256, 256),
    discriminator_dim=(256, 256),
    generator_lr=2e-4,
    generator_decay=1e-6,
    discriminator_lr=2e-4,
    discriminator_decay=1e-6,
    epochs=300,
    batch_size=500,
    verbose=True
)

#-------------- TRAIN -------------------
start = time.perf_counter()   # start time counter
synthesizer.fit(df)
end = time.perf_counter()     # stop time counter
print(f"Tempo di esecuzione: {end - start:.4f} secondi")
#----------------------------------------

# Retrieve loss values vs epochs during training
loss_values = synthesizer.get_loss_values()

# Plot loss vs epochs curve
plt.figure(figsize=(12, 6))
plt.plot(loss_values['Epoch'], loss_values['Generator Loss'], label='Generator Loss', color='blue')
plt.plot(loss_values['Epoch'], loss_values['Discriminator Loss'], label='Discriminator Loss', color='orange')
plt.xlabel("Epoch")
plt.ylabel("Loss")
plt.title("CTGAN Loss During Training")
plt.legend()
plt.savefig("./loss_vs_epochs.png",dpi=300)
plt.show()

#Save the synthesizer to use it later for data generation
synthesizer.save(
    filepath='./data_synthesizer.pkl'
)

# -*- coding: utf-8 -*-
"""
Created on Tue May 27 10:40:00 2025

Synthetic data generation with CTGAN model from Synthetic Data Vault (SDV) library : https://docs.sdv.dev/sdv
trained using COVID-19 related dataset from Ferroni E. et al (2020) https://doi.org/10.2147/CLEP.S271763
 
@author: Giorgia Stendardo
"""

from sdv.single_table import CTGANSynthesizer


# Load the trained CTGAN model
synthesizer = CTGANSynthesizer.load(
    filepath='data_synthesizer.pkl'
)

# Generate synthetic data with a specified number of records
# For the purpose of statistical analysis, we sampled a dataset of the same length as the original 

synthesizer.reset_sampling() # use it to generate always the same data
synth_data = synthesizer.sample(num_rows=42926)

#save new data
synth_data.to_csv("dati_sintetici.csv", index=False)  #esportare il dataset qui nella directory e modificare nome
