# Briefing De Décision Intégration Partenaires

Date: 2026-03-20
Audience: non-spécialistes, sponsors, parties prenantes projet
Objectif: expliquer les choix d'intégration partenaires pour l'automatisation du bâtiment et le jumeau numérique, et documenter le contexte comme mémoire projet stable.

## 1. Contexte de base

Notre plateforme fait déjà les choses suivantes:
1. Ingestion de télémétrie des équipements IoT.
2. Centralisation des données.
3. Gestion de l'identité et des accès.
4. Exposition de la télémétrie vers l'extérieur via API et MQTT.

Ce document porte sur l'ajout de capacités partenaires au-dessus de cette base.

## 1.1 Contexte

1. Précision de contexte Tandem :
- Ramery utilise déjà les outils Autodesk pour modéliser les bâtiments.
- Les modèles de bâtiments existent déjà.
- Ramery utilise déjà des intégrateurs capables d'installer du matériel de GTB dans un bâtiment.
- L'étape cible suivante est de connecter les équipements IoT à ces bâtiments et à leur bus BACnet/KNX/MODbus et de lier télémétrie/contexte via Tandem/Tandem Connect.

## 2. Deux fonctionnalités séparées à l'étude

## 2.1 Automatisation (Schneider, Siemens; (Legrand ajouté en fin de document comme annexe))

Questions auxquelles répondre:
1. Que peuvent automatiser ces partenaires?
2. À quelle granularité (équipement unique, étage, bâtiment, portefeuille)?
3. Comment les connecter techniquement?
4. Quelles implications en architecture, coût, difficulté et risque?

## 2.2 Jumeau Numérique (Autodesk Tandem / Tandem Connect)

Questions auxquelles répondre:
1. Que devons-nous fournir pour faire fonctionner Tandem?
2. Comment notre plateforme doit-elle s'intégrer proprement et en sécurité?
3. Quelles sont les contraintes, les coûts et les risques?

## 3. Partenaires d'automatisation

## 3.1 Schneider (écosystème EcoStruxure Building Operation / SpaceLogic)

En pratique, Schneider peut couvrir plusieurs couches:
1. Couche équipement par salle: contrôle local (ex.: chauffage, ventilation et climatisation (CVC) de salle, certaines séquences locales).
2. Couche équipement par étage: coordination CTA (Centrale de traitement d'air, VMC industrielle) / ventilo-convecteur/boucle de refroidissement et logique de supervision.
3. Couche bâtiment/campus: supervision centrale, alarmes, planification, historisation des tendances, optimisation.

Implication:
1. Il peut constituer une pile complète d'automatisation du bâtiment selon le périmètre de déploiement, même s'il se présente parfois comme un contrôleur de "petit équipement".

## 3.2 Siemens (écosystème Desigo + Building X)

Siemens doit être regardé selon deux dimensions:
1. Systèmes d'automatisation/contrôle du bâtiment (côté contrôleurs et GTB).
2. Capacités de plateforme cloud API-first via Building X (côté opérations/intégration).

Implication:
1. Siemens peut également opérer du contrôle point-a-point jusqu'aux workflows de portefeuille.
2. Les API Building X sont pertinentes pour l'intégration de capacités cloud opérationnelles.

## 3.3 Carte de granularité (applicable aux deux)

Schneider et Siemens peuvent être utilisés aux niveaux suivants:
1. Niveau point/actionneur unique (consigne, on/off, mode).
2. Niveau équipement (CTA, pompes, chillers, ventilo-convecteurs).
3. Niveau zone/étage (contrôle coordonné confort/énergie).
4. Niveau bâtiment complet (plannings, alarmes, optimisation).
5. Niveau portefeuille multi-bâtiments (modes d'exploitation centralisés).

## 4. Comment nous connecter aux partenaires d'automatisation

Dans les programmes réels, les connexions sont généralement un mix de:
1. Intégration par protocoles OT (operational technology) (ex.: famille BACnet dans de nombreux déploiements).
2. Intégration basée API (en particulier pour les capacités de plateforme cloud).
3. Passerelles/serveurs d'intégration pour normaliser les environnements legacy.
4. Interactions par événements/messages (MQTT) pour alertes et orchestration.

Ce qu'il faut avant intégration:
1. Inventaire et mapping des points (lecture/écriture, unités, fréquences, qualité).
2. Matrice d'autorité (qui peut commander quoi, ou, quand).
3. Politique de sécurité fonctionnelle (maintien, override, comportement fail-safe).
4. Modèle de mapping tenant/site (frontières organisation/site).
5. Prérequis réseau et sécurité (segmentation, chemin certificats/clés, flux autorisés).
6. Runbooks d'incident et de rollback.

## 5. Ce que cela signifie pour notre architecture

Vous avez deux modes opératoires valides avec Schneider/Siemens:

1. Partenaire-comme-automatisation-principale:
- La plateforme partenaire détient la majorité du contrôle en boucle fermée.
- Notre plateforme fournit les données/le contexte et l'enveloppe de gouvernance.

2. Partenaire-comme-automatisation-de-domaine-cible:
- Le partenaire contrôle seulement des domaines/sites sélectionnés.
- Notre plateforme reste l'orchestrateur global.

Les deux sont viables; le choix dépend de l'appétit de gouvernance, des contrats existants et du modèle de propriété opérationnelle.

## 6. Coûts, difficulté et limites (automatisation)

L'effort principal n'est généralement pas le codage d'API.
Principaux facteurs d'effort:
1. Nettoyage de qualité des points et métadonnées.
2. Commissioning et mapping par site.
3. Gouvernance de sécurité des commandes et de l'autorité.
4. Approbations cybers et contraintes réseau.
5. Variabilité multi-sites et hétérogénéité legacy.

Tendance de complexité:
1. Pilote cible mono-site: moyenne.
2. Déploiement multi-sites multi-fournisseurs: élevée.
3. Portefeuille complet avec gouvernance de contrôle stricte: très élevée.

## 7. Jumeau numérique avec Autodesk Tandem: ce que c'est

Tandem est à traiter comme une plateforme de jumeau numérique et de contexte cycle de vie.
Ce n'est généralement pas la boucle principale de contrôle terrain à faible latence.

Valeur principale de Tandem:
1. Contexte des actifs et continuité cycle de vie.
2. Liaison des données opérationnelles aux actifs physiques et aux espaces.
3. Workflows pilotes par événements et contexte transverse entre systèmes.

## 8. Ce que vous devez fournir pour faire fonctionner Tandem

Package minimum d'intégration:
1. Hiérarchie des installations (site/bâtiment/étage/espace).
2. Modèle d'actifs et identifiants.
3. Mapping capteur/point vers actif.
4. Contrat de télémétrie (horodatage, unité, qualité, source).
5. Gouvernance des métadonnées (noms, tags, classifications).
6. Configuration credentials/environnement et connecteurs.
7. Politique d'événements (quels changements du twin déclenchent quels workflows).

Mode opératoire recommandé:
1. Garder notre plateforme comme cœur télémétrie/gouvernance.
2. Utiliser Tandem comme couche contexte/twin.
3. Garder l'exécution des commandes dans notre gouvernance de commande et/ou dans le plan partenaire d'automatisation.

## 9. Limites, Coûts Et Risques (Tandem)

Risques principaux:
1. Decalage sémantique entre points IoT et modèle twin.
2. Derive du twin dans le temps (modèle non synchronisé avec la realite du bâtiment).
3. Surcharge de la couche twin avec des responsabilites mieux gardees dans les systèmes de contrôle.

Coûts principaux:
1. Gouvernance de modélisation et de mapping des données.
2. Processus continu de curation et de synchronisation.
3. Alignement de responsabilite inter-équipes (ops/engineering/facilities).

## 10. Scénarios de décision

Vous pouvez choisir un de ces scénarios stratégiques:
1. Schneider/Siemens comme contrôle BAS complet + notre plateforme comme couche superieure données/gouvernance.
2. Schneider/Siemens comme domaines de contrôle sélectifs + notre plateforme orchestre globalement.
3. Tandem uniquement comme couche de contexte numérique.
4. Tandem + partenaire d'automatisation ensemble, avec notre plateforme comme cœur canonique intégration/gouvernance.

Le scenario 4 est souvent le modèle entreprise le plus scalable a long terme.

## 11. Approche Pilote Recommandee

Avant verrouillage final de l'architecture:
1. Choisir un bâtiment pilote.
2. Definir un périmètre borné: 20-30 points en lecture, 5-10 points en écriture.
3. Valider trois éléments:
- fiabilité de télémétrie,
- comportement autorité/sécurité des commandes,
- qualité de synchronisation du twin.
4. Utiliser les preuves du pilote pour decider le modèle opératoire final.

## 12. Sujets de gouvernance critiques pour les sponsors

Ces points sont obligatoires quel que soit le choix de partenaire:

1. Stratégie de modèle sémantique:
- modèle canonique + métadonnées fournisseur contrôlées,
- couche de tagging style Brick/Haystack pour normalisation inter-fournisseurs.

2. Modèle d'autorité de commande:
- matrice explicite de politique "qui peut ecrire quoi, ou, quand",
- contrôles role/site/temps/actif/classe-de-commande,
- lineage immuable des commandes et piste d'audit.

3. SLA de qualité des données:
- staleness/freshness, ratio de données manquantes, bornes de dérive d'horodatage,
- scorecards qualité par partenaire et alerting.

4. Gate de certification partenaire avant production:
- tests de contrat,
- parité de sandbox,
- exercices de bascule,
- repetition de rollback.

5. Alignement baseline cyber:
- segmentation réseau,
- cycle de vie certificats/clés,
- secrets gérés par vault,
- contrôles auditables incident/recovery.

## 13. Questions Ouvertes A Resoudre Avant Design Final

1. Les partenaires doivent-ils détenir le contrôle direct des actionneurs en production, ou toutes les écritures doivent-elles toujours passer d'abord par notre gouvernance centrale?
2. Le rollout commence-t-il en mono-site ou multi-sites?
3. Quel sous-système est prioritaire en premier (CVC, éclairage, mixte)?
4. Pour le jumeau numérique, faut-il d'abord du streaming quasi temps reel ou d'abord la synchronisation contexte/cycle de vie?
5. Les sponsors préfèrent-ils un modèle cible unique recommandé ou une matrice d'options avec compromis?

## 14. Références

1. Vue d'ensemble Schneider GTB:
https://www.se.com/us/en/work/products/product-launch/building-management-system/
2. Document Schneider EBO Enterprise Server:
https://www.se.com/us/en/download/document/03-71021/
3. Vue d'ensemble Siemens Building X:
https://www.siemens.com/us/en/products/buildingtechnologies/building-x.html
4. Vue d'ensemble API manager Siemens Building X:
https://www.siemens.com/en-us/products/building-x/apis/
5. Guide developpeur Siemens Building X:
https://developer.siemens.com/building-x-openness/dev-guide/gettingstarted.html
6. Vue d'ensemble API Siemens Building Operations:
https://developer.siemens.com/building-x-openness/api/building-operations/overview.html
7. Vue d'ensemble Autodesk Tandem Data API:
https://aps.autodesk.com/developer/overview/tandem-data-api
8. Article de reference Autodesk Tandem webhook/events:
https://aps.autodesk.com/blog/tandem-webhook-events
9. Page integrations Autodesk Tandem Connect:
https://intandem.autodesk.com/integrations-tandem-connect/

## 15. Journal de décision - intégration Schneider (carte de granularité)

Date: 2026-03-20
Statut: conclusion de travail (validee avec pages officielles produits/services Schneider)

## 15.1 Ecosysteme Bâtiments Complets (Portefeuille / Multi-bâtiments)

Offre Schneider a ce niveau:
1. Plateforme GTB centrale avec vues portefeuille et comportement de centre de contrôle via EcoStruxure Building Operation.
2. Perimetre d'intégration inter-sous-systèmes incluant CVC, éclairage, énergie, microgrid, recharge EV, sécurité et incendie.
3. Couches de services gérés/distants (Building Advisor) avec monitoring modulaire et assistance opérationnelle.

Services typiques a ce niveau:
1. Monitoring portefeuille et dashboards.
2. Supervision alarmes et sante système sur plusieurs sites.
3. Maintenance basée condition et reporting de valeur.
4. Options de support expert cloud/service-plan.

Ce que cela signifie pour nous:
1. Schneider peut agir comme pile complète d'opérations bâtiment entreprise, pas seulement comme contrôleur local.
2. L'intégration peut se faire au niveau supervision et opérations metier, pas uniquement au niveau équipement terrain.

## 15.2 Ecosysteme Un Batiment

Offre Schneider a ce niveau:
1. Option A : EcoStruxure Building Operation (EBO) comme centre de commande unifié du bâtiment.
2. Option B : AS-P comme frontière edge d'automatisation et propriétaire opérationnel des sous-systèmes, avec exécution locale sous ordres/intentions de commande gouvernés par notre plateforme.
3. Visibilité au niveau bâtiment pour périmètres équipement, étage et bâtiment dans les deux options.
4. Contrôle bâtiment, planification, alarmes, historisation des tendances et workflows d'optimisation, avec une répartition de propriété qui dépend de l'option choisie.

Services typiques a ce niveau:
1. Supervision des opérations à l'échelle du bâtiment.
2. Coordination multi-sous-systèmes.
3. Boucles d'analytique et d'optimisation bâtiment.

Ce que cela signifie pour nous:
1. Nous pouvons integrer bâtiment par bâtiment sans imposer immediatement un rollout portefeuille.
2. Un pilote mono-bâtiment peut être representatif pour la validation technique.

## 15.3 Contrôleur d'un système (CVC/CTA/ventilation/éclairage)

Offre Schneider a ce niveau:
1. Familles de contrôleurs de salle technique (ex.: SpaceLogic MP-C) pour contrôle CVC/salle mecanique.
2. Couche serveurs/contrôleurs d'automatisation (AS-P/AS-B) pour logique edge, tendances, alarmes et connectivité field bus.
3. Contrôleurs salle/système pouvant gérer éclairage/stores/temperature et contrôle lié à l'occupation.

Services typiques a ce niveau:
1. Boucles de contrôle niveau système.
2. Orchestration des équipements (domaine CTA/salle technique).
3. Collecte de données et logique locale de supervision.

Ce que cela signifie pour nous:
1. Schneider peut être utilise comme contrôleur de domaine (par exemple CVC d'abord) sans deleguer le bâtiment entier.
2. Cela supporte une stratégie d'intégration par phases, par sous-système.

## 15.4 Contrôleur d'un équipement (salle / équipement local)

Offre Schneider a ce niveau:
1. Contrôleurs salle/équipement (familles SpaceLogic room controller) pour temperature, éclairage, stores et contrôle local base sur l'occupation.
2. Options locales HMI/affichage operateur pour taches operation/maintenance.
3. Controle au plus pres de l'équipement et collecte de télémétrie a granularité salle/zone.

Services typiques a ce niveau:
1. Sensing/contrôle au niveau point.
2. Logique locale de confort et d'occupation.
3. Diagnostics équipement et overrides locaux (selon design deploye).

Ce que cela signifie pour nous:
1. Schneider peut être integre a granularité très fine, jusqu'au périmètre salle/équipement.
2. C'est utile quand seule une optimisation locale ciblee est necessaire.

## 15.5 Conclusion Generale Pour Schneider

1. Schneider couvre les quatre granularites listees: équipement, système, bâtiment unique et écosystème portefeuille.
2. Le meme fournisseur peut être engage sur un périmètre etroit (un sous-système/site) ou sur une possession complète BAS/GTB.
3. Notre choix d'intégration est d'abord architectural et contractuel, pas limite par la capacite Schneider seule.

Références principales utilisees pour cette conclusion:
1. Page produit Schneider GTB (périmètre, couverture sous-systèmes, serveurs/contrôleurs d'automatisation/contrôleurs salle/HMI):
https://www.se.com/us/en/work/products/product-launch/building-management-system/
2. Page service Schneider Building Advisor (logiciel gere modulaire, plans, services health/alarm/task/value):
https://www.se.com/ie/en/work/services/field-services/building-services/building-advisor/

## 15.6 Deep Dive - Offre Schneider Ecosysteme Portefeuille Complet

Pour un périmètre portefeuille écosystème complet, l'offre Schneider se comprend comme une pile d'exploitation en couches:

1. Couche plateforme d'intégration et de contrôle (EcoStruxure Building Operation):
- Framework d'intégration logicielle ouvert et securise, concu pour connecter systèmes Schneider et tiers.
- Le périmètre inclut explicitement énergie, éclairage, CVC, sécurité incendie, sécurité des accès et gestion des espaces de travail.
- Capacités monitor/manage/control depuis contextes mobile et entreprise.
- Positionnement du petit bâtiment jusqu'aux entreprises multi-sites complexes.

2. Couche équipements et contrôleurs (Connected Products / SmartX IP):
- Produits connectes niveau terrain (capteurs, vannes, actionneurs, etc.).
- Contrôleurs SmartX IP pour des topologies IP end-to-end scalables et la transmission de données depuis les équipements connectes.
- Posture sécurité integree et intention de diagnostic accelere au niveau contrôleur.

3. Modules d'extension de domaine dans le meme écosystème:
- Energy Expert: monitoring/mesure/optimisation énergie integres dans la meme interface que les domaines CVC/éclairage/incendie.
- Security Expert: contrôle d'accès physique integre, base sur les roles, et contexte intrusion avec visibilite entreprise complète.

4. Services de maintenance et analytique portefeuille (Building Advisor):
- Vue portefeuille "outil unique" a travers bâtiments/systèmes/équipements.
- Modèle modulaire: GTB Health, Asset Health, Smart Alarm, Task Manager, Value Reports.
- Plans de service (Plus/Prime/Ultra) combinant supervision distante, diagnostic, maintenance preventive/basée condition et support on-site optionnel.
- Cycle opératoire explicite: Monitor -> Maintain -> Improve avec suivi KPI/ROI.

5. Posture opérationnelle/cyber et cycle de vie:
- L'architecture portefeuille inclut la visibilite de sante logicielle/firmware et l'analyse de tendances réseau/système.
- Le discours Schneider inclut la posture cybers et conformite a travers la pile bâtiment.
- Les services cycle de vie et l'écosystème partenaires (programme EcoXpert) font partie des opérations à l'échelle.

6. Caracteristiques d'echelle et portefeuille mises en avant par Schneider:
- Positionnement pour grandes entreprises et environnements multi-sites.
- Acceleration engineering et commissioning revendiquee dans les pages solution publiees.
- Mention de scale "jusqu'à 10x" pour support grands comptes/multi-sites dans le messaging solution.

Ce que cela signifie pour nous (cas d'usage portefeuille):
1. Schneider peut être choisi comme pile d'exploitation portefeuille end-to-end, pas seulement comme fournisseur équipement/système.
2. Les decisions d'intégration deviennent des decisions de gouvernance: ou se place l'autorité de commande, comment se partage la propriété des données, et quels workflows analytics/maintenance restent dans notre plateforme vs modules de service Schneider.
3. La valeur la plus forte apparait quand opérations portefeuille, maintenance basée condition et optimisation inter-domaines sont requises, pas seulement le contrôle au niveau point.

## 16. Journal de décision - intégration Siemens (carte de granularité)

Date: 2026-03-20
Statut: conclusion de travail (validee avec pages produit et developpeur Siemens)

## 16.1 Ecosysteme Bâtiments Complets (Portefeuille / Multi-bâtiments)

Offre Siemens a ce niveau:
1. Operations portefeuille et inter-bâtiments avec applications plateforme Building X.
2. Backbone de gestion bâtiment integre avec Desigo CC sur plusieurs disciplines.
3. Modèle API et plateforme numérique (Building X Openness) pour intégration données/opérations.

Services typiques a ce niveau:
1. Gestion des opérations multi-bâtiments.
2. Optimisation inter-domaines (énergie, opérations, surete/sécurité, maintenance).
3. Supervision centralisee et intégration de sous-systèmes bâtiment heterogenes.

Ce que cela signifie pour nous:
1. Siemens peut opérer comme partenaire écosystème complet, pas seulement comme fournisseur de contrôleur mono-système.
2. L'intégration peut se faire au niveau UI/workflow opérationnel (Building X) et au niveau GTB de supervision (Desigo CC).

## 16.2 Ecosysteme Un Batiment

Offre Siemens a ce niveau:
1. Option A : Desigo CC comme centre de commande/supervision mono-bâtiment.
2. Option B : PXC comme propriétaires opérationnels locaux des sous-systèmes (CVC, zones, équipements), avec exécution locale et commandes gouvernées par notre plateforme.
3. Gestion unifiée CVC, éclairage, énergie, incendie, sécurité et systèmes tiers.
4. Positionnement architecture ouverte pour futures intégrations et extensions.
5. Dans l'option B, la vue unifiée mono-bâtiment (alarmes, tendances, coordination transverse) peut nécessiter une couche de supervision explicite (Desigo CC ou équivalent validé).

Services typiques a ce niveau:
1. Centre de commande/monitoring à l'échelle bâtiment.
2. Gestion des alarmes/événements et workflows operateur.
3. Optimisation énergie et confort à l'échelle bâtiment.

Ce que cela signifie pour nous:
1. Siemens peut supporter des pilotes mono-bâtiment avec périmètre opérationnel complet.
2. Nous pouvons valider les integrations à l'échelle bâtiment avant rollout portefeuille.

## 16.3 Contrôleur d'un système (CVC/CTA/ventilation/éclairage)

Offre Siemens a ce niveau:
1. Famille de contrôleurs Desigo PXC pour CVC programmable librement et contrôle d'intégration.
2. Options de contrôleurs scalables des contextes salle/compacts jusqu'au contrôle central de salle technique et campus.
3. Capacités protocole/sécurité incluant BACnet Secure Connect sur les nouvelles lignes de contrôleurs.
4. Options d'intégration système basees KNX pour éclairage/ombrage et contrôle confort en salle.

Services typiques a ce niveau:
1. Boucles de contrôle de domaine système (par exemple salle CVC ou domaines room-automation).
2. Orchestration des équipements et optimisation sous-système.
3. Intégration terrain et workflows d'engineering pour déploiement sous-système.

Ce que cela signifie pour nous:
1. Siemens peut être utilise pour une automatisation ciblee par sous-système (CVC d'abord, éclairage d'abord, etc.).
2. Cela supporte un rollout par domaine au lieu d'une reprise complète du bâtiment en une fois.

## 16.4 Contrôleur d'un équipement (salle / équipement local)

Offre Siemens a ce niveau:
1. Controle niveau salle/équipement via produits room automation et unités KNX tactile/salle.
2. Controle local HVAC, éclairage et ombrage au niveau espace.
3. Interfaces locales sensing/operation avec comportement d'automatisation centre sur la salle.

Services typiques a ce niveau:
1. Confort niveau équipement/salle et action locale.
2. Telemetrie au niveau point et comportements d'override local (selon déploiement).
3. Exploitation intelligente de la salle et logique de contrôle localisee.

Ce que cela signifie pour nous:
1. Siemens peut être integre a granularité fine, y compris cas d'usage salle/équipement.
2. Cela permet une modernisation selective de certains etages/zones sans conversion immediate de tout le bâtiment.

## 16.5 Conclusion Generale Pour Siemens

1. Siemens couvre les quatre granularites listees: équipement, système, un bâtiment et écosystème portefeuille.
2. Siemens fournit a la fois des options classiques pile GTB/contrôle (famille Desigo) et des options modernes plateforme numérique orientee API (Building X).
3. Notre choix de modèle d'intégration est strategique (périmètre et autorité de contrôle), pas limite par la couverture capacitaire Siemens.

Références principales utilisees pour cette conclusion:
1. Vue d'ensemble Siemens Building X:
https://www.siemens.com/us/en/products/buildingtechnologies/building-x.html
2. Guide openness developpeur Siemens Building X:
https://developer.siemens.com/building-x-openness/dev-guide/gettingstarted.html
3. Vue d'ensemble API Siemens Building X Building Operations:
https://developer.siemens.com/building-x-openness/api/building-operations/overview.html
4. Page GTB Siemens Desigo CC:
https://www.siemens.com/global/en/products/buildings/automation/desigo/building-management/desigo-cc.html
5. Page famille contrôleurs Siemens Desigo PXC:
https://www.siemens.com/global/en/products/buildings/desigo-building-automation/desigo-pxc.html
6. Page Siemens KNX building control:
https://www.siemens.com/en-us/products/desigo/knx-building-control/

## 17. Matrice de frontière de capacités v2

Date: 2026-03-20
Statut: matrice de décision de travail

Hypotheses d'architecture pour cette matrice:
1. La plateforme est la source de verite globale et l'autorité globale.
2. Les composants edge Schneider gardent la responsabilite temps reel locale dans leur périmètre.
3. Les variantes hybrides evaluees sont:
- `AS-P only`
- `Field controllers only` (sans automation servers)
- `AS-P + field controllers` ensemble

| Capacite | Full EBO | Hybride: AS-P only | Hybride: Field controllers only | Hybride: Both (AS-P + Field) | Signal Licensing / Cout / Complexité |
| --- | --- | --- | --- | --- | --- |
| Gestion identité / utilisateurs / roles | Schneider-centrique ou federee | Peut être possedee par la plateforme; identites locales Schneider optionnelles | Peut être possedee par la plateforme; identites service/équipement edge toujours requises | Peut être possedee par la plateforme avec identites opérationnelles locales | Full EBO implique en general un licensing logiciel/service plus large; l'hybride reduit la dependance stack centrale mais augmente le travail d'intégration |
| Onboarding équipements / opérations de flotte | Majoritairement pile Schneider | Partage ou pilote par plateforme; onboarding objets AS-P toujours requis | Pilote par plateforme + charge de commissioning direct des contrôleurs | Partage: mediation AS-P + commissioning terrain | Le mode field-only amene généralement l'effort de commissioning site par site le plus élevé |
| Collecte de télémétrie (brute) | Chemin de collecte Schneider natif | AS-P agrege la télémétrie edge; la plateforme ingere en amont | La plateforme s'integre directement aux protocoles/contrôleurs terrain | Pipeline terrain -> AS-P -> plateforme | Field-only augmente l'effort de gestion protocolaire pour l'equipe plateforme |
| Normalisation télémétrie / modèle canonique | Majoritairement modèle Schneider | Preferer modèle canonique plateforme | Preferer modèle canonique plateforme | Preferer modèle canonique plateforme | La propriété canonique dans la plateforme preserve la coherence inter-partenaires |
| Presentation des données / dashboards opérations | UX GTB native forte | Split par role: ops Schneider local + vues globales plateforme | Majoritairement plateforme, sauf ajout UX Schneider local | Split par role avec frontières plus claires | Les dashboards dupliques augmentent le coût si les frontières de role ne sont pas explicites |
| Gouvernance de commande (idempotence/sécurité/routage) | Majoritairement interne Schneider sauf intégration custom | Preferer gouvernance plateforme avec AS-P comme couche d'exécution controlee | Preferer gouvernance plateforme avec intégration de commande edge directe | Preferer gouvernance plateforme avec relais d'exécution AS-P | Aligne avec l'objectif d'autorité centrale |
| Boucles de contrôle local rapides | Forte | Forte | Forte | Resilience combinee la plus forte | La responsabilite edge des boucles rapides est preservee dans toutes les variantes hybrides |
| Propriete des scénarios (design et traitement runtime) | Majoritairement workflows Schneider | Split: scénarios techniques locaux dans Schneider, scénarios inter-domaines dans la plateforme | Split mais plus complexe: logique locale contrôleurs + orchestration plateforme | Meilleur modèle split: local dans edge Schneider, global dans plateforme | Exige un RACI explicite et des regles de conflit |
| Gestion des alarmes / événements | Natif fort | Partage | Partage avec plus de mapping custom | Partage avec structure plus forte | La reconciliation sémantique des alarmes est un coût d'intégration recurrent |
| Operations portefeuille multi-sites | Fort out-of-box | Portefeuille pilote par plateforme + services Schneider sélectifs | Majoritairement pilote par plateforme | Pilote par plateforme + overlays portefeuille Schneider sélectifs | Full EBO offre la meilleure UX portefeuille turnkey; l'hybride est meilleur pour souverainete et flexibilite |
| Exposition API a des tiers | Disponible mais oriente modèle Schneider | Preferer API plateforme comme contrat externe | Preferer API plateforme comme contrat externe | Preferer API plateforme comme contrat externe | Permet de garder des contrats partenaires externes uniformes entre ecosystemes |
| Exposition MQTT a des tiers | Pattern natif non principal | Preferer distribution MQTT plateforme | Preferer distribution MQTT plateforme | Preferer distribution MQTT plateforme | Permet de centraliser la distribution télémétrie |
| Add-ons domaine (énergie/sécurité/etc.) | Fit natif dans la pile Schneider | Utilisable de facon selective | Utilisable avec plus d'assemblage d'intégration | Utilisable de facon selective avec points de contact plus clairs | Requiert souvent des droits commerciaux/services supplementaires |
| Couche conseil/service (ex.: Building Advisor) | Fit opérationnel natif | Utilisable en overlay pour opérations portefeuille | Utilisable, mais effort d'intégration plus élevé | Fit hybride le plus pratique pour overlays de service | L'OPEX des plans de service doit être évalué face à l'outillage ops interne |
| Charge de traitement BACnet dans la plateforme | Plus faible | Moyenne | Plus élevée | Moyenne-faible | Field-only est généralement le plus intensif BACnet pour l'intégration plateforme |
| Repartition opérations cyber/sécurité | Schneider-dominant | Partage | Plateforme-dominant | Partage/equilibre | L'hybride requiert un durcissement explicite des interfaces et une gouvernance cycle de vie cert/cle |

## 17.1 Decisions De Split D'Autorite De Controle (Obligatoires Avant Design Final)

1. Autorite finale d'autorisation de commande:
- si toutes les actions mutables doivent être autorisees centralement par la plateforme.
2. Politique d'override local:
- quels composants edge Schneider peuvent surcharger l'intention centrale et dans quelles conditions auditees.
3. Regle de resolution de conflit:
- chemin de décision autoritatif quand logique locale de contrôle et intention centrale divergent.
4. Mode de repli critique sécurité:
- comportement pendant indisponibilites WAN/API (maintien, degrade, ou autonomie locale par classe de commande).
5. Frontière de propriété des scénarios:
- scénarios techniques locaux de contrôle vs scénarios metier/inter-domaines.
6. Autorite sur les alarmes:
- source de verite pour etat incident, accuse de reception et cloture.
7. Chaine de confiance identité:
- mapping du modèle d'identité central vers l'identité d'exécution edge.
8. Autorite d'audit:
- emplacement canonique des enregistrements d'audit et lien vers preuves edge.

## 17.2 Conclusion de travail (stratégie hybride Schneider)

1. Le meilleur fit pour le modèle d'autorité vise est en general `Hybrid: AS-P + Field`, avec exécution locale dans le périmètre Schneider et gouvernance globale dans la plateforme.
2. `Field-only` reste viable mais augmente la charge BACnet/intégration protocolaire et commissioning pour l'equipe plateforme.
3. `AS-P only` peut simplifier la mediation edge mais peut reduire la flexibilite locale niveau équipement par rapport a la topologie combinee.
4. Le choix final doit être valide par preuves pilote sur latence, effort de commissioning, gestion des pannes et tracabilite de gouvernance.

## 18. Resume Technique Intégration Schneider

Date: 2026-03-20
Statut: conclusion technique de travail

1. Tous les contrôleurs terrain Schneider ne sont pas egaux en connectivité:
- certains sont IP-capables (par ex. BACnet/IP),
- d'autres sont principalement orientes field-bus (par ex. environnements MS/TP).

2. L'intégration directe plateforme-vers-contrôleurs-terrain est possible dans certains cas, mais pas toujours pratique à l'échelle.

3. Un pattern d'intégration courant et recommandé pour cette architecture est:
- réseau BACnet terrain local (contrôleurs/équipements),
- AS-P comme frontière intégration/routage,
- intégration plateforme sur le point d'entree AS-P.

4. AS-P peut être utilise comme frontière passerelle/routage dans des topologies BACnet mixtes:
- gestion BACnet/IP + BACnet MS/TP,
- fonctions BBMD/routage si necessaire,
- support BACnet/SC dans les modèles/profils supportes.

5. Repartition des responsabilites d'intégration en pratique:
- integrateur/GTB engineering: commissioning terrain, mapping protocolaire, setup contrôleurs/serveurs,
- spécialistes réseau/sécurité: segmentation, routage/firewall, contrôles de connectivité securisee,
- equipe plateforme: intégration connecteurs vers points d'entree approuves et contrôles de gouvernance.

6. Recommandation par defaut pour opérations hybrides:
- garder la plateforme comme autorité globale/source de verite,
- garder le périmètre edge Schneider responsable du contrôle local temps reel,
- utiliser la frontière AS-P pour reduire la complexité BACnet exposee aux services cœur plateforme.

7. Recommandation de travail ajoutee:
- utiliser le serveur AS-P comme passerelle/point d'entree vers le réseau BACnet local comme pattern principal, sauf justification site-specifique pour intégration directe terrain.

## 20. Offre Siemens (Perimetre GTB)

Pour ce programme, l'offre Siemens peut être lue en quatre couches pratiques:

1. Couche logicielle GTB de supervision:
- Desigo CC pour supervision mono-bâtiment ou multi-bâtiments, alarmes, tendances, planification et workflows operateur.

2. Couche edge automation/contrôleurs:
- Famille Desigo PXC pour contrôle programmable HVAC/intégration, connectivité field-bus et exécution locale de l'automatisation.

3. Ecosysteme room/control devices:
- Equipements d'automatisation de salle base KNX (capteurs, actionneurs, room units) avec interfaces/routeurs/gateways KNX.

4. Couche plateforme/apps digitales (optionnelle mais strategique pour le portefeuille):
- Building X apps et Building X APIs (modèle subscription), orientes opérations portefeuille, analytics et usages digital opérations.

## 21. Differences Architecturales: Siemens vs Schneider

Les deux ecosystemes se recouvrent fonctionnellement, mais diffèrent dans le packaging d'architecture:

1. Pattern courant Schneider:
- Frontière edge centree automation server (role AS-P/AS-B) utilisee comme hub intégration + contrôle,
- plus familles de contrôleurs/équipements,
- plus couches optionnelles de services/overlay.

2. Pattern courant Siemens:
- Famille edge centree contrôleurs (PXC),
- aggregation de supervision via Desigo CC,
- couche optionnelle Building X platform/apps pour capacités cloud portefeuille.

3. Implication intégration:
- Schneider met souvent en avant AS-P comme frontière explicite d'automatisation bâtiment.
- Siemens obtient souvent un resultat equivalent via PXC + intégration KNX + couche de supervision (Desigo CC), selon le périmètre.

4. Implication gouvernance pour ce programme:
- Dans les deux ecosystemes, conserver la gouvernance globale plateforme et les contrats canoniques au centre.
- Utiliser la pile partenaire pour le contrôle local temps reel et l'exécution opérationnelle sur site.

## 22. AS-P vs PXC (Vue Fonctionnelle et Capacitaire)

| Aspect | Schneider AS-P (role automation server) | Siemens PXC (role famille de contrôleurs) |
| --- | --- | --- |
| Positionnement principal | Automation server edge et frontière d'intégration | Contrôleurs d'automatisation edge programmables |
| Role typique en architecture | Frontière serveur mono-bâtiment pour intégration GTB et automatisation locale | Execution contrôle terrain/système; supervision généralement couplee a Desigo CC |
| Logique de contrôle edge | Oui | Oui |
| Trend logging et alarm supervision | Oui | Oui (au niveau automation station/contrôleur) |
| Intégration field-bus/I-O | Oui (selon modèle; intégration serie/IP) | Oui (selon modèle; variantes contrôleurs scalables) |
| Comportement single-point entry | Souvent cadre autour de la frontière AS-P | Souvent obtenu via pattern contrôleur + couche de supervision |
| Extension cloud/app portefeuille | Via couches écosystème séparées | Via Building X apps/APIs (subscription-based) |

## 23. Matrice Side-by-Side (Ligne Dediee Entry-Point)

Legende:
- `native`: pattern direct et explicite dans le cadrage d'architecture fournisseur.
- `via gateway`: possible via gateway/interface protocolaire.
- `needs supervisory layer`: requiert généralement une couche GTB de supervision pour une exploitation centralisee pratique.

| Capacite | Schneider (chemin AS-P/EBO) | Siemens (chemin PXC/Desigo) |
| --- | --- | --- |
| Single building entry point across BACnet/KNX/Modbus | `native` pour BACnet/Modbus a la frontière AS-P; KNX généralement `via gateway` | Convergence BACnet/KNX/Modbus généralement `needs supervisory layer` (Desigo CC) et/ou `via gateway` pour pont KNX |
| Intégration BACnet | `native` | `native` |
| Intégration KNX dans les opérations GTB | `via gateway` | `via gateway` (et souvent normalisee via la couche de supervision) |
| Couche cloud/API apps pour opérations portefeuille | disponible, mais souvent separee de la frontière AS-P | fortement produitisee via Building X apps/APIs (subscription) |

## 24. Conclusion de travail pour le design

1. Ne pas forcer une equivalence stricte one-to-one entre les roles produits AS-P et PXC.
2. Comparer les resultats d'intégration au niveau architecture (single entry point, command governance, mediation protocolaire, ownership opérations), pas uniquement par etiquette produit.
3. Pour ce programme, maintenir l'autorité globale plateforme tout en exploitant les capacités edge/supervision partenaire pour reduire la complexité d'intégration site.

## 25. Glossaire BACnet

1. BACnet:
- Standard de protocole de communication d'automatisation bâtiment utilise par contrôleurs/serveurs/équipements et clients logiciels.

2. BACnet/IP:
- BACnet sur Ethernet/IP (couramment base UDP).

3. BACnet MS/TP:
- BACnet sur bus serie RS-485 utilisant le token passing.

4. BACnet/SC:
- BACnet Secure Connect; profil de transport BACnet securise pour modèles modernes de sécurité IP/base certificat.

5. BBMD:
- BACnet Broadcast Management Device; relaie le trafic broadcast BACnet/IP entre sous-reseaux pour scénarios de decouverte/communication.

6. COV:
- Change of Value; mecanisme de souscription BACnet pour recevoir des mises a jour quand les valeurs changent, reduisant le polling constant.

7. BIBBs:
- BACnet Interoperability Building Blocks; groupes de capacités standardises publies pour decrire quelles fonctions BACnet un produit supporte.

8. Device Instance:
- Identifiant BACnet unique d'équipement utilise pour identifier un équipement BACnet sur le réseau.

9. Object / Property:
- Elements du modèle de données BACnet; les équipements exposent des objets (par ex. analog input/output) avec des proprietes (par ex. presentValue, units, status).

10. IP:
- Adresse réseau (par ex. `10.20.30.40`) utilisee pour atteindre des équipements sur reseaux IP.

11. FQDN:
- Fully Qualified Domain Name (par ex. `as-p-site1.company.local`) utilise comme identité endpoint basée DNS.

12. Point d'entree:
- Frontière d'intégration joignable réseau utilisee par la plateforme pour acceder aux domaines locaux d'automatisation bâtiment (par ex. AS-P, gateway, ou endpoint contrôleur approuve).

