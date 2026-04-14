# Messages Cles Actionnaires (Document Separe)

## 1. Positionnement du projet
Le projet couvre deux mondes complementaires:
1. IoT sans fil (LoRaWAN, Zigbee, puis Z-Wave en roadmap).
2. BMS filaire (BACnet, Modbus, KNX) via partenaires industriels.

## 2. Strategie d'integration retenue
Modele hybride valide:
1. Controle local temps reel delegue aux serveurs automation partenaires (AS-P, PXC, equivalents futurs).
2. Gouvernance globale, securite, audit, idempotence et contrats canoniques conserves par la plateforme.
3. Toutes les ecritures passent par la gouvernance centrale (pas de bypass).

## 3. Point d'entree unique par batiment
1. Le batiment expose un point d'entree automation (serveur edge partenaire) agregeant les protocoles terrain.
2. Notre plateforme dialogue avec ce point d'entree via la couche `partner-integration-layer`.
3. Le commissioning et le parametrage terrain restent sous responsabilite integrateur BMS.

## 4. Capacites deja couvertes
1. Ingestion multi-origines via MQTT depuis gateways/coordinators IoT.
2. Normalisation et exposition API canonique.
3. Routage de commandes gouverne.
4. Interoperabilite multi-partenaires BMS via adapters.

## 5. Digital Twin (scope actuel)
1. Autodesk Tandem / Tandem Connect utilises pour synchroniser telemetrie et contexte.
2. Pas de delegation de commande au Twin dans le scope actuel.

## 6. Garde-fous non fonctionnels
1. Securite IAM et politiques d'acces centralisees.
2. Audit et tracabilite des commandes.
3. Resilience, supervision et observabilite.
4. Scalabilite multi-sites.

## 7. Extensibilite roadmap
1. Ajout de partenaires (Legrand, autres) via le meme pattern d'adapter.
2. Extension protocoles IoT sans remise en cause du coeur.
3. Extension possible du scope Digital Twin apres validation des garde-fous.
