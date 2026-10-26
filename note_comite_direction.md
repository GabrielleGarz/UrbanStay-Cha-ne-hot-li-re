Défintion du chiffre d'affaires :

Le Chiffre d'Affaires retenu correspond à la somme des montants totaux de toutes les réservations effectivement honorées ou confirmées, en excluant strictement l'ensemble des réservations annulées.

Trois constats chiffrés 

1er constat (requête 1 en annexes) :

Les hôtels 4 étoiles génèrent près de 44 % de chiffre d'affaires supplémentaire par rapport aux 3 étoiles (+168 008,95 €). L'écart s'explique principalement par la valorisation de la nuitée (+32 % sur le prix moyen par nuitée), combinée à un volume d'activité plus soutenu (+13,96 % de réservations et +10,93 % de nuitées)

2ème constat (requête 2 en annexes) : 

L’activité repose sur des bases très saines : un volume d'affaires proche du million d'euros (soit 932701,13 euros), une excellente valeur moyenne par séjour (soit 517,88 euros) et un taux d'annulation très bas (soit 9,60%) qui sécurise les prévisions budgétaires.

3ème constat (requête 3 en annexes)

Le canal qui mérite la plus grande part du budget est le Site web, car c'est lui qui génère le plus grand chiffre d'affaires net encaissé (environ 369 500 €), tout en conservant le taux d'annulation le plus faible de toute la chaîne. Viennent ensuite les plateformes comme Booking et les Agences, tandis que le téléphone reste le canal le moins rentable et le plus sujet aux annulations.


Une recommandation (requête recommandation en annexes) : 

Pour optimiser la rentabilité de l'agrandissement, je recommande de construire en priorité une majorité de chambres Confort et Deluxe (par exemple 6 Confort et 4 Deluxe).
Les chambres Confort représentent le meilleur compromis entre un fort volume de demande (325440,41 euros) et un prix maîtrisé (151,79 euros), tandis que les catégories Deluxe et Suite dégagent un chiffre d'affaires par chambre disponible nettement supérieur aux chambres Standards (184111,57 euros et 157584,20 euros respectivement). Les chambres Standards étant déjà très nombreuses dans le parc (soit 749 chambres), privilégier le segment intermédiaire et supérieur maximisera le retour sur investissement.


Une limite :


Le chiffre d'affaires analysé correspond aux montants facturés sur les chambres, sans intégrer la structure des coûts fixes et variables (charges de personnel, coût du ménage par rotation, commission des canaux de distribution tiers comme Booking ou Expedia). Ainsi, un chiffre d'affaires élevé sur un canal tiers ne traduit pas nécessairement une marge nette supérieure.


Annexes :

Requête 1 :

SELECT 
    h.categorie, 
    COUNT(r.reservation_id) AS nombre_reservation_par_categorie,
    SUM(r.date_depart - r.date_arrivee) AS nombre_nuitees_totales,
    ROUND(SUM(r.montant_total), 2) AS CA_global_par_categorie,
    ROUND(AVG(r.montant_total / (r.date_depart - r.date_arrivee)), 2) AS panier_moyen_par_nuitee
FROM hotels h
JOIN chambres c ON h.hotel_id = c.hotel_id
JOIN reservations r ON c.chambre_id = r.chambre_id
WHERE UPPER(TRIM(r.statut)) NOT IN ('ANNULÉE', 'ANNULEE')
GROUP BY h.categorie
ORDER BY CA_global_par_categorie DESC;


Requête 2 :

SELECT 
    -- 1. Le Chiffre d'Affaires Net Encaissé (Volume financier réel)
    ROUND(SUM(CASE WHEN statut != 'Annulée' THEN montant_total ELSE 0 END), 2) AS ca_net_encaisse,
    
    -- 2. Le Panier Moyen par Séjour Honoré (Valeur client)
    ROUND(AVG(CASE WHEN statut != 'Annulée' THEN montant_total END), 2) AS panier_moyen_net,
    
    -- 3. Le Taux d'Annulation Global (Fiabilité opérationnelle)
    ROUND(
        COUNT(CASE WHEN statut = 'Annulée'  THEN 1 END) * 100.0 / COUNT(*), 
        2
    ) AS taux_annulation_global_pourcentage
FROM reservations;

Requête 3 :

SELECT 
(CASE 
    WHEN UPPER(TRIM(canal_reservation)) IN ('TÉLÉPHONE', 'TELEPHONE') THEN 'TÉLÉPHONE'
    ELSE UPPER(TRIM(canal_reservation))
end) as canal_nettoye,
COUNT(*) AS nombre_reservations_valides,
ROUND(SUM(montant_total), 2) AS CA_net_encaisse,
ROUND(AVG(montant_total), 2) AS panier_moyen_net
FROM reservations
WHERE statut !='Annulée' 
GROUP BY canal_nettoye
ORDER BY CA_net_encaisse DESC;


Requête recommandation :

SELECT 
    chambre_reference.type_chambre,
    COUNT(DISTINCT chambre_reference.chambre_id) AS nb_chambres_existantes,
    COUNT(chambre_reference.reservation_id) AS nb_reservations,
    ROUND(
        COUNT(chambre_reference.reservation_id)::NUMERIC / COUNT(DISTINCT chambre_reference.chambre_id), 
        1
    ) AS ratio_reservation_par_chambre,
    ROUND(AVG(chambre_reference.tarif_standard), 2) AS tarif_moyen_catalogue,
    ROUND(AVG(chambre_reference.montant_total / chambre_reference.nuitees), 2) AS prix_moyen_nuitee_reelle,
    ROUND(SUM(chambre_reference.montant_total), 2) AS CA_total
FROM (
    SELECT 
        c.type_chambre,
        c.chambre_id,
        c.tarif_standard,
        r.reservation_id,
        r.montant_total,
        (r.date_depart - r.date_arrivee) AS nuitees
    FROM chambres c
    LEFT JOIN reservations r ON c.chambre_id = r.chambre_id
        AND UPPER(TRIM(r.statut)) NOT IN ('ANNULÉE', 'ANNULEE')
) AS chambre_reference
GROUP BY chambre_reference.type_chambre
ORDER BY CA_total DESC;


--Rappel : note_comite_direction.md 

— une page : la définition du chiffre d'affaires retenue en première ligne, trois constats chiffrés et sans vocabulaire technique, une recommandation, une limite. Les requêtes d'appui en annexe. Chaque chiffre porte la mention vérifié par [prénom].

