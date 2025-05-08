library(shiny)
library(tidyverse)
library(readxl)
library(shinythemes)
library(slickR)
library(shinyWidgets)
library(leaflet)
library(datamods)

TableP1 <- read_xlsx("database/Shiny_PROMAC_2024_12Nov.xlsx", 
                     sheet = "Shiny_PROMAC_2024_12Nov", col_types = "text") 

TableL <- TableP1 %>%
    filter(AnioColecta != "NA") %>% 
    filter(AnioColecta != "9999") %>%
    mutate(AnioColecta = as.factor(AnioColecta)) %>% 
    mutate(RegionCONANP = as.factor(RegionCONANP)) %>% 
    mutate(ANP_RPC_CONANP = as.factor(ANP_RPC_CONANP)) %>% 
    mutate(Estado = as.factor(Estado)) %>% 
    mutate(RazaPrimaria = as.factor(RazaPrimaria)) %>% 
    rename(Longitud = longitude) %>% 
    rename(Latitud = latitude) %>%
    filter(Latitud != "NA") %>% 
    filter(Longitud != "NA") %>% 
    mutate(Latitud = as.numeric(Latitud)) %>% 
    mutate(Longitud = as.numeric(Longitud)) %>% 
    filter(Longitud <= 0) %>% 
    tidyr::drop_na(RazaPrimaria) %>% 
    tidyr::drop_na(Latitud) %>% 
    select(RazaPrimaria, RegionCONANP, ANP_RPC_CONANP, CategoriaConservacion, 
           CategoriaANP, AnioColecta,Estado, Municipio, Localidad,
           longitude = Longitud,latitude = Latitud,
           Localidad,NumeroBeneficiarios) %>% 
    mutate(Estado = str_to_sentence(Estado)) %>% 
    mutate(Municipio = str_to_title(Municipio)) %>% 
    filter(RazaPrimaria != "ND") %>% 
    arrange(RazaPrimaria) 

# Change just some names in RazaPrimaria
# example change from arrocillo to arrocillo

TableL <- TableL %>%
    mutate(RazaPrimaria = case_when(RazaPrimaria == "arrocillo" ~ "Arrocillo",
                                    RazaPrimaria == "Zapalote chico" ~ "Zapalote Chico",
                                    RazaPrimaria == "Zamorano amarillo" ~ "Zamorano Amarillo", 
                                    RazaPrimaria == "Nal-Tel" ~ "Nal-tel", 
                                    RazaPrimaria == "Cónico norteño" ~ "Cónico Norteño", 
                                    RazaPrimaria == "Elotes cónicos" ~ "Elotes Cónicos", 
                                    TRUE ~ RazaPrimaria))

TableL <- TableL %>%
    mutate_at(c("RazaPrimaria", "RegionCONANP", "ANP_RPC_CONANP", 
                "CategoriaConservacion",
                "CategoriaANP","AnioColecta", "Estado"), as.factor)