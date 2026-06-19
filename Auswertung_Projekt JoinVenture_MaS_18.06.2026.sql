USE magist;

SELECT * FROM orders;
-- ow many orders are there in the dataset? 
-- Frage 1: Wie viele Bestellungen enthält der Datensatz?

SELECT 
    COUNT(*) AS Anzahl_Bestellungen
FROM
    orders;
    
-- Are orders actually delivered? Look at the columns in the orders table: one of them is called order_status. Most orders seem to be delivered, but some aren’t. 
-- Find out how many orders are delivered and how many are cancelled, unavailable, or in any other status by grouping and aggregating this column.
-- Frage 2: Werden die Bestellungen tatsächlich zugestellt?

SELECT 
    order_status AS Bestell_Status, COUNT(*) AS Bestellungen
FROM
    orders
GROUP BY order_status;

-- Is Magist having user growth? The orders table contains a row for each order, so this should be easy to find out! 
-- A platform losing users left and right isn’t going to be very useful to us. It would be a good idea to check for the number of orders grouped by year and month. 
-- Tip: you can use the functions YEAR() and MONTH() to separate the year and the month of the order_purchase_timestamp.
-- Frage 3: Verzeichnet Magist ein Nutzerwachstum?

SELECT * FROM orders;

SELECT 
    YEAR(order_purchase_timestamp) AS Jahr_Bestellung,
    MONTH(order_purchase_timestamp) AS Monat,
    COUNT(customer_id) AS Anzahl_Bestellung
FROM
    orders
GROUP BY YEAR(order_purchase_timestamp), MONTH(order_purchase_timestamp)
Order BY YEAR(order_purchase_timestamp);

-- Lösung: 
-- GROUP BY ... WITH ROLLUP: Gruppiert die Daten zuerst nach Jahr und dann nach Monat. 
-- Das Entscheidende hier ist WITH ROLLUP: Diese Funktion fügt automatisch Summenzeilen hinzu 
-- (z. B. die Gesamtsumme für ein ganzes Jahr und die Gesamtsumme über alle Jahre hinweg).

SELECT 
    YEAR(order_purchase_timestamp) `year`,
    MONTH(order_purchase_timestamp) `month`,
    COUNT(*)
FROM
    orders
GROUP BY YEAR
	(order_purchase_timestamp), 
    MONTH(order_purchase_timestamp) 
    WITH ROLLUP
ORDER BY 
	YEAR(order_purchase_timestamp), 
    MONTH(order_purchase_timestamp);
    
 -- by revenue # nach Umsatz
SELECT 
    YEAR(order_purchase_timestamp) `year`,
    MONTH(order_purchase_timestamp) `month`,
    SUM(price)
FROM
    order_items
        JOIN
    orders USING (order_id)
GROUP BY 
	YEAR(order_purchase_timestamp), 
	MONTH(order_purchase_timestamp) 
    WITH ROLLUP
ORDER BY 
	YEAR(order_purchase_timestamp), 
    MONTH(order_purchase_timestamp);
    
-- How many products are there on the products table? (Make sure that there are no duplicate products.)
-- Frage 4 Wie viele Produkte befinden sich auf dem 'produkt table'?

SELECT * FROM products;

SELECT DISTINCT
    product_category_name
FROM
    products;

SELECT
    COUNT(DISTINCT product_id) AS Anzahl_Produkte
FROM
    products;
    
-- Lösung 

SELECT 
    COUNT(*)
FROM
    products;
    
-- Which are the categories with the most products? Since this is an external database and has been partially anonymized, we do not have the names of the products. 
-- But we do know which categories products belong to. This is the closest we can get to knowing what sellers are offering in the Magist marketplace. 
-- By counting the rows in the products table and grouping them by categories, we will know how many products are offered in each category. 
-- This is not the same as how many products are actually sold by category. 
-- To acquire this insight we will have to combine multiple tables together: we’ll do this in the next lesson.
-- Frage 5: Welche Kategorien enthalten die meisten Produkte?

SELECT DISTINCT
    COUNT(product_id) AS Anzahl_Produkte,
    product_category_name AS Kategoriename
FROM
    products
GROUP BY product_category_name
ORDER BY COUNT(product_id) DESC;

-- oder mit Übersetzung

SELECT
    t.product_category_name_english AS product_category_name,
    COUNT(p.product_id) AS product_count
FROM
    products p
    LEFT JOIN product_category_name_translation t ON p.product_category_name = t.product_category_name
GROUP BY
    p.product_category_name,
    t.product_category_name_english
ORDER BY product_count DESC
LIMIT 10;

-- Lösung:
SELECT 
    product_category_name_english, COUNT(*) num_products
FROM
    products
		LEFT JOIN
    product_category_name_translation USING(product_category_name)
GROUP BY product_category_name
ORDER BY COUNT(*) DESC
LIMIT 10;

-- How many of those products were present in actual transactions? The products table is a “reference” of all the available products. 
-- Have all these products been involved in orders? Check out the order_items table to find out!
-- Frage 6: Wie viele dieser Produkte waren in tatsächlichen Transaktionen enthalten?

SELECT * FROM order_items;

SELECT 
    COUNT(DISTINCT (product_id)) AS Produkte,
    COUNT(DISTINCT (order_id)) AS Bestellungen
FROM
    products
        LEFT JOIN
    order_items USING (product_id);
    
-- Lösung    
SELECT 
    COUNT(DISTINCT(product_id)) AS Produkte
FROM
    products
        LEFT JOIN
    order_items USING (product_id);
    
-- What’s the price for the most expensive and cheapest products? 
-- Sometimes, having a broad range of prices is informative. Looking for the maximum and minimum values is also a good way to detect extreme outliers.    
-- Frage 7: Wie hoch sind die Preise für die teuersten und günstigsten Produkte? 
-- Manchmal ist eine breite Preisspanne aufschlussreich. Auch die Suche nach Höchst- und Tiefstwerten ist eine gute Methode, um extreme Ausreißer zu erkennen.

SELECT * FROM order_items;

SELECT 
    MIN(price) AS günstigster_Preis,
    MAX(price) AS höchster_Preis
FROM
    order_items;
  
  -- oder 
  
SELECT 
    product_id, price
FROM
    order_items
WHERE
    price IN(
(SELECT 
	MIN(price)
FROM
	order_items) ,
(SELECT 
	MAX(price)
FROM
order_items));

-- Lösung:
SELECT 
    MAX(price) `most expensive`, MIN(price) cheapest
FROM
    order_items;
    
-- What are the highest and lowest payment values? Some orders contain multiple products. 
-- What’s the highest someone has paid for an order? Look at the order_payments table and try to find it out.
-- Was sind die höchsten und niedrigsten Zahlungsbeträge?
-- Einige Bestellungen enthalten mehrere Produkte.
-- Welchen Höchstbetrag hat jemand für eine Bestellung bezahlt? Sieh dir die Tabelle „order_payments“ an und versuche, dies herauszufinden.

SELECT * FROM order_payments;

SELECT 
    MAX(payment_value) AS höchste_Zahlung,
    MIN(payment_value) AS niedrigste_Zahlung
FROM
    order_payments;

-- höchste Bestellung
SELECT 
    order_id, SUM(payment_value) AS höchste_Bestellung
FROM
    order_payments AS höchste_Bestellung
GROUP BY order_id
ORDER BY SUM(payment_value) DESC
LIMIT 1;

-- niedrigste Bestellung
SELECT 
    order_id, SUM(payment_value) AS höchste_Bestellung
FROM
    order_payments AS höchste_Bestellung
GROUP BY order_id
ORDER BY SUM(payment_value)
LIMIT 4;

-- neuer Lösungsweg den wir noch nicht hatten
WITH order_totals AS (
    SELECT order_id, SUM(payment_value) AS total_order_value
    FROM order_payments
    GROUP BY order_id
    HAVING total_order_value > 1  
)  
SELECT
    MIN(total_order_value) AS lowest_order_value,
    MAX(total_order_value) AS highest_order_value,
    AVG(total_order_value) AS average_order_value
FROM order_totals;

-- Lösung:
SELECT 
    MAX(payment_value) highest, 
    MIN(payment_value) lowest
FROM
    order_payments;
    
-- Geschäftsfragen

-- 2.1 Produktfragen
-- Frage 1: What categories of tech products does Magist have?
-- Welche Kategorien von Technologieprodukten bietet Magist an?
-- e.g.
-- "audio", 
-- "electronics", 
-- "computers_accessories", 
-- "pc_gamer", 
-- "computers", 
-- "tablets_printing_image", 
-- "telephony";

SELECT * FROM order_payments;

SELECT 
    product_category_name, product_category_name_english
FROM
    product_category_name_translation;
    
-- Frage 2: How many products of these tech categories have been sold (within the time window of the database snapshot)? 
-- Wie viele Produkte aus diesen Technologiekategorien wurden verkauft (innerhalb des Zeitraums des Datenbank-Snapshots)?
# wir müssen uns auf einheitliche Kategorien einigen (siehe oben)

SELECT COUNT(DISTINCT product_id) AS Anzahl_Verkaufte_TechProdukte
FROM order_items oi
LEFT JOIN
products p USING (product_id)
LEFT JOIN
product_category_name_translation pt USING (product_category_name)
WHERE product_category_name_english = 'audio'
OR product_category_name_english =  "electronics"
OR product_category_name_english =  "computers_accessories"
OR product_category_name_english =  "pc_gamer"
OR product_category_name_english =  "computers"
OR product_category_name_english =  "tablets_printing_image"
OR product_category_name_english =  "telephony";

-- Lösung:
SELECT COUNT(DISTINCT(oi.product_id)) AS tech_products_sold
FROM order_items oi
LEFT JOIN products p 
	USING (product_id)
LEFT JOIN product_category_name_translation pt
	USING (product_category_name)
WHERE product_category_name_english = "audio"
OR product_category_name_english =  "electronics"
OR product_category_name_english =  "computers_accessories"
OR product_category_name_english =  "pc_gamer"
OR product_category_name_english =  "computers"
OR product_category_name_english =  "tablets_printing_image"
OR product_category_name_english =  "telephony";
	-- 3390
-- Code (COUNT(DISTINCT product_id)): Zählt, wie viele verschiedene Produktarten (Katalogeinträge) mindestens einmal verkauft wurden 
-- (Ergebnis: 3.390 Tech-Produkte von insgesamt 32.951 Produktarten). 
-- ANDERE BETRACHTUNGSWEISE: Die richtige Logik (COUNT(product_id) oder COUNT(*)): Du musst jede einzelne verkaufte Einheit in order_items zählen. 
-- Wenn das "iPhone 13" (eine product_id) 500-mal verkauft wurde, zählt dein Code 1, richtig ist aber 500.  
SELECT COUNT(oi.product_id) AS tech_units_sold
FROM order_items oi
LEFT JOIN products p USING (product_id)
LEFT JOIN product_category_name_translation pt USING (product_category_name)
WHERE pt.product_category_name_english IN (
    'audio', 'electronics', 'computers_accessories', 
    'pc_gamer', 'computers', 'tablets_printing_image', 'telephony'
);
-- 15798

-- zusätzlich Frage 2: What percentage does that represent from the overall number of products sold?   
-- Wie viel Prozent entspricht das der Gesamtzahl der verkauften Produkte?


-- ALLE mit DISTINCT, ohne Filter Tech Kategorie

SELECT COUNT(DISTINCT(product_id)) AS products_sold
FROM order_items;
	-- 32951

-- ohne DISTICT (Gesamtverkäufe) mit Prozent

SELECT 
    -- Tech-Verkäufe
    COUNT(CASE WHEN pt.product_category_name_english IN (
        'audio', 'electronics', 'computers_accessories', 
        'pc_gamer', 'computers', 'tablets_printing_image', 'telephony'
    ) THEN oi.product_id END) AS Anzahl_TechVerkäufe,
    
    -- Gesamt-Verkäufe
    COUNT(oi.product_id) AS Anzahl_Gesamtverläufe,
    
    -- Prozentualer Anteil
    ROUND(
        COUNT(CASE WHEN pt.product_category_name_english IN (
            'audio', 'electronics', 'computers_accessories', 
            'pc_gamer', 'computers', 'tablets_printing_image', 'telephony'
        ) THEN oi.product_id END) * 100.0 / COUNT(oi.product_id), 
    2) AS Prozent_TechVerkäufe

FROM order_items oi
LEFT JOIN products p USING (product_id)
LEFT JOIN product_category_name_translation pt USING (product_category_name);

-- wenn man beides gegenüberstellt

SELECT 
    -- =========================================================================
    -- NACHFRAGE / VERKAUFSZAHLEN (Menge der verkauften Artikel) - OHNE DISTINCT
    -- =========================================================================
    COUNT(CASE WHEN pt.product_category_name_english IN (
        'audio', 'electronics', 'computers_accessories', 
        'pc_gamer', 'computers', 'tablets_printing_image', 'telephony'
    ) THEN oi.product_id END) AS tech_einheiten_verkauft,
    
    COUNT(oi.product_id) AS gesamt_einheiten_verkauft,
    
    ROUND(
        COUNT(CASE WHEN pt.product_category_name_english IN (
            'audio', 'electronics', 'computers_accessories', 
            'pc_gamer', 'computers', 'tablets_printing_image', 'telephony'
        ) THEN oi.product_id END) * 100.0 / COUNT(oi.product_id), 
    2) AS prozent_nachfrage_einheiten,

    -- =========================================================================
    -- SORTIMENT / PRODUKTARTEN (Einzigartige IDs im Katalog) - MIT DISTINCT
    -- =========================================================================
    COUNT(DISTINCT CASE WHEN pt.product_category_name_english IN (
        'audio', 'electronics', 'computers_accessories', 
        'pc_gamer', 'computers', 'tablets_printing_image', 'telephony'
    ) THEN oi.product_id END) AS tech_produktarten_verkauft,
    
    COUNT(DISTINCT oi.product_id) AS gesamt_produktarten_verkauft,
    
    ROUND(
        COUNT(DISTINCT CASE WHEN pt.product_category_name_english IN (
            'audio', 'electronics', 'computers_accessories', 
            'pc_gamer', 'computers', 'tablets_printing_image', 'telephony'
        ) THEN oi.product_id END) * 100.0 / COUNT(DISTINCT oi.product_id), 
    2) AS prozent_sortiment_arten

FROM order_items oi
LEFT JOIN products p USING (product_id)
LEFT JOIN product_category_name_translation pt USING (product_category_name);

-- Lösung
SELECT COUNT(DISTINCT(product_id)) AS products_sold
FROM order_items;
	-- 32951
    
SELECT 3390 / 32951; -- This step can also be done on a calculator
	-- 0.1029, therefore 10%
    
-- Welchen Prozentsatz stellt dies an der Gesamtzahl der verkauften Produkte dar?

SELECT 
    t.product_category_name_english AS Technologie_Kategorie,
    COUNT(*) AS Anzahl_verkauft,
    -- Berechnung des Prozentanteils an den einzelnen Kategorien im Tech dar (war nicht gefragt ist zusätzlich)
    ROUND((COUNT(*) / (SELECT COUNT(*) FROM order_items)) * 100, 2) AS Prozent_an_Gesamtverkaeufe
FROM 
    order_items AS oi
JOIN 
    products AS p 
    ON oi.product_id = p.product_id
JOIN 
    product_category_name_translation AS t 
    ON p.product_category_name = t.product_category_name
WHERE 
    t.product_category_name_english LIKE '%comp%' 
    OR t.product_category_name_english LIKE '%electr%'
    OR t.product_category_name_english LIKE '%teleph%'
    OR t.product_category_name_english LIKE '%audio%'
    OR t.product_category_name_english LIKE '%gamer%'
GROUP BY 
    t.product_category_name_english
ORDER BY 
    Anzahl_verkauft DESC;

-- Frage 3: What’s the average price of the products being sold?    
-- Wie hoch ist der Durchschnittspreis der verkauften Produkte?

SELECT 
    ROUND(AVG(price), 2) AS Durchschnittspreis_aller_Produkte
FROM
    order_items;

-- Lösung: 
SELECT ROUND(AVG(price), 2)
FROM order_items;
	-- 120.65
    
-- Frage 4: Are expensive tech products popular? *
-- Sind teure Technologieprodukte beliebt? *  TIPP: Schauen Sie sich die Funktion CASE WHEN an , um diese Aufgabe zu lösen.
# CASE WHEN anwenden, sortieren nach Preisklassen (z. B. "Günstig", "Mittel", "Teuer"), Danach Produkte pro Klasse zählen
# Die WHERE-Bedingung ist in dieser Abfrage absolut notwendig, weil die Frage explizit nach Technologieprodukten verlangt 
-- („Sind teure Technologieprodukte beliebt?“). sondst werden alle Produkte des gesamten Marktplatzes analysieren
# Fokus Zielgruppe => Datenverfälschung

SELECT 
    CASE
        WHEN oi.price < 100 THEN '1. Günstig (< 100)'
        WHEN oi.price BETWEEN 100 AND 1000 THEN '2. Mittel (100 - 1000)'
        ELSE '3. Teuer (> 1000)'
    END AS Preisklasse,
    COUNT(*) AS Anzahl_verkaufte_TechProdukte,
    ROUND(AVG(oi.price), 2) AS Durchschnittspreis_proKlasse
FROM
    order_items AS oi
        JOIN
    products AS p USING (product_id)
        JOIN
    product_category_name_translation pt USING (product_category_name)
WHERE
    pt.product_category_name_english IN ('audio' , 'electronics',
        'computers_accessories',
        'pc_gamer',
        'computers',
        'tablets_printing_image',
        'telephony')
GROUP BY Preisklasse
ORDER BY Preisklasse;

 -- Lösung
 
SELECT 
    COUNT(oi.product_id),
    CASE
        WHEN price > 1000 THEN 'Expensive'
        WHEN price > 100 THEN 'Mid-range'
        ELSE 'Cheap'
    END AS 'price_range'
FROM
    order_items oi
        LEFT JOIN
    products p ON p.product_id = oi.product_id
        LEFT JOIN
    product_category_name_translation pt USING (product_category_name)
WHERE
    pt.product_category_name_english IN ('audio' , 'electronics',
        'computers_accessories',
        'pc_gamer',
        'computers',
        'tablets_printing_image',
        'telephony')
GROUP BY price_range
ORDER BY 1 DESC;
	-- 11361 cheap
    -- 4263 mid-range
    -- 174 expensive
    
-- 2.2. Verkäufe
-- Frage 1: How many months of data are included in the magist database?
-- Aus wie vielen Monaten stammen die Daten der Magistrate?
# billige produkete sind beliebter ist die Antwort

SELECT COUNT(*) AS Anzahl_Monate_imDatenzeitraum
FROM (
    SELECT 
        YEAR(order_purchase_timestamp) AS Jahr,
        MONTH(order_purchase_timestamp) AS Monat
    FROM orders
    GROUP BY YEAR(order_purchase_timestamp), MONTH(order_purchase_timestamp)
) AS Subquery;

-- Lösung
SELECT 
    TIMESTAMPDIFF(MONTH,
        MIN(order_purchase_timestamp),
        MAX(order_purchase_timestamp))
FROM
    orders;
	-- 25 months

-- Frage 2: How many sellers are there? How many Tech sellers are there? What percentage of overall sellers are Tech sellers?
-- Wie viele Verkäufer gibt es? Wie viele Verkäufer aus dem Technologiebereich gibt es? Welchen Anteil haben Verkäufer aus dem Technologiebereich an allen Verkäufern?
# 3 Kennzahlen aus sellers, order_items, products

SELECT COUNT(seller_id) AS Anzahl_Verkäufer FROM sellers;

-- Lösung
SELECT Stephan soll ich 
    COUNT(DISTINCT seller_id)
FROM
    sellers;
	-- 3095
    
-- zu Frage 2: Hier zählen wir die Verkäufer, die mindestens ein Produkt aus den zuvor definierten Technologie-Kategorien verkauft haben.

SELECT COUNT(DISTINCT oi.seller_id) AS Anzahl_Tech_Verkaeufer
FROM order_items AS oi
JOIN products AS p 
    USING(product_id)
JOIN product_category_name_translation pt 
    USING(product_category_name)
WHERE
    pt.product_category_name_english IN ('audio' , 'electronics',
        'computers_accessories',
        'pc_gamer',
        'computers',
        'tablets_printing_image',
        'telephony');
-- Lösung
SELECT 
    COUNT(DISTINCT seller_id)
FROM
    sellers
        LEFT JOIN
    order_items USING (seller_id)
        LEFT JOIN
    products p USING (product_id)
        LEFT JOIN
    product_category_name_translation pt USING (product_category_name)
WHERE
    pt.product_category_name_english IN ('audio' , 'electronics',
        'computers_accessories',
        'pc_gamer',
        'computers',
        'tablets_printing_image',
        'telephony');
	-- 454
    
-- zu Frage 2: Anteil Prozentual an allen Verkäufen 
# Der WHERE-Filter: Reduziert die Datenmenge sofort auf Verkäufe aus dem Technologiebereich.
#  COUNT(DISTINCT oi.seller_id): Zählt im SELECT-Teil nur noch, wie viele einzigartige Verkäufer in diesen gefilterten Tech-Daten vorkommen.
# (SELECT COUNT(*) FROM sellers): Holt die Gesamtzahl aller registrierten Verkäufer direkt aus der sellers-Stammdatentabelle für die Prozentrechnung (Basiswert für 100 %).

SELECT 
    -- Anzahl der Tech-Verkäufer dividiert durch Gesamtanzahl aller Verkäufer
    ROUND((COUNT(DISTINCT oi.seller_id) / (SELECT COUNT(*) FROM sellers)) * 100, 2) AS Prozent_Tech_Verkaeufer
FROM 
    order_items AS oi
JOIN 
    products AS p 
    USING(product_id)
JOIN 
    product_category_name_translation pt 
    USING(product_category_name)
WHERE
    pt.product_category_name_english IN ('audio' , 'electronics',
        'computers_accessories',
        'pc_gamer',
        'computers',
        'tablets_printing_image',
        'telephony');
    
 -- Lösung
 SELECT (454 / 3095) * 100;
	-- 14.67%
    
-- Frage 3: What is the total amount earned by all sellers? What is the total amount earned by all Tech sellers?    
-- Wie hoch ist der Gesamtverdienst aller Verkäufer? Wie hoch ist der Gesamtverdienst aller Tech-Verkäufer?
# Um den Gesamtverdienst (Umsatz) zu berechnen, nutzen wir die Summe der Produktpreise (SUM(price)) aus der Tabelle order_items. 
# Die Frachtkosten (freight_value) werden beim reinen Produktverdienst der Verkäufer in der Regel weggelassen, da sie für den Versand aufgewendet werden.

# Gesamtverdienst* Verkäufer
SELECT 
    ROUND(SUM(price), 2) AS Gesamtverdienst_alle_Verkaeufer
FROM 
    order_items;
    
 -- Lösung:
SELECT 
    SUM(oi.price) AS total
FROM
    order_items oi
        LEFT JOIN
    orders o USING (order_id)
WHERE
    o.order_status NOT IN ('unavailable' , 'canceled');
    -- 13494400.74
    
 # Gesamtverdienst*TechVerkäufer
 # Verknüpfen der Verkäufe mit den Produkten, um den Verdienst exakt auf Tech-Kategorien zu filtern
    
SELECT 
    ROUND(SUM(oi.price), 2) AS Gesamtverdienst_Tech_Verkaeufer
FROM 
    order_items AS oi
JOIN 
    products AS p 
    USING(product_id)
JOIN 
    product_category_name_translation pt 
    USING(product_category_name)
WHERE
    pt.product_category_name_english IN ('audio' , 'electronics',
        'computers_accessories',
        'pc_gamer',
        'computers',
        'tablets_printing_image',
        'telephony');
        
-- Frage 4 Can you work out the average monthly income of all sellers? Can you work out the average monthly income of Tech sellers?
-- Können Sie das durchschnittliche monatliche Einkommen aller Verkäufer ermitteln? 
-- Können Sie das durchschnittliche monatliche Einkommen der Verkäufer im Technologiebereich ermitteln?

-- Lösung
SELECT 13494400.74/ 3095 / 25;
	-- 174.40
    
 # Werte gegenübergestellt
 # Wir nutzen dafür die Technik der bedingten Aggregation (SUM(CASE WHEN...)). 
 # Dabei durchläuft SQL alle Verkäufe und addiert den Preis nur dann für den Tech-Verdienst auf, wenn die Kategorie passt. 
 # Der Gesamtverdienst wird einfach parallel für alle Zeilen aufsummiert.
 
 SELECT 
    -- 1. Gesamtverdienst aller Produkte auf dem Marktplatz
    ROUND(SUM(oi.price), 2) AS Gesamtverdienst_Alle,

    -- 2. Gesamtverdienst gefiltert nur auf die Tech-Kategorien
    ROUND(SUM(CASE WHEN
    t.product_category_name_english IN ('audio' , 'electronics',
        'computers_accessories',
        'pc_gamer',
        'computers',
        'tablets_printing_image',
        'telephony')
    THEN oi.price ELSE 0 END), 2) AS Gesamtverdienst_Tech,

    -- 3. Prozentualer Anteil des Tech-Verdienstes am Gesamtumsatz
    ROUND((SUM(CASE WHEN 
         t.product_category_name_english IN ('audio' , 'electronics',
        'computers_accessories',
        'pc_gamer',
        'computers',
        'tablets_printing_image',
        'telephony')
    THEN oi.price ELSE 0 END) / SUM(oi.price)) * 100, 2) AS Prozent_Anteil_Tech
FROM 
    order_items AS oi
JOIN 
    products p 
    USING(product_id)
JOIN 
    product_category_name_translation t 
    USING(product_category_name);
    
-- Frage 4: Can you work out the average monthly income of all sellers? Can you work out the average monthly income of Tech sellers?    
-- Können Sie das durchschnittliche monatliche Einkommen aller Verkäufer berechnen? Können Sie das durchschnittliche monatliche Einkommen von Verkäufern im Technologiebereich berechnen?
# Gesamtumsatz durch die Anzahl der Verkäufer und durch die Anzahl der Monate im gesamten Datensatz teilen.
# Aus der allerersten Abfrage wissen wir bereits exakt, dass der Datenbank-Snapshot 25 Monate umfasst. 
# Wir können diese Zahl daher direkt als feste Basis in die Berechnung einbeziehen.

# monatl. Einkommen ALLER Verkäufer => (Gesamtumsatz/ Gesamtanzahl aller Verkäufe)

SELECT 
    ROUND(SUM(oi.price) / ((SELECT COUNT(*) FROM sellers) * 25), 2) AS Avg_Monatseinkommen_Alle_Verkaeufer
FROM
    order_items AS oi;
SELECT 
    -- 1. DURCHSCHNITT ALLER VERKÄUFER
    ROUND(
        SUM(oi.price) / (COUNT(DISTINCT oi.seller_id) * 25), 
        2
    ) AS avg_monthly_income_all_sellers,

    -- 2. DURCHSCHNITT DER TECH-VERKÄUFER
    ROUND(
        SUM(CASE WHEN pt.product_category_name_english IN (
            'audio', 'electronics', 'computers_accessories', 
            'pc_gamer', 'computers', 'tablets_printing_image', 'telephony'
        ) THEN oi.price END) 
        / 
        (COUNT(DISTINCT CASE WHEN pt.product_category_name_english IN (
            'audio', 'electronics', 'computers_accessories', 
            'pc_gamer', 'computers', 'tablets_printing_image', 'telephony'
        ) THEN oi.seller_id END) * 25), 
        2
    ) AS avg_monthly_income_tech_sellers

FROM order_items oi
LEFT JOIN products p USING (product_id)
LEFT JOIN product_category_name_translation pt USING (product_category_name);
-- 175,66 Einkommen weil COUNT(DISTINCT oi.seller_id) zählt nur die 2.985 aktiven Verkäufer, die im Snapshot-Zeitraum auch wirklich mindestens ein Produkt verkauft haben. 
-- Die Tabelle sellers enthält jedoch 3.095 registrierte Verkäufer (inklusive 110 "Karteileichen", die nie etwas verkauft haben). 
-- Da der Umsatz hier durch weniger Verkäufer geteilt wird, steigt das durchschnittliche Einkommen pro aktivem Verkäufer auf 182,13 €. 

-- Lösung
SELECT 13494400.74/ 3095 / 25;
	-- 174.40    
    
# monatl. Einkommen von TechVerküfern
# COUNT(DISTINCT oi.seller_id): Stellt in der zweiten Abfrage sicher, dass der Tech-Umsatz nur durch die Anzahl der Verkäufer geteilt wird, 
# die tatsächlich in dieser Branche aktiv sind.Die Zahl 25: Repräsentiert die 25 Monatszeilen aus Ihrer ersten Analyse. 
# Ohne diesen Teiler würden man den Durchschnitt für den gesamten Zeitraum (ca. 2 Jahre) statt pro Monat erhalten.
# Das Ergebnis ist sehr niedrig. Warum?
# Die „Karteileichen. Der Datensatz enthält über 3.000 registrierte Verkäufer (sellers). 
# Ein riesiger Teil davon hat im gesamten Zeitraum von zwei Jahren nur ein einziges Produkt für z. B. 20 € verkauft oder ist komplett inaktiv.
# Der Verwässerungseffekt: Wenn Sie den Gesamtumsatz durch alle jemals registrierten Verkäufer teilen, ziehen diese inaktiven Händler den Durchschnitt massiv in den Keller.

SELECT 
    -- Tech-Einnahmen dividiert durch (Anzahl der Tech-Verkäufer * 25 Monate)
    ROUND(
        SUM(oi.price) / (COUNT(DISTINCT oi.seller_id) * 25), 2
    ) AS Avg_Monatseinkommen_Tech_Verkaeufer
FROM 
    order_items AS oi
JOIN 
    products p 
    USING(product_id)
JOIN 
    product_category_name_translation t 
    USING(product_category_name)
WHERE
    t.product_category_name_english IN ('audio' , 'electronics',
        'computers_accessories',
        'pc_gamer',
        'computers',
        'tablets_printing_image',
        'telephony');
    
-- Lösung
    SELECT 1666211.28 / 454 / 25;
	-- 146.80    
    
-- 2.3. Lieferzeit
-- Frage 1: What’s the average time between the order being placed and the product being delivered?
-- Wie lange dauert es im Durchschnitt von der Bestellung bis zur Lieferung des Produkts?

SELECT * FROM orders;

-- Lieferzeit pro Bestellung
SELECT order_id, DATEDIFF(order_delivered_customer_date, order_purchase_timestamp) AS Lieferzeit_in_Tagen
FROM orders
WHERE order_status = 'delivered';

-- Durchschnittliche Lieferzeit
-- Berechnet den Durchschnitt der Zeitdifferenz in Tagen
SELECT 
    AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)) AS Durchschnittliche_Lieferzeit_Tage
FROM 
    orders
WHERE 
    order_status = 'delivered'
    AND order_delivered_customer_date IS NOT NULL;

-- Lösung:
SELECT AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp))
FROM orders;
	-- 12.5035
    
-- Frage 2: How many orders are delivered on time vs orders delivered with a delay?
-- Wie viele Bestellungen werden pünktlich geliefert im Vergleich zu Bestellungen mit Verspätung?
# das tatsächliche Lieferdatum (order_delivered_customer_date) mit dem prognostizierten Lieferdatum (order_estimated_delivery_date) vergleichen.
# Mithilfe eines CASE WHEN-Konstrukts => die Bestellungen in „Pünktlich“ und „Verspätet“ einteilen und diese Gruppen direkt gegenüberstellen.
# CASE WHEN order_delivered_customer_date <= order_estimated_delivery_date: 
# Wenn das echte Lieferdatum vor oder exakt am geschätzten Datum lag, gilt die Bestellung als pünktlich.
# COUNT(*): Zählt, wie viele Bestellungen in die jeweilige Kategorie fallen.
# Prozent_Anteil: Berechnet im selben Schritt, wie viel Prozent der erfolgreich zugestellten Bestellungen pünktlich oder verspätet waren.
# WHERE-Block: Sortiert auch hier unzustellbare oder stornierte Bestellungen aus, da für diese kein realer Liefervergleich möglich ist.

SELECT 
    CASE 
        WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN 'Pünktlich / Zu früh'
        ELSE 'Verspätet'
    END AS Lieferstatus,
    COUNT(*) AS Anzahl_Bestellungen,
    ROUND((COUNT(DISTINCT order_id) / (SELECT COUNT(*) FROM orders WHERE order_status = 'delivered' AND order_delivered_customer_date IS NOT NULL)) * 100, 2) AS Prozent_Anteil
FROM 
    orders
WHERE 
    order_status = 'delivered'
    AND order_delivered_customer_date IS NOT NULL
GROUP BY 
    Lieferstatus;
 
 -- Lösung:
 SELECT 
    CASE 
        WHEN DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) > 0 THEN 'Delayed' 
        ELSE 'On time'
    END AS delivery_status, 
    COUNT(DISTINCT order_id) AS orders_count
FROM orders 
WHERE order_status = 'delivered'
    AND order_estimated_delivery_date IS NOT NULL
    AND order_delivered_customer_date IS NOT NULL
GROUP BY delivery_status;
	-- on time 89805
    -- delayed 6665
    
-- Frage 3: Is there any pattern for delayed orders, e.g. big products being delayed more often?    
-- Gibt es ein Muster bei den Lieferverzögerungen, z. B. werden große Produkte häufiger verspätet geliefert?
# Aufteilen der verkauften => Durchschnittliche Lieferzeit, Prozentsatz der verspäteten Bestellungen
  
#  Schwere und sperrige Produkte führen statistisch zu signifikant höheren Lieferverzögerungen, 
# da sie nicht über Standard-Sortieranlagen laufen und im brasilianischen Postsystem gesonderte Transportwege beanspruchen
# durchschnittliche Lieferzeit steigt mit der höheren Gewichtsklasse
# Die Fehlerquote bei sperrigen Produkten > 15 kg deutlich höher
# Wertvolle Business-Insight: Für Magist bedeutet das: Wenn ein High-Tech-Sellers (wie z. B. große Server-Schränke, schwere USV-Anlagen oder Gaming-Tische) angebunden werden soll, 
# drohen unzufriedene Kunden wegen Lieferverzögerungen.

SELECT 
    CASE 
        WHEN p.product_weight_g <= 1000 THEN '1. Leicht (bis 1 kg)'
        WHEN p.product_weight_g BETWEEN 1001 AND 5000 THEN '2. Mittelschwer (1 - 5 kg)'
        WHEN p.product_weight_g BETWEEN 5001 AND 15000 THEN '3. Schwer (5 - 15 kg)'
        ELSE '4. Sehr schwer / Sperrig (> 15 kg)'
    END AS Gewichtsklasse,
    
    -- Gesamtanzahl der gelieferten Artikel in dieser Klasse
    COUNT(*) AS Anzahl_Bestellungen,
    
    -- Durchschnittliche Lieferzeit in Tagen
    ROUND(AVG(TIMESTAMPDIFF(SECOND, o.order_purchase_timestamp, o.order_delivered_customer_date)) / 86400, 1) AS Avg_Lieferzeit_Tage,
    
    -- Anteil der Bestellungen, die nach dem prognostizierten Datum ankamen
    ROUND(
        (SUM(CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 1 ELSE 0 END) / COUNT(*)) * 100, 
        2
    ) AS Prozent_Verspätet
FROM 
    order_items AS oi
JOIN 
    orders AS o ON oi.order_id = o.order_id
JOIN 
    products AS p ON oi.product_id = p.product_id
WHERE 
    o.order_status = 'delivered'
    AND o.order_delivered_customer_date IS NOT NULL
    AND p.product_weight_g IS NOT NULL
GROUP BY 
    Gewichtsklasse
ORDER BY 
    Gewichtsklasse;
    
-- zusätzliche Fragen, welche ich mir gestellt habe:
-- Wieviele Produkte werden als High-End, mittel und low eingestuft?
# Es gibt zwar vereinzelte teure Spitzenreiter (z. B. bei computers), aber der Großteil der Verkäufe bei Olist/Magist spielt sich im Niedrigpreis-Segment ab.
# Echte High-End-Unternehmenshardware wird auf diesem Marktplatz kaum bis gar nicht gehandelt.

SELECT 
    t.product_category_name_english AS Tech_Kategorie,
    COUNT(oi.product_id) AS Anzahl_Verkaeufe,
    ROUND(MIN(oi.price), 2) AS Mindestpreis,
    ROUND(MAX(oi.price), 2) AS Hoechstpreis,
    ROUND(AVG(oi.price), 2) AS Durchschnittspreis
FROM 
    order_items AS oi
JOIN 
    products AS p ON oi.product_id = p.product_id
JOIN 
    product_category_name_translation AS t ON p.product_category_name = t.product_category_name
WHERE 
    (t.product_category_name_english LIKE '%comp%' 
    OR t.product_category_name_english LIKE '%electr%'
    OR t.product_category_name_english LIKE '%teleph%'
    OR t.product_category_name_english LIKE '%audio%'
    OR t.product_category_name_english LIKE '%gamer%')
GROUP BY 
    t.product_category_name_english
ORDER BY 
    Hoechstpreis DESC;
-- Lösung: 
SELECT
    CASE 
        WHEN DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) >= 100 THEN "> 100 day Delay"
        WHEN DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) >= 7 AND DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) < 100 THEN "1 week to 100 day delay"
        WHEN DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) > 3 AND DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) < 7 THEN "4-7 day delay"
        WHEN DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) >= 1  AND DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) <= 3 THEN "1-3 day delay"
        WHEN DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) > 0  AND DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) < 1 THEN "less than 1 day delay"
        WHEN DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) <= 0 THEN 'On time' 
    END AS "delay_range", 
    AVG(product_weight_g) AS weight_avg,
    MAX(product_weight_g) AS max_weight,
    MIN(product_weight_g) AS min_weight,
    SUM(product_weight_g) AS sum_weight,
    COUNT(DISTINCT a.order_id) AS orders_count
FROM orders a
LEFT JOIN order_items b
    USING (order_id)
LEFT JOIN products c
    USING (product_id)
WHERE order_estimated_delivery_date IS NOT NULL
AND order_delivered_customer_date IS NOT NULL
AND order_status = 'delivered'
GROUP BY delay_range;

-- Wo Kommen die Käufer und Verkäufer her?
-- Geo-Analyse. Wie hoch ist der Revenuumsatz im Allgemeinen und wie hoch explizit im High-End Bereich (Brasilie, State, City)?
-- Benchmarketing: Vergleiche der Mitbewerber (Lieferzeit, Verkäufe, spezialisierung High-End, NPS-Score bezüglich Vergleich personalisierter Support=> Firmenstrategie und Kernkompetenz)
-- Marktpotenzial: Spanien (47 Mio)/ Brasilie (203 Mio), wachsende junge Bevölkerung

-- Präsentationsfrage:
-- Ist Magist eine gute Wahl für High-End-Technologieprodukte?
-- Werden die Bestellungen pünktlich geliefert?
-- Begründung