# Schreibvorlage

Diese Normalisierung dient dazu, einen Datensatz als Schreibvorlage zu verwenden. Diese Dokumentation beschreibt die Transformation des Datensatzes während dieses Prozesses.

Wie und wozu und unter welchen Bedingungen diese Normalisierung angewendet wird, können sie [im Katalogisierungshandbuch](https://wiki.obvsg.at/Katalogisierungshandbuch/AlmaWissenDatensatzerweiternSchreibvorlage) nachlesen.

## Allgemeines
Felder, die hier nicht erwähnt werden, werden unverändert übernommen. Siehe [mode unnamed](#mode;unnamed)

## Felder die bedingungslos gelöscht werden
- `001`
- `009`
- `015`
- `016`
- `020`
- `024`
- `035`
- `040`
- `250`
- `300`
- `776`
- `856`
- `912`
- `972`
- `974`

## Felder, die angepasst werden
- `008/00-14` wird auf `######|????####` gesetzt (wobei `#` hier, so wie immer bei Kontrollfeldern und Indikatoren, Leerzeichen repräsentieren)
- `264`: Die Indikatoren und `$$a`, `$$b`, `$$3` werden übernommen. Ein leeres `$$c` wird erstellt.

## Felder, die generiert werden
| Feld             | Bedingung                         |
|------------------|-----------------------------------|
| `015##$$a$$2`    | `015##$$2oeb` im Quelldatensatz   |
| `020##$$a$$c$$q` |                                   |
| `0248#$$a$$q`    | `0248#` im Quelldatensatz         |
| `041##$$a$$a`    | kein `041` im Quelldatensatz      |
| `044##$$c$$c`    | kein `044` im Quelldatensatz      |
| `250##$$a`       |                                   |
| `300##$$a$$b$$c` |                                   |
| `336##$$b`       | kein `336` im Quelldatensatz      |
| `337##$$b`       | kein `337` im Quelldatensatz      |
| `338##$$b`       | kein `338` im Quelldatensatz      |
| `264#1$$a$$c$$c` | kein `264` im Quelldatensatz      |
| `9701#$$c`       | kein `9701#$$c` im Quelldatensatz |
