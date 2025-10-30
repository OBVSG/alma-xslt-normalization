# Aufsatz ableiten - Print

Normalisierung zum Ableiten eines Print-Aufsatzes.

## Disclaimer
Dieses Dokument ist *keine Spezifikation*, es dient der Übersicht über die Transformation `Aufsatz ableiten - print`. Es wird so gut wie möglich aktuell gehalten, bei Unklarheiten oder wenn das Verhalten nicht auf diese Beschreibung passt, ist die Dokumentation zu den einzelnen Templates und Funktion ausschlaggebend. Sollte auch diese nicht hinreichen oder nicht korrekt sein, bitte wenden Sie sich an [alma-kat@obvsg.at](mailto:alma-kat@obvsg.at).

## Beschreibung der Transformation
Alle Felder, die hier nicht behandelt werden, werden **gelöscht**.
### Felder, die unverändert übernommen werden
Folgende Felder werden unverändert übernommen: `007`, `041`, `044`, `264` (bei Monografien), `336`, `337`, `338`, `490`.
### Felder, die angepasst werden
- Bei fortlaufenden Ressourcen wird die erste `26431` als `264#1` übernommen. `$$c` wird geleert.

### Felder, die neu generiert werden
- `leader` in der Form der Verbund-Vorlage für Aufsätze
- `008` in der Form der Verbund-Vorlage für Aufsätze, wenn möglich mit dem Erscheinungsjahr in pos. 07-10 und dem Sprachcode in pos. 35-37
- `1001#` mit leeren `$$a` und `$$4`
- `24500` mit leeren `$$a`, `$$b` und `$$c`. Der erste Indikator wird beim Speichern gegebenenfalls angepasst.
- `655#7` mit leerem `$$a`
- `7001#` mit leeren `$$a` und `$$4`
- `77608`: siehe unten
- `9701#` mit leerem `$c`

### 77308
Das Feld `77308` wird in der folgenden Form generiert. Werte in geschwungenen Klammern ("{}") dienen der Erläuterung und sind nicht Teil des Outputs.

```text
77308 $$iEnthalten in
      $$t{Titelangaben aus 245XX$$a, $$b und $$c mit ISBD-Interpunktion}
      $$d{Inhalt wird, wenn möglich, beim Speichern aus 264 generiert}
      $$k{leer}
      $$w(AT-OBV){AC-Nummer des Datensatzes, von dem abgeleitet wurde}
      $$x{leer}
      $$z{leer}
```
