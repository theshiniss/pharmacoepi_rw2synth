## --------------------------------------------------------------
## Disclosure measures for synthetic data using multi.disclosure()
## Example adapted from Nowok, Raab & Dibben (2025)
## --------------------------------------------------------------

library(synthpop)

# Quasi-identifiers (keys)
keys <- c("eta", "sesso", "centro", "icu")

## --------------------------------------------------------------
## 1. Disclosure measures for synthpop data
## --------------------------------------------------------------

# multi.disclosure calculates UiO, repU, Dorig, DiSCO, and other measures
md_synthpop <- multi.disclosure(
  sds.default,        # synthetic dataset generated using synthpop
  data_input,         # input data
  keys = keys
)

md_synthpop

## Focus on overall IDENTITY DISCLOSURE measures 
## Original data (UiO): 0.26%
## Synthetic data (repU): 0.06%

## ATTRIBUTE DISCLOSURE (Dorig and DiSCO) for each target variable 

var_list <- c(
  "p_coagul_n_d1", "p_aggreg_n_d1", "p_ipolipe_n_d1", "p_ritmo_n_d1",
  "p_ulcera_n_d1", "p_resp_n_d1", "p_antib_n_d1", "p_hiv_n_d1",
  "p_park_n_d1", "p_epil_n_d1", "p_psico_n_d1", "p_depres_n_d1",
  "p_fans_n_d1", "p_corti_n_d1", "p_cloroc_n_d1", "p_immuno_n_d1",
  "r_cardio_d", "r_fibrilatr_d", "r_scomp_d", "r_ipert_d", 
  "r_cerebro_d", "c_diabete_d1", "r_epato_d", "c_demenza_d1",
  "r_polmon_d", "c_insuffren_d1", "c_bpco_d1", "c_tumori_d1",
  "c_artreuma_d1"
)

# Loop over the target variables
discl_synthpop <- lapply(var_list, function(v) {
  disclosure(
    data_syn_synthpop, data_input,
    keys = keys,
    target = v,
    compare.synorig = TRUE,
    not.targetlev = "no"      # Exclude non-informative levels
  )
})

# Print the results
lapply(discl_synthpop, function(x) print(x, to.print = "attrib")) ## Focus on Attribute disclosure measures (Dorig/DiSCO)

## --------------------------------------------------------------
## 2. Disclosure measures for CT-GAN data
## --------------------------------------------------------------

data.si <- syn(data_input, seed = my.seed, method = "parametric")
data_syn_ctgan <- read_csv(here("Epidemiol Prev","data_syn_ctgan.csv"),
    col_types = cols(eta = col_integer(), time_fup = col_integer(), 
                     status_dec = col_character(), npresc = col_integer(), npresc3 = col_integer()))
data.si$syn <- as.data.frame(data_syn_ctgan)

md_gan <- multi.disclosure(
  data.si$syn,        # synthetic dataset generated using CT-GAN
  data_input,         # input data
  keys = keys
)

md_gan

## Focus on overall IDENTITY DISCLOSURE measures 
## Original data (UiO): 0.26%
## Synthetic data (repU): 0.06%   #non mi trovo, questo dovrebbe essere 0.06

discl_ctgan <- lapply(var_list, function(v) {
  disclosure(
    data.si$syn, data_input,                                    
    keys = keys,
    target = v,
    compare.synorig = TRUE,
    not.targetlev = "no"
  )
})

lapply(discl_ctgan, function(x) print(x, to.print = "attrib")) ## Focus on Attribute disclosure measures (Dorig/DiSCO)
