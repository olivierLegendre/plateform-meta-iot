#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
TEMPLATE_DIR="$ROOT_DIR/docs/presentations/templates"
ASSET_DIR="$ROOT_DIR/docs/presentations/assets"
OUT_DOCX="$TEMPLATE_DIR/ramery-reference.docx"
TMP_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

mkdir -p "$TEMPLATE_DIR"

pandoc --print-default-data-file reference.docx > "$OUT_DOCX"
unzip -q "$OUT_DOCX" -d "$TMP_DIR"

# Ensure media directory and copy footer logo.
mkdir -p "$TMP_DIR/word/media" "$TMP_DIR/word/_rels"
cp "$ASSET_DIR/ramery-logo-footer-baseline.png" "$TMP_DIR/word/media/ramery-logo-footer-baseline.png"

# Patch base typography and heading styles.
perl -0777 -i -pe 's#<w:rPr>\s*<w:rFonts[^>]*/>\s*<w:sz w:val="24" />\s*<w:szCs w:val="24" />#<w:rPr>\n        <w:rFonts w:ascii="Lexend" w:hAnsi="Lexend" w:eastAsia="Lexend" w:cs="Lexend" />\n        <w:color w:val="4A4A49" />\n        <w:sz w:val="21" />\n        <w:szCs w:val="21" />#s' "$TMP_DIR/word/styles.xml"

perl -0777 -i -pe 's#<w:style w:type="paragraph" w:styleId="Heading1">(.*?)<w:rPr>.*?</w:rPr>#<w:style w:type="paragraph" w:styleId="Heading1">$1<w:rPr>\n      <w:rFonts w:ascii="Lexend" w:hAnsi="Lexend" w:eastAsia="Lexend" w:cs="Lexend" />\n      <w:b />\n      <w:bCs />\n      <w:color w:val="004383" />\n      <w:sz w:val="40" />\n      <w:szCs w:val="40" />\n    </w:rPr>#s' "$TMP_DIR/word/styles.xml"
perl -0777 -i -pe 's#(<w:style w:type="paragraph" w:styleId="Heading1">.*?<w:pPr>)(.*?)(</w:pPr>)#$1$2\n      <w:pBdr><w:bottom w:val="single" w:sz="18" w:space="6" w:color="D92026" /></w:pBdr>$3#s' "$TMP_DIR/word/styles.xml"

perl -0777 -i -pe 's#<w:style w:type="paragraph" w:styleId="Heading2">(.*?)<w:rPr>.*?</w:rPr>#<w:style w:type="paragraph" w:styleId="Heading2">$1<w:rPr>\n      <w:rFonts w:ascii="Lexend" w:hAnsi="Lexend" w:eastAsia="Lexend" w:cs="Lexend" />\n      <w:b />\n      <w:bCs />\n      <w:color w:val="004383" />\n      <w:sz w:val="30" />\n      <w:szCs w:val="30" />\n    </w:rPr>#s' "$TMP_DIR/word/styles.xml"

perl -0777 -i -pe 's#<w:style w:type="paragraph" w:styleId="Heading3">(.*?)<w:pPr>(.*?)</w:pPr>(.*?)<w:rPr>.*?</w:rPr>#<w:style w:type="paragraph" w:styleId="Heading3">$1<w:pPr>$2\n      <w:ind w:left="340" />\n      <w:pBdr><w:left w:val="single" w:sz="8" w:space="4" w:color="9FB9D6" /></w:pBdr>\n    </w:pPr>$3<w:rPr>\n      <w:rFonts w:ascii="Lexend" w:hAnsi="Lexend" w:eastAsia="Lexend" w:cs="Lexend" />\n      <w:b />\n      <w:bCs />\n      <w:color w:val="004383" />\n      <w:sz w:val="25" />\n      <w:szCs w:val="25" />\n    </w:rPr>#s' "$TMP_DIR/word/styles.xml"

# Add a custom style for macro blocks (.bloc mapped through Lua filter).
perl -0777 -i -pe 's#</w:styles>#  <w:style w:type="paragraph" w:customStyle="1" w:styleId="Bloc">\n    <w:name w:val="Bloc" />\n    <w:basedOn w:val="Heading2" />\n    <w:next w:val="BodyText" />\n    <w:qFormat />\n    <w:pPr>\n      <w:keepNext />\n      <w:keepLines />\n      <w:spacing w:before="260" w:after="120" />\n      <w:pBdr><w:bottom w:val="single" w:sz="18" w:space="4" w:color="004383" /></w:pBdr>\n    </w:pPr>\n    <w:rPr>\n      <w:rFonts w:ascii="Lexend" w:hAnsi="Lexend" w:eastAsia="Lexend" w:cs="Lexend" />\n      <w:b />\n      <w:color w:val="004383" />\n      <w:sz w:val="32" />\n      <w:szCs w:val="32" />\n    </w:rPr>\n  </w:style>\n</w:styles>#s' "$TMP_DIR/word/styles.xml"

# Add footer relationship to document rels.
perl -0777 -i -pe 's#</Relationships>#<Relationship Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/footer" Id="rId31" Target="footer1.xml" /></Relationships>#' "$TMP_DIR/word/_rels/document.xml.rels"

# Add default section footer reference.
perl -0777 -i -pe 's#<w:sectPr\s*/>#<w:sectPr><w:footerReference w:type="default" r:id="rId31" /></w:sectPr>#' "$TMP_DIR/word/document.xml"

# Ensure content-types has footer and png.
perl -0777 -i -pe 's#</Types>#<Default Extension="png" ContentType="image/png" /><Override PartName="/word/footer1.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.footer+xml" /></Types>#' "$TMP_DIR/[Content_Types].xml"

# Footer XML and rels.
cat > "$TMP_DIR/word/footer1.xml" <<'XML'
<?xml version="1.0" encoding="UTF-8"?>
<w:ftr xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
       xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
       xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
       xmlns:pic="http://schemas.openxmlformats.org/drawingml/2006/picture"
       xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing">
  <w:p>
    <w:pPr>
      <w:jc w:val="right" />
      <w:spacing w:before="0" w:after="0" />
    </w:pPr>
    <w:r>
      <w:drawing>
        <wp:inline>
          <wp:extent cx="1500000" cy="826000" />
          <wp:effectExtent b="0" l="0" r="0" t="0" />
          <wp:docPr descr="Ramery footer logo" title="" id="101" name="RameryFooterLogo" />
          <a:graphic>
            <a:graphicData uri="http://schemas.openxmlformats.org/drawingml/2006/picture">
              <pic:pic>
                <pic:nvPicPr>
                  <pic:cNvPr descr="ramery-logo-footer-baseline.png" id="0" name="RameryFooterLogo" />
                  <pic:cNvPicPr><a:picLocks noChangeArrowheads="1" noChangeAspect="1" /></pic:cNvPicPr>
                </pic:nvPicPr>
                <pic:blipFill>
                  <a:blip r:embed="rId1" />
                  <a:stretch><a:fillRect /></a:stretch>
                </pic:blipFill>
                <pic:spPr bwMode="auto">
                  <a:xfrm><a:off x="0" y="0" /><a:ext cx="1500000" cy="826000" /></a:xfrm>
                  <a:prstGeom prst="rect"><a:avLst /></a:prstGeom>
                  <a:noFill />
                  <a:ln w="0"><a:noFill /><a:headEnd /><a:tailEnd /></a:ln>
                </pic:spPr>
              </pic:pic>
            </a:graphicData>
          </a:graphic>
        </wp:inline>
      </w:drawing>
    </w:r>
    <w:r>
      <w:rPr><w:color w:val="D92026" /><w:sz w:val="16" /><w:szCs w:val="16" /></w:rPr>
      <w:t xml:space="preserve">  | </w:t>
    </w:r>
    <w:fldSimple w:instr=" PAGE ">
      <w:r>
        <w:rPr><w:color w:val="D92026" /><w:sz w:val="16" /><w:szCs w:val="16" /></w:rPr>
        <w:t>1</w:t>
      </w:r>
    </w:fldSimple>
  </w:p>
</w:ftr>
XML

cat > "$TMP_DIR/word/_rels/footer1.xml.rels" <<'XML'
<?xml version="1.0" encoding="UTF-8"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/image" Id="rId1" Target="media/ramery-logo-footer-baseline.png" />
</Relationships>
XML

(
  cd "$TMP_DIR"
  zip -qr "$OUT_DOCX" .
)

echo "Built $OUT_DOCX"
