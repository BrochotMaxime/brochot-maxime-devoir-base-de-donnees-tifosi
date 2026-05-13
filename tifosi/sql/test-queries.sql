-- Requêtes de test

USE tifosi;

-- --------------------------------------------------------------------

-- 1. Afficher la liste des noms des focaccias par ordre alphabétique croissant

SELECT nom_focaccia
FROM focaccia
ORDER BY nom_focaccia ASC;

-- Résultat attendu : Américaine, Emmentalaccia, Gorgonzollaccia, Hawaienne, Mozaccia, Paysanne, Raclaccia, Tradizione
-- Résultat obtenu :  Américaine, Emmentalaccia, Gorgonzollaccia, Hawaienne, Mozaccia, Paysanne, Raclaccia, Tradizione

-- --------------------------------------------------------------------

-- 2. Afficher le nombre total d'ingrédients

SELECT COUNT(*) AS nombre_total_ingredients
FROM ingredient;

-- Résultat attendu : 25
-- Résultat obtenu :  25

-- --------------------------------------------------------------------

-- 3. Afficher le prix moyen des focaccias

SELECT ROUND(AVG(prix), 2) AS prix_moyen_focaccia
FROM focaccia;

-- Résultat attendu : 10.38
-- Résultat obtenu :  10.38

-- --------------------------------------------------------------------

-- 4. Afficher la liste des boissons avec leur marque, triée par nom de boisson

SELECT boisson.nom_boisson, marque.nom_marque
FROM boisson
INNER JOIN marque ON boisson.id_marque = marque.id_marque
ORDER BY boisson.nom_boisson ASC;

-- Résultat attendu : 
-- Boisson                     Marque
-- Capri-sun                   Coca-cola
-- Coca-cola original          Coca-cola
-- Coca-cola zéro              Coca-cola
-- Eau de source               Cristaline
-- Fanta citron                Coca-cola
-- Fanta orange                Coca-cola
-- Lipton Peach                PepsiCo
-- Lipton zéro citron          PepsiCo
-- Monster energy ultra blue   Monster
-- Monster energy ultra gold   Monster
-- Pepsi                       PepsiCo
-- Pepsi Max Zéro              PepsiCo

-- Résultat obtenu :
-- Boisson                     Marque
-- Capri-sun                   Coca-cola
-- Coca-cola original          Coca-cola
-- Coca-cola zéro              Coca-cola
-- Eau de source               Cristaline
-- Fanta citron                Coca-cola
-- Fanta orange                Coca-cola
-- Lipton Peach                PepsiCo
-- Lipton zéro citron          PepsiCo
-- Monster energy ultra blue   Monster
-- Monster energy ultra gold   Monster
-- Pepsi                       PepsiCo
-- Pepsi Max Zéro              PepsiCo

-- --------------------------------------------------------------------

-- 5. Afficher la liste des ingrédients pour une Raclaccia

SELECT ingredient.nom_ingredient
FROM ingredient
INNER JOIN comprend ON ingredient.id_ingredient = comprend.id_ingredient
WHERE comprend.id_focaccia = (SELECT id_focaccia FROM focaccia WHERE nom_focaccia = 'Raclaccia');

-- Résultat attendu : ail, base tomate, champignon, cresson, parmesan, poivre, raclette
-- Résultat obtenu :  ail, base tomate, champignon, cresson, parmesan, poivre, raclette

-- --------------------------------------------------------------------

-- 6. Afficher le nom et le nombre d'ingrédients pour chaque foccacia

SELECT focaccia.nom_focaccia, COUNT(comprend.id_ingredient) AS nombre_ingredients
FROM focaccia
LEFT JOIN comprend ON focaccia.id_focaccia = comprend.id_focaccia
GROUP BY focaccia.nom_focaccia;

-- Résultat attendu :
-- Focaccia        Nombre d'ingrédients
-- Américaine      8
-- Emmentalaccia   7
-- Gorgonzollaccia 8
-- Hawaienne       9
-- Mozaccia        10
-- Paysanne        12
-- Raclaccia       7
-- Tradizione      9

-- Résultat obtenu :
-- Focaccia        Nombre d'ingrédients
-- Américaine      8
-- Emmentalaccia   7
-- Gorgonzollaccia 8
-- Hawaienne       9
-- Mozaccia        10
-- Paysanne        12
-- Raclaccia       7
-- Tradizione      9

-- --------------------------------------------------------------------

-- 7. Afficher le nom de la focaccia qui a le plus d'ingrédients

SELECT focaccia.nom_focaccia
FROM focaccia
LEFT JOIN comprend ON focaccia.id_focaccia = comprend.id_focaccia
GROUP BY focaccia.nom_focaccia
ORDER BY COUNT(comprend.id_ingredient) DESC
LIMIT 1;

-- Résultat attendu : Paysanne
-- Résultat obtenu :  Paysanne

-- --------------------------------------------------------------------

-- 8. Afficher la liste des focaccia qui contiennent de l'ail

SELECT focaccia.nom_focaccia
FROM focaccia
INNER JOIN comprend ON focaccia.id_focaccia = comprend.id_focaccia
WHERE comprend.id_ingredient = (SELECT id_ingredient FROM ingredient WHERE nom_ingredient = 'Ail');

-- Résultat attendu : Mozaccia, Gorgonzollaccia, Paysanne, Raclaccia
-- Résultat obtenu :  Mozaccia, Gorgonzollaccia, Paysanne, Raclaccia

-- --------------------------------------------------------------------

-- 9. Afficher la liste des ingrédients inutilisés

SELECT ingredient.nom_ingredient
FROM ingredient
LEFT JOIN comprend ON ingredient.id_ingredient = comprend.id_ingredient
WHERE comprend.id_ingredient IS NULL;

-- Résultat attendu : salami, tomate cerise
-- Résultat obtenu :  salami, tomate cerise

-- --------------------------------------------------------------------

-- 10. Afficher la liste des focaccia qui n'ont pas de champignons

SELECT focaccia.nom_focaccia
FROM focaccia
WHERE focaccia.id_focaccia NOT IN (
        SELECT id_focaccia
        FROM comprend
        WHERE id_ingredient = (SELECT id_ingredient FROM ingredient WHERE nom_ingredient = 'Champignon')
);

-- Résultat attendu : Hawaienne, Paysanne
-- Résultat obtenu :  Hawaienne, Paysanne