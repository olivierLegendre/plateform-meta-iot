![Logo Ramery](file:///home/olivier/work/iot_services/plateform-meta-iot/docs/presentations/assets/ramery-logo-baseline.png){ width=220px }

# Note De Decision Direction — Legrand GTB (Marche France)

Document: version presentation Ramery v1
Date: 2026-04-01
Auteur: Plateforme Meta IoT
Statut: revue management
Audience: Direction, sponsors, parties prenantes fonctionnelles
Perimetre: marche France uniquement
Source principale: `/home/olivier/work/iot_services/plateform-meta-iot/docs/legrand-GTB-comparaison.md`

## 1. Resume Executif

1. Sur le marche France, l'offre Legrand GTB apparait comme un assemblage de sous-systemes, plutot qu'une pile GTB unifiee equivalente a Schneider/Siemens.
2. Legrand propose des briques pertinentes par domaine (WEOZ, KNX, hotellerie BACnet), mais pas une reponse native evidentee pour une gestion GTB unifiee multi-domaines.
3. Le parcours KNX repose sur des composants dedies et un commissioning via ETS, avec couche d'integration/supervision a organiser.
4. La solution WEOZ est associee a un abonnement portail 12 mois; le comportement detaille apres expiration doit etre confirme contractuellement.

## 2. Contexte Et Objectif

Objectif de la note:
1. Positionner Legrand dans la comparaison partenaires pour un besoin de gouvernance GTB globale.
2. Identifier l'ecart entre besoins cibles de la plateforme et couverture Legrand France.
3. Clarifier le niveau de risque d'integration et d'exploitation.

## 3. Etat Des Decisions

### 3.1 Decide

1. Le cadre d'evaluation reste celui du programme: gouvernance globale plateforme, controle local edge partenaire.
2. Le perimetre de recherche Legrand est limite au marche France (`legrand.fr/pro`).

### 3.2 En Cours De Validation

1. Confirmation officielle du mode degrade/post-abonnement pour WEOZ.
2. Validation du cout complet d'integration d'un parcours multi-sous-systemes Legrand.

### 3.3 Ouvert

1. Legrand doit-il rester un candidat coeur GTB, ou un fournisseur de domaines cibles uniquement.
2. Niveau de priorite de Legrand dans la roadmap pilote.

## 4. Analyse De Synthese

### 4.1 Points Forts Constates

1. Presence de solutions par domaines:
- WEOZ pour pilotage GTB/energie,
- SCS/BACnet en hotellerie,
- KNX pour pilotage local.
2. Capacites locales de controle possibles dans certains sous-perimetres.
3. Offre pertinente pour des cas cibles specialises (eclairage, KNX, hotellerie).

### 4.2 Limites Structurantes Pour Notre Besoin

1. Pas de preuve d'une solution GTB unifiee native couvrant de maniere homogene BACnet/KNX/Modbus avec un point d'entree unique equivalent Schneider/Siemens.
2. Besoin probable d'assemblage de plusieurs sous-systemes et de gouvernance integration renforcee.
3. Commissioning plus lourd dans une architecture composee (passerelles, parametres, outils heterogenes).
4. Dependance abonnement pour les services portail WEOZ.

### 4.3 Difference De Nature Avec Schneider / Siemens

1. Schneider et Siemens se positionnent davantage sur une logique de pile BMS/GTB plus unifiee.
2. Legrand France apparait davantage en logique de briques domaine a composer.
3. Cette difference augmente le travail d'integration si l'objectif est une gouvernance globale transverse.

## 5. Recommendation Direction

1. Ne pas retenir Legrand comme candidat principal pour un socle GTB unifie entreprise, a ce stade de preuves.
2. Garder Legrand comme option de niche/domaines cibles lorsqu'un besoin local specialise le justifie.
3. Si Legrand reste dans le panel, exiger une RFI contractuelle avec:
- matrice de couverture fonctionnelle par domaine,
- conditions d'abonnement et post-abonnement,
- responsabilites d'integration/exploitation,
- modeles de support et SLA.

## 6. Risques Et Mitigations

1. Risque: sous-estimer l'effort de composition multi-sous-systemes.
- Mitigation: chiffrage TCO complet (build + run + support).
2. Risque: dependance services portail non maitrisee.
- Mitigation: clarifier contractualisation et mode local nominal/degrade.
3. Risque: divergence entre promesse commerciale et capacite operationnelle inter-domaines.
- Mitigation: preuves pilotes sur un cas d'usage representatif avant engagement large.

## 7. Prochaines Etapes

1. PMO + architecture: qualifier Legrand comme "domain-fit" et non "core-fit" dans la matrice partenaires.
Echeance cible: T2 2026.
2. Achats + juridique: demander clarifications contractuelles WEOZ (abonnement et post-abonnement).
Echeance cible: T2 2026.
3. Equipe integration: estimer l'effort d'assemblage technique (KNX/BACnet/outillage) sur un mini-scope.
Echeance cible: T2 2026.

## 8. References Et Annexes

1. Document source detaille:
`/home/olivier/work/iot_services/plateform-meta-iot/docs/legrand-GTB-comparaison.md`
2. Cadrage global partenaires:
`/home/olivier/work/iot_services/plateform-meta-iot/docs/integration-partenaires.md`
3. Profil de template Ramery:
`/home/olivier/work/iot_services/plateform-meta-iot/docs/presentations/ramery-template-profile-v1.md`
