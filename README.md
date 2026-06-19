# Strategische Risikoanalyse:
Magist Marketplace
SQL- und Tableau-basierte Markteintrittsprüfung
für den Vertrieb von Premium-Tech-Produkten in Brasilien

# 🎯 Projektübersicht

Ein internationaler Premium-Tech-Anbieter prüft den brasilianischen Online-Marktplatz Magist als möglichen Vertriebskanal für sein Hochpreis-Portfolio.
Auf Basis einer SQL-Analyse der relationalen Magist-Datenbank und einer Visualisierung der Ergebnisse in Tableau wurden sechs Dimensionen untersucht:

Marktstruktur, Produktfit, Lieferzeit, Wettbewerb, Working Capital und externe Risiken. 

Die Analyse kommt zu einer klaren Empfehlung gegen Magist als Vertriebsplattform für das Premiumsegment, da Kundenprofil, Preisniveau und operative Rahmenbedingungen nicht zur Zielpositionierung passen.

# 📊 Datensatz & Quellen
Die Magist-Datenbank basiert auf dem öffentlichen Olist Brazilian E-Commerce Dataset und wird häufig in Tech-Bootcamps für SQL- und Tableau-Projekte eingesetzt.
## Quelle: 						
Olist Brazilian E-Commerce Dataset (Kaggle)
## Bootcamp-Referenzstruktur: 	
Eniac-Magist-Projekt (GitHub)

## Größe: 
Relationale Datenbank über mehrere Tabellen – keine einzelne Gesamtzahl an Datensätzen.
- Bestellungen (orders): 99.441 Datensätze
- Bestellposten (order_items): 112.650 Datensätze
- Produkte (products): über 32.900 registrierte Artikel
- Kunden (customers): rund 99.441 Kundenprofile
- Zeitraum: September 2016 bis Oktober 2018, mit Schwerpunkt auf 2017 und 2018.

# 🚀 Wichtige Erkenntnisse & Ergebnisse
62 %Umsatz aus Küstenregionen (SP, RJ, MG)	12,5 Tage
Ø Lieferzeit (brasilianischer Standard)	60–80 %
Importzoll auf Elektronik

(LINK folgt)

- Umsatzkonzentration: 62 % des Umsatzes entfallen auf Küstenregionen (São Paulo 38,3 %, Rio de Janeiro 13,4 %, Minas Gerais 11,7 %) – kein nationales Premium-Vertriebsnetz erkennbar.
- Preis-Fehlanpassung: Der durchschnittliche Verkaufspreis technischer Produkte liegt bei 106,25 €; nur 27,3 % der Bestellungen liegen oberhalb dieses Werts – Magist-Käufer kaufen überwiegend günstig, nicht premium.
- Lieferzeit: 12,5 Tage entsprechen brasilianischem, nicht europäischem Servicestandard – Risiko für Reklamationen und Markenreputation.
- Wettbewerb: Amazon Brasilien liefert über Prime in 1–2 Tagen; lokale Apple-Fertigung in Manaus verringert zusätzlich die Importmarge gegenüber importierten Produkten.
- Working Capital: Ratenzahlung (Parcelamento) ist Standard – Kreditkartenvolumen von 10,88 Mio. € pro Jahr, gefolgt von Boleto (2,39 Mio. €) und Debitkarte (0,18 Mio. €), was Liquidität über Monate bindet.
- Externe Risiken: Hohe Frachtdiebstahlraten, überdurchschnittliche Transportversicherungskosten und Importzölle von bis zu 60–80 % auf Elektronik – in der Datenbank nicht abgebildet, aber wirtschaftlich relevant.
- Empfehlung: Magist ist als Vertriebskanal für das Premium-Tech-Portfolio strukturell ungeeignet. Alternative Kanäle wie selektiver Direktvertrieb, ein eigener Online-Shop oder Amazon Brasilien sollten geprüft werden.

# 🛠️ Verwendete Technologien
### Sprache: 			
SQL
### Visualisierung: 	
Tableau
### Sonstige Quellen: 	
WBS Coding School LMS-Unterlagen, Auswärtiges Amt / EDA Reisehinweise (externe Risikobewertung)

# 📁 Projektstruktur
## Projektordner

### Pflichtenheft
- Ausgangssituation & Zielsetzung
- Kernfragen & Businessziele 
- Marktanalyse
- Projektplan
### Auswertungen
- SQL 
- Tableau-Graphiken
### Handlungsempfehlung

# 📈 Visualisierungen
- Marktstruktur und Reichweite 				(LINK folgt)
- Produktfit - Preisniveau & Küferverhalten	(LINK folgt)
- Operatifer Aufwand - Working Capital		(LINK folgt)

# 🔗 Verwendung dieses Projekts
- Hauptnotizbuch ist das Pflichtenheft		(LINK folgt)
## Sehen Sie die vollständige Analyse:ch:
1. Hauptanalyse:
   	Auswertung.sql (LINK folgt)
	Tableau-Auswertung (LINK folgt)
3. Daten:
   Magist-Datenbank (LINK folgt)
5. Code ausführen:
   Notebook in Google Colab oder Jupyter öffnen und alle Zellen ausführen
7. Abhängigkeiten:
   Keine spezielle Einrichtung erforderlich – verwendet Standard-Data-Science-Bibliotheken

# 🚀 Zukünftige Arbeiten - Handlungsempfehlung

- Alternative Distributionskanäle vertieft analysieren: selektiver Direktvertrieb, eigener Online-Shop, Amazon Brasilien im direkten Vergleich
- Kosten-Nutzen-Modell für Zollabwicklung und Versicherung bei alternativen Kanälen entwickeln
- Produktkategorien jenseits des Technik-Segments auf Marktfit prüfen
- A/B-Test-Design für alternative Distributionsstrategien

# 📧 Kontakt
E-Mail: mathias.stumpf@icloud.com
Linkedin-Profil: www.linkedin.com/in/mathias-stumpf-6440823a4
  
