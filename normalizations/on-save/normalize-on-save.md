# Normalize on Save

Wenn in Alma ein Datensatz gespeichert wird, durchläuft dieser den Prozess "Marc21 Bib normalize on save". Dieser Prozess hat mehrere Schritte. Unter anderem wird eine Nummer in MARC 009 vergeben (so noch keine vorhanden ist), leere Felder werden gelöscht, die Felder werden sortiert, etc.

Der komplexeste Teil dabei ist die Normalisierung. Hierbei werden mittels bestimmten Regeln, geschrieben in der Programmiersprache [XSLT](https://www.w3.org/TR/xslt-30/), Änderungen am Datensatz vorgenommen. Die Regeln für diese Transformation werden in dieser Sprache in sogenannten "Templates" formuliert. Die Reihenfolge, in der die Templates in der Datei deklariert werden, ist nicht relevant. Vielmehr wird in einem Template üblicherweise formuliert, wie der Output zu einem gegebenen Input aussehen soll. Das hat gegenüber Drools den großen Vorteil, dass es während der Verarbeitung keine "Zwischenstände" gibt.

Weil beim Abspeichern eines Datensatzes so einiges passiert, gibt es auch sehr viele Templates. Damit das ganze übersichtlich(er) bleibt, wird das Ganze in mehrere Dateien aufgeteilt, die dann von `normalize-on-save.xsl` mittels `xsl:include` eingebunden werden.
