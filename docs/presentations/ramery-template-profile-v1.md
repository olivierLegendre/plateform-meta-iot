# Profil De Template Ramery v1 (Markdown -> DOCX/PDF)

Date: 2026-04-01
Statut: baseline de production
Usage: generation de livrables management a partir de fichiers `.md`

Style unique actif:
1. Profil `strong` unique via `docs/presentations/ramery-report.css`.

## 1. Objectif

Ce profil definit un format commun pour convertir des notes de recherche en rapports lisibles par des parties prenantes non techniques, avec une identite visuelle Ramery coherente.

## 2. Entrees Attendues

1. Fichier source Markdown.
2. Type de livrable: `docx`, `pdf`, ou `docx+pdf`.
3. Langue: `fr` (par defaut).
4. Metadonnees minimales:
- titre,
- date,
- auteur,
- statut,
- audience cible.

## 3. Sorties Attendues

Pour chaque source:
1. Un document structure pret pour revue manageriale.
2. Une version DOCX et/ou PDF.
3. Un court rapport d'export (template applique, points a corriger manuellement si besoin).

## 4. Tokens Graphiques Ramery (v1)

Reference: `Charte graphique 2023.pdf` + `PPTComplet_Charte_23.pptx`.

Couleurs corporate:
1. Bleu Ramery: RVB `0/67/131`, CMJN `100/70/0/30`, Pantone `280 U`, Hex cible `#004383`.
2. Rouge Ramery: RVB `217/32/38`, CMJN `10/100/100/0`, Pantone `186 U`, Hex cible `#D92026`.
3. Gris corporate: RVB `74/74/73`, CMJN `0/0/0/85`, Pantone `446 C`, Hex cible `#4A4A49`.
4. Noir: Hex `#000000`.
5. Blanc: Hex `#FFFFFF`.

Typographies (baseline operationnelle actuelle):
1. Principale: `Lexend`.
2. Mise en avant: `Playfair Display`.
3. Option premium (si licence disponible): `Houschka Alt Pro`.
4. Fallback si indisponible: `Arial` / `Calibri`.

## 5. Regles De Mise En Page

1. Format: A4.
2. Marges par defaut: 2.0 cm (haut/bas/gauche/droite).
3. En-tete:
- logo Ramery,
- titre court du document.
4. Pied de page:
- version,
- date,
- pagination `Page X / Y`.
5. Table des matieres automatique.
6. Titres numerotes et hierarchy stabilisee (`H1/H2/H3`).
7. Tableaux simplifies et lisibles (pas de surcharge visuelle).

Footer PDF (logo + pagination):
1. Utiliser `wkhtmltopdf` avec Qt patche (`wkhtmltopdf --version` doit afficher `with patched qt`).
2. Utiliser `--footer-html docs/presentations/ramery-footer.html` pour logo Ramery + `Page X/Y`.

## 6. Structure Narrative Standard

1. Resume executif (1 page max).
2. Contexte et objectif.
3. Etat des decisions (decide / en cours / ouvert).
4. Analyse et comparaison.
5. Recommendation.
6. Risques et mitigations.
7. Prochaines etapes (owners + echeances).
8. References / annexes.

## 7. Regles Editoriales

1. Distinguer explicitement:
- faits verifies,
- hypotheses,
- points a confirmer.
2. Garder un ton factuel, orienté decision.
3. Eviter le jargon non defini.
4. Conserver les preuves (sources, dates, perimetre marche).

## 8. Assets De Reference (courants)

1. Charte PDF:
`/home/olivier/Téléchargements/Charte graphique 2023.pdf`
2. Template PowerPoint:
`/home/olivier/Téléchargements/charte/PPTComplet_Charte_23.pptx`
3. Logos:
`/home/olivier/Téléchargements/charte/Logo Ramery + Baseline.pdf`

## 9. Checklist Avant Export

1. Le message cle est visible dans la premiere page.
2. Les sections obligatoires sont presentes.
3. Les couleurs/logo sont conformes au profil.
4. Les tableaux passent en lecture impression.
5. Les references et dates sont presentes.

## 10. Installation Des Polices (Linux/Ubuntu)

Objectif: installer la baseline typographique actuelle (`Lexend` + `Playfair Display`) pour les exports DOCX/PDF.

Polices baseline:
1. `Lexend`
2. `Playfair Display`

Optionnel:
1. `Houschka Alt Pro` (si licence entreprise disponible)

### 10.1 Source Locale Fournie

Chemins indiques:
1. `~/font/Lexend/`
2. `~/font/Playfair_Display/`

Pre-requis:
1. Verifier que ces dossiers contiennent les fichiers `.ttf`/`.otf` de `Lexend` et `Playfair Display`.

### 10.2 Installation Utilisateur (recommandee)

Commandes:
```bash
mkdir -p ~/.fonts/ramery
find ~/font/Lexend ~/font/Playfair_Display -type f \(-iname "*.ttf" -o -iname "*.otf" \) -exec cp -f {} ~/.fonts/ramery/ \;
fc-cache -f -v
```

### 10.3 Verification

Commandes:
```bash
fc-list | rg -i "lexend|playfair"
```

Resultat attendu:
1. Les deux familles remontent dans la liste.
2. Redemarrer LibreOffice/applis d'export apres installation.

### 10.4 Fallback

1. Si une fonte manque, utiliser `Arial` ou `Calibri` pour conserver la compatibilite DOCX/PDF.
2. Tracer le fallback applique dans le rapport d'export.

