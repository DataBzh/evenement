# La fête de la musique en bretagne

library(tidyverse)
source("/home/colin/R/misc/data-bzh-tools-master/main.R")

fete_full <- read_csv2("https://openagenda.com/agendas/7633600/events.csv?oaq%5Bpassed%5D=1")
bret <- fete_full %>% 
  filter(Région == "Bretagne") %>% 
  select(Identifiant, contains("FR"), Aperçu ,Catégorie, `Style musical`, statut, Latitude, 
         Longitude, `Nom du lieu`, Adresse, `Code postal`, Ville, Arrondissement, Région, Département, 
         Pays) %>%
  mutate(Horaires = lubridate::dmy_hm(`Résumé horaires - FR`),
         Département = stringr::str_replace_all(Département, "Côtes-d'Armor", "Cotes-d'Armor"))

# Par département 

bret %>%
  ggplot(aes(Département)) +
  geom_bar(fill = databzh$colour1) +
  labs(title = "Événements par département", 
       subtitle = "Données via OpenAgenda", 
       caption = "http://data-bzh.fr", 
       y = "") +
  databzhTheme()

# Dix villes les plus représentées

bret %>% 
  count(Ville) %>% 
  arrange(desc(n)) %>% 
  top_n(10) %>% 
  ggplot(aes(reorder(Ville, n), n)) +
  geom_bar(stat = "identity", fill = databzh$colour2) +
  coord_flip() +
  labs(title = "Les dix villes avec le plus d'événements", 
       subtitle = "Données via OpenAgenda", 
       caption = "http://data-bzh.fr", 
       x  = "", y = "") +
  databzhTheme()

# Par heure de départ

bret %>% 
  mutate(heure = lubridate::hour(Horaires)) %>% 
  count(heure) %>% 
  arrange(desc(n)) %>% 
  top_n(10) %>% 
  ggplot(aes(heure, n)) +
  geom_bar(stat = "identity", fill = databzh$colour3) +
  labs(title = "Heures de début des événements", 
       subtitle = "Données via OpenAgenda", 
       caption = "http://data-bzh.fr") +
  databzhTheme()

# Mots clés les plus fréquents 

library(tidytext)
data_frame(line = bret$Identifiant, text = bret$`Mots clés - FR`) %>%
  unnest_tokens(word, text) %>%
  filter(!word %in% stopwords::stopwords_iso$fr) %>%
  count(word, sort = TRUE) %>%
  na.omit() %>% 
  top_n(10) %>% 
  ggplot(aes(reorder(word, n), n)) +
  geom_bar(stat = "identity", fill = databzh$colour5) +
  coord_flip() +
  labs(title = "Les dix mots clés les plus présents", 
       subtitle = "Données via OpenAgenda", 
       caption = "http://data-bzh.fr", 
       x = "", 
       y = "") +
  databzhTheme()

# Text-mining des descriptions

data_frame(line = bret$Identifiant, text = bret$`Description longue - FR`) %>%
  unnest_tokens(word, text) %>%
  filter(!word %in% stopwords::stopwords_iso$fr) %>%
  count(word, sort = TRUE) %>%
  na.omit() %>% 
  top_n(15) %>% 
  ggplot(aes(reorder(word, n), n)) +
  geom_bar(stat = "identity", fill = databzh$colour6) +
  coord_flip() +
  labs(title = "Text-mining des descriptions longues", 
       subtitle = "Données via OpenAgenda", 
       caption = "http://data-bzh.fr", 
       x = "", 
       y = "") +
  databzhTheme()

# Styles clés les plus fréquents 

bret$style <- stringr::str_replace_all(bret$`Style musical`,"\\|",", ")

data_frame(line = bret$Identifiant, text = bret$style) %>%
  unnest_tokens(word, text, token = stringr::str_split, pattern = ",") %>%
  filter(!word %in% stopwords::stopwords_iso$fr) %>%
  count(word, sort = TRUE) %>%
  na.omit() %>% 
  top_n(10) %>% 
  ggplot(aes(reorder(word, n), n)) +
  geom_bar(stat = "identity", fill = databzh$colour7) +
  coord_flip() +
  labs(title = "Les dix styles les plus présents", 
       subtitle = "Données via OpenAgenda", 
       caption = "http://data-bzh.fr", 
       x = "", 
       y = "") +
  databzhTheme()

# Carte
library(rgdal)
wmap_df <- readOGR(dsn=".", layer="R53_dep") %>%
  fortify()
ggplot(wmap_df, aes(long,lat, group=group)) + 
  geom_polygon() + 
  coord_map() +
  geom_path(data=wmap_df, aes(long, lat, group=group, fill=NULL), color="grey50") +
  geom_point(data = bret, aes(x = as.numeric(Longitude), y = as.numeric(Latitude), group = NULL, col = Département),size = 4) + 
  scale_color_manual(values = databzh$colours, name = "") +
  labs(title = "Fête de la musique en Bretagne", 
       subtitle = "Données via OpenAgenda", 
       caption = "http://data-bzh.fr")  + 
  databzhTheme(axis.text.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks=element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        panel.grid.major= element_line("grey50", linetype = "dashed"), 
        panel.background= element_blank()) 
