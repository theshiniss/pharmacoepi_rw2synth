## --------------------------------------------------------------
## Synthetic data generation via synthpop
## Example adapted from Nowok, Raab & Dibben (2023)
## --------------------------------------------------------------

## --------------------------------------------------------------
## 1. Import required libraries
## --------------------------------------------------------------
library(tidyverse)
library(skimr)
library(synthpop)
library(rio)

## --------------------------------------------------------------
## 2. Data import
## --------------------------------------------------------------
## Load the input dataset to be synthesized.
## Set data types to avoid unwanted conversions.

data_input <- read_csv(
  "data_input.csv",
  col_types = cols(
    eta      = col_integer(),
    time_fup = col_integer(),
    npresc   = col_integer(),
    npresc3  = col_integer()
  )
)

## Display the first rows and the structure of the input data
glimpse(data_input)
skim(data_input)

## --------------------------------------------------------------
## 3. Set seed for reproducibility
## --------------------------------------------------------------
my.seed <- 123
set.seed(my.seed)

## --------------------------------------------------------------
## 4. Synthesis using default methods
## --------------------------------------------------------------
## We use syn() without specifying methods:
## - the first variable in the synthesis order is generated using the "sample" method (random sampling)
## - all remaining variables use the CART method (with previously synthesized variables as predictors)
## - the synthesis order (visit.sequence) follows the original variable order in the dataset

# Record start time
start <- Sys.time()

# Generate the synthetic dataset
sds.default <- syn(
  data = data_input,
  seed = my.seed
)

# Record end time and print elapsed time
end <- Sys.time()
cat("Time to generate the synthetic dataset:", end - start, "\n")

## The resulting object is of class "synds".
## Printing it shows:
## - the first rows of the synthetic dataset
## - the synthesis methods used
## - the synthesis order
## - the predictor matrix
sds.default

## Extract the synthetic dataset (the $syn component) and export new dataset in the current working directory
sds.default$syn |> export("data_syn_synthpop.csv")
