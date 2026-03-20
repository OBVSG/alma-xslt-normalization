# AI-Assistant

Bei der Verwendung des KI-Assistenten im Metadaten-Editor in Alma sind
Normalisierungen notwendig, um die Datenqualität hoch zu halten bzw.
wiederkehrende manuelle Korrekturen zu vermeiden. Darüber hinaus werden
Datensätze, die mit dem Assistenten erstellt oder angereichert wurden,
entsprechend in `9700#` markiert. Details siehe
[flagAiAssistant](#temp;flagAiAssistant;nil).

Diese Normalisierungen laufen beim Auslösen des KI-Assistenten. Bei mit dem
Assistenten neu erstellten Datensätzen scheint dies von Alma etwas anders
gehandhabt zu werden, wie bei Anreicherungen. Daher wird die Markierung in
`9700#` bei Neuaufnahmen sofort beim Auslösen des Assistenten eingefügt, bei
Anreicherungen aber erst beim Speichern durch den/die Bearbeiter:in (also durch
Normalize on Save).

## Pilotbetrieb

Die Verwendung des AI-Assistant im Metadaten-Editor im OBV befindet derzeit im
Pilotbetrieb. Während dieses Pilotbetriebs wird er von einigen Teilnehmenden
Institutionen getestet und es werden Erfahrungen gesammelt. Darauf aufbauend
werden auch die Normalisierungen ständig verbessert. Bitte löschen Sie keine der
relevanten Markierungen!

## Verwendung in anderen Stylesheets

Das Template `flagAiAssistant` wird auch in Normalize on Save gebraucht, um
Datensätze zu markieren, die nicht mit dem KI-Assistenten erstellt wurden,
sondern nur angereichert.

`ai-assistant.xsl` muss mit `xsl:import` eingebunden werden, weil es nicht nur
das hier verwendete named template, sondern auch ein diverse matching templates
enthält. Diese sollen natürlich nicht zur Anwendung kommen. Bei der Verwendung
der `xsl:import`-Deklaration wird dies durch die Import-Präzedenz sichergestellt.

