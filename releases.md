# Drools2XSLT
<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-refresh-toc -->
**Table of Contents**

- [Drools2XSLT](#drools2xslt)
  - [Allgemeines ](#allgemeines)
  - [Workflow und Zeitplan](#workflow-und-zeitplan)
- [Releases](#releases)
  - [PSB 19.01.2026 (geplant)](#psb-19012026-geplant)
  - [PROD initialer Stand 15.12.2025](#prod-initialer-stand-15122025)
    - [Schreibvorlage](#schreibvorlage)
    - [Aufsatz ableiten - print](#aufsatz-ableiten---print)
    - [Externe Ressourcen Library of Congress](#externe-ressourcen-library-of-congress)
    - [Normalize on Save](#normalize-on-save)

<!-- markdown-toc end -->
## Allgemeines 
Die Normalisierungen in Alma sollen im Laufe des Jahres 2026 sukzessive in der Sprache XSLT neu implementiert werden. XSLT ist wesentlich mächtiger als Drools und ermöglicht auch automatisierte Tests und [automatisiert erstellte Dokumentation](https://share.obvsg.at/xsldocsxslt-normalization/index.html).

## Workflow und Zeitplan
- Der tagesaktuelle Entwicklungsstand befindet sich in der [Standard-Sandbox](https://sandbox-eu.alma.exlibrisgroup.com/mng/login?institute=43ACC_NETWORK) 
- Am vorletzten Montag des Monats gibt es ein Update in der [Premium-Sandbox](https://obv-at-obvsg-psb.alma.exlibrisgroup.com/mng/login). Das sind die Änderungen, die zwei Wochen später ins Produktionssystem übernommen werden sollen. Erster geplanter Termin: 19.01.2026
- Am ersten Montag des Monats werden die Änderungen ins [Produktionssystem](https://obv-at-obvsg-psb.alma.exlibrisgroup.com/mng/login) übernommen.

# Releases
## PSB 19.01.2026 (geplant)
- `007/01` bei Musik auf `q` setzen (KATA-082-fix007\_music). Commit 348cbd4 
- `034` löschen, wenn sie nur Werte aus der Vorlage und sonst nichts enthält. Issue #22, Commit 15c5e67
- `016`: löschen, wenn nur Werte auf der Vorlage; aus `035` generieren.
## PROD initialer Stand 15.12.2025
### Schreibvorlage
Vollständig implementiert: [Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_schreibvorlage/index.html)

### Aufsatz ableiten - print
Vollständig implementiert: [Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_aufsatz-ableiten-p/index.html)

### Externe Ressourcen Library of Congress
Entfernen diverser Felder beim Import: [Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_EXTR_LoC/index.html)

### Normalize on Save
- [LDR/18 und LDR/19](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;leader;nil)
- [Bindestriche aus ISBN entfernen](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield[@tag='020']/subfield[@code='a'];nil)
- [028$$aBestellnummer ...](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield[@tag='028']/subfield[@code='a'][starts-with(.,%20'Bestellnummer')%20or%20starts-with(.,%20'Best.-Nr.')];nil) und [Indikator 2](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield[@tag='028']/@ind2;nil)
- [041: Sprachcodes "scc" und "scr" auf "qsh" ändern](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield[@tag='041']/subfield[.=('scc',%20'scr')];nil)
- ORCID-Handling in [100, SF0](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield[@tag='100'][subfield[@code='2'][.='orcid']]/subfield[@code='0'];nil), [100, SF9](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield[@tag='100']/subfield[@code='9'][starts-with(.,%20'(orcid)')];nil), [700, SF0](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield[@tag='700'][subfield[@code='2'][.='orcid']]/subfield[@code='0'];nil) und [700, SF9](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield[@tag='700']/subfield[@code='9'][starts-with(.,%20'(orcid)')];nil)
- Aus einer `264` mit mehreren Verlagen mehrere Felder `264` erstellen: [Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield[@tag='264'][count(subfield[@code='b'])%20gt%201][not(subfield[@code=('6',%20'8')])];nil)
- `760-787`
  - [Präfix in SFw ergänzen](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield[@tag%20ge%20'760'%20and%20@tag%20le%20'787']/subfield[@code='w'];nil)
  - [Bindestriche aus SFz (ISBN) entfernen](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield[@tag%20ge%20'765'%20and%20@tag%20le%20'787']/subfield[@code='z'];nil)
  - [773, Indikatoren bedingungslos auf "08" stellen](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield[@tag='773']/@ind1|datafield[@tag='773']/@ind2;nil)
  - [773er bei Aufsätzen bearbeiten](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield[@tag='773'][subfield[@code='i'][.='Enthalten%20in']];nil)
  - [773 SFa löschen](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield[@tag='773']/subfield[@code='a'];nil)
  - [773 löschen, wenn sie nur den Inhalt aus dem Sonderdruck-Template, aber sonst nichts enthält](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield[@tag='773'][subfield[@code='i'][.='Sonderdruck%20aus']][not(subfield[@code='t']/text())];nil)
- [Präfix in 830 SFw ergänzen](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield[@tag='830']/subfield[@code='w'];nil)
- [Menschenlesbare Koordinaten in 250 aus 034 erstellen](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#stylesheet;src/geografika.xsl)
- [Sortieren der Ausgabefelder, etc.](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#stylesheet;src/sort.xsl)
