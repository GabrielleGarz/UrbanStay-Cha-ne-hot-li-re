L’enquête UrbanStay

Ressource pour les deux briefs de la semaine. À faire dès que vous avez terminé une couche de travail.


Ce que c’est
Douze missions indépendantes. Chacune est une vraie demande, formulée en français par quelqu’un de chez UrbanStay. Chacune se termine. Vous les prenez dans l’ordre que vous voulez, une à la fois.
Il y en a plus que ce que vous ferez cette semaine, et c’est volontaire : vous ne devez jamais vous retrouver sans travail. Faites-en trois, faites-en dix — ce qui compte n’est pas combien, c’est comment.
Aucune mission ne contient de requête, ni d’indice SQL. C’est la différence avec le brief : ici, on vous donne une question, pas une consigne.


Ce que vous rendez pour chaque mission
Dans un fichier enquete.md , recopiez ce gabarit pour chaque mission traitée :


Les six rubriques sont obligatoires. Celle qui compte le plus est « Ce que j’ai décidé ». Une mission sans décision explicite n’est pas traitée.


Pourquoi c’est le vrai travail
Dans le brief, on vous dit quoi faire. Dans la vraie vie, on vous pose une question floue et on attend un chiffre.
Entre les deux, il y a une décision que personne ne prendra à votre place : qu’est-ce que la question veut dire au juste ? Si le directeur demande le « meilleur » hôtel, parle-t-il de celui qui encaisse le plus, de celui qui reçoit le plus de monde, ou de celui où chaque client dépense le plus ? Ce ne sont pas les mêmes hôtels.
Un analyste qui répond sans avoir choisi donne un chiffre au hasard. Un analyste qui choisit, le dit, et assume — c’est quelqu’un qu’on rappelle.


SÉRIE 1 — accessible dès le lundi

(ces missions se traitent avec ce que vous voyez lundi et mardi)

Mission 1 — « Quel est notre meilleur hôtel ? »

Attention : prenez le temps. Cette mission n’est pas celle que vous croyez.

**Ce que j'ai compris de la question**
[2 lignes. Qu'est-ce qu'on me demande exactement ? Qu'est-ce qui est ambigu ?]
Le directeur général veut savoir quel hôtel rapporte le plus d’argent, c’est-à-dire l’hôtel qui a le CA le plus élevé.

**Ce que j'ai décidé**
[1 ligne. Quel critère j'ai retenu, et pourquoi celui-là.]
Je dois faire une requête qui donne le chiffre d’affaires total par hôtel. On peut en faire deux : une qui cumule le résulat sur toute la période, une qui donne le résulat par année.

**Ma requête** SELECT …

*CA par hôtel et par année

select h.nom_hotel, EXTRACT(YEAR FROM date_arrivee) AS annee, round(sum(r.montant_total),2) as CA_par_hotel_et_annee
from reservations r
left join chambres c on r.chambre_id = c.chambre_id 
left join hotels h on h.hotel_id = c.hotel_id 
group by h.nom_hotel, extract(year from date_arrivee)
order by annee, CA_par_hotel_et_annee desc;*

**Le résultat**
[Les chiffres obtenus, nombre de lignes.]

--Résulat : 16 lignes

--UrbanStay Bordeaux Quinconces		2024	121300.06
--UrbanStay Paris Opéra			    2024	120270.33
--UrbanStay Marseille Vieux-Port	2024	117697.23
--UrbanStay Lyon Part-Dieu			2024	105015.40
--UrbanStay Paris République		2024	93553.84
--UrbanStay Lyon Confluence		    2024	87076.87
--UrbanStay Bordeaux Saint-Jean		2024	68666.73
--UrbanStay Marseille Joliette		2024	66883.22
--UrbanStay Marseille Vieux-Port	2025	41870.45
--UrbanStay Paris Opéra			    2025	39220.44
--UrbanStay Bordeaux Quinconces		2025	38123.24

*CA par hôtel et pour toute la période :

select h.nom_hotel, round(sum(r.montant_total),2) as CA_par_hotel_global
from reservations r
left join chambres c on r.chambre_id = c.chambre_id 
left join hotels h on h.hotel_id = c.hotel_id 
group by h.nom_hotel
order by CA_par_hotel_global desc;

**Le résultat**
[Les chiffres obtenus, nombre de lignes.]

--Résultat : 8 lignes

--UrbanStay Marseille Vieux-Port		159567.68
--UrbanStay Paris Opéra			        159490.77
--UrbanStay Bordeaux Quinconces		    159423.30
--UrbanStay Lyon Part-Dieu			    131212.33
--UrbanStay Paris République		    124796.70
--UrbanStay Lyon Confluence		        110765.44
--UrbanStay Bordeaux Saint-Jean		    94076.89
--UrbanStay Marseille Joliette	        92293.90

**Ma vérification**
[Une DEUXIÈME requête, écrite autrement, qui confirme le résultat. Si elle ne confirme pas, dites-le — c'est une information.]

-- Requête alternative 2 : départ depuis la table HOTELS
SELECT 
    h.nom_hotel,
    ROUND(SUM(r.montant_total), 2) AS ca_global
FROM hotels h
JOIN chambres c ON h.hotel_id = c.hotel_id
JOIN reservations r ON c.chambre_id = r.chambre_id
GROUP BY h.nom_hotel
ORDER BY ca_global DESC;

--Résulat : 8 lignes.

--UrbanStay Marseille Vieux-Port		159567.68
--UrbanStay Paris Opéra			        159490.77
--UrbanStay Bordeaux Quinconces		    159423.30
--UrbanStay Lyon Part-Dieu	            131212.33
--UrbanStay Paris République		    124796.70
--UrbanStay Lyon Confluence		        110765.44
--UrbanStay Bordeaux Saint-Jean	    	94076.89
--UrbanStay Marseille Joliette		    92293.90

Cette requête donne le même résulat.

**Ma réponse, en français**
[2 ou 3 lignes. Comme si vous répondiez à la personne qui a posé la question. Aucun mot technique : ni « requête », ni « table », ni « jointure ».]
Au global : L'établissement le plus rentable est UrbanStay Marseille Vieux-Port avec un Chiffre d'Affaires cumulé de 159 567,68 €,
Par année : Sur l'exercice complet 2024, UrbanStay Bordeaux Quinconces a été l'hôtel le plus performant (121 300,06 €), alors qu'en 2025 (sur le début d'année), c'est Marseille Vieux-Port qui prend la tête (41 870,45 €).


Mission 2 — « On perd plus de réservations ailleurs ? »
La responsable qualité : « J’ai l’impression que certains établissements annulent beaucoup plus que d’autres. Est-ce que c’est vrai, ou est-ce que je me fais des idées ? »
**Ce que j'ai compris de la question**
[2 lignes. Qu'est-ce qu'on me demande exactement ? Qu'est-ce qui est ambigu ?]

Je comprends qu’il faut regarder le taux d’annulation des réservations le plus élevé par canal de réservation et par hôtel. Le canal de réservation donne des libellés incorrects donc il faudra faire des corrections à la main.

**Ce que j'ai décidé**
[1 ligne. Quel critère j'ai retenu, et pourquoi celui-là.]

J’ai décidé de définir le Taux d’annulation des réservations par canal et par hôtel= Nombre d'annulations du canal dans cet hôtel/Nombre total de réservations du canal dans cet hôtel*100
et de le calculer pour les 5 canaux

**Ma requête** SELECT …

SELECT 
    h.nom_hotel,
    UPPER(TRIM(r.canal_reservation)) AS canal_trime_majuscule,
    COUNT(CASE WHEN UPPER(TRIM(r.statut)) IN ('ANNULÉE', 'ANNULEE') THEN 1 END) AS nombre_annulations,
    COUNT(*) AS total_reservations,
    ROUND(COUNT(CASE WHEN UPPER(TRIM(r.statut)) IN ('ANNULÉE', 'ANNULEE') THEN 1 END) * 100.0 / COUNT(*), 2) AS taux_annulation_reservations
FROM reservations r
JOIN chambres c ON r.chambre_id = c.chambre_id
JOIN hotels h ON c.hotel_id = h.hotel_id
GROUP BY h.nom_hotel, UPPER(TRIM(r.canal_reservation))
ORDER BY h.nom_hotel, taux_annulation_reservations DESC;


**Le résultat**
[Les chiffres obtenus, nombre de lignes.]

--Résultat : 38 lignes

UrbanStay Bordeaux Quinconces	TELEPHONE		1	2	50.00
UrbanStay Bordeaux Quinconces	AGENCE			8	50	16.00
UrbanStay Bordeaux Quinconces	TÉLÉPHONE		3	19	15.79
UrbanStay Bordeaux Quinconces	SITE WEB		14	111	12.61
UrbanStay Bordeaux Quinconces	BOOKING		    7	84	8.33
UrbanStay Bordeaux Saint-Jean	TÉLÉPHONE		3	26	11.54
UrbanStay Bordeaux Saint-Jean	BOOKING		    7	61	11.48
UrbanStay Bordeaux Saint-Jean	AGENCE			3	41	7.32
UrbanStay Bordeaux Saint-Jean	SITE WEB		5	69	7.25
UrbanStay Bordeaux Saint-Jean	TELEPHONE		0	2	0.00
UrbanStay Lyon Confluence		TÉLÉPHONE		5	24	20.83
UrbanStay Lyon Confluence		BOOKING	    	13	79	16.46
UrbanStay Lyon Confluence		AGENCE			6	61	9.84
UrbanStay Lyon Confluence		SITE WEB		5	97	5.15
UrbanStay Lyon Confluence		TELEPHONE		0	1	0.00
UrbanStay Lyon Part-Dieu		TÉLÉPHONE		5	28	17.86
UrbanStay Lyon Part-Dieu		SITE WEB		8	92	8.70
UrbanStay Lyon Part-Dieu		BOOKING		    4	57	7.02
UrbanStay Lyon Part-Dieu		AGENCE			2	50	4.00
UrbanStay Lyon Part-Dieu		TELEPHONE		0	1	0.00
UrbanStay Marseille Joliette	TELEPHONE		1	1	100.00
UrbanStay Marseille Joliette	AGENCE			5	35	14.29
UrbanStay Marseille Joliette	SITE WEB		9	75	12.00
UrbanStay Marseille Joliette	BOOKING		    6	64	9.38
UrbanStay Marseille Joliette	TÉLÉPHONE		0	23	0.00
UrbanStay Marseille Vieux-Port	BOOKING		    9	87	10.34
UrbanStay Marseille Vieux-Port	TÉLÉPHONE		2	25	8.00
UrbanStay Marseille Vieux-Port	SITE WEB		9	115	7.83
UrbanStay Marseille Vieux-Port	AGENCE			3	49	6.12
UrbanStay Paris Opéra		AGENCE			    6	59	10.17
UrbanStay Paris Opéra		SITE WEB		    11	124	8.87
UrbanStay Paris Opéra		TÉLÉPHONE		    2	24	8.33
UrbanStay Paris Opéra		BOOKING		        6	86	6.98
UrbanStay Paris République		AGENCE			7	60	11.67
UrbanStay Paris République		TÉLÉPHONE		3	29	10.34
UrbanStay Paris République		BOOKING		    7	91	7.69
UrbanStay Paris République		SITE WEB		7	96	7.29
UrbanStay Paris République		TELEPHONE		0	2	0.00


**Ma vérification**
[Une DEUXIÈME requête, écrite autrement, qui confirme le résultat. Si elle ne confirme pas, dites-le — c'est une information.]

On inverse reservations et hôtels :

SELECT 
    h.nom_hotel,
    UPPER(TRIM(r.canal_reservation)) AS canal_trime_majuscule,
    COUNT(CASE WHEN UPPER(TRIM(r.statut)) IN ('ANNULÉE', 'ANNULEE') THEN 1 END) AS nombre_annulations,
    COUNT(*) AS total_reservations,
    ROUND(COUNT(CASE WHEN UPPER(TRIM(r.statut)) IN ('ANNULÉE', 'ANNULEE') THEN 1 END) * 100.0 / COUNT(*), 2) AS taux_annulation_reservations
FROM hotels h
JOIN chambres c ON h.hotel_id = c.hotel_id
JOIN reservations r ON c.chambre_id = r.chambre_id
GROUP BY h.nom_hotel, UPPER(TRIM(r.canal_reservation))
ORDER BY h.nom_hotel, taux_annulation_reservations DESC;

--Résultat : 38 lignes identique à la requête de base

**Ma réponse, en français**
[2 ou 3 lignes. Comme si vous répondiez à la personne qui a posé la question. Aucun mot technique : ni « requête », ni « table », ni « jointure ».]
Les hôtels à fort taux d'annulation :
    • UrbanStay Lyon Confluence et UrbanStay Lyon Part-Dieu ont des pics d'annulation très élevés sur le canal Téléphone (~18% à 20,8%).
    • UrbanStay Bordeaux Quinconces enregistre des taux élevés sur plusieurs canaux (16% sur Agence, 15,8% sur Téléphone, 12,6% sur Site Web).


Mission 3 — « Quel canal nous rapporte le plus ? »

**Ce que j'ai compris de la question**
[2 lignes. Qu'est-ce qu'on me demande exactement ? Qu'est-ce qui est ambigu ?] 
On me demande d'identifier le canal de réservation qui génère le plus de Chiffre d'Affaires afin d'orienter l'allocation du budget marketing entre les 4 canaux (Site Web, Booking, Agences et Téléphone).
L'ambiguïté : La question ne précise pas si « rapporter » désigne le Chiffre d'Affaires brut (toutes ventes) ou le Chiffre d'Affaires net (hors annulations), ni si l'analyse doit se baser sur le volume global ou sur le panier moyen par réservation.
**Ce que j'ai décidé**
[1 ligne. Quel critère j'ai retenu, et pourquoi celui-là.]

Pour lever l'ambiguïté citée, je prends la requête qui doit calculer le CA Net (hors annulations) et le Panier moyen sur les 4 canaux (en nettoyant la casse et les espaces avec UPPER(TRIM())).

**Ma requête** SELECT ...

SELECT 
(CASE 
    WHEN UPPER(TRIM(canal_reservation)) IN ('TÉLÉPHONE', 'TELEPHONE') THEN 'TÉLÉPHONE'
    ELSE UPPER(TRIM(canal_reservation))
end) as canal_nettoye,
COUNT(*) AS total_reservations,
ROUND(SUM(CASE WHEN statut !='Annulée' THEN montant_total ELSE 0 END), 2) AS CA_net_encaisse,
ROUND(AVG(CASE WHEN statut !='Annulée' THEN montant_total END), 2) AS panier_moyen_net
FROM reservations
GROUP BY canal_nettoye
ORDER BY Ca_net_encaisse DESC;

**Le résultat**
[Les chiffres obtenus, nombre de lignes.]

Résultat : 4 lignes

SITE WEB	779	369503.38	521.16
BOOKING	    609	267163.74	488.42
AGENCE	    405	205771.82	566.86
TÉLÉPHONE	207	90262.19	495.95

**Ma vérification**
[Une DEUXIÈME requête, écrite autrement, qui confirme le résultat. Si elle ne confirme pas, dites-le — c'est une information.]

J’utilise la clause where au lieu du case  when :

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


Résultat : identique à la requête principale

SITE WEB	711	369503.38	521.16
BOOKING 	550	267163.74	488.42
AGENCE	    365	205771.82	566.86
TÉLÉPHONE	182	90262.19	495.95

**Ma réponse, en français**
[2 ou 3 lignes. Comme si vous répondiez à la personne qui a posé la question. Aucun mot technique : ni « requête », ni « table », ni « jointure ».]

Le canal qui mérite la plus grande part du budget est le Site web, car c'est lui qui génère le plus grand chiffre d'affaires net encaissé (environ 369 500 €), tout en conservant le taux d'annulation le plus faible de toute la chaîne. Viennent ensuite les plateformes comme Booking et les Agences, tandis que le téléphone reste le canal le moins rentable et le plus sujet aux annulations.


Mission 4 — « Combien nous coûtent les annulations ? »

Celle-ci demande une précaution particulière : réfléchissez à ce que « perdre » veut dire avant d’écrire quoi que ce soit.

**Ce que j'ai compris de la question**
[2 lignes. Qu'est-ce qu'on me demande exactement ? Qu'est-ce qui est ambigu ?]
On me demande d'évaluer le manque à gagner financier total dû aux annulations de réservations afin d'anticiper le budget. Ambiguïté : La question ne précise pas si l'on doit calculer le montant total brut perdu au cumul (2024-2025) ou si l'on doit ventiler le coût annuel/mensuel pour une projection budgétaire.

**Ce que j'ai décidé**
[1 ligne. Quel critère j'ai retenu, et pourquoi celui-là.]
Je calcule le  montant des réservations annulées et le panier moyen de l'annulation sur la période 2024-2025.

**Ma requête** SELECT ...
SELECT 
EXTRACT(YEAR FROM date_arrivee) AS annee,
COUNT(*) AS nombre_annulations,
ROUND(SUM(montant_total), 2) AS montant_total_annule,
ROUND(AVG(montant_total), 2) AS panier_moyen_annulation
FROM reservations
WHERE statut !='Annulée' 
AND EXTRACT(YEAR FROM date_arrivee) IN (2024, 2025)
GROUP BY annee;

**Le résultat**
[Les chiffres obtenus, nombre de lignes.
Résultat : 2 lignes corresponant aux années 2024 et 2025

2024	135	70020.80	522.54
2025	57	28905.08	507.11


**Ma vérification**
[Une DEUXIÈME requête, écrite autrement, qui confirme le résultat. Si elle ne confirme pas, dites-le — c'est une information.]
J’utilise le case when à la place du where :

select
EXTRACT(YEAR FROM date_arrivee) AS annee,
SUM(CASE WHEN UPPER(TRIM(statut)) IN ('ANNULÉE', 'ANNULEE') THEN 1 ELSE 0 END) AS nombre_annulations,
ROUND(SUM(CASE WHEN statut !='Annulée' THEN montant_total ELSE 0 END), 2) AS montant_total_annule,
ROUND(AVG(CASE WHEN statut !='Annulée' THEN montant_total END), 2) AS panier_moyen_annulation
FROM reservations
WHERE EXTRACT(YEAR FROM date_arrivee) IN (2024, 2025)
group by EXTRACT(YEAR FROM date_arrivee);

Résultat : 2 lignes identiques à la requête de base.

2024	135	70020.80	522.54
2025	57	28905.08	507.11

**Ma réponse, en français**
[2 ou 3 lignes. Comme si vous répondiez à la personne qui a posé la question. Aucun mot technique : ni « requête », ni « table », ni « jointure ».]

 Pour préparer votre budget, voici la décomposition exacte des pertes liées aux annulations sur la période 2024-2025 :
    • En 2024 : 70 020,80 € de manque à gagner (135 séjours annulés), soit un panier moyen de 522,54 €.
    • En 2025 : 28 905,08 € de manque à gagner (57 séjours annulés), soit un panier moyen de 507,11 €.

Mission 5 — « Nos clients étrangers sont-ils différents ? »

**Ce que j'ai compris de la question**
[2 lignes. Qu'est-ce qu'on me demande exactement ? Qu'est-ce qui est ambigu ?]
On me demande de comparer le comportement d'achat des clients étrangers par rapport aux clients français pour justifier l'investissement dans un service en anglais.
Ambiguïté : La question ne précise pas si « différent » concerne la valeur financière (panier moyen, CA), la durée du séjour (nombre de nuitées) ou la fidélité/fiabilité (taux d'annulation) ; je vais donc comparer l'ensemble de ces indicateurs entre la France et les autres pays.

**Ce que j'ai décidé**
[1 ligne. Quel critère j'ai retenu, et pourquoi celui-là.]

J’affiche le CA, le panier moyen, la durée du séjour, le taux d’annulation par pays et je compare la France aux pays anglophones.


**Ma requête** SELECT ...

SELECT 
    cl.pays,
    COUNT(DISTINCT cl.client_id) AS nombre_clients_uniques,
    COUNT(r.reservation_id) AS nombre_reservations,
    SUM(r.date_depart - r.date_arrivee) AS nombre_nuitees_totales,
    ROUND(AVG(r.montant_total), 2) AS panier_moyen,
    ROUND(SUM(r.montant_total), 2) AS CA_total,
    ROUND(
        COUNT(CASE WHEN UPPER(TRIM(r.statut)) IN ('ANNULÉE', 'ANNULEE') THEN 1 END) * 100.0 / COUNT(r.reservation_id), 
        2
    ) AS taux_annulation_reservation
FROM clients cl
JOIN reservations r ON cl.client_id = r.client_id
WHERE cl.pays IS NOT NULL AND cl.pays <> ''
GROUP by cl.pays
ORDER BY CA_total DESC;


**Le résultat**
[Les chiffres obtenus, nombre de lignes.]

Résultat : 6 lignes

FRANCE	    313	1260	3.3	513.06	643885.00	8.49
ROYAUME-UNI	34	141	    3.3	526.40	74223.07	8.51
ITALIE		32	128	    3.5	575.80	73702.86	12.50
ESPAGNE	    39	149	    3.0	486.68	72028.39	11.41
BELGIQUE	28	127 	3.5	541.58	68781.19	11.02
ALLEMAGNE	31	128 	3.3	525.47	66208.76	8.59


**Ma vérification**
[Une DEUXIÈME requête, écrite autrement, qui confirme le résultat. Si elle ne confirme pas, dites-le — c'est une information.]

--On utilise une sous-requête :

SELECT 
    reference.pays,
    COUNT(DISTINCT reference.client_id) AS nombre_clients_uniques,
    COUNT(reference.reservation_id) AS nombre_reservations,
    SUM(reference.nuitees) AS nombre_nuitees_totales,
    ROUND(AVG(reference.montant_total), 2) AS panier_moyen,
    ROUND(SUM(reference.montant_total), 2) AS CA_pays_sejour,
    ROUND(
        COUNT(CASE WHEN statut = 'Annulée' THEN 1 END) * 100.0 / COUNT(reference.reservation_id), 
        2
    ) AS taux_annulation_reservation
FROM (
    SELECT 
        cl.pays,
        cl.client_id,
        r.reservation_id,
        (r.date_depart - r.date_arrivee) AS nuitees,
        r.montant_total,
        r.statut
    FROM clients cl
    JOIN reservations r ON cl.client_id = r.client_id
    WHERE cl.pays IS NOT NULL AND TRIM(cl.pays) <> ''
) AS reference
GROUP BY reference.pays
ORDER BY CA_pays_sejour DESC;

--Résulatat : identique à celui de la requête de base

**Ma réponse, en français**
[2 ou 3 lignes. Comme si vous répondiez à la personne qui a posé la question. Aucun mot technique : ni « requête », ni « table », ni « jointure ».]

Les clients étrangers se comportent différemment par rapport aux clients français : ils restent plus longtemps (jusqu'à 3,5 nuits) et dépensent plus par séjour que les Français, à l'image des Italiens qui ont le panier moyen le plus élevé (575,80 €). Les pays anglophones (Royaume-Uni et Allemagne) représentant à eux seuls plus de 140 000 € de chiffre d'affaires, l'ouverture d'un service en anglais est pleinement justifiée. 

Mission 6 — « Quelle est notre haute saison ? »

Ici aussi, deux réponses possibles. Les deux sont vraies.

**Ce que j'ai compris de la question**
[2 lignes. Qu'est-ce qu'on me demande exactement ? Qu'est-ce qui est ambigu ?]
On me demande d'identifier les mois ou trimestres qui enregistrent la plus forte activité (volume de réservations et fréquentation) afin de planifier les recrutements du personnel saisonnier.
L'ambiguïté : La question ne précise pas si la "haute saison" doit s'évaluer à l'échelle globale de toute la chaîne ou établissement par établissement (car un hôtel 4étoiles et un 3 étoiles peuvent avoir des pics différents), ni si le volume se mesure en nombre d'arrivées ou en nuits consommées.

**Ce que j'ai décidé**
[1 ligne. Quel critère j'ai retenu, et pourquoi celui-là.]
Je vais afficher le CA et le nombre de nuitées par catégorie d’hôtel et par mois.

**Ma requête** SELECT ...

SELECT 
    h.categorie, 
    TO_CHAR(r.date_arrivee, 'YYYY-MM') AS mois,
    COUNT(*) AS nombre_reservation_par_categorie,
    SUM(r.date_depart - r.date_arrivee) AS nombre_nuitees_totales,
    ROUND(SUM(r.montant_total), 2) AS CA_par_categorie_mois
FROM reservations r
JOIN chambres c ON r.chambre_id = c.chambre_id
JOIN hotels h ON h.hotel_id = c.hotel_id
WHERE UPPER(TRIM(r.statut)) NOT IN ('ANNULÉE', 'ANNULEE')
GROUP BY h.categorie, TO_CHAR(r.date_arrivee, 'YYYY-MM')
ORDER BY mois, CA_par_categorie_mois DESC;

**Le résultat**
[Les chiffres obtenus, nombre de lignes.]

Résultat : 36 lignes

3 étoiles	2024-01	26	87	7096.65
4 étoiles	2024-01	19	65	5846.86
4 étoiles	2024-02	42	131	15182.43
3 étoiles	2024-02	40	134	12061.61
4 étoiles	2024-03	58	192	28709.78
3 étoiles	2024-03	59	175	22281.48
4 étoiles	2024-04	58	183	25725.37
3 étoiles	2024-04	48	161	18709.79
4 étoiles	2024-05	58	195	27706.42
3 étoiles	2024-05	50	164	16664.90
4 étoiles	2024-06	80	260	61447.55
3 étoiles	2024-06	58	195	35779.81
4 étoiles	2024-07	85	276	76169.77
3 étoiles	2024-07	79	273	59489.34
4 étoiles	2024-08	79	289	69095.03
3 étoiles	2024-08	62	211	40645.51
4 étoiles	2024-09	57	183	35628.61
3 étoiles	2024-09	57	185	27838.37
4 étoiles	2024-10	69	215	38381.20
3 étoiles	2024-10	38	119	16144.00
4 étoiles	2024-11	39	130	12813.54
3 étoiles	2024-11	37	119	10217.97
4 étoiles	2024-12	47	152	25186.58
3 étoiles	2024-12	50	187	21620.31
4 étoiles	2025-01	30	93	10213.56
3 étoiles	2025-01	24	78	6344.79
4 étoiles	2025-02	41	126	13575.99
3 étoiles	2025-02	31	97	8066.75
3 étoiles	2025-03	61	208	24750.08
4 étoiles	2025-03	48	158	23893.81
4 étoiles	2025-04	52	165	23296.48
3 étoiles	2025-04	41	135	16792.37
4 étoiles	2025-05	48	149	19906.51
3 étoiles	2025-05	41	136	13584.66
4 étoiles	2025-06	53	153	37575.55
3 étoiles	2025-06	43	144	24257.70

**Ma vérification**
[Une DEUXIÈME requête, écrite autrement, qui confirme le résultat. Si elle ne confirme pas, dites-le — c'est une information.]

**Ma réponse, en français**
[2 ou 3 lignes. Comme si vous répondiez à la personne qui a posé la question. Aucun mot technique : ni « requête », ni « table », ni « jointure ».]

Pour la planification des équipes, nous recommandons de concentrer les recrutements saisonniers sur la période estivale : de juin à août pour les hôtels 4 étoiles (qui enregistrent une montée en charge plus précoce), et sur juillet et août pour les 3 étoiles. 


SÉRIE 2 — à partir du mercredi

(ces missions demandent ce que vous verrez mercredi)

Mission 7 — « Les 4 étoiles rapportent-ils vraiment plus ? »


**Ce que j'ai compris de la question**
[2 lignes. Qu'est-ce qu'on me demande exactement ? Qu'est-ce qui est ambigu

On me demande de comparer les performances financières des hôtels 4 étoiles par rapport aux 3 étoiles pour déterminer si la montée en gamme génère un gain réel qui justifie les investissements.
L'ambiguïté : La question ne précise pas si la notion de "rapporter plus" s'évalue sur le Chiffre d'Affaires total, sur le Chiffre d'Affaires moyen par hôtel ou sur le prix moyen d'une chambre (tarification catalogue vs panier moyen réel).
**Ce que j'ai décidé**
[1 ligne. Quel critère j'ai retenu, et pourquoi celui-là.]

 Je vais donc analyser le CA global, le CA moyen par établissement et le panier moyen par nuitée par catégorie d’hôtel.

**Ma requête** SELECT ...


SELECT 
    h.categorie, 
    COUNT(*) AS nombre_reservation_par_categorie,
    SUM(r.date_depart - r.date_arrivee) AS nombre_nuitees_totales,
    ROUND(SUM(r.montant_total), 2) AS CA_global_par_categorie,
    ROUND(AVG(r.montant_total / (r.date_depart - r.date_arrivee)), 2) AS panier_moyen_par_nuitee
FROM reservations r
JOIN chambres c ON r.chambre_id = c.chambre_id
JOIN hotels h ON h.hotel_id = c.hotel_id
WHERE UPPER(TRIM(r.statut)) NOT IN ('ANNULÉE', 'ANNULEE')
GROUP BY h.categorie
ORDER BY CA_global_par_categorie DESC;

**Le résultat**
[Les chiffres obtenus, nombre de lignes.]

Résultat : 2 lignes

4 étoiles	963	3115	550355.04	179.05
3 étoiles	845	2808	382346.09	135.64


**Ma vérification**
[Une DEUXIÈME requête, écrite autrement, qui confirme le résultat. Si elle ne confirme pas, dites-le — c'est une information.]

On inverse les jointures  (hotels au lieu de reservations) :

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

**Ma réponse, en français**
[2 ou 3 lignes. Comme si vous répondiez à la personne qui a posé la question. Aucun mot technique : ni « requête », ni « table », ni « jointure ».]

Les hôtels 4 étoiles génèrent près de 44 % de chiffre d'affaires supplémentaire par rapport aux 3 étoiles (+168 008,95 €). L'écart s'explique principalement par la valorisation de la nuitée (+32 % sur le prix moyen par nuitée), combinée à un volume d'activité plus soutenu (+13,96 % de réservations et +10,93 % de nuitées). Il y a un écart réel entre les deux catégories, et on peut signer pour le 4 étoiles.


Mission 8 — « Quel type de chambre faut-il construire ? »

**Ce que j'ai compris de la question**
[2 lignes. Qu'est-ce qu'on me demande exactement ? Qu'est-ce qui est ambigu ?]

On me demande de recommander le meilleur arbitrage entre les 4 catégories de chambres (Standard, Confort, Deluxe, Suite) pour la construction de 10 nouvelles chambres.
L'ambiguïté : La question ne précise pas si la décision doit s'appuyer sur la rentabilité pure (chiffre d'affaires et prix par nuitée) ou sur la demande réelle (taux de remplissage/volume de réservations). 
**Ce que j'ai décidé**
[1 ligne. Quel critère j'ai retenu, et pourquoi celui-là.]

Je vais donc analyser la performance financière et la tension sur l'offre pour chaque type de chambre : nombre de chambres existantes, nombre de réservations, nombre de réservations par chambre, tarif moyen catalogue, prix moyen nuitée réelle, CA total par type de chambre.

**Ma requête** SELECT ...

SELECT 
    c.type_chambre,
    COUNT(DISTINCT c.chambre_id) AS nb_chambres_existantes,
    COUNT(r.reservation_id) AS nb_reservations,
    ROUND(COUNT(r.reservation_id)::NUMERIC / COUNT(DISTINCT c.chambre_id), 1) AS reservations_par_chambre,
    ROUND(AVG(c.tarif_standard), 2) AS tarif_moyen_catalogue,
    ROUND(AVG(r.montant_total / (r.date_depart - r.date_arrivee)), 2) AS prix_moyen_nuitee_reelle,
    ROUND(SUM(r.montant_total), 2) AS CA_total
FROM chambres c
LEFT JOIN reservations r ON c.chambre_id = r.chambre_id 
    AND UPPER(TRIM(r.statut)) NOT IN ('ANNULÉE', 'ANNULEE')
GROUP BY c.type_chambre
ORDER BY CA_total DESC;

**Le résultat**
[Les chiffres obtenus, nombre de lignes.]

Résultat : 4 lignes

Confort		56	626	11.2	151.79	154.34	325440.41
Standard	64	749	11.7	105.82	107.57	265564.95
Deluxe		24	271	11.3	212.02	219.99	184111.57
Suite		16	162	10.1	299.54	309.53	157584.20


**Ma vérification**
[Une DEUXIÈME requête, écrite autrement, qui confirme le résultat. Si elle ne confirme pas, dites-le — c'est une information.]

J’utilise une sous-requête :
Cette sous-requête va sortir une table temporaire où chaque ligne correspond à un séjour sur une chambre.


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

--Résultat : identique à la requête de base

Confort		626	11.2	151.79	325440.41
Standard	749	11.7	105.82	265564.95
Deluxe		271	11.3	212.02	184111.57
Suite		162	10.1	299.54	157584.20

**Ma réponse, en français**
[2 ou 3 lignes. Comme si vous répondiez à la personne qui a posé la question. Aucun mot technique : ni « requête », ni « table », ni « jointure ».]

Pour optimiser la rentabilité de l'agrandissement, je recommande de construire en priorité une majorité de chambres Confort et Deluxe (par exemple 6 Confort et 4 Deluxe).
Les chambres Confort représentent le meilleur compromis entre un fort volume de demande et un prix maîtrisé, tandis que les catégories Deluxe et Suite dégagent un chiffre d'affaires par chambre disponible nettement supérieur aux chambres Standards. Les chambres Standards étant déjà très nombreuses dans le parc, privilégier le segment intermédiaire et supérieur maximisera le retour sur investissement.

Mission 9 — « Est-ce que nos clients reviennent ? »


**Ce que j'ai compris de la question**
[2 lignes. Qu'est-ce qu'on me demande exactement ? Qu'est-ce qui est ambigu ?]

On doit dire si la chaîne possède une vraie base de clients récurrents (qui reviennent plusieurs fois) afin de décider de la création ou non d'un programme de fidélité.
L'ambiguïté : La question ne précise pas si être « fidèle » signifie avoir effectué au moins 2 séjours sur l'ensemble de la période (2024-2025) ou revenir régulièrement à un rythme annuel/mensuel, ni si les réservations annulées doivent être exclues du comptage de la fidélité.

**Ce que j'ai décidé**
[1 ligne. Quel critère j'ai retenu, et pourquoi celui-là.]

J’affiche le  chiffre d’affaires net par client pour ceux qui ont fait plus d’une réservation.
 
**Ma requête** SELECT ...

SELECT 
    cl.client_id,
    COUNT(r.reservation_id) AS nombre_reservations_par_client,
    ROUND(SUM(r.montant_total), 2) AS ca_net_client
FROM clients cl
JOIN reservations r ON cl.client_id = r.client_id
WHERE statut!= ‘Annulée’
GROUP BY cl.client_id
HAVING COUNT(r.reservation_id) > 1
ORDER BY nombre_reservations_par_client DESC;


**Le résultat**
[Les chiffres obtenus, nombre de lignes.]

Résultat : 438 lignes.

Extrait :

325	9	6007.12
1	8	5013.28
232	8	4519.14
470	8	5362.26
128	8	2594.35
477	8	6638.33
491	8	2665.82
277	8	4644.20
294	7	5587.36
371	7	1622.89
86	7	3514.40
427	7	2546.18
52	7	4945.88
185	7	3095.11

**Ma vérification**
[Une DEUXIÈME requête, écrite autrement, qui confirme le résultat. Si elle ne confirme pas, dites-le — c'est une information.]

Je fais une sous-requête :

SELECT 
    clients_reference.client_id,
    COUNT(clients_reference.reservation_id) AS nombre_reservations_par_client,
    ROUND(SUM(clients_reference.montant_total), 2) AS ca_net_client
FROM (
    SELECT 
        cl.client_id,
        r.reservation_id,
        r.montant_total
    FROM clients cl
    JOIN reservations r ON cl.client_id = r.client_id
    WHERE statut != 'Annulée'
) AS clients_reference
GROUP BY clients_reference.client_id
HAVING COUNT(clients_reference.reservation_id) > 1
ORDER BY nombre_reservations_par_client DESC, ca_net_client DESC;

--Résultat : 438 lignes et identique à la requête de base

325	9	6007.12
477	8	6638.33
470	8	5362.26
1	8	5013.28
277	8	4644.20
232	8	4519.14
491	8	2665.82
128	8	2594.35
197	7	7964.21
262	7	6187.03


**Ma réponse, en français**
[2 ou 3 lignes. Comme si vous répondiez à la personne qui a posé la question. Aucun mot technique : ni « requête », ni « table », ni « jointure ».]

Pour répondre à cette question je propose de garder que les clients qui ont entre 5 et 9 réservations (9 étant le max identifié) car cela fait beaucoup de clients à enregistrer dans la base comme « à fidéliser ».

La reqûete suivante donne 160 clients ce qui est raisonnable à gérer.

SELECT 
    cl.client_id,
    COUNT(r.reservation_id) AS nombre_reservations_par_client,
    ROUND(SUM(r.montant_total), 2) AS ca_net_client
FROM reservations r
JOIN clients cl ON r.client_id = cl.client_id
 WHERE statut != 'Annulée'
GROUP BY cl.client_id
HAVING COUNT(r.reservation_id) BETWEEN 5 AND 9
ORDER BY nombre_reservations_par_client DESC, ca_net_client DESC;


Mission 10 — « Y a-t-il des clients qui comptent beaucoup ? »

**Ce que j'ai compris de la question**
[2 lignes. Qu'est-ce qu'on me demande exactement ? Qu'est-ce qui est ambigu ?]

On me demande d'évaluer la concentration du chiffre d'affaires sur nos principaux clients, en mesurant l'impact financier qu'aurait la perte de nos 10 plus gros clients sur l'activité globale de l'entreprise.
L'ambiguïté : La question ne précise pas si la notion de « dix meilleurs clients » s'évalue sur le Chiffre d'Affaires brut ou net d'annulations, ni s'il faut présenter le poids cumulé sous forme de montant global, de pourcentage du Chiffre d'Affaires total ou de détail client par client.

**Ce que j'ai décidé**
[1 ligne. Quel critère j'ai retenu, et pourquoi celui-là.]

Je vais fournir la liste des 10 meilleurs clients et calculer leur poids cumulé (montant et pourcentage) sur le Chiffre d'Affaires net de la chaîne. (question vue en approfondissment)

**Ma requête** SELECT ...

SELECT 
    ROUND(SUM(top10.ca_client), 2) AS ca_cumule_top10,
    ROUND((SELECT SUM(montant_total) FROM reservations WHERE statut != 'Annulée'), 2) AS ca_total_entreprise,
    ROUND(
        SUM(top10.ca_client) * 100.0 / (SELECT SUM(montant_total) FROM reservations where statut != 'Annulée'), 
        2
    ) AS part_du_ca_top10_pourcentage
FROM (
    SELECT 
        r.client_id,
        SUM(r.montant_total) AS ca_client
    FROM reservations r
    WHERE statut != 'Annulée'
    GROUP BY r.client_id
    ORDER BY ca_client DESC
    LIMIT 10
) AS top10;

**Le résultat**
[Les chiffres obtenus, nombre de lignes.]

59617.28	932701.13	6.39

**Ma vérification**
[Une DEUXIÈME requête, écrite autrement, qui confirme le résultat. Si elle ne confirme pas, dites-le — c'est une information.]

**Ma réponse, en français**
[2 ou 3 lignes. Comme si vous répondiez à la personne qui a posé la question. Aucun mot technique : ni « requête », ni « table », ni « jointure ».]

Si on perdait nos 10 meilleurs clients, cela ne fragiliserait pas l'entreprise car l’activité est très peu dépendante des plus gros clients (6,39 de part minime du chiffre d’affaires global). 


Mission 11 — « Les séjours courts sont-ils rentables ? »

**Ce que j'ai compris de la question**
[2 lignes. Qu'est-ce qu'on me demande exactement ? Qu'est-ce qui est ambigu ?]
On me demande d'évaluer la rentabilité et l'impact financier des séjours courts (1 seule nuit) par rapport aux séjours longs, sachant que les frais fixes opérationnels (comme le nettoyage de la chambre à chaque départ) sont identiques quel que soit le nombre de nuitées.
L'ambiguïté : La question ne précise pas si la "rentabilité" doit s'évaluer sur le prix moyen facturé par nuitée, sur le volume de Chiffre d'Affaires global généré par ce segment ou sur la marge nette après déduction des coûts de ménage fixes
 
**Ce que j'ai décidé**
[1 ligne. Quel critère j'ai retenu, et pourquoi celui-là.]

Je vais analyser le prix moyen de la nuitée, le panier moyen global et la part du Chiffre d'Affaires apportée par les séjours d'une nuit.

**Ma requête** SELECT …

SELECT 
    prix_reference.classement_sejour,
    COUNT(*) AS nombre_reservations,
    ROUND(AVG(prix_reference.prix_nuitee), 2) AS prix_moyen_nuitee_reelle,
    ROUND(AVG(prix_reference.montant_total), 2) AS panier_moyen_sejour,
    ROUND(SUM(prix_reference.montant_total), 2) AS CA_total_segment,
    ROUND(
        SUM(prix_reference.montant_total) * 100.0 / (
            SELECT SUM(montant_total) 
            FROM reservations 
            where statut != 'Annulée'), 2 ) AS part_du_ca_total_porcentage
FROM (
    SELECT 
        reservation_id, 
        CASE
            WHEN (date_depart - date_arrivee) = 1 THEN '1 nuit' 
            ELSE 'Plus de 1 nuit'
        END AS classement_sejour,
        montant_total,
        montant_total / (date_depart - date_arrivee) AS prix_nuitee
    FROM reservations r
    WHERE statut != 'Annulée'
) AS prix_reference
GROUP BY prix_reference.classement_sejour
ORDER BY prix_moyen_nuitee_reelle DESC;

**Le résultat**
[Les chiffres obtenus, nombre de lignes.]

Résultat : 2 lignes

1 nuit		    159	    164.13	164.13	26096.49	2.80
Plus de 1 nuit	1649	158.21	552.13	906604.64	97.20


**Ma vérification**
[Une DEUXIÈME requête, écrite autrement, qui confirme le résultat. Si elle ne confirme pas, dites-le — c'est une information.]

**Ma réponse, en français**
[2 ou 3 lignes. Comme si vous répondiez à la personne qui a posé la question. Aucun mot technique : ni « requête », ni « table », ni « jointure ».]

Les séjours d'une nuit restent rentables car ils sont facturés plus cher à la nuitée !
Même si les frais de ménage sont identiques à chaque rotation de chambre, le prix moyen d'une nuitée pour un séjour court est supérieur à celui des séjours longs. Cette tarification plus élevée permet d'absorber les coûts fixes de nettoyage tout en générant une marge très satisfaisante. De plus, les séjours d'une nuit représentent un volume d'activité indispensable pour maintenir un taux d'occupation élevé dans les établissements.

Mission 12 — « Prépare-moi le comité de lundi »

Celle-ci n’a pas de bonne réponse. Elle a des réponses défendables. Préparez la vôtre.

**Ce que j'ai compris de la question**
[2 lignes. Qu'est-ce qu'on me demande exactement ? Qu'est-ce qui est ambigu ?]

On me demande d'isoler les 3 indicateurs clés de performance (KPI) fondamentaux qui résument le mieux la santé financière, commerciale et la fiabilité opérationnelle de l'entreprise sur la période.
L'ambiguïté : La question ne précise pas quels piliers privilégier (volume, valeur, taux d'occupation, rentabilité ou taux d'annulation)

**Ce que j'ai décidé**
[1 ligne. Quel critère j'ai retenu, et pourquoi celui-là.]

Je vais retenir un triptyque équilibré : le Chiffre d'Affaires net encaisse, le Panier moyen par réservation et le Taux d'annulation global. 

**Ma requête** SELECT …


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


**Le résultat**
[Les chiffres obtenus, nombre de lignes.]

Résultat : 1 ligne :

932701.13	517.88	9.60


**Ma vérification**
[Une DEUXIÈME requête, écrite autrement, qui confirme le résultat. Si elle ne confirme pas, dites-le — c'est une information.]

**Ma réponse, en français**
[2 ou 3 lignes. Comme si vous répondiez à la personne qui a posé la question. Aucun mot technique : ni « requête », ni « table », ni « jointure ».]

L’activité repose sur des bases très saines : un volume d'affaires proche du million d'euros (soit 932701,13 euros), une excellente valeur moyenne par séjour (soit 517,88 euros) et un taux d'annulation très bas (soit 9,60%) qui sécurise les prévisions budgétaires.

Trois règles
    1. Une mission à la fois, jusqu’au bout. Six rubriques remplies avant de passer à la suivante. Trois missions finies valent mieux que huit commencées.
    2. La vérification n’est pas facultative. Un chiffre non vérifié n’est pas un résultat, c’est une hypothèse.
    3. Si deux critères donnent deux réponses différentes, dites-le. Ce n’est pas un échec de l’enquête : c’est sa conclusion.


Comment ce fichier est rendu
Vous déposez	avec vos autres livrables, même s’il ne contient qu’une seule mission.
En haut du fichier, une ligne : « Mission que je souhaite qu’on regarde : n°    ».
Le nombre de missions n’est pas évalué — ni en votre faveur, ni en votre défaveur. Seule compte celle que vous désignez. Choisissez celle dont vous êtes le plus satisfait, pas la plus difficile.
Si le socle du brief vous a pris tout votre temps, déposez le fichier avec une seule mission, ou écrivez-le en une ligne. C’est une information utile pour le formateur, pas une faute.