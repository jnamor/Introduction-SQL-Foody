CREATE DATABASE Foody ;
USE Foody ;

CREATE TABLE Client
(
CodeCli CHAR(10) PRIMARY KEY,
Societe CHAR(40),
Contact CHAR(30),
Fonction CHAR(30),
Adresse CHAR(50),
Ville CHAR(20),
Region CHAR(30),
CodePostal CHAR(10),
Pays CHAR(15),
Tel CHAR(20),
Fax CHAR(20)
);

CREATE TABLE Commande
(
NoCom CHAR(10) PRIMARY KEY,
CodeCli CHAR(5),
NoEmp CHAR(10),
NoMess CHAR(10),
DateCom CHAR(10),
ALivAvant CHAR(10),
DateEnv CHAR(10),
Port CHAR(10),
Destinataire CHAR(40),
AdrLiv CHAR(50),
VilleLiv CHAR(15),
RegionLiv CHAR(15),
CodePostalLiv CHAR(10),
PaysLiv CHAR(15),
FOREIGN KEY(CodeCli) REFERENCES Client(CodeCli),
FOREIGN KEY(NoEmp) REFERENCES Employe(NoEmp),
FOREIGN KEY(NoMess) REFERENCES Messager(NoMess)
);

CREATE TABLE DetailCommande
(
Nocom CHAR(10),
Refprod CHAR(10),
PrixUnit CHAR(10),
Qte CHAR(3),
Remise FLOAT,
PRIMARY KEY (Nocom, Refprod),
FOREIGN KEY(Nocom) REFERENCES Commande(Nocom),
FOREIGN KEY(Refprod) REFERENCES Produit(Refprod)

);

CREATE TABLE Messager
(
NoMess CHAR(10) PRIMARY KEY,
NomMess CHAR(20),
Tel CHAR(20)
);

CREATE TABLE Employe
(
NoEmp CHAR(10) PRIMARY KEY,
Nom CHAR(10),
Prenom CHAR(10),
Fonction CHAR(30),
TitreCortoisie CHAR(5),
DateNaissance date,
DateEmbauche date,
Adresse CHAR(30),
Ville CHAR(10),
Region CHAR(2),
CodePostal CHAR(7),
Pays CHAR(3),
TelDom CHAR(14),
Extension CHAR(4),
RendComptA CHAR(1),
FOREIGN KEY(RendComptA) REFERENCES Employe_1(NoEmp)
);

ALTER TABLE Employe MODIFY RendComptA CHAR(10) ;
ALTER TABLE Employe ADD FOREIGN KEY(RendComptA) REFERENCES Employe_1(NoEmp) ;
SET FOREIGN_KEY_CHECKS=0;
SET GLOBAL FOREIGN_KEY_CHECKS=0;
DESCRIBE Employe ;

CREATE TABLE Employe_1
(
NoEmp CHAR(10) PRIMARY KEY,
Nom TEXT,
Prenom TEXT,
Fonction TEXT,
TitreCortoisie TEXT,
DateNaissance date,
DateEmbauche date,
Adresse TEXT,
Ville TEXT,
Region TEXT,
CodePostal TEXT,
Pays TEXT,
TelDom TEXT,
Extension TEXT,
RendComptA FLOAT
);

CREATE TABLE Produit
(
Refprod CHAR(10) PRIMARY KEY,
Nomprod TEXT,
NoFour CHAR(10),
CodeCateg CHAR(10),
QteParUnit CHAR(20),
PrixUnit CHAR(8),
UnitesStock CHAR(3),
UnitesCom CHAR(3),
NiveauResp CHAR(2),
Indisponible CHAR(1),
FOREIGN KEY(NoFour) REFERENCES Fournisseur(NoFour),
FOREIGN KEY(CodeCateg) REFERENCES Catégorie(CodeCateg)
);

CREATE TABLE Fournisseur
(
NoFour CHAR(10) PRIMARY KEY,
Societe CHAR(40) NOT NULL,
Contact CHAR(28),
Fonction CHAR(28),
Adresse CHAR(45),
Ville CHAR(13),
Region CHAR(8),
CodePostal CHAR(8),
Pays CHAR(11),
Tel CHAR(15),
Fax CHAR(15),
PageAccueil CHAR(100)
);

CREATE TABLE Catégorie
(
CodeCateg CHAR(10) PRIMARY KEY,
NomCateg CHAR(14),
Descriptionn CHAR(58)
);

# Modifier
SELECT MAX(LENGTH(NomCateg)) FROM Catégorie ;
ALTER TABLE Catégorie MODIFY NomCateg CHAR(14) ;
DESCRIBE Catégorie ;


# Importer les données
SET global local_infile=true;
SHOW GLOBAL VARIABLES LIKE 'local_infile';
LOAD DATA LOCAL INFILE 'C:\Users\jorda\Dropbox\Simplon\Programmation\SQL\Projet Foody\data\categorie'
INTO TABLE Catégorie FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;


#Exercices 1 :
#1 - Lister le contenu de la table Produit
SELECT * FROM Produit ;

#2 - N'afficher que les 10 premiers produits
SELECT * FROM Produit LIMIT 10 ;

#3 - Trier tous les produits par leur prix unitaire
SELECT * FROM Produit ORDER BY PrixUnit ;

#4 - Lister les trois produits les plus chers
SELECT * FROM Produit ORDER BY PrixUnit DESC LIMIT 3 ;


#Exercices 2 :
#1 - Lister les clients français installés à Paris
SELECT Societe, Ville FROM Client WHERE Ville = 'Paris' ;

#2 - Lister les clients français, allemands et canadiens
SELECT Societe, Pays FROM Client WHERE Pays IN ('France', 'Germany', 'Canada') ;

#3 - Lister les clients dont le numéro de fax n'est pas renseigné
SELECT Societe, Fax FROM Client WHERE Fax IS NULL ;

#4 - Lister les clients dont le nom contient "restaurant" (nom présent dans la colonne Societe/CompanyName)
SELECT Societe FROM Client WHERE Societe LIKE '%Restaurant%' ;


# Exercices 3 - Projection :
# 1.Lister uniquement la description des catégories de produits (table Categorie)
SELECT Descriptionn FROM Catégorie ;

# 2.Lister les différents pays des clients
SELECT Societe, Pays FROM Client ;

# 3.Idem en ajoutant les villes, le tout trié par ordre alphabétique du pays et de la ville
SELECT Societe, Pays, Ville FROM Client WHERE Pays IS NOT NULL ORDER BY Pays AND Ville asc ;

# 4.Lister tous les produits vendus en bouteilles (bottle) ou en canettes(can)
SELECT Nomprod, QteParUnit FROM Produit WHERE QteParUnit LIKE '%bottle%' OR QteParUnit LIKE '%can%';

# 5.Lister les fournisseurs français, en affichant uniquement le nom, le contact et la ville, triés par ville
SELECT Societe, Contact, Ville  FROM Fournisseur WHERE Pays = "France" ORDER BY Ville ;

# 6.Lister les produits (nom en majuscule et référence) du fournisseur n° 8
# dont le prix unitaire est entre 10 et 100 euros, en renommant les attributs pour que ça soit explicite
SELECT UPPER(NomProd) AS "Produit du fournisseur n°8", RefProd AS "Référence" FROM Produit WHERE NoFour = 8 AND PrixUnit BETWEEN 10 AND 100;

# 7.Lister les numéros d'employés ayant réalisé une commande (cf table Commande) à livrer en France, à Lille, Lyon ou Nantes
SELECT DISTINCT NoEmp, VilleLiv FROM Commande WHERE VilleLiv  IN ('Lille','Lyon', 'Nantes') ORDER BY NoEmp ;

# 8.Lister les produits dont le nom contient le terme "tofu" ou le terme "choco",
# dont le prix est inférieur à 100 euros (attention à la condition à écrire)
SELECT NomProd AS Produit, ROUND(PrixUnit, 1) AS PrixUnit FROM Produit WHERE (NomProd LIKE '%tofu%' OR NomProd LIKE '%choco%') AND PrixUnit < 100 ;


# Exercices 4 :
# La table DetailsCommande contient l'ensemble des lignes d'achat de chaque commande.
# Calculer, pour la commande numéro 10251, pour chaque produit acheté dans celle-ci, le montant de la ligne d'achat en incluant la remise (stockée en proportion dans la table).
#Afficher donc (dans une même requête) :
#- le prix unitaire,
#- la remise,
#- la quantité,
#- le montant de la remise,
#- le montant à payer pour ce produit

SELECT PrixUnit, Qte, ROUND(Remise*100) AS Remise, ROUND((PrixUnit*Remise)) AS "Montant de la remise", ROUND((PrixUnit-(PrixUnit*Remise))*Qte) AS "Montant total à payer" FROM DetailCommande WHERE NoCom = 10251 ;


# Exercices 5 :
#1 - A partir de la table Produit, afficher "Produit non disponible" lorsque l'attribut Indisponible vaut 1, et "Produit disponible" sinon.
SELECT Nomprod, Indisponible,
CASE
	WHEN Indisponible=1 THEN 'Produit non disponible'
    WHEN Indisponible=0 THEN 'Produit disponible' 
END AS Disponibilité
FROM Produit ;

#2 - Dans la table DetailsCommande, indiquer les infos suivantes en fonction de la remise
#- si elle vaut 0 : "aucune remise"
#- si elle vaut entre 1 et 5% (inclus) : "petite remise"
#- si elle vaut entre 6 et 15% (inclus) : "remise modérée"
#- sinon :"remise importante"
SELECT Remise,
CASE
	WHEN DetailCommande.Remise=0 THEN 'Aucune remise'
    WHEN DetailCommande.Remise BETWEEN 0.01 and 0.05 THEN 'Petite remise'
    WHEN DetailCommande.Remise BETWEEN 0.06 and 0.15 THEN 'Remise modérée'
    ELSE "Remise importante"
END AS Remise
FROM DetailCommande ;

#3 - Indiquer pour les commandes envoyées si elles ont été envoyées en retard (date d'envoi DateEnv supérieure (ou égale) à la date butoir ALivAvant) ou à temps
SELECT NoCom, ALivAvant, DateEnv,
CASE
	WHEN ALivAvant >= DateEnv THEN "A l'heure"
    ELSE "En Retard"
END AS "Etat de la Commande"
FROM Commande ;


# Exercices 6 :
# Dans une même requête, sur la table Client :
# * Concaténer les champs Adresse, Ville, CodePostal et Pays dans un nouveau champ nommé Adresse_complète, pour avoir : Adresse, CodePostal, Ville, Pays
# * Extraire les deux derniers caractères des codes clients
# * Mettre en minuscule le nom des sociétés
# * Remplacer le terme "Owner" par "Freelance" dans Fonction
# * Indiquer la présence du terme "Manager" dans Fonction
SELECT CONCAT((Adresse), ", ",(CodePostal), ", " ,(Ville), ", in " , (Pays)) as Adresse, RIGHT(CodeCli,2) AS "Derniers caractères", lower(Societe) AS Societe,
REPLACE (Fonction, "Owner", "Freelance") as Fonction,
CASE
	WHEN Fonction LIKE '%Manager%' THEN "Poste de Manager"
    ELSE " "
END AS Présence
FROM Client ;


# Exercices 7 :
# 1 - Afficher le jour de la semaine en lettre pour toutes les dates de commande, afficher "week-end" pour les samedi et dimanche,
SELECT NoCom, DateCom,
CASE
	WHEN DAYOFWEEK(DateCom) = 2 THEN "Lundi"
    WHEN DAYOFWEEK(DateCom) = 3 THEN "Mardi"
    WHEN DAYOFWEEK(DateCom) = 4 THEN "Mercredi"
    WHEN DAYOFWEEK(DateCom) = 5 THEN "Jeudi"
    WHEN DAYOFWEEK(DateCom) = 6 THEN "Vendredi"
    ELSE "Week-end"
END AS Jour
FROM Commande ;

# 2.Calculer le nombre de jours entre la date de la commande (DateCom) et la date butoir de livraison (ALivAvant), pour chaque commande
SELECT NoCom, DateCom, AlivAvant, CONCAT(DATEDIFF(AlivAvant, DateCom), " Jours") AS Intervalle FROM Commande ;

# On souhaite aussi contacter les clients 1 mois après leur commande. ajouter la date correspondante pour chaque commande
SELECT NoCom, DateCom, DateEnv, CONCAT(DATEDIFF(DateEnv, DateCom), " " , "Jours") AS Intervalle,
CASE
	WHEN DATEDIFF(DateEnv, DateCom) > 30 THEN "À CONTACTER !"
    ELSE " "
END AS "Service Client"
FROM Commande ;


# Exercices 8 :
# 1 - Calculer le nombre d'employés qui sont "Sales Manager"
SELECT Fonction, COUNT(*) AS Nombre FROM Employe WHERE Fonction = "Sales Manager" ;

# 2 - Calculer le nombre de produits de moins de 50 euros
SELECT COUNT(*) AS Nombre FROM Produit WHERE PrixUnit < 50 ;

# 3 - Calculer le nombre de produits de catégorie 2 et avec plus de 10 unités en stocks
SELECT COUNT(*) AS Nombre FROM Produit WHERE CodeCateg = 2 AND UnitesStock >= 10 ; #SELECT * FROM Produit WHERE CodeCateg = 2 AND UnitesStock > 10 ;

# 4 - Calculer le nombre de produits de catégorie 1, des fournisseurs 1 et 18
SELECT COUNT(*) AS Nombre FROM Produit WHERE CodeCateg = 1 AND NoFour IN (1,18) ;

# 5 - Calculer le nombre de pays différents de livraison
SELECT COUNT(DISTINCT PaysLiv) AS Pays FROM Commande ;

# 6 - Calculer le nombre de commandes réalisées le Aout 2006
SELECT COUNT(*) AS Nombre FROM Commande WHERE MONTH(DateCom) = 8 AND YEAR(DateCom) = 2006 ;


# Exercices 9 :
# 1.Calculer le coût du port minimum et maximum des commandes , ainsi que le coût moyen du port pour les commandes du client dont le code est "QUICK" (attribut CodeCli)
SELECT ROUND(MIN(Port), 2) AS Min, ROUND(MAX(Port), 2) AS Max, ROUND(AVG(Port), 2) AS Moy FROM Commande WHERE CodeCli = "QUICK" ;

# 2.Pour chaque messager (par leur numéro : 1, 2 et 3), donner le montant total des frais de port leur correspondant
SELECT NoMess, ROUND(SUM(PORT), 2) AS "Frais de Port Total" FROM Commande GROUP BY NoMess ;


# Exercices 10 :
# 1 - Donner le nombre d'employés par fonction
SELECT Fonction, COUNT(*) AS NbEmployes FROM Employe GROUP BY Fonction ;

# 2 - Donner le montant moyen du port par messager(shipper)
SELECT NoMess, ROUND(AVG(Port), 2) AS "Montant Moyen" FROM Commande GROUP BY NoMess ;

# 3 - Donner le nombre de catégories de produits fournis par chaque fournisseur
SELECT NoFour, COUNT(DISTINCT CodeCateg) AS NbCategories FROM Produit GROUP BY NoFour;

# 4 - Donner le prix moyen des produits pour chaque fournisseur et chaque catégorie de produits fournis par celui-ci
SELECT NoFour, ROUND(AVG(PrixUnit), 2) AS "Prix Moyen", CodeCateg FROM Produit GROUP BY NoFour ;


# Exercices 11 :
# 1 - Lister les fournisseurs ne fournissant qu'un seul produit
SELECT NoFour FROM Produit GROUP BY NoFour HAVING COUNT(*) = 1 ;

# 2 - Lister les catégories dont les prix sont en moyenne supérieurs strictement à 50 euros
SELECT CodeCateg FROM Produit GROUP BY CodeCateg HAVING AVG(PrixUnit) > 50 ;

# 3 - Lister les fournisseurs ne fournissant qu'une seule catégorie de produits
SELECT NoFour FROM Produit GROUP BY NoFour HAVING COUNT(DISTINCT CodeCateg) = 1 ;

# 4 - Lister le Products le plus cher pour chaque fournisseur, pour les Products de plus de 50 euro
SELECT NoFour, RefProd, NomProd, ROUND(MAX(PrixUnit), 2) as Max FROM Produit WHERE PrixUnit > 50 GROUP BY NoFour ;
SELECT NoFour, RefProd, NomProd, PrixUnit FROM Produit WHERE PrixUnit > 50 GROUP BY NoFour HAVING PrixUnit = MAX(PrixUnit);


# Exercices 12 :
# 1.Récupérer les informations des fournisseurs pour chaque produit
SELECT * FROM Produit NATURAL JOIN Fournisseur;

# 2.Afficher les informations des commandes du client "Lazy K Kountry Store"
SELECT * FROM Client NATURAL JOIN Commande WHERE Societe = "Lazy K Kountry Store" ;

# 3.Afficher le nombre de commande pour chaque messager (en indiquant son nom)
SELECT NomMess, COUNT(*) AS "NbCommandes" FROM Commande NATURAL JOIN Messager GROUP BY NomMess;


# Exercices 13
# 1 - Récupérer les informations des fournisseurs pour chaque produit, avec une jointure interne
SELECT * FROM Produit INNER JOIN Fournisseur ON Fournisseur.NoFour = Produit.NoFour ;

# 2 - Afficher les informations des commandes du client "Lazy K Kountry Store", avec une jointure interne
SELECT * FROM Client INNER JOIN Commande ON Client.CodeCli = Commande.CodeCli WHERE Societe = "Lazy K Kountry Store" ;

# 3 - Afficher le nombre de commande pour chaque messager (en indiquant son nom), avec une jointure interne
SELECT NomMess, COUNT(*) AS "NbCommandes" FROM Commande INNER JOIN Messager ON Commande.NoMess = Messager.NoMess GROUP BY NomMess;


# Exercices 14
# 1 - Compter pour chaque produit, le nombre de commandes où il apparaît, même pour ceux dans aucune commande
SELECT NomProd, COUNT(DISTINCT NoCom) AS NbApparitions FROM Produit LEFT JOIN DetailCommande ON Produit.RefProd = DetailCommande.RefProd GROUP BY NomProd;

# 2 - Lister les produits n'apparaissant dans aucune commande
SELECT NomProd FROM Produit LEFT OUTER JOIN DetailCommande ON Produit.RefProd = DetailCommande.RefProd GROUP BY NomProd HAVING COUNT(NoCom) = 0;

# 3 - Existe-t'il un employé n'ayant enregistré aucune commande ?
SELECT Nom, Prenom FROM Employe LEFT OUTER JOIN Commande ON Employe.NoEmp = Commande.NoEmp GROUP BY Nom, Prenom HAVING COUNT(DISTINCT NoCom) = 0;


#Exercices 15 :
# 1 - Récupérer les informations des fournisseurs pour chaque produit, avec jointure à la main
SELECT * FROM Produit, Fournisseur WHERE Fournisseur.NoFour = Produit.NoFour ;

# 2 - Afficher les informations des commandes du client "Lazy K Kountry Store", avec jointure à la main
SELECT * FROM Client, Commande WHERE Client.CodeCli = Commande.CodeCli AND Societe = "Lazy K Kountry Store" ;

# 3 - Afficher le nombre de commande pour chaque messager (en indiquant son nom), avec jointure à la main
SELECT NomMess, COUNT(*) AS "NbCommandes" FROM Commande, Messager WHERE Messager.NoMess = Commande.NoMess GROUP BY NomMess;


# Exercices 16 :
# 1 - Lister les employés n'ayant jamais effectué une commande, via une sous-requête
SELECT Nom, Prenom FROM Employe WHERE NoEmp NOT IN (SELECT NoEmp FROM Commande) ;

# 2 - Nombre de produits proposés par la société fournisseur "Ma Maison", via une sous-requête
SELECT COUNT(*) AS NbProduits FROM Produit WHERE NoFour IN (SELECT NoFour FROM Fournisseur WHERE Societe = "Ma Maison") ;

# 3 - Nombre de commandes passées par des employés sous la responsabilité de "Buchanan Steven"
SELECT COUNT(*) FROM Commande WHERE NoEmp IN (SELECT NoEmp FROM Employe WHERE RendComptA = 2) ;
SELECT COUNT(*) FROM Commande WHERE NoEmp IN (SELECT NoEmp FROM Employe WHERE Nom = "Buchanan" AND Prenom = "Steven") ;

# Exercices 17 :
# 1 - Lister les produits n'ayant jamais été commandés, à l'aide de l'opérateur EXISTS
SELECT NomProd FROM Produit WHERE NOT EXISTS (SELECT * FROM DetailCommande WHERE RefProd = Produit.RefProd);

# 2 - Lister les fournisseurs dont au moins un produit a été livré en France
SELECT Societe FROM Fournisseur WHERE EXISTS (SELECT * FROM Commande WHERE PaysLiv = 'France') ;
SELECT Societe FROM Fournisseur WHERE EXISTS (SELECT * FROM Produit, DetailCommande, Commande WHERE Produit.RefProd = DetailCommande.RefProd AND DetailCommande.NoCom = Commande.NoCom AND PaysLiv = "France" AND NoFour = Fournisseur.NoFour);

# 3 - Liste des fournisseurs qui ne proposent que des boissons (drinks)
SELECT Societe FROM Fournisseur WHERE EXISTS (SELECT * FROM Produit, Catégorie WHERE Produit.CodeCateg = Catégorie.CodeCateg AND NoFour = Fournisseur.NoFour AND NomCateg = "drinks") AND NOT EXISTS (SELECT * FROM Produit, Catégorie WHERE Produit.CodeCateg = Catégorie.CodeCateg AND NoFour = Fournisseur.NoFour AND NomCateg <> "drinks");


# Exercices 18 :
# En utilisant la clause UNION :
# 1 - Lister les employés (nom et prénom) étant "Representative" ou étant basé au Royaume-Uni (UK)
SELECT Nom, Prenom FROM Employe WHERE Fonction LIKE "%Representative%" UNION ALL SELECT Nom, Prenom FROM Employe WHERE Pays = "UK" ;

# 2 - Lister les clients (société et pays) ayant commandés via un employé situé à Londres ("London" pour rappel) ou ayant été livré par "Speedy Express"
SELECT Societe, Client.Pays FROM Client, Commande, Employe WHERE Client.CodeCli = Commande.CodeCli AND Commande.NoEmp = Employe.NoEmp AND Employe.Ville = "London" UNION SELECT Societe, Client.Pays FROM Client, Commande, Messager WHERE Client.CodeCli = Commande.CodeCli AND Commande.NoMess = Messager.NoMess AND NomMess = "Speedy Express" ;


# Exercices 19 :
# 1.Lister les employés (nom et prénom) étant "Representative" et étant basé au Royaume-Uni (UK)
SELECT DISTINCT Nom, Prenom, Fonction, Pays FROM Employe WHERE Fonction LIKE "%Representative%" AND Pays IN (SELECT Pays FROM Employe WHERE Pays = "UK");

# 2.Lister les clients (société et pays) ayant commandés via un employé basé à "Seattle" et ayant commandé des "Desserts"
SELECT DISTINCT Societe, Client.Pays FROM Client, Commande, Employe WHERE Client.CodeCli = Commande.CodeCli AND Commande.NoEmp = Employe.NoEmp AND Employe.Ville = "Seattle" IN (SELECT NomCateg FROM Catégorie WHERE NomCateg = "Desserts") ;
SELECT DISTINCT Societe, Client.Pays FROM Client, Commande, Employe WHERE Client.CodeCli = Commande.CodeCli AND Commande.NoEmp = Employe.NoEmp AND Employe.Ville = "Seattle" IN (SELECT NomCateg FROM Client, Commande, DetailCommande, Produit, Catégorie WHERE Client.CodeCli = Commande.CodeCli AND Commande.NoCom = DetailCommande.NoCom AND DetailCommande.RefProd = Produit.RefProd AND Produit.CodeCateg = Catégorie.CodeCateg AND NomCateg = "Desserts") ;


# Exercices 20 :
# 1.Lister les employés (nom et prénom) étant "Representative" mais n'étant pas basé au Royaume-Uni (UK)
SELECT Nom, Prenom FROM Employe WHERE Fonction LIKE "%Representative%" AND Pays NOT IN (SELECT Pays FROM Employe WHERE Pays = "UK") ;

# 2.Lister les clients (société et pays) ayant commandés via un employé situé à Londres ("London" pour rappel) et n'ayant jamais été livré par "United Package"
SELECT Societe, Client.Pays FROM Client, Commande, Employe, Messager WHERE Client.CodeCli = Commande.CodeCli AND Commande.NoEmp = Employe.NoEmp AND Employe.Ville = "London" AND Commande.NoMess = Messager.NoMess AND NomMess NOT IN (SELECT NomMess FROM Messager WHERE NomMess = "United Package") ;