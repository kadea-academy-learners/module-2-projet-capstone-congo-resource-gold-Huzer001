SELECT * FROM engins;

SELECT type, COUNT(id_engin) AS nombre_engins
FROM engins
GROUP BY type;

SELECT * FROM sites;

SELECT * FROM production;

SELECT DISTINCT type_minerai FROM production;

SELECT * FROM exportations;

SELECT s.nom, s.province, p.type_minerai
FROM
	sites s 
	JOIN production p USING (id_site)
ORDER BY s.nom;

--sites par province et type de minerai
SELECT
	s.nom,
	s.province,
	p.type_minerai
FROM
	sites s
	JOIN production p USING(id_site)
GROUP BY
	s.nom,
	s.province,
	p.type_minerai;

-- Mission A : Exploration et Audit (SQL)
-- 1. Inventaire : Compter le nombre d'engins par site.
SELECT s.nom, s.province, COUNT(e.id_engin)
FROM
	sites s
	JOIN engins e USING(id_site)
GROUP BY
	s.nom, s.province;

-- 2. Vérification : Identifier s'il y a des jours où la production a été nulle (Tonnage = 0).
SELECT *
FROM
	production
WHERE
	tonnage_brut = 0;

-- 3. Jointure de contrôle : Afficher la liste des engins avec le nom de leur site respectif (au lieu de l'ID).
SELECT e.type, s.nom, s.province
FROM
	sites s 
	JOIN engins e USING (id_site)
ORDER BY e.type;

-- Mission B : Intelligence Métier et KPIs (SQL Avancé)
-- 1. Production Totale : Somme du tonnage brut par Province et par Type de Minerai.
SELECT
	s.province,
	p.type_minerai,
	SUM(p.tonnage_brut) AS Somme_du_tonnage_brut
FROM
	sites s
	JOIN production p USING(id_site)
GROUP BY
	s.province, p.type_minerai;

-- 2. Calcul du "Contenu Fin" : Le tonnage de métal pur (Tonnage Brut * Teneur %).
SELECT 
    type_minerai,
    ROUND(SUM(tonnage_brut * teneur / 100)::numeric, 2) AS tonnage_metal_pur
FROM 
	production
GROUP BY
    type_minerai;

-- 3. Analyse Financière : Chiffre d'affaires total par site (Tonnage Vendu * Prix Unitaire).
SELECT
	s.nom,
	ROUND(SUM(e.tonnage_vendu * e.prix_unitaire_usd)::numeric) AS CA_par_site
FROM
	sites s
	JOIN exportations e USING(id_site)
GROUP BY
	s.nom
ORDER BY
	CA_par_site DESC;

-- 4. Alerte Teneur : Lister les sites dont la teneur moyenne est inférieure à 2.5% (seuil de rentabilité).
SELECT
    s.nom,
    ROUND(AVG(p.teneur)::numeric, 2) AS teneur_moyenne
FROM
    sites s
    JOIN production p USING(id_site)
GROUP BY
    s.nom
HAVING
    AVG(p.teneur) < 2.5
ORDER BY
	teneur_moyenne;