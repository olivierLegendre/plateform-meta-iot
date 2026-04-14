![Logo Ramery](file:///home/olivier/work/iot_services/plateform-meta-iot/docs/presentations/assets/ramery-logo-baseline.png){ width=220px }

# Note De Decision Direction — Integration Partenaires BMS Et Jumeau Numerique

Document: version presentation Ramery v1
Date: 2026-04-01
Auteur: Plateforme Meta IoT
Statut: revue management
Audience: Direction, sponsors, parties prenantes fonctionnelles
Perimetre: marche France, phase recherche et cadrage
Source principale: `/home/olivier/work/iot_services/plateform-meta-iot/docs/integration-partenaires.md`

## 1. Resume Executif

1. Le coeur du programme reste la plateforme IoT sans fil et ses services (ingestion, centralisation, IAM, exposition API/MQTT).
2. Les integrations BMS filaires (Schneider/Siemens/Legrand) et jumeau numerique (Autodesk Tandem) sont des extensions strategiques, actuellement en phase de recherche avancee.
3. Le modele cible de travail est hybride:
- gouvernance globale et autorite de commande dans la plateforme,
- controle local temps reel sur les serveurs/controleurs edge partenaires.
4. La decision d'architecture finale doit etre prise apres pilote sur un batiment, avec mesures factuelles sur securite, latence, qualite telemetrie et cout de commissioning.

## 2. Contexte Et Objectif

Objectif de la note:
1. Poser une lecture direction des options d'integration partenaires.
2. Distinguer les points decides des points encore ouverts.
3. Cadencer les prochaines decisions vers une trajectoire de deploiement.

## 3. Etat Des Decisions

### 3.1 Decide

1. La plateforme interne reste le coeur canonique de gouvernance, d'identite et de diffusion des donnees.
2. Les integrations partenaires doivent respecter une matrice d'autorite explicite (qui ecrit quoi, ou, quand).
3. Autodesk Tandem est traite comme couche de contexte/twin, pas comme boucle de controle terrain.

### 3.2 En Cours De Validation

1. Split d'autorite final entre plateforme et edge partenaire sur les ecritures de commande.
2. Niveau de couverture initiale (mono-site pilote vs multi-sites).
3. Priorisation sous-systeme de depart (HVAC, eclairage, ou mixte).

### 3.3 Ouvert

1. Choix final du mode operatoire cible (partner-as-primary vs partner-as-domain).
2. Niveau de standardisation semantique inter-fournisseurs a imposer en phase 1.
3. Sequence d'industrialisation post-pilote.

## 4. Analyse De Synthese

### 4.1 Partenaires BMS (Schneider / Siemens)

1. Les deux offres couvrent les niveaux equipement, systeme, batiment et portefeuille.
2. Les deux supports permettent un modele hybride compatible avec l'autorite centrale plateforme.
3. Le facteur de complexite principal n'est pas l'API mais le terrain:
- qualite de points,
- commissioning,
- securite reseau/cyber,
- heterogeneite legacy multi-sites.

### 4.2 Jumeau Numerique (Autodesk Tandem)

1. Valeur: contexte d'actifs et continuite cycle de vie.
2. Pre-requis: mapping solide actifs/points et gouvernance metadonnees.
3. Risque principal: derive semantique et derive de synchronisation dans le temps.

### 4.3 Gouvernance Technique A Ne Pas Negocier

1. Modele canonique inter-fournisseurs (avec normalisation tags).
2. Autorite de commande et audit immuable.
3. SLA qualite des donnees par partenaire.
4. Gate de certification avant production (contrats, bascule, rollback).
5. Baseline cyber (segmentation, certs/cles, secrets, runbooks).

## 5. Recommendation Direction (Phase Cadrage)

1. Confirmer officiellement le mode hybride comme hypothese de reference.
2. Lancer un pilote mono-site borne (20-30 points lecture, 5-10 points ecriture).
3. Mesurer 3 KPI de decision:
- fiabilite telemetrie,
- securite/autorite de commande,
- qualite de synchronisation twin.
4. Utiliser les preuves pilote comme gate avant toute generalisation multi-sites.

## 6. Risques Et Mitigations

1. Risque: sous-estimation de l'effort de commissioning.
- Mitigation: budget/site planning dedies + checklist pre-integration.
2. Risque: confusion d'autorite entre plateforme et edge.
- Mitigation: RACI et regles de conflit formalises avant production.
3. Risque: derive du twin et cout de curation.
- Mitigation: process de gouvernance continue + ownership explicite ops/engineering/facilities.

## 7. Prochaines Etapes

1. Sponsor + architecture: valider le cadre de pilote et le perimetre technique.
Echeance cible: T2 2026.
2. Equipe plateforme: finaliser la matrice d'autorite et le contrat de telemetrie pilote.
Echeance cible: T2 2026.
3. Equipes partenaires/integrateur: preparer inventaire points, prerequis reseau/cyber et runbooks.
Echeance cible: T2 2026.
4. PMO: definir criteres go/no-go post-pilote et planning de decision direction.
Echeance cible: fin T2 2026.

## 8. References Et Annexes

1. Document source detaille:
`/home/olivier/work/iot_services/plateform-meta-iot/docs/integration-partenaires.md`
2. Comparatif Legrand (France):
`/home/olivier/work/iot_services/plateform-meta-iot/docs/legrand-GTB-comparaison.md`
3. Profil de template Ramery:
`/home/olivier/work/iot_services/plateform-meta-iot/docs/presentations/ramery-template-profile-v1.md`
