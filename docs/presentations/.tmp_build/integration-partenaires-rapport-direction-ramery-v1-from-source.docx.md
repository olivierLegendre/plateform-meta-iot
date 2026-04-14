![Logo Ramery](/home/olivier/work/iot_services/plateform-meta-iot/docs/presentations/assets/ramery-logo-baseline.png){ width=220px }

# Briefing De Decision Integration Partenaires (Depuis Zero)

Date: 2026-03-20
Audience: non-specialistes, sponsors, parties prenantes projet
Objectif: expliquer les choix d'integration partenaires pour l'automatisation du batiment et le jumeau numerique, et documenter le contexte comme memoire projet stable.

## 1. Contexte De Base (Acte)

Votre plateforme fait deja les choses suivantes:
1. Ingestion de telemetrie des equipements IoT.
2. Centralisation des donnees.
3. Gestion de l'identite et des acces.
4. Exposition de la telemetrie vers l'exterieur via API et MQTT.

Ce briefing porte sur l'ajout de capacites partenaires au-dessus de cette base.

## 1.1 Mises A Jour Du Contexte De Travail (Journal De Decision)

1. Precision de contexte Tandem (enregistree le 2026-03-20):
- L'entreprise est une societe de construction qui utilise deja les outils Autodesk pour modeliser les batiments.
- Les modeles de batiments existent deja.
- L'etape cible suivante est de connecter les equipements IoT a ces batiments et de lier telemetrie/contexte via Tandem/Tandem Connect.

## 2. Deux Fonctionnalites Separees A L'Etude

## 2.1 Partenaires D'Automatisation (Schneider, Siemens; potentiellement d'autres)

Questions auxquelles repondre:
1. Que peuvent automatiser ces partenaires?
2. A quelle granularite (equipement unique, etage, batiment, portefeuille)?
3. Comment les connecter techniquement?
4. Quelles implications en architecture, cout, difficulte et risque?

## 2.2 Partenaire Jumeau Numerique (Autodesk Tandem / Tandem Connect)

Questions auxquelles repondre:
1. Que devons-nous fournir pour faire fonctionner Tandem?
2. Comment notre plateforme doit-elle s'integrer proprement et en securite?
3. Quelles sont les contraintes, les couts et les risques?

## 3. Partenaires D'Automatisation: Ce Qu'ils Sont Et Ce Qu'ils Peuvent Faire

## 3.1 Schneider (ecosysteme EcoStruxure Building Operation / SpaceLogic)

En pratique, Schneider peut couvrir plusieurs couches:
1. Couche equipement/salle: controle local (ex.: HVAC de salle, certaines sequences locales).
2. Couche equipement/etage: coordination AHU/FCU/boucle de refroidissement et logique de supervision.
3. Couche batiment/campus: supervision centrale, alarmes, planification, historisation des tendances, optimisation.

Implication:
1. Schneider n'est pas seulement un controleur de "petit equipement".
2. Il peut constituer une pile complete d'automatisation du batiment selon le perimetre de deploiement.

## 3.2 Siemens (ecosysteme Desigo + Building X)

Siemens doit etre regarde selon deux dimensions:
1. Systemes d'automatisation/controle du batiment (cote controleurs et BMS).
2. Capacites de plateforme cloud API-first via Building X (cote operations/integration).

Implication:
1. Siemens peut egalement operer du controle point-a-point jusqu'aux workflows de portefeuille.
2. Les API Building X sont pertinentes pour l'integration de capacites cloud operationnelles.

## 3.3 Carte De Granularite (Applicable Aux Deux)

Schneider et Siemens peuvent etre utilises aux niveaux suivants:
1. Niveau point/actionneur unique (consigne, on/off, mode).
2. Niveau equipement (AHU, pompes, chillers, ventilo-convecteurs).
3. Niveau zone/etage (controle coordonne confort/energie).
4. Niveau batiment complet (plannings, alarmes, optimisation).
5. Niveau portefeuille multi-batiments (modes d'exploitation centralises).

## 4. Comment Nous Connecter Aux Partenaires D'Automatisation

Dans les programmes reels, les connexions sont generalement un mix de:
1. Integration par protocoles OT (ex.: famille BACnet dans de nombreux deploiements).
2. Integration basee API (en particulier pour les capacites de plateforme cloud).
3. Passerelles/serveurs d'integration pour normaliser les environnements legacy.
4. Interactions par evenements/messages pour alertes et orchestration.

Ce qu'il faut avant integration:
1. Inventaire et mapping des points (lecture/ecriture, unites, frequences, qualite).
2. Matrice d'autorite (qui peut commander quoi, ou, quand).
3. Politique de securite fonctionnelle (maintien, override, comportement fail-safe).
4. Modele de mapping tenant/site (frontieres organisation/site).
5. Prerequis reseau et securite (segmentation, chemin certificats/cles, flux autorises).
6. Runbooks d'incident et de rollback.

## 5. Ce Que Cela Signifie Pour Votre Architecture

Vous avez deux modes operatoires valides avec Schneider/Siemens:

1. Partenaire-comme-automatisation-principale:
- La plateforme partenaire detient la majorite du controle en boucle fermee.
- Votre plateforme fournit les donnees/le contexte et l'enveloppe de gouvernance.

2. Partenaire-comme-automatisation-de-domaine-cible:
- Le partenaire controle seulement des domaines/sites selectionnes.
- Votre plateforme reste l'orchestrateur global.

Les deux sont viables; le choix depend de l'appetit de gouvernance, des contrats existants et du modele de propriete operationnelle.

## 6. Couts, Difficulte Et Limites (Automatisation)

L'effort principal n'est generalement pas le codage d'API.
Principaux facteurs d'effort:
1. Nettoyage de qualite des points et metadonnees.
2. Commissioning et mapping par site.
3. Gouvernance de securite des commandes et de l'autorite.
4. Approbations cybers et contraintes reseau.
5. Variabilite multi-sites et heterogeneite legacy.

Tendance de complexite:
1. Pilote cible mono-site: moyenne.
2. Deploiement multi-sites multi-fournisseurs: elevee.
3. Portefeuille complet avec gouvernance de controle stricte: tres elevee.

## 7. Jumeau Numerique Avec Autodesk Tandem: Ce Que C'est

Tandem est a traiter comme une plateforme de jumeau numerique et de contexte cycle de vie.
Ce n'est generalement pas la boucle principale de controle terrain a faible latence.

Valeur principale de Tandem:
1. Contexte des actifs et continuite cycle de vie.
2. Liaison des donnees operationnelles aux actifs physiques et aux espaces.
3. Workflows pilotes par evenements et contexte transverse entre systemes.

## 8. Ce Que Vous Devez Fournir Pour Faire Fonctionner Tandem

Package minimum d'integration:
1. Hierarchie des installations (site/batiment/etage/espace).
2. Modele d'actifs et identifiants.
3. Mapping capteur/point vers actif.
4. Contrat de telemetrie (horodatage, unite, qualite, source).
5. Gouvernance des metadonnees (noms, tags, classifications).
6. Configuration credentials/environnement et connecteurs.
7. Politique d'evenements (quels changements du twin declenchent quels workflows).

Mode operatoire recommande:
1. Garder votre plateforme comme coeur telemetrie/gouvernance.
2. Utiliser Tandem comme couche contexte/twin.
3. Garder l'execution des commandes dans votre gouvernance de commande et/ou dans le plan partenaire d'automatisation.

## 9. Limites, Couts Et Risques (Tandem)

Risques principaux:
1. Decalage semantique entre points IoT et modele twin.
2. Derive du twin dans le temps (modele non synchronise avec la realite du batiment).
3. Surcharge de la couche twin avec des responsabilites mieux gardees dans les systemes de controle.

Couts principaux:
1. Gouvernance de modelisation et de mapping des donnees.
2. Processus continu de curation et de synchronisation.
3. Alignement de responsabilite inter-equipes (ops/engineering/facilities).

## 10. Scenarios De Decision

Vous pouvez choisir un de ces scenarios strategiques:
1. Schneider/Siemens comme controle BAS complet + votre plateforme comme couche superieure donnees/gouvernance.
2. Schneider/Siemens comme domaines de controle selectifs + votre plateforme orchestre globalement.
3. Tandem uniquement comme couche de contexte numerique.
4. Tandem + partenaire d'automatisation ensemble, avec votre plateforme comme coeur canonique integration/gouvernance.

Le scenario 4 est souvent le modele entreprise le plus scalable a long terme.

## 11. Approche Pilote Recommandee

Avant verrouillage final de l'architecture:
1. Choisir un batiment pilote.
2. Definir un perimetre borne: 20-30 points en lecture, 5-10 points en ecriture.
3. Valider trois elements:
- fiabilite de telemetrie,
- comportement autorite/securite des commandes,
- qualite de synchronisation du twin.
4. Utiliser les preuves du pilote pour decider le modele operatoire final.

## 12. Sujets De Gouvernance Critiques Pour Les Sponsors

Ces points sont obligatoires quel que soit le choix de partenaire:

1. Strategie de modele semantique:
- modele canonique + metadonnees fournisseur controlees,
- couche de tagging style Brick/Haystack pour normalisation inter-fournisseurs.

2. Modele d'autorite de commande:
- matrice explicite de politique "qui peut ecrire quoi, ou, quand",
- controles role/site/temps/actif/classe-de-commande,
- lineage immuable des commandes et piste d'audit.

3. SLA de qualite des donnees:
- staleness/freshness, ratio de donnees manquantes, bornes de derive d'horodatage,
- scorecards qualite par partenaire et alerting.

4. Gate de certification partenaire avant production:
- tests de contrat,
- parite de sandbox,
- exercices de bascule,
- repetition de rollback.

5. Alignement baseline cyber:
- segmentation reseau,
- cycle de vie certificats/cles,
- secrets geres par vault,
- controles auditables incident/recovery.

## 13. Questions Ouvertes A Resoudre Avant Design Final

1. Les partenaires doivent-ils detenir le controle direct des actionneurs en production, ou toutes les ecritures doivent-elles toujours passer d'abord par votre gouvernance centrale?
2. Le rollout commence-t-il en mono-site ou multi-sites?
3. Quel sous-systeme est prioritaire en premier (HVAC, eclairage, mixte)?
4. Pour le jumeau numerique, faut-il d'abord du streaming quasi temps reel ou d'abord la synchronisation contexte/cycle de vie?
5. Les sponsors preferent-ils un modele cible unique recommande ou une matrice d'options avec compromis?

## 14. References

1. Vue d'ensemble Schneider BMS:
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

## 15. Journal De Decision - Integration Schneider (Carte De Granularite)

Date: 2026-03-20
Statut: conclusion de travail (validee avec pages officielles produits/services Schneider)

## 15.1 Ecosysteme Batiments Complets (Portefeuille / Multi-batiments)

Offre Schneider a ce niveau:
1. Plateforme BMS centrale avec vues portefeuille et comportement de centre de controle via EcoStruxure Building Operation.
2. Perimetre d'integration inter-sous-systemes incluant HVAC, eclairage, energie, microgrid, recharge EV, securite et incendie.
3. Couches de services geres/distants (Building Advisor) avec monitoring modulaire et assistance operationnelle.

Services typiques a ce niveau:
1. Monitoring portefeuille et dashboards.
2. Supervision alarmes et sante systeme sur plusieurs sites.
3. Maintenance basee condition et reporting de valeur.
4. Options de support expert cloud/service-plan.

Ce que cela signifie pour nous:
1. Schneider peut agir comme pile complete d'operations batiment entreprise, pas seulement comme controleur local.
2. L'integration peut se faire au niveau supervision et operations metier, pas uniquement au niveau equipement terrain.

## 15.2 Ecosysteme Un Batiment

Offre Schneider a ce niveau:
1. Operations integrees mono-batiment via EcoStruxure Building Operation comme centre de controle unifie.
2. Visibilite au niveau batiment pour perimetres equipement, etage et batiment.
3. Controle batiment, planification, alarmes, historisation des tendances et workflows d'optimisation.

Services typiques a ce niveau:
1. Supervision des operations a l'echelle du batiment.
2. Coordination multi-sous-systemes.
3. Boucles d'analytique et d'optimisation batiment.

Ce que cela signifie pour nous:
1. Nous pouvons integrer batiment par batiment sans imposer immediatement un rollout portefeuille.
2. Un pilote mono-batiment peut etre representatif pour la validation technique.

## 15.3 Controleur D'Un Systeme (HVAC/AHU/FCU/Eclairage)

Offre Schneider a ce niveau:
1. Familles de controleurs de salle technique (ex.: SpaceLogic MP-C) pour controle HVAC/salle mecanique.
2. Couche serveurs/controleurs d'automatisation (AS-P/AS-B) pour logique edge, tendances, alarmes et connectivite field bus.
3. Controleurs salle/systeme pouvant gerer eclairage/stores/temperature et controle lie a l'occupation.

Services typiques a ce niveau:
1. Boucles de controle niveau systeme.
2. Orchestration des equipements (domaine AHU/salle technique).
3. Collecte de donnees et logique locale de supervision.

Ce que cela signifie pour nous:
1. Schneider peut etre utilise comme controleur de domaine (par exemple HVAC d'abord) sans deleguer le batiment entier.
2. Cela supporte une strategie d'integration par phases, par sous-systeme.

## 15.4 Controleur D'Un Equipement (Salle / Equipement Local)

Offre Schneider a ce niveau:
1. Controleurs salle/equipement (familles SpaceLogic room controller) pour temperature, eclairage, stores et controle local base sur l'occupation.
2. Options locales HMI/affichage operateur pour taches operation/maintenance.
3. Controle au plus pres de l'equipement et collecte de telemetrie a granularite salle/zone.

Services typiques a ce niveau:
1. Sensing/controle au niveau point.
2. Logique locale de confort et d'occupation.
3. Diagnostics equipement et overrides locaux (selon design deploye).

Ce que cela signifie pour nous:
1. Schneider peut etre integre a granularite tres fine, jusqu'au perimetre salle/equipement.
2. C'est utile quand seule une optimisation locale ciblee est necessaire.

## 15.5 Conclusion Generale Pour Schneider

1. Schneider couvre les quatre granularites listees: equipement, systeme, batiment unique et ecosysteme portefeuille.
2. Le meme fournisseur peut etre engage sur un perimetre etroit (un sous-systeme/site) ou sur une possession complete BAS/BMS.
3. Notre choix d'integration est d'abord architectural et contractuel, pas limite par la capacite Schneider seule.

References principales utilisees pour cette conclusion:
1. Page produit Schneider BMS (perimetre, couverture sous-systemes, serveurs/controleurs d'automatisation/controleurs salle/HMI):
https://www.se.com/us/en/work/products/product-launch/building-management-system/
2. Page service Schneider Building Advisor (logiciel gere modulaire, plans, services health/alarm/task/value):
https://www.se.com/ie/en/work/services/field-services/building-services/building-advisor/

## 15.6 Deep Dive - Offre Schneider Ecosysteme Portefeuille Complet

Pour un perimetre portefeuille ecosysteme complet, l'offre Schneider se comprend comme une pile d'exploitation en couches:

1. Couche plateforme d'integration et de controle (EcoStruxure Building Operation):
- Framework d'integration logicielle ouvert et securise, concu pour connecter systemes Schneider et tiers.
- Le perimetre inclut explicitement energie, eclairage, HVAC, securite incendie, securite des acces et gestion des espaces de travail.
- Capacites monitor/manage/control depuis contextes mobile et entreprise.
- Positionnement du petit batiment jusqu'aux entreprises multi-sites complexes.

2. Couche equipements et controleurs (Connected Products / SmartX IP):
- Produits connectes niveau terrain (capteurs, vannes, actionneurs, etc.).
- Controleurs SmartX IP pour des topologies IP end-to-end scalables et la transmission de donnees depuis les equipements connectes.
- Posture securite integree et intention de diagnostic accelere au niveau controleur.

3. Modules d'extension de domaine dans le meme ecosysteme:
- Energy Expert: monitoring/mesure/optimisation energie integres dans la meme interface que les domaines HVAC/eclairage/incendie.
- Security Expert: controle d'acces physique integre, base sur les roles, et contexte intrusion avec visibilite entreprise complete.

4. Services de maintenance et analytique portefeuille (Building Advisor):
- Vue portefeuille "outil unique" a travers batiments/systemes/equipements.
- Modele modulaire: BMS Health, Asset Health, Smart Alarm, Task Manager, Value Reports.
- Plans de service (Plus/Prime/Ultra) combinant supervision distante, diagnostic, maintenance preventive/basee condition et support on-site optionnel.
- Cycle operatoire explicite: Monitor -> Maintain -> Improve avec suivi KPI/ROI.

5. Posture operationnelle/cyber et cycle de vie:
- L'architecture portefeuille inclut la visibilite de sante logicielle/firmware et l'analyse de tendances reseau/systeme.
- Le discours Schneider inclut la posture cybers et conformite a travers la pile batiment.
- Les services cycle de vie et l'ecosysteme partenaires (programme EcoXpert) font partie des operations a l'echelle.

6. Caracteristiques d'echelle et portefeuille mises en avant par Schneider:
- Positionnement pour grandes entreprises et environnements multi-sites.
- Acceleration engineering et commissioning revendiquee dans les pages solution publiees.
- Mention de scale "jusqu'a 10x" pour support grands comptes/multi-sites dans le messaging solution.

Ce que cela signifie pour nous (cas d'usage portefeuille):
1. Schneider peut etre choisi comme pile d'exploitation portefeuille end-to-end, pas seulement comme fournisseur equipement/systeme.
2. Les decisions d'integration deviennent des decisions de gouvernance: ou se place l'autorite de commande, comment se partage la propriete des donnees, et quels workflows analytics/maintenance restent dans notre plateforme vs modules de service Schneider.
3. La valeur la plus forte apparait quand operations portefeuille, maintenance basee condition et optimisation inter-domaines sont requises, pas seulement le controle au niveau point.

## 16. Journal De Decision - Integration Siemens (Carte De Granularite)

Date: 2026-03-20
Statut: conclusion de travail (validee avec pages produit et developpeur Siemens)

## 16.1 Ecosysteme Batiments Complets (Portefeuille / Multi-batiments)

Offre Siemens a ce niveau:
1. Operations portefeuille et inter-batiments avec applications plateforme Building X.
2. Backbone de gestion batiment integre avec Desigo CC sur plusieurs disciplines.
3. Modele API et plateforme numerique (Building X Openness) pour integration donnees/operations.

Services typiques a ce niveau:
1. Gestion des operations multi-batiments.
2. Optimisation inter-domaines (energie, operations, surete/securite, maintenance).
3. Supervision centralisee et integration de sous-systemes batiment heterogenes.

Ce que cela signifie pour nous:
1. Siemens peut operer comme partenaire ecosysteme complet, pas seulement comme fournisseur de controleur mono-systeme.
2. L'integration peut se faire au niveau UI/workflow operationnel (Building X) et au niveau BMS de supervision (Desigo CC).

## 16.2 Ecosysteme Un Batiment

Offre Siemens a ce niveau:
1. Gestion integree mono-batiment via Desigo CC.
2. Gestion unifiee HVAC, eclairage, energie, incendie, securite et systemes tiers.
3. Positionnement architecture ouverte pour futures integrations et extensions.

Services typiques a ce niveau:
1. Centre de commande/monitoring a l'echelle batiment.
2. Gestion des alarmes/evenements et workflows operateur.
3. Optimisation energie et confort a l'echelle batiment.

Ce que cela signifie pour nous:
1. Siemens peut supporter des pilotes mono-batiment avec perimetre operationnel complet.
2. Nous pouvons valider les integrations a l'echelle batiment avant rollout portefeuille.

## 16.3 Controleur D'Un Systeme (HVAC/AHU/FCU/Eclairage)

Offre Siemens a ce niveau:
1. Famille de controleurs Desigo PXC pour HVAC programmable librement et controle d'integration.
2. Options de controleurs scalables des contextes salle/compacts jusqu'au controle central de salle technique et campus.
3. Capacites protocole/securite incluant BACnet Secure Connect sur les nouvelles lignes de controleurs.
4. Options d'integration systeme basees KNX pour eclairage/ombrage et controle confort en salle.

Services typiques a ce niveau:
1. Boucles de controle de domaine systeme (par exemple salle HVAC ou domaines room-automation).
2. Orchestration des equipements et optimisation sous-systeme.
3. Integration terrain et workflows d'engineering pour deploiement sous-systeme.

Ce que cela signifie pour nous:
1. Siemens peut etre utilise pour une automatisation ciblee par sous-systeme (HVAC d'abord, eclairage d'abord, etc.).
2. Cela supporte un rollout par domaine au lieu d'une reprise complete du batiment en une fois.

## 16.4 Controleur D'Un Equipement (Salle / Equipement Local)

Offre Siemens a ce niveau:
1. Controle niveau salle/equipement via produits room automation et unites KNX tactile/salle.
2. Controle local HVAC, eclairage et ombrage au niveau espace.
3. Interfaces locales sensing/operation avec comportement d'automatisation centre sur la salle.

Services typiques a ce niveau:
1. Confort niveau equipement/salle et action locale.
2. Telemetrie au niveau point et comportements d'override local (selon deploiement).
3. Exploitation intelligente de la salle et logique de controle localisee.

Ce que cela signifie pour nous:
1. Siemens peut etre integre a granularite fine, y compris cas d'usage salle/equipement.
2. Cela permet une modernisation selective de certains etages/zones sans conversion immediate de tout le batiment.

## 16.5 Conclusion Generale Pour Siemens

1. Siemens couvre les quatre granularites listees: equipement, systeme, un batiment et ecosysteme portefeuille.
2. Siemens fournit a la fois des options classiques pile BMS/controle (famille Desigo) et des options modernes plateforme numerique orientee API (Building X).
3. Notre choix de modele d'integration est strategique (perimetre et autorite de controle), pas limite par la couverture capacitaire Siemens.

References principales utilisees pour cette conclusion:
1. Vue d'ensemble Siemens Building X:
https://www.siemens.com/us/en/products/buildingtechnologies/building-x.html
2. Guide openness developpeur Siemens Building X:
https://developer.siemens.com/building-x-openness/dev-guide/gettingstarted.html
3. Vue d'ensemble API Siemens Building X Building Operations:
https://developer.siemens.com/building-x-openness/api/building-operations/overview.html
4. Page BMS Siemens Desigo CC:
https://www.siemens.com/global/en/products/buildings/automation/desigo/building-management/desigo-cc.html
5. Page famille controleurs Siemens Desigo PXC:
https://www.siemens.com/global/en/products/buildings/desigo-building-automation/desigo-pxc.html
6. Page Siemens KNX building control:
https://www.siemens.com/en-us/products/desigo/knx-building-control/

## 17. Matrice De Frontiere De Capacites v2

Date: 2026-03-20
Statut: matrice de decision de travail

Hypotheses d'architecture pour cette matrice:
1. La plateforme est la source de verite globale et l'autorite globale.
2. Les composants edge Schneider gardent la responsabilite temps reel locale dans leur perimetre.
3. Les variantes hybrides evaluees sont:
- `AS-P only`
- `Field controllers only` (sans automation servers)
- `AS-P + field controllers` ensemble

| Capacite | Full EBO | Hybride: AS-P only | Hybride: Field controllers only | Hybride: Both (AS-P + Field) | Signal Licensing / Cout / Complexite |
| --- | --- | --- | --- | --- | --- |
| Gestion identite / utilisateurs / roles | Schneider-centrique ou federee | Peut etre possedee par la plateforme; identites locales Schneider optionnelles | Peut etre possedee par la plateforme; identites service/equipement edge toujours requises | Peut etre possedee par la plateforme avec identites operationnelles locales | Full EBO implique en general un licensing logiciel/service plus large; l'hybride reduit la dependance stack centrale mais augmente le travail d'integration |
| Onboarding equipements / operations de flotte | Majoritairement pile Schneider | Partage ou pilote par plateforme; onboarding objets AS-P toujours requis | Pilote par plateforme + charge de commissioning direct des controleurs | Partage: mediation AS-P + commissioning terrain | Le mode field-only amene generalement l'effort de commissioning site par site le plus eleve |
| Collecte de telemetrie (brute) | Chemin de collecte Schneider natif | AS-P agrege la telemetrie edge; la plateforme ingere en amont | La plateforme s'integre directement aux protocoles/controleurs terrain | Pipeline terrain -> AS-P -> plateforme | Field-only augmente l'effort de gestion protocolaire pour l'equipe plateforme |
| Normalisation telemetrie / modele canonique | Majoritairement modele Schneider | Preferer modele canonique plateforme | Preferer modele canonique plateforme | Preferer modele canonique plateforme | La propriete canonique dans la plateforme preserve la coherence inter-partenaires |
| Presentation des donnees / dashboards operations | UX BMS native forte | Split par role: ops Schneider local + vues globales plateforme | Majoritairement plateforme, sauf ajout UX Schneider local | Split par role avec frontieres plus claires | Les dashboards dupliques augmentent le cout si les frontieres de role ne sont pas explicites |
| Gouvernance de commande (idempotence/securite/routage) | Majoritairement interne Schneider sauf integration custom | Preferer gouvernance plateforme avec AS-P comme couche d'execution controlee | Preferer gouvernance plateforme avec integration de commande edge directe | Preferer gouvernance plateforme avec relais d'execution AS-P | Aligne avec l'objectif d'autorite centrale |
| Boucles de controle local rapides | Forte | Forte | Forte | Resilience combinee la plus forte | La responsabilite edge des boucles rapides est preservee dans toutes les variantes hybrides |
| Propriete des scenarios (design et traitement runtime) | Majoritairement workflows Schneider | Split: scenarios techniques locaux dans Schneider, scenarios inter-domaines dans la plateforme | Split mais plus complexe: logique locale controleurs + orchestration plateforme | Meilleur modele split: local dans edge Schneider, global dans plateforme | Exige un RACI explicite et des regles de conflit |
| Gestion des alarmes / evenements | Natif fort | Partage | Partage avec plus de mapping custom | Partage avec structure plus forte | La reconciliation semantique des alarmes est un cout d'integration recurrent |
| Operations portefeuille multi-sites | Fort out-of-box | Portefeuille pilote par plateforme + services Schneider selectifs | Majoritairement pilote par plateforme | Pilote par plateforme + overlays portefeuille Schneider selectifs | Full EBO offre la meilleure UX portefeuille turnkey; l'hybride est meilleur pour souverainete et flexibilite |
| Exposition API a des tiers | Disponible mais oriente modele Schneider | Preferer API plateforme comme contrat externe | Preferer API plateforme comme contrat externe | Preferer API plateforme comme contrat externe | Permet de garder des contrats partenaires externes uniformes entre ecosystemes |
| Exposition MQTT a des tiers | Pattern natif non principal | Preferer distribution MQTT plateforme | Preferer distribution MQTT plateforme | Preferer distribution MQTT plateforme | Permet de centraliser la distribution telemetrie |
| Add-ons domaine (energie/securite/etc.) | Fit natif dans la pile Schneider | Utilisable de facon selective | Utilisable avec plus d'assemblage d'integration | Utilisable de facon selective avec points de contact plus clairs | Requiert souvent des droits commerciaux/services supplementaires |
| Couche conseil/service (ex.: Building Advisor) | Fit operationnel natif | Utilisable en overlay pour operations portefeuille | Utilisable, mais effort d'integration plus eleve | Fit hybride le plus pratique pour overlays de service | L'OPEX des plans de service doit etre evalue face a l'outillage ops interne |
| Charge de traitement BACnet dans la plateforme | Plus faible | Moyenne | Plus elevee | Moyenne-faible | Field-only est generalement le plus intensif BACnet pour l'integration plateforme |
| Repartition operations cyber/securite | Schneider-dominant | Partage | Plateforme-dominant | Partage/equilibre | L'hybride requiert un durcissement explicite des interfaces et une gouvernance cycle de vie cert/cle |

## 17.1 Decisions De Split D'Autorite De Controle (Obligatoires Avant Design Final)

1. Autorite finale d'autorisation de commande:
- si toutes les actions mutables doivent etre autorisees centralement par la plateforme.
2. Politique d'override local:
- quels composants edge Schneider peuvent surcharger l'intention centrale et dans quelles conditions auditees.
3. Regle de resolution de conflit:
- chemin de decision autoritatif quand logique locale de controle et intention centrale divergent.
4. Mode de repli critique securite:
- comportement pendant indisponibilites WAN/API (maintien, degrade, ou autonomie locale par classe de commande).
5. Frontiere de propriete des scenarios:
- scenarios techniques locaux de controle vs scenarios metier/inter-domaines.
6. Autorite sur les alarmes:
- source de verite pour etat incident, accuse de reception et cloture.
7. Chaine de confiance identite:
- mapping du modele d'identite central vers l'identite d'execution edge.
8. Autorite d'audit:
- emplacement canonique des enregistrements d'audit et lien vers preuves edge.

## 17.2 Conclusion De Travail (Strategie Hybride Schneider)

1. Le meilleur fit pour le modele d'autorite vise est en general `Hybrid: AS-P + Field`, avec execution locale dans le perimetre Schneider et gouvernance globale dans la plateforme.
2. `Field-only` reste viable mais augmente la charge BACnet/integration protocolaire et commissioning pour l'equipe plateforme.
3. `AS-P only` peut simplifier la mediation edge mais peut reduire la flexibilite locale niveau equipement par rapport a la topologie combinee.
4. Le choix final doit etre valide par preuves pilote sur latence, effort de commissioning, gestion des pannes et tracabilite de gouvernance.

## 18. Resume Technique Integration Schneider

Date: 2026-03-20
Statut: conclusion technique de travail

1. Tous les controleurs terrain Schneider ne sont pas egaux en connectivite:
- certains sont IP-capables (par ex. BACnet/IP),
- d'autres sont principalement orientes field-bus (par ex. environnements MS/TP).

2. L'integration directe plateforme-vers-controleurs-terrain est possible dans certains cas, mais pas toujours pratique a l'echelle.

3. Un pattern d'integration courant et recommande pour cette architecture est:
- reseau BACnet terrain local (controleurs/equipements),
- AS-P comme frontiere integration/routage,
- integration plateforme sur le point d'entree AS-P.

4. AS-P peut etre utilise comme frontiere passerelle/routage dans des topologies BACnet mixtes:
- gestion BACnet/IP + BACnet MS/TP,
- fonctions BBMD/routage si necessaire,
- support BACnet/SC dans les modeles/profils supportes.

5. Repartition des responsabilites d'integration en pratique:
- integrateur/BMS engineering: commissioning terrain, mapping protocolaire, setup controleurs/serveurs,
- specialistes reseau/securite: segmentation, routage/firewall, controles de connectivite securisee,
- equipe plateforme: integration connecteurs vers points d'entree approuves et controles de gouvernance.

6. Recommandation par defaut pour operations hybrides:
- garder la plateforme comme autorite globale/source de verite,
- garder le perimetre edge Schneider responsable du controle local temps reel,
- utiliser la frontiere AS-P pour reduire la complexite BACnet exposee aux services coeur plateforme.

7. Recommandation de travail ajoutee:
- utiliser le serveur AS-P comme passerelle/point d'entree vers le reseau BACnet local comme pattern principal, sauf justification site-specifique pour integration directe terrain.

## 19. Glossaire BACnet

1. BACnet:
- Standard de protocole de communication d'automatisation batiment utilise par controleurs/serveurs/equipements et clients logiciels.

2. BACnet/IP:
- BACnet sur Ethernet/IP (couramment base UDP).

3. BACnet MS/TP:
- BACnet sur bus serie RS-485 utilisant le token passing.

4. BACnet/SC:
- BACnet Secure Connect; profil de transport BACnet securise pour modeles modernes de securite IP/base certificat.

5. BBMD:
- BACnet Broadcast Management Device; relaie le trafic broadcast BACnet/IP entre sous-reseaux pour scenarios de decouverte/communication.

6. COV:
- Change of Value; mecanisme de souscription BACnet pour recevoir des mises a jour quand les valeurs changent, reduisant le polling constant.

7. BIBBs:
- BACnet Interoperability Building Blocks; groupes de capacites standardises publies pour decrire quelles fonctions BACnet un produit supporte.

8. Device Instance:
- Identifiant BACnet unique d'equipement utilise pour identifier un equipement BACnet sur le reseau.

9. Object / Property:
- Elements du modele de donnees BACnet; les equipements exposent des objets (par ex. analog input/output) avec des proprietes (par ex. presentValue, units, status).

10. IP:
- Adresse reseau (par ex. `10.20.30.40`) utilisee pour atteindre des equipements sur reseaux IP.

11. FQDN:
- Fully Qualified Domain Name (par ex. `as-p-site1.company.local`) utilise comme identite endpoint basee DNS.

12. Point d'entree:
- Frontiere d'integration joignable reseau utilisee par la plateforme pour acceder aux domaines locaux d'automatisation batiment (par ex. AS-P, gateway, ou endpoint controleur approuve).

## 20. Offre Siemens (Perimetre BMS)

Pour ce programme, l'offre Siemens peut etre lue en quatre couches pratiques:

1. Couche logicielle BMS de supervision:
- Desigo CC pour supervision mono-batiment ou multi-batiments, alarmes, tendances, planification et workflows operateur.

2. Couche edge automation/controleurs:
- Famille Desigo PXC pour controle programmable HVAC/integration, connectivite field-bus et execution locale de l'automatisation.

3. Ecosysteme room/control devices:
- Equipements d'automatisation de salle base KNX (capteurs, actionneurs, room units) avec interfaces/routeurs/gateways KNX.

4. Couche plateforme/apps digitales (optionnelle mais strategique pour le portefeuille):
- Building X apps et Building X APIs (modele subscription), orientes operations portefeuille, analytics et usages digital operations.

## 21. Differences Architecturales: Siemens vs Schneider

Les deux ecosystemes se recouvrent fonctionnellement, mais diffèrent dans le packaging d'architecture:

1. Pattern courant Schneider:
- Frontiere edge centree automation server (role AS-P/AS-B) utilisee comme hub integration + controle,
- plus familles de controleurs/equipements,
- plus couches optionnelles de services/overlay.

2. Pattern courant Siemens:
- Famille edge centree controleurs (PXC),
- aggregation de supervision via Desigo CC,
- couche optionnelle Building X platform/apps pour capacites cloud portefeuille.

3. Implication integration:
- Schneider met souvent en avant AS-P comme frontiere explicite d'automatisation batiment.
- Siemens obtient souvent un resultat equivalent via PXC + integration KNX + couche de supervision (Desigo CC), selon le perimetre.

4. Implication gouvernance pour ce programme:
- Dans les deux ecosystemes, conserver la gouvernance globale plateforme et les contrats canoniques au centre.
- Utiliser la pile partenaire pour le controle local temps reel et l'execution operationnelle sur site.

## 22. AS-P vs PXC (Vue Fonctionnelle et Capacitaire)

| Aspect | Schneider AS-P (role automation server) | Siemens PXC (role famille de controleurs) |
| --- | --- | --- |
| Positionnement principal | Automation server edge et frontiere d'integration | Controleurs d'automatisation edge programmables |
| Role typique en architecture | Frontiere serveur mono-batiment pour integration BMS et automatisation locale | Execution controle terrain/systeme; supervision generalement couplee a Desigo CC |
| Logique de controle edge | Oui | Oui |
| Trend logging et alarm supervision | Oui | Oui (au niveau automation station/controleur) |
| Integration field-bus/I-O | Oui (selon modele; integration serie/IP) | Oui (selon modele; variantes controleurs scalables) |
| Comportement single-point entry | Souvent cadre autour de la frontiere AS-P | Souvent obtenu via pattern controleur + couche de supervision |
| Extension cloud/app portefeuille | Via couches ecosysteme separees | Via Building X apps/APIs (subscription-based) |

## 23. Matrice Side-by-Side (Ligne Dediee Entry-Point)

Legende:
- `native`: pattern direct et explicite dans le cadrage d'architecture fournisseur.
- `via gateway`: possible via gateway/interface protocolaire.
- `needs supervisory layer`: requiert generalement une couche BMS de supervision pour une exploitation centralisee pratique.

| Capacite | Schneider (chemin AS-P/EBO) | Siemens (chemin PXC/Desigo) |
| --- | --- | --- |
| Single building entry point across BACnet/KNX/Modbus | `native` pour BACnet/Modbus a la frontiere AS-P; KNX generalement `via gateway` | Convergence BACnet/KNX/Modbus generalement `needs supervisory layer` (Desigo CC) et/ou `via gateway` pour pont KNX |
| Integration BACnet | `native` | `native` |
| Integration KNX dans les operations BMS | `via gateway` | `via gateway` (et souvent normalisee via la couche de supervision) |
| Couche cloud/API apps pour operations portefeuille | disponible, mais souvent separee de la frontiere AS-P | fortement produitisee via Building X apps/APIs (subscription) |

## 24. Conclusion De Travail Pour Le Design

1. Ne pas forcer une equivalence stricte one-to-one entre les roles produits AS-P et PXC.
2. Comparer les resultats d'integration au niveau architecture (single entry point, command governance, mediation protocolaire, ownership operations), pas uniquement par etiquette produit.
3. Pour ce programme, maintenir l'autorite globale plateforme tout en exploitant les capacites edge/supervision partenaire pour reduire la complexite d'integration site.
