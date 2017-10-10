# Data sources ----
trc.EauduBassinRennais.Poussins <- read.delim("data/trc2017_EauduBassinRennais-Poussins.tsv", stringsAsFactors = F)
trc.EauduBassinRennais.Poussins$Course <- "Eau du Bassin Rennais-Poussins"
trc.EauduBassinRennais.Poussins$Distance <- 1.35

trc.EauduBassinRennais.Minimes <- read.delim("data/trc2017_EauduBassinRennais-Minimes.tsv", stringsAsFactors = F)
trc.EauduBassinRennais.Minimes$Course <- "Eau du Bassin Rennais-Benjamins"
trc.EauduBassinRennais.Minimes$Distance <- 2.95

trc.EauduBassinRennais.Benjamins <- read.delim("data/trc2017_EauduBassinRennais-Benjamins.tsv", stringsAsFactors = F)
trc.EauduBassinRennais.Benjamins$Course <- "Eau du Bassin Rennais - Minimes"
trc.EauduBassinRennais.Benjamins$Distance <- 4.2

trc.Lacoursefeminine.30ansTVR <- read.delim("data/trc2017_Lacourseféminine–30ansTVR.tsv", stringsAsFactors = F)
trc.Lacoursefeminine.30ansTVR$Course <- "La course féminine – 30 ans TVR"
trc.Lacoursefeminine.30ansTVR$Distance <- 3.1
trc.Lacoursefeminine.30ansTVR$Sexe <- "F"

trc.LaFranceBleuArmorique.5km <- read.delim("data/trc2017_LaFranceBleuArmorique-5km.tsv", stringsAsFactors = F)
trc.LaFranceBleuArmorique.5km$Course <- "La France Bleu Armorique - 5km"
trc.LaFranceBleuArmorique.5km$Distance <- 5

trc.Le10kmCMB <- read.delim("data/trc2017_Le10kmCMB.tsv", stringsAsFactors = F)
trc.Le10kmCMB$Course <- "Le 10km CMB"
trc.Le10kmCMB$Distance <- 10
  
trc.LeSmiOuestFrance <- read.delim("data/trc2017_LeS'miOuestFrance.tsv", stringsAsFactors = F)
trc.LeSmiOuestFrance$Course <- "Le S'mi Ouest France"
trc.LeSmiOuestFrance$Distance <- 21.1

trc.MatchInter.SobhiSportMen <- read.delim("data/trc2017_MatchInter.SobhiSportMen.tsv", stringsAsFactors = F)
trc.MatchInter.SobhiSportMen$Course <- "Match International Sobhi Sport Men"
trc.MatchInter.SobhiSportMen$Distance <- 10

trc.MatchInter.SobhiSportWomen <- read.delim("data/trc2017_MatchInter.SobhiSportWomen.tsv", stringsAsFactors = F)
trc.MatchInter.SobhiSportWomen$Course <- "Match International Sobhi Sport Women"
trc.MatchInter.SobhiSportWomen$Distance <- 10
trc.MatchInter.SobhiSportWomen$Sexe <- "F"

trc <- rbind(
  trc.EauduBassinRennais.Poussins,
  trc.EauduBassinRennais.Benjamins,
  trc.EauduBassinRennais.Minimes,
  trc.Lacoursefeminine.30ansTVR,
  trc.LaFranceBleuArmorique.5km,
  trc.Le10kmCMB,
  trc.LeSmiOuestFrance,
  trc.MatchInter.SobhiSportMen,
  trc.MatchInter.SobhiSportWomen
)

# Feature engineering ----
trc$Course <- factor(trc$Course, c("Eau du Bassin Rennais-Poussins", "Eau du Bassin Rennais - Minimes", "Eau du Bassin Rennais-Benjamins", "La course féminine – 30 ans TVR", "La France Bleu Armorique - 5km", "Le 10km CMB", "Le S'mi Ouest France", "Match International Sobhi Sport Men", "Match International Sobhi Sport Women"))
trc$Sexe <- as.factor(trc$Sexe)
trc$Categorie <- factor(trc$Categorie, c("PH", "PF", "BH", "BF", "MH", "MF", "CH", "CF", "JH", "JF", "EH", "EF", "SH", "SF", "VH1", "VF1", "VH2", "VF2", "VH3", "VF3", "VH4", "VF4", "VH5", "VF5", "U20", "U23"))
trc$TempsLib <- trc$Temps
trc$Temps <- strptime(trc$Temps, "%H:%M:%S")
trc$TempsSec <- trc$Temps$hour * 3600 + trc$Temps$min * 60 + trc$Temps$sec
trc$Allure <- trc$TempsSec / trc$Distance / 60

# Anonymization ----
trc$NomPrenom <- NULL
trc$Club <- NULL
trc$Dossard <- NULL

# Save ----
save(trc, file = "data/ToutRennesCourt.RData")
