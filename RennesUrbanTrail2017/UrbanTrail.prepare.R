# Data sources ----
trail.7km <- read.delim("data/RennesUrbanTrail2017_7km.tsv", stringsAsFactors = F)
trail.7km$Course <- "7km"
trail.7km$Distance <- 7

trail.14km <- read.delim("data/RennesUrbanTrail2017_14km.tsv", stringsAsFactors = F)
trail.14km$Course <- "14km"
trail.14km$Distance <- 14

trail.24km <- read.delim("data/RennesUrbanTrail2017_24km.tsv", stringsAsFactors = F)
trail.24km$Course <- "24km"
trail.24km$Distance <- 24

trail <- rbind(trail.7km, trail.14km, trail.24km)

# Feature engineering ----
trail$Course <- factor(trail$Course, c("7km", "14km", "24km"))
trail$Sexe <- as.factor(trail$Sexe)
trail$Categorie <- factor(trail$Categorie, c("CA", "JU", "ES", "SE", "V1", "V2", "V3", "V4"))
trail$TempsLib <- trail$Temps
trail$Temps <- strptime(trail$Temps, "%H:%M:%S")
trail$TempsSec <- trail$Temps$hour * 3600 + trail$Temps$min * 60 + trail$Temps$sec
trail$Allure <- trail$TempsSec / trail$Distance / 60
trail$Age <- 2017 - trail$Annee

# Anonymization ----
trail$NomPrenom <- NULL
trail$Club <- NULL
trail$Dossard <- NULL

# Save ----
save(trail, file = "data/UrbanTrail.RData")
