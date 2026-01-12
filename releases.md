# Drools2XSLT - Releases
<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-refresh-toc -->
**Table of Contents**

- [Drools2XSLT - Releases](#drools2xslt---releases)
  - [Allgemeines ](#allgemeines)
  - [Workflow und Zeitplan](#workflow-und-zeitplan)
- [Releases](#releases)
  - [Standard-Sandbox 19.01.2026 (geplant)](#standard-sandbox-19012026-geplant)
    - [Normalize on Save](#normalize-on-save)
    - [Datensatz ableiten](#datensatz-ableiten)
  - [PROD initialer Stand 23.12.2025](#prod-initialer-stand-23122025)
    - [Schreibvorlage](#schreibvorlage)
    - [Aufsatz ableiten - print](#aufsatz-ableiten---print)
    - [Externe Ressourcen Library of Congress](#externe-ressourcen-library-of-congress)
    - [Normalize on Save](#normalize-on-save-1)

<!-- markdown-toc end -->
## Allgemeines 
Die Normalisierungen in Alma sollen im Laufe des Jahres 2026 sukzessive in der Sprache XSLT neu implementiert werden. XSLT ist wesentlich mächtiger als Drools und ermöglicht auch automatisierte Tests und [automatisiert erstellte Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/index.html).

Nach Möglichkeit soll kein neuer Drools-Code mehr geschrieben werden. D. h. auch Fehlerbehebungen etc. werden möglichst gleich in XSLT implementiert. Bei dringenden Fehlerbehebungen ist es möglich, dass diese den Release-Zyklus umgehen und direkt ins Produktionssystem eingespielt werden.

## Workflow und Zeitplan
- Der tagesaktuelle Entwicklungsstand befindet sich in der [Premium-Sandbox](https://obv-at-obvsg-psb.alma.exlibrisgroup.com/mng/login)
- Am vorletzten Montag des Monats gibt es ein Update in der [Standard-Sandbox](https://sandbox-eu.alma.exlibrisgroup.com/mng/login?institute=43ACC_NETWORK). Das sind die Änderungen, die zwei Wochen später ins Produktionssystem übernommen werden sollen. Erster geplanter Termin: 19.01.2026
- Am ersten Montag des Monats werden die Änderungen ins [Produktionssystem](https://obv-at-obvsg-psb.alma.exlibrisgroup.com/mng/login) übernommen. Erster geplanter Termin: 02.02.2026

# Releases

## Standard-Sandbox 19.01.2026 (geplant)
Geplante Änderungen. Links zur Dokumentation sind noch nicht öffentlich erreichbar.

### Normalize on Save
- [X] Feld `008`: [Dokumentation](http://share-test.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;controlfield%5B@tag='008'%5D;nil)
  - [X] Sprachcodes mit `041` angleichen. Issue #26; Commit e86c2a9
  - [X] `008/15-17` auf `|||` setzen, wenn es einen Ländercode in `044##$$c` gibt.
  - [X] `008/19` bei fortlaufenden Ressourcen auf `|` setzen.
  - [X] `008/39` (cataloging source) fix auf `c` für "cooperative cataloging" setzen.
- [X] `016` und `035` bei ZDB-Records synchronisieren. Issue #23; Commit 4c9b204a; Dokumentation [hier](http://share-test.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield%5B@tag='016'%5D%5Bnot(subfield%5B@code=('a',%20'z')%5D/text())%5D;nil), [hier](http://share-test.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield%5B@tag='016'%5D%5Bsubfield%5B@code='2'%5D%5B.='DE-600'%5D%5D%5Bsubfield%5B@code='a'%5D/text()%5D;nil) und [hier](http://share-test.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield%5B@tag='035'%5D%5Bsubfield%5B@code='a'%5D%5Bstarts-with(.,%20'(DE-600)')%20or%20starts-with(upper-case(.),%20'ZDB-NEU')%5D%5D;nil)
- [X] `024` entfernen, wenn nur Werte aus der Vorlage und sonst nichts vorhanden ist. Issue #24; Dokumentation [hier](http://share-test.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield%5B@tag='024'%5D%5Bnot(subfield%5B@code=('a',%20'z')%5D/text())%5D;nil)
- [X] Bindestriche aus ISMN in `0242X$$a` entfernen. Commit 834c187; [hier](http://share-test.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield%5B@tag='024'%5D%5B@ind1='2'%5D/subfield%5B@code='a'%5D;nil)
- [X] Diverse Normalisierungen in `035`. Issue #27
  - [X] EKI erzeugen. Commit 2f85cc9
  - [X] `035##$$a(AT-OBV)` als erstes sortieren. Commit 7be669f
  - [X] `$$Z` in `$$a` ändern. Template-Text entfernen, der via Schreibhilfe in `$$Z` eingefügt, aber nicht verändert wurde. Commit 0c4bd73; Dokumentation [hier](http://share-test.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield%5B@tag='035'%5D/subfield%5B@code='Z'%5D;nil)

### Datensatz ableiten
- [X] Schreibvorlage E2P. Issue #18; Commit 2e13ee0; [Dokumentation](http://share-test.obvsg.at/xsldocs/xslt-normalization/OBV_schreibvorlage_e2p/index.html)

## PROD initialer Stand 23.12.2025

### Schreibvorlage
Vollständig implementiert: [Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_schreibvorlage/index.html)

### Aufsatz ableiten - print
Vollständig implementiert: [Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_aufsatz-ableiten-p/index.html)

### Externe Ressourcen Library of Congress
Entfernen diverser Felder beim Import: [Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_EXTR_LoC/index.html)

### Normalize on Save
- [LDR/18 und LDR/19](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;leader;nil)
- `007/01` bei Musik auf `q` setzen (KATA-082-fix007\_music). Commit 348cbd4, [Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;controlfield[@tag='007'][substring(../leader,%207,%201)%20=%20('c',%20'd')];nil)
- [Bindestriche aus ISBN entfernen](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield[@tag='020']/subfield[@code='a'];nil)
- [028$$aBestellnummer ...](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield[@tag='028']/subfield[@code='a'][starts-with(.,%20'Bestellnummer')%20or%20starts-with(.,%20'Best.-Nr.')];nil) und [Indikator 2](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield[@tag='028']/@ind2;nil)
- `034` löschen, wenn sie nur Werte aus der Vorlage und sonst nichts enthält. Issue #22, Commit 15c5e67, [Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield[@tag='034'];nil)
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
