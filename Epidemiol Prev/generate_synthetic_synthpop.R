## --------------------------------------------------------------
## Synthetic data generation via synthpop
## Example adapted from Nowok, Raab & Dibben (2023)
## --------------------------------------------------------------

library(synthpop)
library(tidyverse)
library(here)
library(rio)

## --------------------------------------------------------------
## 1. Importazione dati
## --------------------------------------------------------------
## Carichiamo il dataset osservato che vogliamo sintetizzare.
## Le specifiche dei tipi vengono fissate per evitare conversioni indesiderate.

data_input <- read_csv(
  here("Epidemiol Prev", "data_input.csv"),
  col_types = cols(
    eta      = col_integer(),
    time_fup = col_integer(),
    npresc   = col_integer(),
    npresc3  = col_integer()
  )
)

## Esploriamo le prime righe
head(data_input)
str(data_input)

## --------------------------------------------------------------
## 2. Impostazione seed per riproducibilità
## --------------------------------------------------------------
my.seed <- 1841634
set.seed(my.seed)

## --------------------------------------------------------------
## 3. Sintesi con metodi di default
## --------------------------------------------------------------
## Utilizziamo syn() senza specificare metodi:
## - la prima variabile nell’ordine di sintesi è generata con metodo "sample" (campionamento casuale)
## - tutte le altre con metodo CART (utilizzando come predittori le variabili sintetizzate prima)
## - l’ordine di sintesi (visit.sequence) segue l’ordine originale delle variabili nel dataset

start <- Sys.time()

sds.default <- syn(
  data = data_input,
  seed = my.seed
)

## L’oggetto risultante è un oggetto di classe "synds".
## La stampa mostra:
## - prime righe del dataset sintetico
## - metodi di sintesi usati
## - ordine di sintesi
## - predictor matrix

sds.default        # output sintetico e informazioni rilevanti

## Estrarre il dataset sintetico (componente $syn)
data_syn <- sds.default$syn

end <- Sys.time()

cat("Time to generate the synthetic dataset:", end - start, "\n")


