# Schreibvorlage E2P
| Feld                      | Beschreibung                      | Aktion                                                           | implementiert |
|---------------------------|-----------------------------------|------------------------------------------------------------------|---------------|
| 001                       | Kontrollnummer                    | löschen                                                          | y             |
| 007                       |                                   | auf "tu" setzen                                                  | y             |
| 008, Pos. 0-5             | Date entered on file              | auf ###### setzen                                                | y             |
| 008, Pos. 7-10            | Date 1                            | bleibt                                                           | y             |
| 008, Pos. 11-14           | Date 2                            | bleibt                                                           | y             |
| 008, Pos. 23              | Exemplarform                      | auf "#" setzen                                                   | y             |
| 009                       | AC-Nummer                         | löschen                                                          | y             |
| 015                       | Nummer der Nationalbibliografie   | löschen                                                          | y             |
| 016                       | Kontrollnummer                    | löschen                                                          | y             |
| 020                       | ISBN                              | 020 mit leerem Sfa hinzufügen                                    | y             |
| 020                       | E-ISBN                            | wird nach 776 08 Sfz transferiert                                | y             |
| 024                       | Anderer Standard-Identifier       | löschen                                                          | y             |
| 035                       | System-Kontrollnummer             | alle löschen                                                     | y             |
| 040                       | Katalogisierungsquelle            | löschen und `040##$$erda` erzeugen                               | y             |
| 041                       | Sprachcode                        | Indikatoren auf ##, Feld mit Sfa erzeugen, falls nicht vorhanden | y             |
| 044                       | Ländercode                        | Feld mit leerem Sfc hinzufügen, falls nicht vorhanden            | y             |
| 264                       | Veröffentlichungsangabe           | bleibt                                                           | y             |
| 300                       | Physische Beschreibung            | "1 Online-Ressource (\*)"  entfernen, wenn vorhanden             | y             |
| 336                       | Inhaltstyp                        | Feld mit Sfb txt hinzufügen, falls nicht vorhanden               | y             |
| 337                       | Medientyp                         | vorhandenes löschen und Sfb n hinzufügen                         | y             |
| 338                       | Datenträgertyp                    | vorhandenes löschen und Sfb nc hinzufügen                        | y             |
| 347                       | Eigenschaften der Digitalen Datei | löschen                                                          | y             |
| 773                       | TAT-Link bzw. Aufsatz-Link        | Inhalt von SF-w löschen                                          | y             |
| 776.{0,8}.n.Druck-Ausgabe | Link zur Druck-Ausgabe            | in 020 übertragen                                                | y             |
| 776.{0,8}                 | Link zur Online-Ausgabe           | einfügen                                                         | y             |
| 830                       | TUT-Link bzw. Serien-Link         | Inhalt von SF-w löschen                                          | y             |
| 856                       | Linkfeld                          | Löschen                                                          | y             |
| 912                       | Produktsigel                      | löschen                                                          | y             |
| 970.{1,-}                 | Fachgruppen                       | Feld mit leerem Sfc hinzufügen, falls nicht vorhanden            | y             |
| 972                       | Local Owner                       | löschen                                                          | y             |
| 974.{0,\*}                | "Wickelfelder"                    | löschen                                                          | y             |
