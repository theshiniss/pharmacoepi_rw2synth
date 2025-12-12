## --------------------------------------------------------------
## Misure di disclosure per i dati sintetici con multi.disclosure()
## Esempio adattato da Nowok, Raab & Dibben (2025)
## --------------------------------------------------------------

library(synthpop)

# Quasi-identifiers (keys)
keys <- c("eta", "sesso", "centro", "icu")

# multi.disclosure calcola UiO, repU, Dorig, DiSCO e altri indicatori
md_synthpop <- multi.disclosure(
  sds.default,        # synthetic dataset
  data_input,         # input data
  keys = keys
)

md_synthpop

## --------------------------------------------------------------
## 2. ATTRIBUTE DISCLOSURE (Dorig e DiSCO) per ciascuna variabile target
## --------------------------------------------------------------

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

# Ciclo sulle variabili target
discl_synthpop <- lapply(var_list, function(v) {
  disclosure(
    data_syn, data_input,
    keys = keys,
    target = v,
    compare.synorig = TRUE,
    not.targetlev = "no"      # esclude livelli non informativi
  )
})

# Stampa dei risultati
lapply(discl_synthpop, function(x) print(x, to.print = "attrib"))

## --------------------------------------------------------------
## 3. CT-GAN: misure di disclosure con esclusione di "no"
## --------------------------------------------------------------
dati_sintetici_ctgan <- read_csv(here("DATASET","dati_sintetici_ctgan.csv"),  # Da modificare qui
    col_types = cols(id = col_integer(), eta = col_integer(), 
        time_fup = col_integer(), status_dec = col_character(), 
        npresc = col_integer(), npresc3 = col_integer()))
gan <- dplyr::select(dati_sintetici_ctgan,-id)
data.si$syn <- as.data.frame(gan)  # Da modificare qui

discl_ctgan <- lapply(var_list, function(v) {
  disclosure(
    data.si$syn, data_input,                                     # Da modificare data.si$syn
    keys = keys,
    target = v,
    compare.synorig = TRUE,
    not.targetlev = "no"
  )
})

lapply(discl_ctgan, function(x) print(x, to.print = "attrib"))
