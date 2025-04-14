library(tidyverse)
library(readxl)
library(xlsx)
library(sp)
#library(rgeos)
#library(maptools)
#library(rgdal)
library(scales)
#library(downloader)
library(shiny)
library(leaflet)
library(RColorBrewer)


#TableP <- read_xlsx("Consulta_Alex_abril.xlsx", sheet = "RawData", col_names = T)
#head(TableP)


#TableP1 <- xlsx::read.xlsx(file = "database/database_2022.xlsx", sheetName = "Base",
#                           header = T, as.data.frame = T) 

#TableP1 <- read_xlsx("database/Shiny_PROMAC_2024.xlsx", sheet = "Shiny_PROMAC_2024", col_types = "text") 

TableP1 <- read_xlsx("database/Shiny_PROMAC_2024_12Nov.xlsx", sheet = "Shiny_PROMAC_2024_12Nov", col_types = "text") 

names(TableP1)

#TableP <- read.delim("Consulta_Alex_abril.csv", header = T, sep = "\t", fill = T, fileEncoding = "WINDOWS-1252", dec = ".")
dir()

TableL <- TableP1 %>%
    filter(AnioColecta != "NA") %>% 
    filter(AnioColecta != "9999") %>% 
    #mutate(AnioColecta = as.numeric(AnioColecta))
    #tidyr::drop_na(AnioColecta) %>%
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
    select(RazaPrimaria, RegionCONANP, ANP_RPC_CONANP, CategoriaConservacion, CategoriaANP,
           AnioColecta,Estado, Municipio, Localidad,longitude = Longitud,latitude = Latitud,
           Localidad,NumeroBeneficiarios) %>% 
    #mutate(RazaPrimaria = str_to_title(RazaPrimaria)) %>% 
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

    #mutate(CategoriaANP = case_when(CategoriaANP == "NA" ~ "",
    #                               CategoriaANP == "RB" ~ "Reserva de la Biósfera",
    #                               CategoriaANP == "PN" ~ "Parque Nacional",
    #                               CategoriaANP == "APFF" ~ "Área de Protección de Flora y Fauna",
    #                               CategoriaANP == "APRN" ~ "Área de Protección de Recursos Naturales",
    #                               CategoriaANP == "MN" ~ "Monumento Natural",
    #                               CategoriaANP == "S" ~ "Santuario")) %>% 
    #mutate(CategoriaConservacion = case_when(CategoriaConservacion == "NA" ~ "",
    #                                CategoriaConservacion == "ANP" ~ "Área Natural Protegida",
    #                                CategoriaConservacion == "RPC" ~ "Región Prioritaria para la Conservación"))

