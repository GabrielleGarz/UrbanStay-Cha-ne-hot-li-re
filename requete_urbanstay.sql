-- La base UrbanStay, déjà installée dans votre PostgreSQL : 8 hôtels, 160 chambres, 500 clients, 2 000 réservations.

--Bloc	A	—	Compter

--A1.Combien	y	a-t-il	de	réservations en	tout ?	(c’est	l’exemple	—	recopiez-le	et	exécutez-le)

SELECT	count(*)	AS	nb_reservations
FROM	reservations;
--Résultat : 2000

--A2.Combien	y	a-t-il	d’hôtels ?

select count(*) as nombre_total_hotels from hotels ;

-- résultat : 8 hôtels


--A3.Combien	y	a-t-il	de	chambres ?

select count(*) as nombre_de_chambres from chambres;

--Résultat : 160 chambres

--A4.Combien	y	a-t-il	de	clients	?

select count(*) as nombre_de_clients from clients ;

--résultat : 500 clients


--A5.Combien	de	réservations	ont	été	annulées ?

select count(statut) as nombre_resefvations_annulees from reservations 
where statut in ('Annulée', 'annulée', 'annulee', 'Annulee');

--résultat : 192 réservations annulées

--A6.Pour	combien	de	clients	le	pays	n’est-il	pas	renseigné ?

select count(*) as clients_sans_pays_renseigne
from clients
where pays is null;

--Résultat : 15 clients dont le pays n'est pas renseigné


--A7.Exécutez	exactement	ceci,	puis	expliquez	l’écart	par	écrit	dans	votre	cahier	:

SELECT	count(*)	AS	toutes_les_lignes,
count(montant_total)	AS	lignes_avec_montant
FROM	reservations;

--Les	deux	nombres	ne	sont	pas	égaux.	Pourquoi ?	(Indice	:	relisez	A6,	c’est	le	même	phénomène.) 
--Par analogie avec la question A6, on peut penser qu'il y a des montants 'montant_total' qui ne sont pas renseignés, 
--d'où une différence de 8 lignes entre toutes_les _lignes et lignes_avec_montant. On sait que count(montant_total) 
--ne compte pas les lignes à NULL.
--pour vérifier cela on passe la requête de contrôle suivante :

select count(*) as montant_non_renseigne
from reservations 
where montant_total is null;

--Résultat : 8 lignes 
--On a donc bien 8 lignes qui ont un montant_total à NULL.

--Bloc	B	—	Sommer	et	moyenner
--Exemple	travaillé.	
--count	compte	des	lignes.	Pour additionner des valeurs, on	utilise	extrêmes,	min	et	max, sum;	
--pour une	moyenne, avg	; pour les round(...,	2) arrondit	à	deux	décimales.
--Sans	lui,	vous	obtiendrez	un	nombre	à	rallonge,	illisible	dans	un	rapport.

SELECT	round(sum(montant_total),	2)	AS	ca_brut
FROM	reservations;
--résultat : 1031627,01 euros


--B1.Quel	est	le	montant	total	de	toutes	les	réservations ?

select sum(montant_total) as montant_total_reservations
from reservations;

--résultat : 1031627,01 réservations


B2.Quel	est	le	montant	moyen	d’une	réservation	?

select round(avg(montant_total),2) as montant_moyen_reservation
from reservations;

--résultat : le montant moyen d'une réservation est de 517,89 euros


--B3.Quelle	est	la	plus	petite	et	la	plus	grosse	réservation	?	(une	seule	requête,	deux	colonnes)

select min(montant_total) as la_plus_petite_reservation, max(montant_total) as la_plus_grosse_reservation
from reservations;

--résultat : 43,56 euros pour la plus petite réservation et 3484,96 euros pour la plus grande réservation


--B4.Quel	est	le	tarif	moyen	d’une	chambre	?

select round(avg(tarif_standard), 2) as tarif_moyen_chambre
from chambres;

--résultat : le prix moyen d'une chambre est de 156,01 euros

--B5.Quel	est	le	tarif	le	plus	élevé	du	parc ?

select max(tarif_standard) as tarif_le_plus_eleve
from chambres;

--résultat : le tarif le plus elevé d'une chambre est de 359,05 euros


--B6.La	règle	du	jour.	
--Reprenez	B2,	et	ajoutez-y	le	nombre	de	réservations	sur	lequel	la	moyenne	est	calculée,	
--dans	la	même	requête.
--À	retenir,	et	pour	tout	le	reste	de	votre	vie	professionnelle	: jamais	une	moyenne	sans son	effectif	à	côté.	
--Une	moyenne calculée	sur	3	valeurs	et	une	moyenne	calculée	sur	3	000	valeurs	s’affichent	exactement	pareil.	
--L’une	veut	dire	quelque	chose,	l’autre non.	
--Celui	qui	lit	votre	rapport	ne	peut	pas	faire	la	différence	—	sauf	si	vous	lui	donnez	le	nombre.

select round(avg(montant_total),2) as montant_moyen_reservation, count(*) as nombre_de_reservations
from reservations;

--Bloc	C	—	Regrouper
--Exemple	travaillé.	Jusqu’ici	vous	obteniez	un	seul	chiffre	pour	toute	la	table.	
--GROUP	BY	permet	d’obtenir	un	chiffre	par catégorie :
SELECT	statut,	count(*)  AS	nb
FROM	reservations
GROUP	BY	statut
ORDER	BY	nb	DESC;

Lisez-la	comme	une	phrase	:	«	donne-moi	le	statut	et	le	nombre	de	lignes,	en	regroupant	les	lignes	qui	ont	le	même
--statut,	triées	du plus	grand	au	plus	petit.	»
--La	règle	à	ne	jamais	oublier	:	toute	colonne	qui	apparaît dans le	
--SELECT	et	qui	n’est	pas	dans	une	fonction	(count , sum ,	avg …) doit	figurer	dansle	 GROUP	BY.

--Si	vous	l’oubliez,	PostgreSQL	refuse	la	requête	et	vous	le	dit.	
--Lisez	le	message,	il	nomme	la	colonne fautive.

C1.Combien	de	réservations	par	statut	?	(c’est	l’exemple)

SELECT	statut,	count(*)	AS	nb
FROM	reservations
GROUP	BY	statut
ORDER	BY	nb	DESC;

--résultat : 1423 'Terminée', 385 'Confirmée' et 192 'Annulée'

--C2.Combien	de	réservations	par	canal	de	réservation	?		

select canal_reservation, count(*) as nombre_de_reservations_par_canal
from reservations 
group by canal_reservation order by nombre_de_reservations_par_canal desc;

--Comptez	le	nombre	de	lignes	du	résultat	et	notez-le.

--résultat : Site web = 772 réservations,  Booking = 595 réservations, Agence = 405 résrevations, Téléphone = 198 réservations
--booking =  booking = 9 réservations, Telephone = 9 réservations, site web = 7 réservations, BOOKING = 5 réservations

--Il	y	a	quatre	canaux chez	UrbanStay	—	est-ce	bien	ce	que	vous	obtenez	? 
--On obtient 8 canaux au lieu de 4 car il y a un problème de saisie de BOOKIB, Telephone, booking et site web qui double les lignes.


C3.Combien	de	clients	par	segment ?

select trim(segment_client), count(*) as nombre_de_clients_par_segment
from clients
group by trim(segment_client)
order by nombre_de_clients_par_segment desc;

--résultat : Loisirs = 305 clients, Business = 151 clients, Groupe = 44 clients

C4.Combien	de	clients	par	pays ?

select pays, count(*) as nombre_de_clients_par_pays
from clients
group by clients.pays order by nombre_de_clients_par_pays desc;

--résultat : France = 319 clients, Espagne = 39 clients, Royaume_Uni = 35 clients, Italie = 32 clients, Allemagne = 31 clients
--Belgique = 29 clients, NULL (non renseigné)= 15 clients

--C5.Combien	de	chambres	par	type ?

select type_chambre, count(*) as nombre_de_chambres_par_type
from chambres
group by type_chambre
order by nombre_de_chambres_par_type desc;

--résultat : Standard = 64 chambres, Confort = 56 chambres, Deluxe = 24 chambres, Suite = 16 chambres


--C6.Combien d’hôtels par catégorie ?

select categorie, count(*) as nombre_hotels_par_categorie
from hotels
group by categorie order by nombre_hotels_par_categorie desc;

--résultat : Hôtel 3 étoiles = 4, Hôtel 4 étoiles = 4 (au total on en a bien 8 hôtels)


--C7.Combien	de	chambres	par	hôtel	?	(utilisez hotel_id	—	le	nom	de	l’hôtel, ce	sera	demain)

select hotel_id, count(*) as nombre_de_chambres_par_hotel
from chambres
group by hotel_id order by nombre_de_chambres_par_hotel;

--résulatat : pour les 8 hôtels il y a 20 chambres pour chacun

--C8.Quel	montant	total	par	statut	?

select statut, sum(montant_total) as montant_total
from reservations
group by statut
order by montant_total desc;

--résultat : 3 lignes
--Terminée : 731761,88
--Confirmée : 200939,45
--Annulée : 98925,88


--C9.Quel	montant	moyen	par	canal	—	avec	l’effectif,	règle	du	bloc B.

select canal_reservation, round(avg(montant_total),2) as montant_moyen_par_canal, count(*) as nombre_effectif
from reservations
group by canal_reservation
order by montant_moyen_par_canal desc;

--résultat :site web = 761,11 euros (7 effectif), 
--BOOKING = 669,7 (5 effectif), 
--Agence = 558,27 (405 effectif)
-- Telephone = 521,14 (9 effectif), 
--Site web = 520,31 (effectif 772), 
--Téléphone = 506, 74 (198 effectif), 
--Booking = 487,78 (595 effectif), 
--booking = 455,51 (9 effectif)


--C10.Quel	tarif	moyen	par	type	de	chambre,	avec	le	nombre	de	chambres ?

select type_chambre, count(*) as nombre_de_chambres_par_type_de_chambre
from chambres
group by type_chambre order by nombre_de_chambres_par_type_de_chambre desc;

--résultat : Confort = 64 chambres, Deluxe = 24 chambres, Suite = 16 chambres


--C11.Pour	chaque	type	de	chambre,	le	tarif	le	moins	cher	et	le	plus	cher.

select type_chambre, min(tarif_standard) as le_tarif_le_moins_cher_par_chambre, max(tarif_standard) as le_tarif_le_plus_cher_par_chambre
from chambres
group by type_chambre
order by le_tarif_le_moins_cher_par_chambre asc;

--résultat : Standard : min = 86,59 et max = 125,36 ; Confort : min = 124,1 et max = 178,43 ;
-- Deluxe : min = 171,01 et max = 250,97 ; Suite : min = 247,51 et max = 358,05


--C12.Combien	de	réservations	par	année	d’arrivée	?
--Pour	extraire	l’année	d’une	date	:	extract(year	FROM	date_arrivee) 

select extract(year from date_arrivee) as annee_arrivee, count(*) as nombre_de_reservations_par_annee_arrivee
from reservations
group by annee_arrivee
order by nombre_de_reservations_par_annee_arrivee;

--résultat : année 2025 = 570 réservations, année 2024 = 1430 réservations

--Approfondissement	du	lundi

--D1.Combien	de	villes	différentes	la	table hotels	contient-elle ?
--Pour	compter	des	valeurs	distinctes	:	


select count(distinct(ville))
from hotels
group by ville;

--résultat : 8 villes (mais la typographie n'est pas correcte : on a LYON et Lyon donc compté 2 fois alors que c'est la ville de Lyon)

--Puis	exécutez	ceci	et	comparez : (upper()	met	en	majuscules,	trim()	enlève	les	espaces	au	début	et	à	la	fin.)

SELECT	count(DISTINCT	upper(trim(ville)))	AS	villes_reelles	from hotels;
--résultat : 4 villes

--Expliquez	l’écart	par	écrit :

--avec la deuxième requête on a transformé en majuscules le nom de la ville écrit en minuscule et ainsi on a réduit les doublons 
--comme BOrdeaux et bordeaux.


--D2.Combien	de	pays	différents	chez	les	clients	?

SELECT COUNT(DISTINCT TRIM(pays)) AS nombre_de_pays_differents
FROM clients
WHERE pays IS NOT NULL 
AND TRIM(pays) <> '';

--résultat : 6 pays différents


--D3.Pour	chaque	segment	:	le	nombre	de	clients	et	la	date	d’inscription	la	plus	ancienne.

select  trim(segment_client), min(date_inscription) as date_la_plus_ancienne
from clients
group by trim(segment_client)
order by date_la_plus_ancienne;

--résultat : Business : 2023-01-01 ; Loisirs : 2023-01-03 ; Groupe : 2023-02-01



--D4.Quelle	est	la	durée	moyenne	d’un	séjour,	en	nuits	?
--En PostgreSQL,	soustraire	deux	dates	donne	un	nombre	de	jours	:	date_depart - date_arrivee.

select round(avg(date_depart-date_arrivee),0) as duree_moyenne_du_sejour
from reservations;

--résultat : durée moyenne du séjour : 3 jours


--D5.La	même	chose,	mais	par	statut.

select statut, round(avg(date_depart-date_arrivee),0) as duree_moyenne_du_sejour
from reservations
group by statut
order by duree_moyenne_du_sejour;

--Résultat : Annulée : 3 jour ; Terminée : 3 jours ; Confirmée : 3 jours

--Un séjour	annulé	dure-t-il	aussi	longtemps	qu’un	séjour	terminé	?
--Oui, un séjour annulé et terminé ont 3 jours en moyenne tous les deux.


--D6.Le	chiffre	d’affaires	mois	par	mois	sur	l’année	2024.	
--Pour	obtenir	«	2024-03	»	à	partir	d’une	date	:	to_char(date_arrivee,	'YYYY-MM').

SELECT 
TO_CHAR(date_arrivee, 'YYYY-MM') AS mois, 
SUM(montant_total) AS chiffre_affaires
FROM reservations
WHERE EXTRACT(YEAR FROM date_arrivee) = 2024
GROUP BY TO_CHAR(date_arrivee, 'YYYY-MM')
ORDER BY mois;

--résultat : 12 lignes avec le CA par mois

 --D7.Reprenez C2,	mais	en	harmonisant	les	libellés avec upper(trim(canal_reservation)).

select upper(trim(canal_reservation)), count(*) as nombre_de_reservations_par_canal
from reservations 
group by upper(trim(canal_reservation)) order by nombre_de_reservations_par_canal desc;

--Résultat : 5 lignes
--SITE WEB : 779
--BOOKING : 609
--AGENCE : 405
--TÉLÉPHONE : 198
--TELEPHONE : 9


--Comptez	les	lignes	du	résultat.	
--5 lignes
--Vous	en attendiez	quatre.	Combien	en	avez-vous	?	J'en ai 8.
--Regardez	les	libellés un	par	un	et	expliquez ce	qui	se	passe :
--La fonction trim nettoie les espaces autour du libellé. La fonction upper met en majuscule le libellé. 
--Mais ceci ne règle pas le problème d'orthographe que trim et upper ne règlent pas. 
--Le nettoyage des libellé se fait par une autre méthode (python).

 --D8.Combien	de	réservations	par	jour	de	la	semaine	d’arrivée	?
--to_char(date_arrivee,	'Day')	renvoie	le	nom	du	jour
--Note : Ajouter EXTRACT(ISODOW FROM date_arrivee) permet de trier selon l'ordre logique de la semaine (1 pour Lundi, 7 pour Dimanche)

SELECT 
TO_CHAR(date_arrivee, 'Day') AS jour_de_la_semaine, 
COUNT(*) AS nombre_de_reservations
FROM reservations
GROUP BY TO_CHAR(date_arrivee, 'Day'), EXTRACT(ISODOW FROM date_arrivee)
ORDER BY EXTRACT(ISODOW FROM date_arrivee);

--résultat : affichage du nombre de réervations par le jour de la semaine (de lundi à dimanche) :
--Monday : 302
--Tuesday : 299
--Wednesday : 277
--Thursday : 252
--Friday : 304
--Saturday : 297
--Sunday : 269

--Mardi 13 octobre 2026

Bloc	A	—	Une	jointure

--Exemple	travaillé : 

SELECT	r.reservation_id,	cl.segment_client,	r.montant_total
FROM	reservations	r
JOIN	clients	cl	ON	r.client_id	=	cl.client_id
ORDER	BY	r.reservation_id
LIMIT	10;


--Trois	choses	nouvelles	:	reservations	r	donne	à	la	table	le	surnom	r.	
--On	écrit	ensuite r.montant_total	au	lieu	de	 reservations.montant_total.
--Avec	deux	ou	trois	tables,	ça	devient	indispensable.
--JOIN	clients	cl	dit	: ajoute	aussi	la	table clients ON	r.client_id	=	cl.client_id	
--dit	comment	les	relier	:	la	colonne	client_id	de	la	réservation	correspond	à	la	colonne	client_id	du	client.	
--C’est	la	ligne	la	plus	importante	de	la	requête.	
--Sans	elle,	PostgreSQL	ne	sait	pas	quelle	ligne va	avec quelle	ligne.


--A1.Affichez	les	10	premières	réservations	avec	le	segment	de	leur	client.	(c’est	l’exemple)

SELECT	r.reservation_id,	cl.segment_client,	r.montant_total
FROM	reservations	r
JOIN	clients	cl	ON	r.client_id	=	cl.client_id
ORDER	BY	r.reservation_id
LIMIT	10;

--résultat : 10 lignes 


--A2.Combien de	réservations ont	été	faites	par	des	clients	du	segment	Business?

SELECT 
    TRIM(cl.segment_client) AS segment_client, 
    COUNT(*) AS nombre_reservations_client
FROM reservations r
JOIN clients cl ON r.client_id = cl.client_id
WHERE TRIM(cl.segment_client) = 'Business'
GROUP BY TRIM(cl.segment_client);

--résultat : 578 clients Business


--A3.Combien	de	réservations	portent	sur	une	chambre	de	type Suite	?

select c.type_chambre, count(*) as nombre_de_reservation_Suite
from reservations r
join chambres c on r.chambre_id = c.chambre_id
where c.type_chambre = 'Suite'
group by c.type_chambre;

--résultat : 180 réservations


--A4.Combien	de	réservations par segment client ?

select trim(cl.segment_client), count(*) as nombre_de_reservations_par_segment_client
from reservations r
join clients cl on r.client_id = cl.client_id
group by trim(cl.segment_client) order by  nombre_de_reservations_par_segment_client desc;


--A5.Combien	de	réservations par type de chambre? 

select c.type_chambre, count(*) as nombre_de_reservation_type_chambre
from reservations r
join chambres c on r.chambre_id = c.chambre_id
group by c.type_chambre
order by nombre_de_reservation_type_chambre desc;

--résultat : 4 lignes : Standard = 834 ; Confort = 684 ; Deluxe = 302 ; Suite = 180

--A6.	Montant	moyen	par	type	de	chambre, avec l’effectif.

select c.type_chambre, round(avg(montant_total),2) as montant_moyen_par_type_de_chambre, count(*) as effectif
from reservations r
join chambres c on r.chambre_id = c.chambre_id
group by c.type_chambre
order by montant_moyen_par_type_de_chambre desc;

--résultat : Suite : 986,66 euros et 180 effectif ; Deluxe : 692,88 euros et 302 effectif
-- Confort : 520,75 euros et 684 effectif ; Standard : 350,62 euros et 834 effectif

--A7.Montant moyen par segment	client,	avec l’effectif.

select trim(cl.segment_client), round(avg(montant_total), 2) as montant_moyen_par_segment_client, count(*) as effectif
from reservations r
join clients cl on r.client_id = cl.client_id
group by trim(cl.segment_client) order by   montant_moyen_par_segment_client desc;

--résultat : Groupe : 722,31 euros et 182 effectif ; Loisirs : 551,99 euros et 1240 effectif
--Business : 380,22 euros et 578 effectif 


--A8.Nombre	de	réservations par pays du client.;

select pays, count(*) as nombre_de_reservations_par_pays_du_client
from reservations r
join clients cl on r.client_id = cl.client_id
group by pays order by   nombre_de_reservations_par_pays_du_client desc;

--résultat : France : 1260 réservations ; Espagne : 149 réservations ; Royaume-Uni : 141 réservations ; Allemagne : 128 réservations
--Italie : 128 réservations ; Belgique : 127 réservations ; Pays non renseigné (NULL) : 67 réservations

--A9.Durée	moyenne	du	séjour	par	segment	client.	Quel segment	reste	le	plus	longtemps ?

select trim(cl.segment_client), round(avg(date_depart - date_arrivee), 0) as moyenne_du_sejour
from reservations r
join clients cl on r.client_id = cl.client_id
group by trim(cl.segment_client) order by  moyenne_du_sejour desc;

--résultat : Loisirs : 4 jours ; Groupe : 4 jours ;  Business : 2 jours
--Le segment qui reste le plus longtemps est Loisirs.

--Bloc	B	—	Deux	jointures
--Exemple	travaillé :
--reservations	ne	connaît	pas	hôtels. Mais reservations connaît chambres , et	chambres connaît hotels.	
--On passe	donc par	le	milieu :

SELECT	h.nom_hotel,	count(*)	AS	nb_reservations
FROM	reservations r
JOIN	chambres	c	ON	r.chambre_id	=	c.chambre_id
JOIN	hotels	h	ON	c.hotel_id	=	h.hotel_id
GROUP	BY	h.nom_hotel
ORDER	BY	nb_reservations	DESC;

--Chaque JOIN rajoute une table, ON	dit	comment	l’accrocher	à	ce	qui	précède.	On	peut	en	enchaîner	autant	qu’on	veut.


--B1.Combien	de	chambres	dans	chaque	hôtel	—	avec	le	nom	de	l’hôtel, cette	fois ?	(une	seule	jointure	suffit)

select h.nom_hotel, count(*) as nombre_de_chambres_par_hotel
from chambres c
join hotels h on c.hotel_id = h.hotel_id
group by h.nom_hotel order by nombre_de_chambres_par_hotel desc;

--résultat : 
--UrbanStay Paris Opéra : 20 chambres
--UrbanStay Bordeaux Saint-Jean : 20 chambres
--UrbanStay Paris République : 20 chambres
UrbanStay Marseille Vieux-Port : 20 chambres
UrbanStay Marseille Joliette : 20 chambres
UrbanStay Lyon Confluenec : 20 chambres
UrbanStay Lyon Part-Dieu : 20 chambres
UrbanStay Bordeaux Quinconces : 20 chambres


--B2.Combien	de	réservations	par	hôtel	?	(c’est	l’exemple)

SELECT	h.nom_hotel,	count(*)	AS	nb_reservations
FROM	reservations r
JOIN	chambres	c	ON	r.chambre_id	=	c.chambre_id
JOIN	hotels	h	ON	c.hotel_id	=	h.hotel_id
GROUP	BY	h.nom_hotel
ORDER	BY	nb_reservations	DESC;

--résultat :
--UrbanStay Paris Opéra : 293 réservations
--UrbanStay Paris République : 278 réservations
--UrbanStay Marseille Vieux-Port : 276 réservations
--UrbanStay Bordeaux Quinconces : 266 réservations
--UrbanStay Lyon Confluence : 262 réservations
--UrbanStay Part-Dieu : 228 réservations
--UrbanStay Bordeaux Saint6jean : 199 réservations
--UrbaStay Marseille Joliette : 198 réservations



--B3.Quel	est	le	chiffre	d’affaires	par	hôtel,	avec	le	nombre	de	réservations ?

select h.nom_hotel, count(*) as nombre_de_reservations_par_hotel
from reservations r
join chambres c on r.chambre_id  = c.chambre_id 
join hotels h on c.hotel_id = h.hotel_id 
group by h.nom_hotel order by nombre_de_reservations_par_hotel DESC;

--résultat :
--UrbanStay Opéra : 293
--UrbanStay Paris République : 278
--UrbanStay Marseille Vieux-Port : 276
--UrbanStay Bordeaux Quinconces : 266
--UrbanStay Lyon Confluence : 262
--UrbanStay Lyon Part-Dieu : 228
--UrbanStay Bordeaux Saint-Jean : 199
--UrbanStay Marseille Joliette : 198 



--B4.Quel	est	le	chiffre	d’affaires	par	catégorie	d’hôtel	(3	ou	4	étoiles)	?

select h.categorie, round(sum(r.montant_total),2) as CA_par_categorie_hotel
from reservations r
join chambres c on r.chambre_id  = c.chambre_id 
join hotels h on c.hotel_id = h.hotel_id 
group by h.categorie order by CA_par_categorie_hotel DESC;

--résultat : 4 étoiles : 609694,08 euros ; 3 étoiles : 421932,93 euros


--B5.Combien	de	réservations	annulées	par	hôtel	?

select h.nom_hotel, count(*) as total_reservations_annulees
from reservations r
join chambres c on r.chambre_id  = c.chambre_id 
join hotels h on c.hotel_id = h.hotel_id 
where r.statut = 'Annulée'
group by h.nom_hotel order by total_reservations_annulees DESC;

--résultat :
--UrbanStay Bordeaux Quinconces : 33
--UrbanStay Lyon Confluence : 29
--Urbanstay aris Opéra : 25
--Urbanstay Paris République : 24
--Urbanstay Marseille Vieux-Port : 23
--Urbanstay Marseille Joliette : 21
--Urbanstay Lyon Part-Dieu : 19
--Urbanstay Bordeaux Saint-Jean : 18



--B6.Combien	de	réservations	par	hôtel	et	par	type	de	chambre	?
--Deux	colonnes	dans	le	nombre	de	lignes	du	résultat	et	expliquez-le.

select trim(h.nom_hotel), c.type_chambre, count(*) as total_reservations_par_hotel_et_type_chambre
from reservations r
join chambres c on r.chambre_id  = c.chambre_id 
join hotels h on c.hotel_id = h.hotel_id 
group by trim(h.nom_hotel), c.type_chambre order by total_reservations_par_hotel_et_type_chambre DESC;

--résultat :
--UrbanStay Paris Opéra : Standard/130
--UrbanStay Lyon Confluence : Standard/114
--UrbanStay Paris République : Standard/113
--UrbanStay Bordeaux Quinconces : Standard/108
--UrbanStay Marseille Vieux-Port : Standard/106
--UrbanStay Marseille Vieux-Port : Confort/105
--UrbanStay Paris République : Confort/103
--UrbanStay Lyon Part-Dieu : Standard/102
--UrbanStay Paris Opéra : Confort/99
--UrbanStayLyon Confluence : Confort/90
--UrbanStay Bordeaux Quinconces : Confort/86
--UrbanStay Bordeaux Saint-Jean : Standard/82
--UrbanStay Marseille Joliette : Standard/79
--UrbanStay Lyon Part-Dieu : Confort/78
--UrbanStay Marseille Joliette : Confort/64
--UrbanStay Bordeaux Saint-Jean : Confort/59
--UrbanStay Bordeaux Quinconces : Deluxe/46
--UrbanStay Marseille Vieux-Port : Deluxe/44
--UrbanStay Paris Opéra : Deluxe/42
--UrbanStay Marseille Joliette : Deluxe/37
--UrbanStay Paris République : Deluxe/36
--UrbanStay Lyon Confluence : Deluxe/35
--UrbanStay Bordeaux Saint-Jean : Deluxe/31
--UrbanStay Lyon Part-Dieu : Deluxe/31
--UrbanStay Bordeaux Saint-Jean : Suite/27
--UrbanStay Paris République : Suite/26
--UrbanStay Bordeaux Quinconces : Suite/26
--UrbanStay Lyon Confluence : Suite/23
--UrbanStay Paris Opéra : Suite/22
--UrbanStay Marseille Vieux-Port : Suite/21
--UrbanStay Marseille Joliette : Suite/18
--UrbanStay Lyon Part-Dieu : Suite/17


--B7.Chiffre	d’affaires	par	catégorie	d’hôtel	et	par	segment	client.	(trois	jointures)

select h.categorie, trim(cl.segment_client), round(sum(montant_total),2) as CA_par_categorie_hotel
from reservations r
join clients cl on r.client_id = cl.client_id
join chambres c on r.chambre_id  = c.chambre_id 
join hotels h on c.hotel_id = h.hotel_id 
group by h.categorie, trim(cl.segment_client) order by CA_par_categorie_hotel DESC;

--Bloc	C	—	Ce	que	la	jointure	fait	disparaître
--Exemple	travaillé :	
--Un JOIN	ne	garde	que	les	lignes	qui	trouvent	un	correspondant.	
--Un	client	qui	n’a	jamais	réservé	n’apparaît dans	aucune	ligne	du	résultat.	
--Il	disparaît,	et	rien	ne	vous	le	signale.
--LEFT	JOIN	garde	toutes	les	lignes	de	la	table	de	gauche,	même	celles	sans	correspondant	—	
--les	colonnes	de	droite	valent	alors :

SELECT	count(*)	AS	clients_sans_reservation
FROM	clients	cl
LEFT	JOIN	reservations	r	ON	r.client_id	=	cl.client_id
WHERE	r.reservation_id	IS	NULL;

--résultat : 8 clients sans réservation

--La	condition	null WHERE	r.reservation_id	IS	NULL	ne	garde	que	les	lignes	où	la	partie	droite	est	vide	—	
--donc	exactement	les	clients	sans réservation.

--C1.Combien	de	clients	n’ont	jamais	réservé	?	(c’est	l’exemple)

SELECT	count(*)	AS	clients_sans_reservation
FROM	clients	cl
LEFT	JOIN	reservations	r	ON	r.client_id	=	cl.client_id
WHERE	r.reservation_id	IS	NULL;

--résultat : 8 clients sans réservation

--C2.Affichez-les,	avec	leur	pays	et	leur	segment.

SELECT	cl.pays, trim(cl.segment_client), count(*)	AS	clients_sans_reservation_par_pays_et_segment
FROM	clients	cl
LEFT	JOIN	reservations	r	ON	r.client_id	=	cl.client_id
WHERE	r.reservation_id	IS	null
group by cl.pays, trim(cl.segment_client)
order by clients_sans_reservation_par_pays_et_segment;

--résultat :
--Belgique : Loisirs / 1
--France : Groupe / 1
--Royaume-Uni : Loisirs / 1
--France : Loisirs / 2
--France : Business / 3


--C3.Combien	de	chambres	n’ont	jamais	été	réservées	?	
-->	Attention	:	un	résultat	à	zéro	n’est	pas	forcément	une	erreur.	
--Relise zvotre	requête,	puis	relisez	la	question.


select count(*) as chambres_jamais_reservees
from chambres c
left join reservations r on c.chambre_id = r.chambre_id
where r.chambre_id is null;

--résultat 0
--COUNT(*) : compte le nombre total de ces chambres. 
--Si le résultat renvoie 0, cela signifie simplement que toutes les chambres du parc Novatel ont été réservées au moins une fois !

--C4.Exécutez	ceci	et	expliquez	les	trois	nombres	par	écrit	:

SELECT	(SELECT	count(*)	FROM	clients)	AS	tous_les_clients,
(SELECT	count(DISTINCT	cl.client_id)	FROM	clients	cl
JOIN	reservations	r	ON	r.client_id	=	cl.client_id)	AS	vus_par_un_join,
(SELECT	count(DISTINCT	cl.client_id)	FROM	clients	cl
LEFT	JOIN	reservations	r	ON	r.client_id	=	cl.client_id)	AS	vus_par_un_left_join;

--résulat : 
--tous_les_clients : 500 : la requête compte toutes les lignes de la table clients. 
--C'est le volume total de la table clients (le référentiel client).
--vus_par_un_join 492 : 
--La requête compte le nombre de clients uniques/distincts qui ont effectué au moins une réservation (les clients communs aux deux tables)
--vus_par_un_left_join : 500 : La requête ramène toutes les lignes de la table de gauche soit resevations qu'il y aient reservé ou pas.

--Approfondissement	du	mardi

--D1.	Le	contrôle	anti-gonflement.	
--Une	jointure	mal	écrite	peut	multiplier	vos	lignes	sans	aucun	message	d’erreur,	
--et	votre	chiffre d’affaires	devient	faux.	
--Vérifiez-le	:

SELECT	(SELECT	count(*)	FROM	reservations)	AS	avant,
(SELECT	count(*)	FROM	reservations	r
JOIN	chambres	c	ON	r.chambre_id	=	c.chambre_id
JOIN	hotels	h			ON	c.hotel_id			=	h.hotel_id)	AS	apres;

--résultat :
--avant : 2000
--apres : 2000

--Les	deux	nombres	doivent	être	identiques.	
--Prenez	l’habitude	de	faire	ce	contrôle	à	chaque	fois	que	vous	ajoutez	une	jointure	à
--une	requête	qui	calcule	une	somme.


--D2.	Quel	est	le	panier	moyen	par	hôtel	?	Classez	du	plus	élevé	au	plus	faible.

select h.nom_hotel, round(avg(r.montant_total), 2) as panier_moyen_par_hotel, count(*) as nombre_de_reservations
from hotels h
join chambres c on c.hotel_id = h.hotel_id
join reservations r on r.chambre_id = c.chambre_id 
group by h.nom_hotel
order by panier_moyen_par_hotel desc;

--résultat :
--UrbanStay Bordeaux Quinconces : 601,6 / reservations : 266
--UrbanStay Marseille Vieux-Port : 582,36 / reservations : 276
--UrbanStay Lyon Part-Dieu : 578,03 / reservations : 228
--UrbanStay Paris Opéra : 548,08 / reservations : 293
--UrbanStay Bordeaux Saint-Jean : 472,75 / reservations : 199
--UrbanStay Marseille Joliette : 468,5 / reservations : 198
--UrbanStay Paris République : 448,91 / reservations : 278
--UrbanStay Lyon Confluence : 424,39 / reservations : 262



--D3.Quel	est	le	tarif	moyen	affiché	par	hôtel	—	
--en partant	de	chambres ,	sans	passer	par	reservations ?

select h.nom_hotel, round(avg(c.tarif_standard), 2) as panier_moyen_par_hotel, count(*) as nombre_de_chambres
from hotels h
join chambres c on c.hotel_id = h.hotel_id
group by h.nom_hotel
order by panier_moyen_par_hotel desc;

--résultat :
--UrbanStay Bordeaux Quinconces : 178,85 / chambres : 20
--UrbanStay Lyon Part-Dieu : 178,31 / chambres : 20
--UrbanStay Marseille Vieux-Port : 177,84 / chambres : 20
--UrbanStay Paris Opéra : 176,15 / chambres : 20
--UrbanStay Lyon Confliuence : 135,03 / chambres : 20
--UrbanStay Marseille Joliette : 134,49 / chambres : 20
--UrbanStay Paris République : 133,77 / chambres : 20
--UrbanStay Bordeaux Saint-Jean : 133,66 / chambres : 20

-- En quoi ce chiffre est-il différent de D2 ?

--la requête D3 calcule le prix théorique moyen d'une seule nuitée (prix catalogue de la chambre)
--la requête D2 calcule le montant total dépensé par transaction, 
--qui cumule plusieurs nuitées réservées (ainsi que d'éventuelles variations tarifaires ou promotions).


--D4.	Pour	les	clients	étrangers	uniquement	:	nombre	de	réservations	par	pays	et	par	segment.

select cl.pays, trim(cl.segment_client) as segment_client, count (*) as nombre_de_reservations_par_pays_segment_hors_France
from clients cl
left join reservations r on cl.client_id = r.client_id 
where cl.pays != 'France'
group by cl.pays, trim(cl.segment_client)
order by  nombre_de_reservations_par_pays_segment_hors_France desc;

--résultat : 15 lignes 
--Royaume-Uni : Loisirs / 94
--Allemagne : Loisirs / 86
--Italie : Loisirs / 85
--Espagne : Loisirs / 76
--Belgique : Loisirs / 66
--Espagne : Business / 64
--Belgique : Business / 43
--Royaume-Uni : Business / 40
--Italie : Business / 30
--Allemagne : Business / 28
--Belgique : Groupe / 19
--Allemagne : Groupe / 14
--Italie : Groupe / 13
--Espagne : Groupe / 9
--Royaume-Uni : Groupe / 8


--D5.	Combien	de	réservations	ont	été	faites	par	un	client	dont	le	pays	n’est	pas	renseigné	?

SELECT cl.pays, COUNT(r.reservation_id) AS nombre_reservations_sans_pays
FROM reservations r
JOIN clients cl ON r.client_id = cl.client_id
WHERE cl.pays IS NULL OR TRIM(cl.pays) = ''
group by cl.pays;

--résultat : 67 pays non renseignés
--Note : Le JOIN ne garde que les lignes où une réservation existe réellement et où le client correspondant n'a pas de pays.
--Un client sans pays qui n'a jamais réservé est automatiquement exclu du résultat, ce qui évite de compter des "fausses" réservations.

--D6.Pour	chaque	hôtel	:	le	nombre	de	réservations et le	nombre	de	clients	différents.	
--Les	deux	nombres	ne	sont	pas	les	mêmes - pourquoi ?


SELECT h.nom_hotel, count(distinct r.client_id) as nombre_clients_differents, count(r.reservation_id) as nombre_reservations
FROM reservations r
JOIN chambres c ON r.chambre_id = c.chambre_id
join hotels h on h.hotel_id = c.hotel_id
group by h.nom_hotel
order by nombre_reservations;

--Jour 3	·	mercredi	14	octobre

--Bloc	A	—	Filtrer	des	groupes	:	
--HAVING
--WHERE	élimine	des	lignes	avant	le	regroupement.	
--GROUP	BY	colonne	HAVING	count(*)	>	250
--HAVING	élimine	des	groupes	après.

--A1.Quels	hôtels	ont	plus	de	250	réservations ?

SELECT h.nom_hotel, count(*) AS nombre_reservations_par_hotel
FROM reservations r
JOIN chambres c ON r.chambre_id = c.chambre_id
JOIN hotels h ON h.hotel_id = c.hotel_id
WHERE r.statut != 'Annulée'
GROUP BY h.nom_hotel
HAVING count(*) > 250
order by nombre_reservations_par_hotel desc;

--résultat : 2 lignes

--UrbanStay Paris Opéra				268
--UrbanStay Paris République		254
--UrbanStay Marseille Vieux-Port	253


--A2.De	quels	pays	viennent	plus	de	100	réservations ?

select cl.pays, count(*) as nombre_reservations_par_pays
from reservations r
join clients cl on r.client_id = cl.client_id
where r.statut != 'Annulée'
group by cl.pays
having count(*) > 100
order by  nombre_reservations_par_pays asc;

--résultat : 6 lignes 

--Italie		112
--Belgique	113
--Allemagne	117
--Royaume-Uni	129
--Espagne		132
--France		1153

--A3.	Quels	hôtels	ont	un	panier	moyen	supérieur	à	500	€	?
--note : à ne pas faire

--A4.	Parmi	les	réservations	non	annulées	uniquement,	quels	hôtels	dépassent	200	réservations ?
--Cette	question	demande	les	deux	à la fois.	Réfléchissez	à	ce	qui	va	dans WHERE	et	
--ce	qui	va	dans HAVING	—	et	pourquoi	l’inverse	ne	marcherait	pas.

SELECT h.nom_hotel, count(*) AS nombre_reservations_par_hotel
FROM reservations r
JOIN chambres c ON r.chambre_id = c.chambre_id
JOIN hotels h ON h.hotel_id = c.hotel_id
WHERE r.statut != 'Annulée'
GROUP BY h.nom_hotel
HAVING count(*) > 200
order by nombre_reservations_par_hotel desc;

--résultat : 6 lignes

--UrbanStay Paris Opéra			268
--UrbanStay Paris République		254
--UrbanStay Marseille Vieux-Port	253
--UrbanStay Lyon Confluence		233
--UrbanStay Bordeaux Quinconces	233
--UrbanStay Lyon Part-Dieu		209


--A5.	Quels	clients	ont	fait	au	moins	8	réservations ?

select client_id, count(*)
from reservations
group by client_id
having count (*) >= 8
order by client_id;

--résultat : 11 lignes

--1		8
--35	8
--53	8
--86	9
--103	8
--128	9
--197	8
--232	8
--277	9
--325	9
--441	8


--A6.	Quels	types	de	chambre	ont	un	tarif	moyen	supérieur	à	200	€	?

select type_chambre, round(avg(tarif_standard),2) as tarif_moyen_chambre
from chambres
group by type_chambre
having round(avg(tarif_standard),2)> 200
order by tarif_moyen_chambre desc;

--résultat : 2 lignes

--Suite		300.79
--Deluxe	209.81
 

A7.	Quels	mois	de	2024	ont	dépassé	100	000	€	de	chiffre	d’affaires	?


SELECT 
TO_CHAR(date_arrivee, 'YYYY-MM') AS mois,
ROUND(SUM(montant_total), 2) AS chiffre_affaires_par_mois_annee_2024
FROM reservations
WHERE EXTRACT(YEAR FROM date_arrivee) = 2024
  AND statut != 'Annulee'
GROUP BY TO_CHAR(date_arrivee, 'YYYY-MM')
HAVING SUM(montant_total) > 100000
ORDER BY mois;

--résultat : 3 lignes 

2024-06	105113.45
2024-07	151629.01
2024-08	121057.50


--A8.	Par	écrit,	dans	votre	cahier,	en	trois	lignes	:	
--quelle	est	la	différence	entre	WHERE et HAVING ? Donnez un cas où mettre la condition dans	l’un 
--ou dans l’autre	ne	donne	pas	le	même	résultat.

--WHERE filtre les lignes individuelles de la table avant tout regroupement ou calcul d'agrégation.

--HAVING filtre les résultats après l'exécution du GROUP BY, en s'appuyant directement sur une fonction d'agrégation (SUM, COUNT, AVG).

--Exemple : Je regarde la capacite totale > 5 par type de chambre :

SELECT 
type_chambre, 
SUM(capacite) AS capacite_totale
FROM chambres
WHERE capacite > 5
GROUP BY type_chambre
ORDER BY capacite_totale DESC;

--résultat : 0 lignes (aucune chambre n'est aussi grande car capacité comprise entre 1 et 4).

SELECT 
type_chambre, 
SUM(capacite) AS capacite_totale
FROM chambres
GROUP BY type_chambre
HAVING SUM(capacite) > 5
ORDER BY capacite_totale DESC;

--résultat : 4 lignes

Standard	128
Confort		112
Deluxe		72
Suite		64

-- Explication du résultat :
--On additionne la capacité de toutes les chambres d'une même catégorie 
--puis on vérifie si ce total dépasse 5. 
--Résultat = Toutes les catégories apparaissent, car leur capacité cumulée dépasse largement 5.



--Bloc	B	—	Compter	sous	condition	:	CASE	WHEN

--CASE	WHEN	fabrique	une	valeur	selon	une	condition.	
--Placé	à	l’intérieur	d’un sum() ,	il	compte	une	sous-population.
--CASE	WHEN	condition	THEN	valeur	WHEN	autre_condition	THEN	valeur	ELSE	valeur	END
--sum(CASE	WHEN	condition	THEN	1	ELSE	0	END)


--B1.Classez	chaque	réservation	en	Petite	(moins	de	300	€),	Moyenne	(300	à	800	€)	ou	Grosse.	
--Affichez	les	15	premières.

select reservation_id, montant_total,
CASE 
	when montant_total < 300 then 'Petite'
	when montant_total between 300 and 800 then 'Moyenne'
	else 'Grosse'
	end as categorie_montant
from reservations
limit 15; 

--résultat : 15 lignes

--1		1490.98	Grosse
--2		393.12	Moyenne
--3		370.66	Moyenne
--4		430.00	Moyenne
--5		933.87	Grosse
--6		1403.06	Grosse
--7		355.91	Moyenne
--8		132.01	Petite
--9		299.30	Petite
--10	996.44	Grosse
--11	318.45	Moyenne
--12	1119.19	Grosse
--13	255.82	Petite
--14	333.88	Moyenne
--15	712.72	Moyenne



--B2.Combien	de	réservations	dans	chaque	catégorie	?
--Attention	au	nombre	de	lignes	que	vous	obtenez.	
--Il	y	a	trois	catégories	—	en voyez-vous	trois	?

SELECT 
    CASE 
        WHEN montant_total < 300 THEN 'Petite'
        WHEN montant_total BETWEEN 300 AND 800 THEN 'Moyenne'
        ELSE 'Grosse'
    END AS categorie_montant,
    COUNT(*) AS nombre_reservations_par_categorie
FROM reservations
GROUP BY categorie_montant
ORDER BY nombre_reservations_par_categorie DESC;

--B3.Le	geste	de	la	journée.	Pour	chaque	hôtel	:
--le nombre	total	de	réservations, le	nombre	d’annulées,	et	le	taux d’annulation en pourcentage.

SELECT 
    h.nom_hotel AS nom_hotel,
    COUNT(CASE WHEN r.statut = 'Annulée' THEN 1 END) AS nombre_reservations_annulees,
    COUNT(r.reservation_id) AS nombre_total_reservations,
    ROUND(COUNT(CASE WHEN r.statut= 'Annulée' THEN 1 END) * 100.0 / COUNT(r.reservation_id), 2 ) AS taux_annulation_reservations
FROM reservations r
JOIN chambres c ON c.chambre_id = r.chambre_id
JOIN hotels h ON h.hotel_id = c.hotel_id
GROUP BY h.nom_hotel
ORDER BY nombre_reservations_annulees DESC;

--résultat : 8 lignes (car 8 hôtels)

--UrbanStay Bordeaux Quinconces		33	266	12.41
--UrbanStay Lyon Confluence			29	262	11.07
--UrbanStay Paris Opéra				25	293	8.53
--UrbanStay Paris République		24	278	8.63
--UrbanStay Marseille Vieux-Port	23	276	8.33
--UrbanStay Marseille Joliette		21	198	10.61
--UrbanStay Lyon Part-Dieu			19	228	8.33
--UrbanStay Bordeaux Saint-Jean		18	199	9.05

--B4.Le	même	taux,	mais	par	canal	de	réservation.	
--(Vous	savez	depuis	lundi	ce	qu’il	faut	faire	aux	libellés.)

SELECT 
    upper(trim(canal_reservation)) as canal_trimé_majuscules,
    COUNT(CASE WHEN statut = 'Annulée' THEN 1 END) AS nombre_reservations_annulees_par_canal,
    COUNT(reservation_id) AS nombre_total_reservations,
    ROUND(COUNT(CASE WHEN statut= 'Annulée' THEN 1 END) * 100.0 / COUNT(reservation_id), 2 ) AS taux_annulation_reservations
FROM reservations
GROUP by upper(trim(canal_reservation))
ORDER BY nombre_reservations_annulees_par_canal DESC;

--résultat : 5 lignes au lieu de 4 (problème de typo pas réglé)

SITE WEB	68	779	8.73
BOOKING		59	609	9.69
AGENCE		40	405	9.88
TÉLÉPHONE	23	198	11.62
TELEPHONE	2	9	22.22


--B5.	Le	même	taux,	par	segment	client.	(Même	remarque,	et	c’est	plus	traître.) 
--à ne pas faire

--B6.	Par	hôtel,	côte	à	côte	dans	la	même	requête	:	
--le	CA	des	réservations	retenues	et	le	CA	des	annulées.
--à ne pas faire

--B7.	Classez	les	séjours	en	«	1	nuit	»,	«	2	à	3	nuits	»,	«	4	nuits	et	plus	».	
--Pour	chaque	classe	:	combien,	et	quel	panier	moyen	?

SELECT 
    CASE 
        WHEN (date_depart - date_arrivee) = 1 THEN '1 nuit'
        WHEN (date_depart - date_arrivee) between 2 and 3 THEN '2 à 3 nuits'
        ELSE '4 nuits et plus'
    END AS classement_sejour,
    COUNT(*) AS nombre_reservations_par_sejour,
    round(avg(montant_total),2) as panier_moyen_par_sejour
from reservations
group by classement_sejour
ORDER BY classement_sejour asc;

--résultat : 3 lignes (car on a 4 types de séjours) 

--1 nuit			177	161.89
--2 à 3 nuits		1045	405.61
--4 nuits et plus	778		749.41

--Bloc	C	—	Se	comparer	à	un	repère	:	les	sous-requêtes


--Une	requête	peut	en	contenir	une	autre,	entre	parenthèses,	à	la	place	d’une	valeur.
--WHERE	montant_total	>	(SELECT	avg(montant_total)	FROM	reservations)

--C1.Quelles	réservations	dépassent	le	montant	moyen	?	Les	10	plus	grosses.

SELECT 
    reservation_id, 
    montant_total,
    ROUND((SELECT AVG(montant_total) FROM reservations), 2) AS panier_moyen_global
FROM reservations
WHERE statut != 'Annulée'
  AND montant_total > (SELECT AVG(montant_total) FROM reservations)
ORDER BY montant_total DESC
LIMIT 10;

--résultat : 10 lignes

1532	3484.96		517.89
1932	2665.44		517.89
973		2649.32		517.89
1214	2427.33		517.89
1389	2300.99		517.89
706		2292.20		517.89
1734	2289.23		517.89
652		2246.73		517.89
854		2204.72		517.89
1179	2156.56		517.89

--C2.Combien	y	en	a-t-il	au	total	?

SELECT 
    reservation_id, 
    montant_total,
    ROUND((SELECT AVG(montant_total) FROM reservations), 2) AS panier_moyen_global,
    (select count(*) from reservations where statut != 'Annulée' and montant_total > (SELECT AVG(montant_total) from reservations)) as total_reservations_superieures_panier_moyen
FROM reservations
WHERE statut != 'Annulée'
  AND montant_total > (SELECT AVG(montant_total) from reservations)
ORDER by montant_total DESC;

--résultat : 659 réservations

--C3.Quelles	chambres	sont	plus	chères	que	le	tarif	moyen	du	parc ?
--à ne pas faire

--C4.	Combien	de	clients	différents	ont	séjourné	à	UrbanStay	Paris	Opéra	?	
--Lisez	la	question	deux	fois.	
--On vous demande	des	clients, pas des séjours.

SELECT h.nom_hotel,
    COUNT(DISTINCT r.client_id) AS nombre_clients_differents_paris_opera
FROM reservations r
JOIN chambres c ON r.chambre_id = c.chambre_id
JOIN hotels h ON c.hotel_id = h.hotel_id
WHERE r.statut != 'Annulée'
  AND TRIM(h.nom_hotel) = 'UrbanStay Paris Opéra'
  AND (r.date_depart - r.date_arrivee) >= 1
group by h.nom_hotel;

--résultat : 208 clients

--UrbanStay Paris Opéra	208

--C5.Quelle	part du	CA	total	chaque	hôtel	représente-t-il, en	pourcentage	?
--à ne pas faire

--Approfondissement	du	mercredi


--D1.Quels	hôtels	ont	un	taux	d’annulation	supérieur	à	la	moyenne	générale	?	
--(une	sous-requête	dans	un	HAVING )

SELECT 
    h.nom_hotel,
    COUNT(CASE WHEN r.statut = 'Annulée' THEN 1 END) AS nombre_reservations_annulees_par_hotel,
    COUNT(r.reservation_id) AS nombre_total_reservations,
    ROUND(COUNT(CASE WHEN r.statut = 'Annulée' THEN 1 END) * 100.0 / COUNT(r.reservation_id), 2
    ) AS taux_annulation_reservations_par_hotel,
    (SELECT ROUND( COUNT(CASE WHEN statut = 'Annulée' THEN 1 END) * 100.0 / COUNT(*), 2) FROM reservations
    ) AS taux_annulation_moyen_general
FROM reservations r
JOIN chambres c ON r.chambre_id = c.chambre_id
JOIN hotels h ON c.hotel_id = h.hotel_id
GROUP BY h.nom_hotel
HAVING 
    ROUND(COUNT(CASE WHEN r.statut = 'Annulée' THEN 1 END) * 100.0 / COUNT(r.reservation_id), 2) > (
        SELECT ROUND(COUNT(CASE WHEN statut = 'Annulée' THEN 1 END) * 100.0 / COUNT(*), 2)
        FROM reservations)
ORDER BY taux_annulation_reservations_par_hotel DESC;

--résultat : 3 lignes

--UrbanStay Bordeaux Quinconces		33	266	12.41	9.60
--UrbanStay Lyon Confluence			29	262	11.07	9.60
--UrbanStay Marseille Joliette		21	198	10.61	9.60



--D2.Le	top	10	des	clients	par	chiffre	d’affaires,	avec	leur	segment	et	leur	nombre	de	réservations.

select r.client_id, upper(trim(cl.segment_client)) as segment_client,
round(sum(r.montant_total), 2) as CA_par_client_par_segment,
count(*) as nombre_reservations
FROM reservations r
JOIN clients cl on r.client_id = cl.client_id
where r.statut != 'Annulée'
GROUP BY r.client_id, segment_client
order by CA_par_client_par_segment desc
limit 10;

--197	LOISIRS	7964.21	7
--477	GROUPE	6638.33	8
--262	GROUPE	6187.03	7
--325	LOISIRS	6007.12	9
--400	LOISIRS	5685.82	5
--213	GROUPE	5616.83	5
--294	GROUPE	5587.36	7
--103	LOISIRS	5555.04	7
--470	GROUPE	5362.26	8
--1		LOISIRS	5013.28	8

--D3.Ces 10	clients	représentent quelle	part du	CA	total ?
--Note : Quand on écrit top10.ca_client dans le SELECT, 
--on dit à SQL : « va chercher la colonne ca_client qui se trouve dans la table temporaire top10 ».

SELECT 
    ROUND(SUM(top10.ca_client), 2) AS ca_cumule_top_10,
    ROUND((SELECT SUM(montant_total) FROM reservations WHERE statut != 'Annulée'), 2) AS ca_total_global,
    ROUND(
        SUM(top10.ca_client) * 100.0 / (SELECT SUM(montant_total) FROM reservations WHERE statut != 'Annulée'), 2) AS part_du_ca_top_10_pourcentage
FROM (
    SELECT 
        r.client_id,
        SUM(r.montant_total) AS ca_client
    FROM reservations r
    WHERE statut != 'Annulée'
    GROUP BY r.client_id
    ORDER BY ca_client DESC
    LIMIT 10
) as top10;

--résultat :

59617.28	932701.13	6.39

--D4.Combien de	clients	ont	fait 1	réservation,	2,	3…	?	(une	requête	dont la	source	est	une	autre	requête)

SELECT 
	COUNT(*) AS nombre_de_clients,
    resas.nombre_total_reservations AS nb_reservations_effectuees   
FROM (
    SELECT 
        client_id,
        COUNT(reservation_id) AS nombre_total_reservations
    FROM reservations
    where statut != 'Annulée'
    GROUP BY client_id
) AS resas
GROUP BY resas.nombre_total_reservations
ORDER BY nb_reservations_effectuees asc;

--résultat : 9 lignes

--50	1
--82	2
--105	3
--91	4
--82	5
--50	6
--20	7
--7		8
--1		9



--D5.Pour	chaque	hôtel,	la	part	de	séjours	d’une	seule	nuit.

SELECT 
    sejours.nom_hotel,
    COUNT(CASE WHEN sejours.nuitees = 1 THEN 1 END) AS nombre_sejours_1_nuit,
    COUNT(*) AS nombre_total_sejours,
    ROUND(
        COUNT(CASE WHEN sejours.nuitees = 1 THEN 1 END) * 100.0 / COUNT(*), 
        2
    ) AS part_sejour_1_nuit_pourcentage
FROM (
    SELECT 
        h.nom_hotel,
        (r.date_depart - r.date_arrivee) AS nuitees
    FROM reservations r
    JOIN chambres c ON r.chambre_id = c.chambre_id
    JOIN hotels h ON c.hotel_id = h.hotel_id
    WHERE statut != 'Annulée'
) AS sejours
GROUP BY sejours.nom_hotel
ORDER BY part_sejour_1_nuit_pourcentage DESC;

--résultat : 8 lignes 

--UrbanStay Lyon Part-Dieu			23	209	11.00
--UrbanStay Lyon Confluence			22	233	9.44
--UrbanStay Bordeaux Saint-Jean		17	181	9.39
--UrbanStay Bordeaux Quinconces		21	233	9.01
--UrbanStay Paris Opéra				24	268	8.96
--UrbanStay Marseille Vieux-Port	22	253	8.70
--UrbanStay Paris République		21	254	8.27
--UrbanStay Marseille Joliette		9	177	5.08


--D6.Le	CA	par	catégorie	d’hôtel	et	par	taille	de	réservation
--Note :Sous-requête : Elle sort le montant de chaque séjour (r.montant_total).
--Requête principale : Elle additionne (SUM) tous ces montants pour chaque couple (Catégorie, Taille de réservation).

select 
sejours.categorie,
sejours.nuitees as taille_reservation,
round(sum(sejours.montant_total), 2) as CA_total
from(
select h.categorie,
        (r.date_depart - r.date_arrivee) AS nuitees,
        r.montant_total
    FROM reservations r
    JOIN chambres c ON r.chambre_id = c.chambre_id
    JOIN hotels h ON c.hotel_id = h.hotel_id
    WHERE statut != 'Annulée'
) AS sejours
group by sejours.categorie, taille_reservation
order by sejours.categorie, taille_reservation desc;

--résultat : 14 lignes

--3 étoiles	7	23373.88
--3 étoiles	6	36573.18
--3 étoiles	5	77500.02
--3 étoiles	4	93913.87
--3 étoiles	3	87716.37
--3 étoiles	2	53151.76
--3 étoiles	1	10117.01
--4 étoiles	7	30020.86
--4 étoiles	6	50874.12
--4 étoiles	5	85899.90
--4 étoiles	4	131165.09

