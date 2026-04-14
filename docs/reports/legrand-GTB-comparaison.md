# Recherche Legrand GTB (marche France) et comparaison a 3 fournisseurs

Date: 2026-03-30
Politique de sources: pages `legrand.fr/pro` uniquement

## 1. Pourquoi ce document existe

Le coeur du programme reste la plateforme IoT sans fil.
Ce document capture la piste de recherche actuelle sur la GTB filaire en France, en ajoutant Legrand dans le meme cadre de comparaison que Schneider et Siemens.

## 2. Maturite des decisions

1. Scope coeur confirme: plateforme et services IoT sans fil.
2. Modele d'integration GTB: encore en phase de recherche.
3. Hypothese de travail:
- la plateforme porte la gouvernance globale,
- le edge partenaire porte le controle local batiment.

## 3. Ce que Legrand France expose pour la GTB

Sur `legrand.fr/pro`, l'offre visible s'articule autour de trois chemins: controleur GTB WEOZ, controleurs BACnet hotellerie, et composants KNX de pilotage batiment.

### 3.1 Controleur GTB: Area Manager WEOZ

Elements visibles sur les pages Legrand France:

1. L'Area Manager est explicitement positionne comme controleur GTB pour la gestion batiment et l'efficacite energetique.
2. La page produit mentionne la conformite de contexte (exemple decret BACS) et le pilotage/controle a distance via tableau de bord.
3. Les pages produit/solution mentionnent notamment:
   - perimetre multi-protocoles: Z-wave, Zigbee, Modbus RTU, Modbus IP, MQTT, Wi-Fi, Ethernet,
   - gestion locale des regles et des donnees,
   - communication locale entre gestionnaires de zones,
   - communication avec dashboard via Cloud Legrand,
   - capacite de reference: jusqu'a 20 appareils sans fil + 100 points Modbus,
   - note produit: jusqu'a 20 equipements et 100 registres Modbus par Area Manager (au-dela, ajouter un autre Area Manager).

### 3.2 Controleur BACnet (hotellerie)

Legrand France expose aussi des controleurs BACnet explicites pour la gestion de chambre d'hotel:

1. Ref 0 484 08 et 0 484 12: controleurs modulaires multi-applications SCS/Bacnet.
2. Les fiches indiquent des entrees/sorties configurables et des usages de pilotage chambre.
3. La formation IP BACnet Legrand couvre explicitement la maitrise des objets BACnet du controleur de chambre.

### 3.3 KNX (pilotage batiment)

Legrand France expose des composants KNX de pilotage:
1. Controleur KNX modulaire (ref 0 484 18) pour eclairage/ouvrants/contacteurs/moteurs/variation DALI.
2. Configuration via ETS et raccordement bus KNX.
3. Commande tactile KNX (ref 0 488 84) pour piloter plusieurs controleurs KNX avec programmation de scenarios via ETS.

### 3.4 Abonnement WEOZ: ce qui est confirme et ce qui reste a valider

Constat explicite (au 1er avril 2026):
1. La page produit Area Manager indique qu'un abonnement portail de 12 mois est associe au produit pour l'usage des services.
2. Les contenus WEOZ mettent en avant un usage application/portail (dashboard d'exploitation, gestion multi-sites, usages distants).

Constat explicite cote mode local:
1. Le manuel integrateur WEOZ indique qu'un Area Manager peut rester operationnel en local meme non connecte.
2. La logique locale (regles, donnees locales) est donc un comportement attendu en cas de perte internet.

Point ouvert (a clarifier avant engagement contractuel):
1. Le comportement exact apres expiration de l'abonnement n'est pas explicite publiquement pour toutes les fonctions.
2. Hypothese de travail: l'operation locale continue, mais les fonctions portail/cloud (dashboard en ligne, fonctions multi-sites, certains services distants) dependent du plan actif.
3. Action recommandee: obtenir une confirmation ecrite Legrand (matrice des fonctions avec/sans plan, et apres expiration).

## 4. Vision "edge automation server" pour le marche France

Du point de vue catalogue France, Legrand fournit surtout plusieurs patterns edge, plutot qu'un unique produit universel type AS-P.

### 4.1 Candidat GTB edge principal

`Area Manager WEOZ` est le candidat le plus direct pour le role de noeud edge GTB car il combine:

1. execution locale des regles,
2. integration multi-protocoles,
3. liaison cloud/dashboard,
4. positionnement GTB en contexte BACS.

### 4.2 Noeuds edge par domaine

Selon les cas d'usage, Legrand propose aussi:

1. des controleurs SCS/BACnet pour l'automatisation hoteliere,
2. des controleurs et IHM KNX pour des architectures centrees KNX.

Inference explicite:
1. L'architecture edge Legrand France est plutot compositionnelle par domaine (WEOZ + SCS/BACnet + KNX selon scope).
2. Pour un scope GTB multi-domaines large, l'effort d'integration peut dependre davantage de l'assemblage solution que d'un pattern "serveur edge unique".

## 5. Matrice comparative v3 (Schneider vs Siemens vs Legrand)

Legende:
- `natif`: pattern fournisseur direct et explicite.
- `via gateway`: realisable via composition gateway/bridge protocolaire.
- `besoin d'une couche de supervision`: necessite en general une couche supervision/app pour une operation centralisee pratique.

| Capacite | Schneider (parcours AS-P/EBO) | Siemens (parcours PXC/Desigo/Building X) | Legrand France (`legrand.fr/pro`) |
| --- | --- | --- | --- |
| Point d'entree batiment unique sur BACnet/KNX/Modbus | `natif` pour BACnet/Modbus a la frontiere AS-P; KNX souvent `via gateway` | Souvent `besoin d'une couche de supervision` et/ou `via gateway` selon topologie | Souvent compose: WEOZ comme candidat edge GTB; controleurs KNX et SCS/BACnet pour scopes specifiques |
| Integration BACnet | `natif` | `natif` | `natif` sur des lignes France ciblees (ex: controleurs hotellerie SCS/BACnet) |
| Integration KNX dans les operations | Souvent `via gateway` | Souvent `via gateway` + options room-automation KNX | `natif` avec composants KNX et configuration ETS |
| Logique de controle locale edge | Forte | Forte | Forte sur WEOZ et sur controleurs de domaine (KNX / SCS-BACnet) |
| Extension cloud/app portefeuille | Disponible via ecosysteme Schneider | Produit via Building X apps/APIs | WEOZ annonce couplage cloud/dashboard; profondeur portefeuille a valider en pilote |
| Fit avec gouvernance centrale plateforme | Fort | Fort | Fort en principe; necessite un design explicite des frontieres d'autorite dans des deploiements composes |
| Charge d'integration sur sites multi-fournisseurs | Moyenne a elevee | Moyenne a elevee | Moyenne a elevee; potentiellement plus elevee si combinaison de plusieurs familles Legrand pour scope GTB large |

## 6. Conclusion pratique pour la phase actuelle

1. Pour le marche France, Legrand n'est pas un candidat pertinent pour le même usage que siemens / schneider.
2.  Il n'existe pas de solution native pour obtenir un seul point d'acces GTB
3. `Area Manager WEOZ` est le candidat le plus proche d'un role "serveur edge GTB" dans l'offre France, mais elle depend d'un abonnement a un service externe, non recommandé
4.  Legrand peut cependant être interessant dans un cadre specifique lié a un domaine precis (eclairage, bus KNX, hotelerie), ce qui ne correspond pas a nos besoins mais peut être noté. 
3. Pour hotellerie ou architecture KNX, Legrand propose des options edge concretes (SCS/BACnet et KNX), mais qui necessiterait une adaptation.

## 7. References France utilisees

1. [Produit Area Manager WEOZ](https://www.legrand.fr/pro/catalogue/controleur-gtb-area-manager-weoz-pour-la-gestion-des-batiments-et-de-lefficacite-energetique)
2. [Solution WEOZ](https://www.legrand.fr/pro/solutions/efficacite-energetique/weoz-tm-le-gestionnaire-de-batiment-intelligent)
3. [Categorie gestion chambre d'hotel](https://www.legrand.fr/pro/catalogue/appareillage-maison-connectee-et-pilotage-du-batiment/pilotage-du-batiment/gestion-de-la-chambre-dhotel)
4. [Controleur SCS/BACnet (0 484 12)](https://www.legrand.fr/pro/catalogue/controleur-modulaire-multi-applications-pour-fonction-hotel-scsbacnet-avec-16-entrees-et-16-sorties-12-modules)
5. [Controleur SCS/BACnet (0 484 08)](https://www.legrand.fr/pro/catalogue/controleur-modulaire-multi-applications-pour-fonction-hotel-scsbacnet-avec-8-entrees-et-8-sorties-8-modules)
6. [Formation IP BACnet hotel](https://www.legrand.fr/pro/formations/sante-hotel/formation-legrand-solution-controleur-de-chambre-dhotel-ip-bacnet-270)
7. [Controleur KNX modulaire (0 484 18)](https://www.legrand.fr/pro/catalogue/controleur-modulaire-bus-knx-8-modules-multi-applications-avec-8-entrees-et-8-sorties-8-modules)
8. [Commande tactile KNX (0 488 84)](https://www.legrand.fr/pro/catalogue/commande-filaire-tactile-57pouces-mosaic-pour-pilotage-de-plusieurs-controleurs-bus-knx)
9. [Alimentation bus KNX (0 035 07)](https://www.legrand.fr/pro/catalogue/alimentation-modulaire-bus-knx-150v-a-275v-30v-640ma-7-modules)
10. [Manuel integrateurs WEOZ (PDF)](https://assets.legrand.com/pim/NP-FT-GT/legrand-manuel-integrateurs-weoz.pdf)
