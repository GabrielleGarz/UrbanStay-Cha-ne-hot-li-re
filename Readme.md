# 🏨 UrbanStay Hotels – Pilotage de la Performance Hôtelière (Power BI)

Ce dépôt héberge la documentation et les ressources du projet analytique pour la chaîne hôtelière **UrbanStay Hotels**. L'objectif est de centraliser et d'exploiter les données issues du système de réservation afin de fournir à la direction un outil décisionnel unique et interactif sous Power BI.

---

## 📋 Contexte du Projet

**UrbanStay Hotels** est une chaîne hôtelière présente dans plusieurs villes françaises. Jusqu'à présent, les informations relatives aux établissements, aux chambres, aux clients et aux réservations résidaient dans des tables isolées au sein d'une base PostgreSQL locale, sans outil de pilotage unifié.

En tant que **Data Analyst**, la mission consiste à :
1. **Déployer & Connecter :** Alimenter la base PostgreSQL locale via le script SQL fourni et la connecter à Power BI Desktop.
2. **Préparer & Modéliser :** Nettoyer et transformer les données dans **Power Query** pour bâtir un modèle relationnel analytique (schéma en étoile/flocon).
3. **Calculer des KPIs Métier :** Concevoir des mesures avancées en **DAX** pour évaluer la santé financière et l'activité opérationnelle.
4. **Restituer & Analyser :** Concevoir un tableau de bord interactif permettant de comparer les établissements, de détecter les tendances et d'extraire des recommandations stratégiques.

---

## 🛠️ Stack Technique & Architecture

* **Source de Données :** Base de données relationnelle **PostgreSQL** (exécutée en local).
* **Extraction & Transformation (ETL) :** **Power Query M** (nettoyage des libellés, typage, gestion des valeurs manquantes, tables de faits et de dimensions).
* **Modélisation & Calculs :** **DAX** (mesures calculées pour le suivi des revenus, taux d'occupation, paniers moyens et annulations).
* **Restitution Visuelle :** **Power BI Desktop** (rapport interactif dynamique).

---

## 📊 Indicateurs Clés de Performance (KPIs)

Le tableau de bord permet à la direction de piloter l'activité selon 4 axes principaux :

1. **Performance Financière & Revenus :**
   * **Chiffre d’Affaires (CA) global et ventilé** par hôtel, type de chambre et période.
   * **Revenu Moyen par Chambre / Panier Moyen**.

2. **Taux d'Occupation & Activité Operionnelle :**
   * **Taux d'Occupation (TO) :** Capacité utilisée par rapport à la capacité disponible.
   * **Volume de nuitées vendues** et durée moyenne des séjours.

3. **Analyse de la Sinistralité Commerciale & Annulations :**
   * **Taux d'annulation** des réservations et pertes de revenus associées.
   * Répartition des annulations par canal ou par hôtel.

4. **Segmentation & Comparaison des Établissements :**
   * **Benchmark inter-hôtels :** Comparaison directe des performances selon la localisation (villes françaises) et la typologie des clients.

---

## 🎛️ Fonctionnalités du Tableau de Bord (Power BI)

* **Navigation & Filtrage Dynamique :** Filtres croisés par ville/établissement, typologie de chambre et plages temporelles.
* **Scorecards Exécutives :** Affichage synthétique des indicateurs globaux pour la prise de décision rapide.
* **Visualisations Adaptées :** Graphiques temporels d'évolution des ventes, diagrammes de répartition et tableaux comparatifs inter-établissements.

---

## 🚀 Étapes de Mise en Œuvre

1. **Base de données :** Exécution du script SQL dans PostgreSQL pour générer le schéma et alimenter les tables (`hôtels`, `chambres`, `clients`, `réservations`).
2. **Connexion & ETL :** Chargement des tables dans Power BI via le connecteur PostgreSQL et nettoyage sous Power Query.
3. **Modélisation :** Mise en place des relations (1 à plusieurs) entre les tables de dimensions et la table de faits des réservations.
4. **Création DAX :** Écriture des formules métier (CA, Taux d'occupation, Annulations).
5. **Restitution :** Finalisation de la mise en page du rapport et rédaction des constats analytiques.

## 📸 Aperçu du Dashboard

### 1. Vue d'ensemble des Performances (KPIs)

Présentés sur Canva :
https://canva.link/nvm164m4biz3cih
---
