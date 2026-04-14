# One-Slide Actionnaires - Plateforme IoT + BMS + Digital Twin

## Message unique
La plateforme unifie l'IoT sans fil et le BMS filaire avec une gouvernance centrale des ecritures, tout en gardant le controle temps reel au niveau edge partenaire (AS-P, PXC, equivalents).

```mermaid
flowchart LR
  A[IoT sans fil\nLoRaWAN Zigbee Z-Wave roadmap] --> G[Gateway Coordinator]
  G -->|MQTT| P[Plateforme\nServices coeur + gouvernance]

  B[Equipements BMS\nBACnet Modbus KNX] --> E[Point d entree batiment\nAS-P PXC equivalent]
  E -->|Adapters| P

  P -->|Ecritures gouvernees| E
  P -->|Sync telemetrie contexte| T[Tandem Connect + Tandem]

  R1[Integrateur BMS\nCommissioning OT terrain] -.responsable.-> E
  R2[Equipe plateforme\nIAM Audit Idempotence] -.responsable.-> P
```

## Rappels de scope
- In scope: telemetrie IoT/BMS, gouvernance commandes, sync Tandem telemetrie/contexte.
- Hors scope actuel: commande depuis le jumeau numerique.
