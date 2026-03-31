# TAT ableiten

Normalisierung zum Ableiten eines Teils mit abhängigem Titel.

## Disclaimer
Dieses Dokument ist *keine Spezifikation*, es dient der Übersicht über die Transformation `1_TAT ableiten`. Es wird so gut wie möglich aktuell gehalten, bei Unklarheiten oder wenn das Verhalten nicht auf diese Beschreibung passt, ist die Dokumentation zu den einzelnen Templates und Funktion ausschlaggebend. Sollte auch diese nicht hinreichen oder nicht korrekt sein, bitte wenden Sie sich an [alma-kat@obvsg.at](mailto:alma-kat@obvsg.at).

## Beschreibung der Transformation
Alle Felder, die hier nicht behandelt werden, werden **gelöscht**.

### Felder, die unverändert übernommen werden
Folgende Felder werden unverändert übernommen: 
  - `007`
  - `041`
  - `044`
  - `1XX`
  - `246`
  - `250`
  - `336` wenn es sich nicht um eine Medienkombination (`LDR/06=o`) handelt
  - `337` wenn es sich nicht um eine Medienkombination (`LDR/06=o`) handelt
  - `338` wenn es sich nicht um eine Medienkombination (`LDR/06=o`) handelt
  - `700`
  - `710`
  - `711`
  - `880`
  - `970`

### Felder, die angepasst werden
- [x] `leader`
  - Pos. 7 auf `m` setzen
  - Pos. 19 auf `c` setzen
- [x] `008`:
  - Aktuelles Datum in Pos. 00-05 eintragen
  - Pos. 06 mit `s` befüllen
  - Pos. 07-14 mit `????####` befüllen
  - Pos. 21 mit `|` befüllen
- [x] `245`: `$$a` und `$$c` werden übernommen, dazwischen leere `$$n` und `$$p` eingefügt.
- [x] `264#*`: `$$c` leeren und `$$3` löschen
- [x] `26431` (beim Ableiten von Reihen): Indikatoren auf `#1` setzen, `$$c` leeren.
- [x] Bei `490` wird `$$v` geleert
- [x] Bei `830` wird `$$v` geleert

### Felder, die neu generiert werden
- [x] `020##$$a`
- [x] `0242#$$a`, wenn es sich um Noten (`LDR/06=c`) handelt
- [x] `02822$$a`, wenn es sich um Noten (`LDR/06=c`) handelt
- [x] `02832$$a`, wenn es sich um Noten (`LDR/06=c`) handelt
- [x] `040##$$bger$$erda`
- [x] `1001#$$a`, wenn nicht vorhanden
- [x] `250`, wenn nicht vorhanden
- [x] `300##$$a$$b$$c`
- [x] `336##$$b`, `337##$$b`, `338##$$b`, wenn nicht vorhanden oder wenn es sich um eine Medienkombination handelt.
- [x] `655#7$$a`
- [x] 3x `7001#$$a$$4`
- [x] `77308` mit der AC-Nummer der Überordnung und leerem `$$q`
- [x] `9701#$$c`, wenn nicht vorhanden
- [x] `9708#$$h`

### Warnung beim Ableiten von einer Zeitschrift
Wenn ein TAT von einer Zeitschrift (`LDR/07=s` und `008/21!=m`) abgeleitet werden soll, wird die `245` mit einer Warnung befüllt:

```
24500$$aSie versuchen, einen TAT von einer Zeitschrift abzuleiten. Lassen Sie das!
```
