# Legrand BMS Research (France Market) and 3-Vendor Comparison

Date: 2026-03-30
Status: research baseline (architecture not finalized)
Audience: sponsors, architecture stakeholders
Market scope: France only
Source policy: only `legrand.fr/pro` pages

## 1. Why This Document Exists

The core program scope remains the wireless-IoT platform and its service architecture.
This document captures the current wired-BMS research track for France, adding Legrand in the same comparison frame as Schneider and Siemens.

## 2. Decision Maturity

1. Confirmed core scope: wireless IoT platform and services.
2. BMS integration model: still in research.
3. Working assumption (not locked):
- platform handles global governance,
- partner edge handles local building control.

## 3. What Legrand France Exposes for BMS/GTB

Based on `legrand.fr/pro`, the visible offer is structured around GTB controllers, hotel-room BACnet controllers, and KNX building-control components.

## 3.1 GTB controller path: WEOZ Area Manager

Key evidence from Legrand France pages:
1. Area Manager is explicitly presented as a GTB controller for building and energy management.
2. The product page states BACS relevance and remote control/monitoring use via dashboard.
3. Technical and solution pages indicate:
- multi-protocol scope including Z-wave, Zigbee, Modbus RTU, Modbus IP, MQTT, Wi-Fi, Ethernet,
- local rule/data management,
- local communication between zone managers,
- communication to operations dashboard through Legrand Cloud,
- capacity references such as up to 20 wireless devices + 100 Modbus points,
- product-page note: up to 20 équipements and 100 registres Modbus per Area Manager (then add another Area Manager).

## 3.2 BACnet room-controller path (hospitality)

Legrand France also exposes explicit BACnet controllers for hotel-room management:
1. Ref 0 484 08 and 0 484 12 are listed as SCS/BACnet multi-application modular controllers.
2. Product details highlight programmable inputs/outputs and integration into room-management workflows.
3. Legrand training content for IP BACnet hotel-room controller includes BACnet object usage and supervision/pilotage outcomes.

## 3.3 KNX building-control path

Legrand France exposes KNX components for building control:
1. KNX modular controller (ref 0 484 18) for lighting/shutters/contactors/motors/DALI with ETS configuration.
2. KNX tactile command panel (ref 0 488 84) to drive multiple KNX controllers with scenario programming via ETS.
3. KNX power supplies and KNX bus cabling are also listed.

## 4. Edge Automation Server View for French Market

From the French store perspective, Legrand provides several edge patterns rather than one universal AS-P-like product.

## 4.1 Most direct GTB edge node

`Area Manager WEOZ` is the most direct candidate for a French-market GTB edge node because it combines:
1. local rule execution,
2. multi-protocol field integration,
3. cloud/dashboard linkage,
4. GTB positioning aligned with BACS context.

## 4.2 Domain-specific edge nodes

For domain-specific projects, Legrand France also provides:
1. BACnet hotel-room controllers (SCS/BACnet) for hospitality room automation,
2. KNX controllers + KNX HMI for KNX-centric building control.

Inference (explicit):
1. Legrand France edge architecture is compositional (WEOZ + SCS/BACnet + KNX components depending scope).
2. For broad multi-domain GTB, architecture and integration effort are likely more solution-composition dependent than a single-edge-server pattern.

## 5. Side-by-Side Matrix v3 (Program-Level View)

Legend:
- `native`: direct and explicit primary vendor pattern.
- `via gateway`: achievable through protocol gateway/bridge composition.
- `needs supervisory layer`: usually requires supervisory/app layer for practical centralized operation.

| Capability | Schneider (AS-P/EBO path) | Siemens (PXC/Desigo/Building X path) | Legrand France (`legrand.fr/pro`) |
| --- | --- | --- | --- |
| Single building entry point across BACnet/KNX/Modbus | `native` for BACnet/Modbus at AS-P boundary; KNX often `via gateway` | Often `needs supervisory layer` and/or `via gateway` depending topology | Often composition-based: WEOZ as GTB edge candidate; KNX and SCS/BACnet domain controllers for specific scopes |
| BACnet integration | `native` | `native` | `native` in specific French lines (for example SCS/BACnet hospitality controllers) |
| KNX integration in operations | Usually `via gateway` | Usually `via gateway` + KNX room automation options | `native` with KNX control components and ETS-based configuration |
| Local edge control logic | Strong | Strong | Strong in WEOZ and in domain controllers (KNX / SCS-BACnet contexts) |
| Portfolio/cloud extension | Available through Schneider ecosystem layers | Productized via Building X apps/APIs | WEOZ includes cloud dashboard coupling; portfolio depth still to validate by pilot |
| Fit with platform-central governance model | Strong | Strong | Strong in principle; requires explicit authority split design in composed deployments |
| Integration burden in mixed-vendor sites | Medium to high | Medium to high | Medium to high; can increase when combining multiple Legrand control families for broad GTB scope |

## 6. Practical Conclusion for Current Program Phase

1. For France, Legrand is a valid research candidate for the hybrid model (platform governance + local partner control).
2. `Area Manager WEOZ` is the closest French-market answer to an edge GTB controller role.
3. For hospitality and KNX-centric projects, Legrand has concrete edge options (SCS/BACnet room controllers and KNX controllers).
4. Before architecture lock, pilot evidence remains required on:
- command authority/audit fit,
- commissioning complexity,
- supervision depth and operations model at multi-site scale.

## 7. France-Only References Used

1. Area Manager WEOZ product page:
https://www.legrand.fr/pro/catalogue/controleur-gtb-area-manager-weoz-pour-la-gestion-des-batiments-et-de-lefficacite-energetique
2. WEOZ solution page:
https://www.legrand.fr/pro/solutions/efficacite-energetique/weoz-tm-le-gestionnaire-de-batiment-intelligent
3. Hotel room management category page:
https://www.legrand.fr/pro/catalogue/appareillage-maison-connectee-et-pilotage-du-batiment/pilotage-du-batiment/gestion-de-la-chambre-dhotel
4. SCS/BACnet controller (0 484 12):
https://www.legrand.fr/pro/catalogue/controleur-modulaire-multi-applications-pour-fonction-hotel-scsbacnet-avec-16-entrees-et-16-sorties-12-modules
5. SCS/BACnet controller (0 484 08):
https://www.legrand.fr/pro/catalogue/controleur-modulaire-multi-applications-pour-fonction-hotel-scsbacnet-avec-8-entrees-et-8-sorties-8-modules
6. Training page (IP BACnet hotel-room controller):
https://www.legrand.fr/pro/formations/sante-hotel/formation-legrand-solution-controleur-de-chambre-dhotel-ip-bacnet-270
7. KNX modular controller (0 484 18):
https://www.legrand.fr/pro/catalogue/controleur-modulaire-bus-knx-8-modules-multi-applications-avec-8-entrees-et-8-sorties-8-modules
8. KNX tactile command (0 488 84):
https://www.legrand.fr/pro/catalogue/commande-filaire-tactile-57pouces-mosaic-pour-pilotage-de-plusieurs-controleurs-bus-knx
9. KNX power supply example (0 035 07):
https://www.legrand.fr/pro/catalogue/alimentation-modulaire-bus-knx-150v-a-275v-30v-640ma-7-modules
