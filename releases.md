# Drools2XSLT - Releases
<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-refresh-toc -->
**Table of Contents**

- [Drools2XSLT - Releases](#drools2xslt---releases)
  - [Allgemeines ](#allgemeines)
  - [Workflow und Zeitplan](#workflow-und-zeitplan)
- [Releases](#releases)
  - [Standard Sandbox 18.05.2026 (geplant)](#standard-sandbox-18052026-geplant)
    - [Normalize on Save](#normalize-on-save)
  - [Standard Sandbox 20.04.2026](#standard-sandbox-20042026)
    - [Normalize on Save](#normalize-on-save-1)
    - [TAT ableiten](#tat-ableiten)
  - [Produktion 07.04.2026](#produktion-07042026)
    - [Normalize on Save](#normalize-on-save-2)
    - [Library of Congress](#library-of-congress)
    - [KI-Assistent](#ki-assistent)
    - [Allgemeines](#allgemeines)
  - [Produktion 02.03.2026](#produktion-02032026)
    - [Normalize on Save](#normalize-on-save-3)
    - [E2P](#e2p)
  - [Produktion 02.02.2026](#produktion-02022026)
    - [Normalize on Save](#normalize-on-save-4)
    - [Datensatz ableiten](#datensatz-ableiten)
  - [PROD initialer Stand 23.12.2025](#prod-initialer-stand-23122025)
    - [Schreibvorlage](#schreibvorlage)
    - [Aufsatz ableiten - print](#aufsatz-ableiten---print)
    - [Externe Ressourcen Library of Congress](#externe-ressourcen-library-of-congress)
    - [Normalize on Save](#normalize-on-save-5)

<!-- markdown-toc end -->
## Allgemeines 
Die Normalisierungen in Alma sollen im Laufe des Jahres 2026 sukzessive in der Sprache XSLT neu implementiert werden. XSLT ist wesentlich mächtiger als Drools und ermöglicht auch automatisierte Tests und [automatisiert erstellte Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/index.html).

Nach Möglichkeit soll kein neuer Drools-Code mehr geschrieben werden. D. h. auch Fehlerbehebungen etc. werden möglichst gleich in XSLT implementiert. Bei dringenden Fehlerbehebungen ist es möglich, dass diese den Release-Zyklus umgehen und direkt ins Produktionssystem eingespielt werden.

## Workflow und Zeitplan
- Der tagesaktuelle Entwicklungsstand befindet sich in der [Premium-Sandbox](https://obv-at-obvsg-psb.alma.exlibrisgroup.com/mng/login)
- Am vorletzten Montag des Monats gibt es ein Update in der [Standard-Sandbox](https://sandbox-eu.alma.exlibrisgroup.com/mng/login?institute=43ACC_NETWORK). Das sind die Änderungen, die zwei Wochen später ins Produktionssystem übernommen werden sollen. Erster geplanter Termin: 19.01.2026
- Am ersten Montag des Monats werden die Änderungen ins [Produktionssystem](https://obv-at-obvsg-psb.alma.exlibrisgroup.com/mng/login) übernommen. Erster geplanter Termin: 02.02.2026

# Releases

## Standard Sandbox 18.05.2026 (geplant)

### Normalize on Save
- [ ] MARC-Escapes in `$$6` gegen ISO-Schriftcodes tauschen, wenn möglich

## Standard Sandbox 20.04.2026

### Normalize on Save
- [x] FIX: Löschen von `776` ohne sinnvollen Inhalt: Erweitere den Begriff "sinnvoll" um die Subfelder `atbdh`. Commit 4086da6; [Dokumentation](https://share.obvsg.at/xsldocs/preview/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield%5B@tag='776'%5D%5Bnot(subfield%5B@code=('a',%20't',%20'b',%20'd',%20'h',%20'o',%20'w',%20'x',%20'z')%5D/text())%5D;nil)
- [x] Nur die erste `040` berücksichtigen. Commit 5a8f786; [Dokumentation](https://share.obvsg.at/xsldocs/preview/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield%5B@tag='040'%5D%5Bpreceding-sibling::datafield%5B@tag='040'%5D%5D;nil)
- [x] `240 $$l` nach hinten sortieren. Commit ae34f66d; [Dokumentation](https://share.obvsg.at/xsldocs/preview/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield%5B@tag='240'%5D;sort)
- [x] `591##$$aUnikaler Bestand ...` um ISIL ergänzen. Commit ef1ce33; [Dokumentation](https://share.obvsg.at/xsldocs/preview/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield%5B@tag='591'%5D/subfield%5B@code='a'%5D%5B.='Unikaler%20Bestand%20-%20bitte%20nicht%20nutzen!'%5D;nil)
- [x] ZDB-Artefakte aus `035` entfernen. D. h. "ZDB-NEU" etc. kommt in `9703#`. Commit c2bcedd; [Dokumentation](https://share.obvsg.at/xsldocs/preview/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield%5B@tag='035'%5D%5Bsubfield%5B@code=('a',%20'Z')%5D%5Bstarts-with(.,%20'(DE-600)')%20or%20starts-with(upper-case(.),%20'ZDB-NEU')%5D%5D;nil)
- [x] `880` ohne assoziiertes Feld löschen. Commit 12c6ac6; [Dokumentation](https://share.obvsg.at/xsldocs/preview/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield%5B@tag='880'%5D;sort)

### TAT ableiten
Ganze Normalisierung neu. Commit 642934b; [Dokumentation](https://share.obvsg.at/xsldocs/preview/xslt-normalization/OBV_normalize-on-save/index.html#file:///home/ss/projects/almaConfig/xsltNormalization/docs/OBV_tat_ableiten/index.html)

## Produktion 07.04.2026

### Normalize on Save
- [x] bei Löschung der letzten `830`, `LDR/19=#`. Commit d83a53d; [Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;leader;nil)
- [x] `035` aus `009` generieren. Commit dc07c08,
[Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;controlfield%5B@tag='009'%5D;nil) 
- [X] `1XX` und `700-730` bearbeiten
  - [X] `ind1` bei Personen setzen; Commit 1e8a2f4; [Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;personInd1;nil)
  - [X] Default-Relator-Code setzen; Commit 3179ee2; [Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;addDefaultRelator;nil)
  - [X] Felder ohne `$$a` entfernen (weil sie nur Daten aus dem Template enthalten). Commit 878669c; Dokumentation siehe Templates zu Feld `100`, `110`, `111`, `700`, `710`, `711`
  - [X] Indikator 1 von `X11` setzen: Commit 6d1ac56; Dokumentation siehe die Templates zu `111` und `711` jeweils `@ind1`
  - [X] Indikator 2 von `700`, `710` und `711` auf `2` setzen, wenn es ein `$$a` gibt (es sich also um eine analytische Aufnahme handelt). Commit e228e99; [Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield%5B@tag=('700',%20'710',%20'711')%5D/@ind2;nil) 
- [X] `240`
  - [X] `$$F` in `$$a` umwandeln. Drools: `KATA-018-rn240Fa`; [Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield%5B@tag='240'%5D/subfield%5B@code='F'%5D/@code;nil) 
  - [X] Indikatoren fix auf `10` setzen. Drools: `KATA-077-ci240`; [Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield%5B@tag='240'%5D/@ind1;nil) 
  - [x] Subfelder sortieren. [Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield[@tag='240'];sort)
- [X] `245`. Commit d4f592a
  - [X] Indikatoren setzen. [Dokumentation für ind1](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield[@tag='245']/@ind1;nil) und [ind2](https://share.obvsg.at/xsldocs/preview/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield[@tag='245'][@ind2%20ne%20'0']/@ind2;nil)
  - [X] Subfelder `$$n[...]` bei fR entfernen. [Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield[@tag='245']/subfield[@code='n'];nil)
  - [X] Nichtsortierzeichen einfügen. [Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield[@tag='245'][@ind2%20ne%20'0']/subfield[@code='a'][not(starts-with(.,%20'%3C'))]/text();nil)
- [X] Indikatoren in `246` setzen. Commit 54858ad; [Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield[@tag='246'];nil)
- [X] `247` entfernen, wenn es keinen Text in `$$a` gibt. Commit 437fb14; [Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield[@tag='247'][not(subfield[@code='a']/text())];nil)
- [X] `264#4` entfernen, wenn nur `$$c©`. Commit e30a93a; [Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield%5B@tag='264'%5D%5B@ind1='%20'%5D%5B@ind2='4'%5D%5Bsubfield%5B@code='c'%5D%5Bnormalize-space(.)%20eq%20'%C2%A9'%5D%5D;nil)
- [X] Indikatoren von `300` fix auf `##` setzen. Commit e85b7aa; [Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield[@tag='300']/@ind1;nil), 
- [X] `337` aus `338` erzeugen. Commit fe44a83; [Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield[@tag='338'][subfield[@code='b']/text()];nil)
- [X] `348`/`655` für `gnd-music` bearbeiten. Commit 14ed0a0; Dokumentation für [348](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield[@tag='348']/subfield[@code='N']/@code;nil) und [655](https://share.obvsg.at/xsldocs/preview/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield[@tag='655'][subfield[@code='2'][.='gnd-music']];nil)
- [X] `347 $$eRegion ...` entfernen. Commit 1453251; [Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield%5B@tag='347'%5D/subfield%5B@code='e'%5D%5B.='Region%20...'%5D;nil)
- [x] `362` Indikatoren fix auf `0#` setzen. Commit 66141d1; [Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield[@tag='362']/@ind1;nil)
- [x] `500`. Commit 0a276c3
  - [x] `$$D` in `$$a` ändern. [Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield[@tag='500']/subfield[@code='D']/@code;nil) 
  - [x] Feld entfernen, wenn nur Template-Text. [Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield[@tag='500'][subfield[@code='a'][.=('Zusatzmaterial:',%20'Bildseitenverh%C3%A4ltnis:')]];nil)
  - [x] Inhalte für Implicit/Explicit/Entstehungsstufe mit `290` synchronisieren. [Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield[@tag='500'];nil)
- [x] `538` entfernen, wenn es kein `$$a` gibt. Commit 1857a7e; [Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield[@tag='538'][not(subfield[@code='a']/text())];nil)
- [x] `546` entfernen, wenn `$$a` nur Vortexte enthält. Commit 8ec42ff; [Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield%5B@tag='546'%5D%5Bmatches(subfield%5B@code='a'%5D,%20'%5E(Sprachfassungen%7CUntertitel):%20?$')%5D;nil)
- [x] `655`. Commit 89b29ea
  - [x] entfernen, wenn kein `$$a`. [Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield%5B@tag='655'%5D%5Bnot(subfield%5B@code=('a',%20'N')%5D/text())%5D;nil)
  - [x] `$$N` auf `$$a` ändern. [Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield%5B@tag='655'%5D/subfield%5B@code='N'%5D/@code;nil) 
  - [x] `@ind2` auf "7" setzen, wenn es ein `$$2` gibt. [Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield%5B@tag='655'%5D%5Bsubfield%5B@code='2'%5D/text()%5D/@ind2;nil)
- [x] `689`. Commit e5e2284
  - [x] `$$5AT-OBV` hinzufügen, wo notwendig.[Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield%5B@tag='689'%5D%5B@ind2='%20'%5D%5Bsubfield%5B@code='5'%5D%5D%5Bnot(subfield%5Bnot(@code='5')%5D)%5D;nil)
  - [x] `689X#` löschen, wenn es keine dazugehörige Folge gibt.[Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield%5B@tag='689'%5D;sort)
  - [x] `$$Z` (wg. CV-Liste) in `$$a` ändern.[Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield%5B@tag='689'%5D/subfield%5B@code='Z'%5D/@code;nil)
- [x] `776`: Löschen, wenn es nur Template-Text gibt. `$$n` löschen, wenn es kein passendes `$$i` gibt. Commit 454ce76; [Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield%5B@tag='776'%5D%5Bnot(subfield%5B@code=('o',%20'w',%20'x',%20'z')%5D/text())%5D;nil) und[Dokumentation](https://share.obvsg.at/xsldocs/preview/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield%5B@tag='776'%5D%5Bnot(subfield%5B@code='i'%5D%5B.='Erscheint%20auch%20als'%5D)%5D/subfield%5B@code='n'%5D%5B.='Online-Ausgabe'%5D;nil)
- [x] Indikatoren in `780` je nach `$$i` setzen. Commit 51d52d4; [Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield%5B@tag='780'%5D/@ind1;nil) und[Dokumentation](https://share.obvsg.at/xsldocs/preview/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield%5B@tag='780'%5D/@ind2;nil)
- [x] Indikatoren in `785` je nach `$$i` setzen. Commit ee40c17; [Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield%5B@tag='785'%5D/@ind1;nil) und[Dokumentation](https://share.obvsg.at/xsldocs/preview/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield%5B@tag='785'%5D/@ind2;nil)
- [x] `830`: Indikatoren fix auf `#0` setzen. Commit 37e2ed5; [Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield%5B@tag='830'%5D/@ind1;nil)
- [x] `856` ohne `$$u` löschen. Commit fdcdde0; [Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield%5B@tag='856'%5D%5Bnot(subfield%5B@code='u'%5D)%5D;nil)
- [x] `970`: Wenn "Dublette zu" in SFa oder SFA vorhanden ist, die Indikatoren auf `0#` setzen. Commit fdb6564; [Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield%5B@tag='970'%5D%5Bsubfield%5B@code=('a',%20'A')%5D%5Bcontains(.,%20'Dublette%20zu')%5D%5D/(@ind1%7C@ind2);nil)
- [x] `9707#`: ISIL zur LKR-Markierung hinzufügen. Commit 8aac715; [Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield%5B@tag='970'%5D%5B@ind1='7'%5D/subfield%5B@code=('a',%20'A')%5D%5Bmatches(.,%20'%5E(lkr/itm%7Clkr%7Citm)$',%20'i')%5D;nil)
- [x] `9702#$$vNAK-Bestand`, wenn `090##$$v1`. Commit f4d4bbc. [Dokumentation für Feld 090](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield%5B@tag='090'%5D%5B1%5D;nil) und [Feld 970](https://share.obvsg.at/xsldocs/preview/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield%5B@tag='970'%5D%5B@ind1='2'%5D%5B@ind2='%20'%5D;nil) 
- [x] Von Institution eingemeldeten Link bei barrierefrei aufbereiteten Inhalten einfügen. Commit 7c50591; [Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield%5B@tag='970'%5D%5Bsubfield%5B@code=('a',%20'A')%5D%5B.='barrierefrei%20aufbereitet'%5D%5D%5Bnot(subfield%5B@code='i'%5D/text())%5D;nil)
- [X] Subfelder sortieren in `1XX`, `240`, `385`, `6XX`, `7XX` - jeweils in den Feldern, wo es eine GND-Verlinkung geben kann. [Dokumentation hier beim jeweiligen Feld](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#stylesheet;src/sort.xsl)
- FIX: Bindestriche aus `020##$$z` entfernen. Commit 5c054b7; [Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield[@tag='020']/subfield[@code=('a',%20'z')];nil)


### Library of Congress

- ISBD-Interpunktion entfernen. Commit ecf09b9; [Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;subfield/text();nil)

### KI-Assistent

Commit 0ae5b91, [Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_AI_Assistant/index.html)

- Datensätze in `9700#` markieren
- relator terms in `$$e` in codes in `$$4` umwandeln
- ISBD entfernen

Dann in Normalize on Save

- Markierung setzen, wenn der Datensatz angereichert wird
- Redaktionelle Markierungen in `9700#$$aAI-Assistant$$r...` normalisieren und anreichern (ISIL und timestamp)

### Allgemeines
- [X] Leere Felder und Subfelder entfernen. Commit 8ba9199. [Dokumentation für leere Subfelder](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield/subfield%5Bnot(text())%5D;sort) und [leere Felder](https://share.obvsg.at/xsldocs/preview/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield%5Bnot(subfield/text())%5D;sort)

## Produktion 02.03.2026

### Normalize on Save
- [X] `034` nur mit Template-Inhalt entfernen. Commit 69d71e36; [Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/#temp;datafield[@tag='034'];nil)
- [X] `255` nur aus `034` generieren, wenn es von beiden nur eines gibt. Commit 0a22b49; Dokumentation [hier](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/#temp;datafield[@tag='034'];nil) und [hier](https://share.obvsg.at/xsldocs/preview/xslt-normalization/OBV_normalize-on-save/#temp;datafield[@tag='255'][count(../datafield[@tag='255'])%20eq%201%20and%20count(../datafield[@tag='034'])%20eq%201];nil)
- [X] FIX: `LDR/19`, TATs ziehen immer vor (auch bei Sonderdrucken etc.). Commit c799939;  [Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;leader;nil)
- ISIL der bearbeitenden Institution
  - [X] ISIL als Parameter übernehmen. Issue #32; Commit 401e233, a19176a; Dokumentation [hier](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#func;utils:collect-metadata) und [hier](https://share.obvsg.at/xsldocs/preview/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield[@tag='MOD'];nil)
  - [X] `040` bearbeiten. Commit 6caee5a; [Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;handle040)
  - [X] Handling von `090` bei OAI-Importen. Commit 799f46f; [hier](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield%5B@tag='090'%5D%5B1%5D;nil) und [hier](https://share.obvsg.at/xsldocs/preview/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield%5B@tag='090'%5D%5Bposition()%20ne%201%5D;nil)

### E2P
- `506` und `540` entfernen

## Produktion 02.02.2026
Vollständige Doku hier: https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html

### Normalize on Save
- [X] Feld `008`: [Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;controlfield%5B@tag='008'%5D;nil)
  - [X] Sprachcodes mit `041` angleichen. Issue #26; Commit e86c2a9
  - [X] `008/15-17` auf `|||` setzen, wenn es einen Ländercode in `044##$$c` gibt.
  - [X] `008/19` bei fortlaufenden Ressourcen auf `|` setzen.
  - [X] `008/39` (cataloging source) fix auf `c` für "cooperative cataloging" setzen.
- [X] `016` und `035` bei ZDB-Records synchronisieren. Issue #23; Commit 4c9b204a; Dokumentation [hier](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield%5B@tag='016'%5D%5Bnot(subfield%5B@code=('a',%20'z')%5D/text())%5D;nil), [hier](http://share-test.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield%5B@tag='016'%5D%5Bsubfield%5B@code='2'%5D%5B.='DE-600'%5D%5D%5Bsubfield%5B@code='a'%5D/text()%5D;nil) und [hier](http://share-test.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield%5B@tag='035'%5D%5Bsubfield%5B@code='a'%5D%5Bstarts-with(.,%20'(DE-600)')%20or%20starts-with(upper-case(.),%20'ZDB-NEU')%5D%5D;nil)
- [X] `024` entfernen, wenn nur Werte aus der Vorlage und sonst nichts vorhanden ist. Issue #24; Dokumentation [hier](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield%5B@tag='024'%5D%5Bnot(subfield%5B@code=('a',%20'z')%5D/text())%5D;nil)
- [X] Bindestriche aus ISMN in `0242X$$a` entfernen. Commit 834c187; [hier](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield%5B@tag='024'%5D%5B@ind1='2'%5D/subfield%5B@code='a'%5D;nil)
- [X] Diverse Normalisierungen in `035`. Issue #27
  - [X] EKI erzeugen. Commit 2f85cc9; Dokumentation [hier](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;createEki)
  - [X] `035##$$a(AT-OBV)` als erstes sortieren. Commit 7be669f
  - [X] `$$Z` in `$$a` ändern. Template-Text entfernen, der via Schreibhilfe in `$$Z` eingefügt, aber nicht verändert wurde. Commit 0c4bd73; Dokumentation [hier](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield%5B@tag='035'%5D/subfield%5B@code='Z'%5D;nil)
- [X] `084` ohne Inhalt in `$$a` entfernen. Commit e2ab8c2; Dokumentation [hier](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield%5B@tag='084'%5D%5Bnot(subfield%5B@code='a'%5D/text())%5D;nil)
- [X] `830 $$a` auf `$$w`, wenn es eine AC-Nummer enthält. Issue #31; Commit 26679de; Dokumentation [hier](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield%5B@tag='830'%5D/subfield%5B@code='a'%5D%5Bmatches(.,%20'(%5C(AT-OBV%5C))?AC')%5D;nil)
- [X] `830` ohne `$$w` entfernen. Issue #30; Commit be5bc05; Dokumentation [hier](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_normalize-on-save/index.html#temp;datafield%5B@tag='830'%5D%5Bnot(subfield%5B@code='w'%5D)%20and%20not(subfield%5B@code='a'%5D%5Bmatches(.,%20'(%5C(AT-OBV%5C))?AC')%5D)%5D;nil)

### Datensatz ableiten
- [X] Schreibvorlage E2P. Issue #18; Commit 2e13ee0; [Dokumentation](https://share.obvsg.at/xsldocs/xslt-normalization/OBV_schreibvorlage_e2p/index.html)

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
