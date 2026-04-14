# Option B - Schema Multi-Niveaux (Zoom L0 / L1 / L2)

## L0 - Carte de valeur (executif)
```mermaid
flowchart LR
  A[Besoin: unifier IoT et BMS] --> P[Plateforme de gouvernance]
  B[Besoin: maitriser securite et audit] --> P
  C[Besoin: rester multi-partenaires] --> P
  D[Besoin: preparer le Digital Twin] --> P

  P --> V1[Valeur: interop MQTT BACnet Modbus KNX]
  P --> V2[Valeur: point d entree unique batiment via serveur automation partenaire]
  P --> V3[Valeur: echelle multi-sites et extensibilite]
  P --> V4[Valeur: sync Tandem telemetrie/contexte sans ouvrir la commande]
```

## L1 - Architecture de reference (macro)
```mermaid
flowchart LR
  subgraph FIELD[Terrain]
    IOT[IoT sans fil\nLoRaWAN Zigbee Z-Wave ROADMAP]
    G1[Gateway / Coordinator]
    BMS[Equipements BMS\nBACnet Modbus KNX]
    E1[Point d entree batiment\nAS-P PXC ou equivalent]
  end

  subgraph PART[Partenaires automation]
    S1[Schneider]
    S2[Siemens]
    S3[Legrand ROADMAP]
    S4[Autres ROADMAP]
  end

  subgraph CORE[Plateforme]
    U1[operator-ui]
    U2[identity-access-config]
    U3[device-ingestion-service]
    U4[reference-api-service]
    U5[channel-policy-router]
    U6[automation-scenario-service]
    U7[partner-integration-layer]
    U8[platform-foundation]
  end

  subgraph NFR[Garde-fous non fonctionnels]
    N1[Securite IAM]
    N2[Tracabilite et audit]
    N3[Resilience]
    N4[Observabilite]
    N5[Scalabilite multi-sites]
  end

  subgraph DT[Digital Twin]
    D1[Tandem Connect]
    D2[Tandem]
    D3[Scope actuel: telemetrie et contexte uniquement]
  end

  IOT --> G1
  G1 -->|MQTT| U8
  U8 --> U3
  U3 --> U4

  BMS --> E1
  E1 -->|BACnet Modbus KNX via adapters| U7
  S1 --> U7
  S2 --> U7
  S3 --> U7
  S4 --> U7
  U7 --> U4

  U1 --> U4
  U6 --> U5
  U4 --> U5
  U5 -->|writes gouvernes obligatoires| U7
  U7 --> E1

  U4 --> D1
  U7 --> D1
  D1 --> D2
  D3 --- D1

  U2 --> U1
  U2 --> U4
  U2 --> U5
  U2 --> U6
  U2 --> U7

  U8 --- N1
  U8 --- N2
  U8 --- N3
  U8 --- N4
  U8 --- N5
```

## L2 - Flux operationnels (detail)
```mermaid
sequenceDiagram
  autonumber
  participant GW as Gateway Coordinator
  participant BROKER as MQTT Broker platform-foundation
  participant ING as device-ingestion-service
  participant REF as reference-api-service
  participant CPR as channel-policy-router
  participant ADP as partner-integration-layer
  participant EDGE as AS-P PXC equivalent
  participant BMS as Equipements BACnet Modbus KNX
  participant TC as Tandem Connect
  participant T as Tandem

  Note over GW,REF: Ingestion IoT sans fil
  GW->>BROKER: publish telemetrie
  BROKER->>ING: message MQTT
  ING->>REF: normalisation canonique

  Note over EDGE,REF: Ingestion BMS filaire
  BMS-->>EDGE: etat et mesures terrain
  EDGE->>ADP: export vers adaptateur
  ADP->>REF: mapping canonique

  Note over REF,T: Sync Digital Twin (scope actuel)
  REF->>TC: push telemetrie contexte
  ADP->>TC: mapping metadonnees partenaires
  TC->>T: mise a jour twin

  Note over CPR,BMS: Ecriture gouvernee obligatoire
  REF->>CPR: demande de commande
  CPR->>CPR: politiques securite idempotence audit
  CPR->>ADP: commande autorisee
  ADP->>EDGE: traduction protocolaire
  EDGE->>BMS: execution
  BMS-->>EDGE: ack
  EDGE-->>ADP: resultat
  ADP-->>REF: statut final

  Note over T,CPR: Pas d ecriture depuis Tandem dans le scope actuel
```

## Legende scope
- IN SCOPE: LoRaWAN, Zigbee, MQTT, BACnet/Modbus/KNX via partenaires, sync Tandem telemetrie/contexte.
- ROADMAP: Z-Wave, nouveaux partenaires BMS, extensions digital twin futures.
