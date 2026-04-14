# Recherche partenaire Autodesk (Tandem + Tandem Connect)

Date: 2026-04-02  
Statut: baseline de recherche (document vivant, à enrichir)  
Audience: manager plateforme, parties prenantes fonctionnelles, sponsors

## 1. Résumé exécutif

Autodesk propose deux offres complémentaires :

1. **Autodesk Tandem** : la plateforme de jumeau numérique (contexte actifs, modèle d'installation, données d'exploitation, séries temporelles).
2. **Autodesk Tandem Connect** : la couche d'intégration low-code pour relier des systèmes externes (GTB, GMAO (Gestion de maintenance assistée par ordinateur), IoT, MQTT, APIs, etc.) à Tandem.

Pour notre stratégie, le meilleur alignement est :

1. Garder **notre plateforme** comme socle canonique d'intégration et de gouvernance.
2. Utiliser **Tandem** comme couche jumeau numérique/contexte.
3. Utiliser **Tandem Connect** de manière ciblée quand les plugins préconstruits accélèrent réellement la livraison.

## 2. Rôle de chaque service

### 2.1 Autodesk Tandem (jumeau numérique)

Tandem est positionné comme une plateforme de jumeau numérique reliant les données BIM (Building Information Modeling ou Bati Immobilier Modelisé) et les données d'exploitation pour le suivi et l'optimisation.

Capacités utiles (sources officielles) :

1. Modèle jumeau numérique d'installation (actifs, espaces, systèmes, relations).
2. Prise en charge de flux/séries temporelles capteurs.
3. Usage conjoint quasi temps réel + historique.
4. APIs pour lire/écrire les propriétés d'actifs et schémas personnalisés.

### 2.2 Autodesk Tandem Connect (intégration)

Tandem Connect est présenté comme un service vendor-agnostic, low-code, en glisser-déposer, basé sur des plugins et des pipelines.

Capacités utiles (sources officielles) :

1. Bibliothèque de plugins pré-packagés (page Autodesk : 46 plugins et plus).
2. Pipelines pour relier systèmes cloud et (selon l'offre/topologie) systèmes locaux.
3. Catégories de plugins : Stream, Gateway, Connector, Service, Mapper, Filter, Channel.
4. Plugins OT/IoT concrets : BACnet Stream, MQTT Stream/Gateway/Channel/Connector, OPC UA Stream/Subscribe, Kafka Stream, Tridium NDS Stream, Azure IoTHub Stream.

## 3. Modes d'intégration possibles avec notre plateforme

Il n'existe pas un seul mode imposé ; plusieurs patterns sont possibles.

### 3.1 Pattern A - Intégration API (notre plateforme vers Tandem Data API)

Flux :

1. Notre plateforme conserve ingestion + gouvernance.
2. Notre adaptateur pousse/met à jour dans Tandem via API.
3. Optionnel : webhooks Tandem pour des workflows événementiels.

Pertinent si :

1. Nous voulons garder un contrôle maximal des contrats.
2. Nous disposons déjà d'un socle d'intégration robuste.
3. Nous voulons limiter la dépendance à un runtime low-code supplémentaire.

### 3.2 Pattern B - Ingestion directe de flux vers Tandem

Autodesk documente l'ingestion directe de stream :

1. Un capteur/passerelle poste des valeurs numériques vers l'endpoint d'ingestion.
2. Authentification possible par secret de stream (basic auth) ou OAuth.
3. Contraintes de fréquence minimale et de payload à respecter.

Pertinent si :

1. Pilote simple, périmètre réduit.
2. Besoin de démarrage rapide.

Compromis :

1. Rapide à lancer.
2. Peut réduire la cohérence de gouvernance si l'on contourne notre chemin canonique.

### 3.3 Pattern C - Tandem Connect comme tissu d'intégration

Flux :

1. Les pipelines Tandem Connect récupèrent/émettent vers les systèmes sources.
2. Les plugins gèrent mapping et transformation.
3. Les données alimentent Tandem via plugins Tandem.

Pertinent si :

1. Il faut connecter rapidement des systèmes hétérogènes.
2. Les plugins préconstruits évitent du développement spécifique.

Compromis :

1. Accélération de la mise en place.
2. Surface d'exploitation/gouvernance supplémentaire (capacité, plugins, exploitation pipeline).

### 3.4 Pattern D - Hybride (baseline recommandée)

Flux :

1. Notre plateforme reste canonique pour l'identité, la tenancy, la gouvernance de commande, les contrats API/MQTT.
2. Tandem sert de couche jumeau/contexte.
3. Tandem Connect est utilisé là où il apporte un vrai gain sans casser les frontières de gouvernance.

Ce pattern est le plus aligné avec notre trajectoire actuelle.

## 4. Ce qu'Autodesk attend de nous

Quel que soit le pattern, la réussite dépend de la qualité des entrées que nous fournissons.

Package d'intégration minimal :

1. Hiérarchie stable site/bâtiment/étage/espace.
2. Modèle d'actifs avec identifiants durables et stratégie métadonnées.
3. Mapping point capteur/stream vers actif/équipement/espace/système.
4. Contrat télémétrie (unités, horodatage, qualité, rétention).
5. Cycle de vie des secrets/identités d'intégration.
6. Règles de gouvernance de l'autorité d'écriture et audit.

Spécifique Tandem Connect :

1. Proprieté du design de pipeline et du cycle release.
2. Gestion des secrets/credentials par plugin.
3. Décision d'hébergement d'exécution (cloud vs outpost/local selon l'offre).

## 5. Valeur fonctionnelle potentielle

Pour les parties prenantes, la valeur est surtout opérationnelle :

1. Couche jumeau numérique reliant BIM + exploitation + flux.
2. Diagnostic plus rapide grâce au contexte actif/espace/système.
3. Workflows pilotés par alertes et événements.
4. Accélération possible de certaines intégrations via plugins.
5. Meilleur pont entre données ingénierie et opérations terrain.

## 6. Coûts de licence (point critique)

Les modèles commerciaux Autodesk évoluent.

Vérification marché France (au 2026-04-02) :

1. Autodesk expose bien **France** dans les options régionales de la page produit.
2. Autodesk indique que les contenus Tandem peuvent être hébergés sur l'offre régionale **EU**.
3. La page commerciale publique affiche les prix en USD avec la mention "*includes estimated VAT*".

La page publique produit affiche actuellement :

1. Tandem : **3 200 USD/an**.
2. Tandem Connect : **5 000 USD/an**.
3. Existence de paliers gratuits pour exploration.

Conversion indicative en euros (hypothèse de travail) :

1. Taux utilisé pour estimation: **1 EUR = 1.153 USD** (snapshot marché, mars 2026).
2. Tandem: **~2 775 EUR/an** (indicatif).
3. Tandem Connect: **~4 337 EUR/an** (indicatif).

Important:

1. Ces valeurs EUR sont des **estimations** pour cadrage.
2. Le prix contractuel France doit être confirmé via devis Autodesk/revendeur (devise de facturation, TVA réelle, remises, capacité/add-ons).

Les Conditions Autodesk décrivent aussi :

1. Une logique de capacité et de paliers (actifs, data points, streams, plugins, brokers MQTT, messages, outpost selon le type d'offre).
2. Une logique plugins pack / add-on broker MQTT dans certains modes d'offre.
3. Des limites de capacité/rétention selon le niveau de souscription.
4. Des transitions contractuelles autour des offres capacity-based en 2026.

Implication pratique :

1. Le coût doit être piloté comme une **architecture de capacité**, pas uniquement comme une architecture de licences utilisateurs.
2. Le cadrage pilote doit estimer explicitement : actifs, streams/data points, packs plugins, besoins brokers MQTT.

## 7. Goulots d'étranglement et risques

Les risques principaux sont d'intégration/gouvernance :

1. **Risque sémantique** : mismatch entre schéma BIM/jumeau et points IoT/BMS.
2. **Risque d'autorité** : ambiguïté sur qui écrit quoi.
3. **Risque qualité de données** : unités incohérentes, dérive temporelle, bruit.
4. **Risque d'exploitation** : prolifération de pipelines/plugins sans gouvernance.
5. **Risque coût/capacité** : sous-estimation des volumes (data points, plugins, brokers).
6. **Risque événementiel** : webhooks asynchrones, donc orchestration résiliente nécessaire.
7. **Risque sécurité** : gestion stricte des secrets de stream, tokens OAuth et endpoints.

## 8. Implications MQTT pour notre architecture

D'après le modèle plugin et les définitions Autodesk :

1. Tandem Connect supporte des patterns MQTT d'ingestion et de publication (plugins stream/gateway/channel/connector).
2. La capacité broker MQTT est fournit sous forme d'addon sous licence selon le mode d'offre.
3. Les pipelines sont conçus dans le cloud puis déployés selon les capacités de l'offre (dont outpost dans les paliers qui le permettent).

Implication de design :

1. Nous pouvons relier Tandem Connect à notre écosystème MQTT, mais il faut fixer clairement :
   - gouvernance des topics,
   - QoS/rétention,
   - ownership de la normalisation,
   - frontières de sécurité entre brokers.

## 9. Recommandation pilote (niveau fonctionnel)

Pilote conseillé (petit mais représentatif) :

1. Un bâtiment.
2. 20 à 30 points télémétrie, 5 à 10 actifs pilotés/mappés.
3. Un flux API + un flux Tandem Connect (comparatif A/B).
4. Un workflow déclenché par webhook (ex : alerte vers ticketing).
5. Critères de succès explicites :
   - qualité de mapping,
   - fraîcheur/qualité des données,
   - traçabilité de gouvernance,
   - effort opérationnel par connecteur,
   - confiance sur l'estimation mensuelle de capacité/coût.

## 10. Cadre de décision pour sponsors

Questions a poser  :

1. Où placer l'autorité système de référence.
2. Quels chemins d'intégration standardiser (API-first vs Connect-first vs hybride).
3. Quel niveau de variabilité capacité/coût accepter en échange de la vitesse d'intégration.

Recommandation de travail actuelle :

1. Démarrer en **hybride**, avec notre plateforme comme couche canonique de gouvernance.
2. Utiliser Tandem pour la valeur jumeau/contexte.
3. Utiliser Tandem Connect uniquement quand le gain plugin est supérieur au coût d'un adaptateur spécifique.

## 11. Sources (officielles)

1. Vue d'ensemble/pricing Tandem :  
https://www.autodesk.com/products/tandem/overview
2. Bibliothèque intégrations Tandem Connect :  
https://intandem.autodesk.com/integrations-tandem-connect/
3. Tandem comme plateforme (roadmap API, positionnement push/pull) :  
https://intandem.autodesk.com/tandem-as-a-platform/
4. APS Tandem Data API overview :  
https://aps.autodesk.com/developer/overview/tandem-data-api
5. APS blog - ingestion capteurs IoT dans Tandem API :  
https://aps.autodesk.com/blog/adding-iot-sensors-tandem-api
6. APS blog - guide création de streams :  
https://aps.autodesk.com/blog/tandem-data-api-guide-stream-creation
7. APS blog - suppression de données de stream :  
https://aps.autodesk.com/blog/tandem-api-deleting-stream-data
8. APS blog - événements webhook Tandem :  
https://aps.autodesk.com/blog/tandem-webhook-events
9. Autodesk Terms of Use - Offerings (tiers Tandem/Tandem Connect, plugins, add-on broker MQTT, outpost) :  
https://www.autodesk.com/company/terms-of-use/en/offering-types-and-benefits
10. Autodesk Terms of Use - wording subscription/capacity (transitions 2026) :  
https://www.autodesk.com/company/terms-of-use/en/subscription-types
11. Indication de taux de change (USD/EUR) utilisée pour conversion indicative :  
https://www.investing.com/currencies/eur-usd
