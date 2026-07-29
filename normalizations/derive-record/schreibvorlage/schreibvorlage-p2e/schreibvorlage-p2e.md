# Schreibvorlage P2E

| Feld                           | Beschreibung                           | Aktion                                                           |
|--------------------------------|----------------------------------------|------------------------------------------------------------------|---|
| LDR                            |                                        | alles bis auf 06-08 auf Standard setzen                          |
| 001                            | Kontrollnummer                         | löschen                                                          |
| 003                            |                                        | löschen                                                          |
| 005                            | Änderungsdatum                         | löschen                                                          |
| 007                            |                                        | auf "cr" setzen                                                  |
| 010                            |                                        | löschen                                                          |
| 008, Pos. 0-5                  | Date entered on file                   | auf ###### setzen                                                |
| 008, Pos. 6                    | Type of date                           | auf "s" setzen                                                   |
| 008, Pos. 7-10                 | Date 1                                 | bleibt                                                           |
| 008, Pos. 11-14                | Date 2                                 | bleibt                                                           |
| 008, Pos. 23                   | Exemplarform                           | auf "o" setzen                                                   |
| 009                            | AC-Nummer                              | löschen                                                          |
| 015                            | Nummer der Nationalbibliografie        | löschen                                                          |
| 016                            | Kontrollnummer                         | löschen                                                          |
| 020                            | ISBN                                   | 020 mit leerem Sfa und SFq hinzufügen                            |
| 020                            | Print-ISBN                             | wird nach 776 08 Sfz transferiert                                |
| 024                            | Anderer Standard-Identifier            | löschen, leeres Feld für doi einfügen                            |
| 035                            | System-Kontrollnummer                  | alle löschen                                                     |
| 040                            | Katalogisierungsquelle                 | SFe immer mit "rda" belegen                                      |
| 041                            | Sprachcode                             | Indikatoren auf ##, Feld mit Sfa erzeugen, falls nicht vorhanden |
| 044                            | Ländercode                             | Feld mit leerem Sfc hinzufügen, falls nicht vorhanden            |
| 090 Sfa                        | Papierzustand                          | löschen                                                          |
| 090 Sfb                        | Informationen zu audiovisuellen Medien | löschen                                                          |
| 263                            |                                        | löschen                                                          |
| 300                            | Physische Beschreibung                 | Sfa "1 Online-Ressource" voranstellen und Sfc löschen            |
| 336                            | Inhaltstyp                             | Feld mit leerem Sfb hinzufügen, falls nicht vorhanden            |
| 337                            | Medientyp                              | vorhandenes löschen und Sfb c hinzufügen                         |
| 338                            | Datenträgertyp                         | vorhandenes löschen und Sfb cr hinzufügen                        |
| 347                            |                                        | SfaTextdatei, leeres Sfb                                         |
| 490                            | Gesamttitel                            | Indikator 1 auf "0" setzen                                       |
| 583                            |                                        | löschen                                                          |
| 773                            | TAT-Link bzw. Aufsatz-Link             | löschen                                                          |
| 776.{0,8}.n.Online-Ausgabe     | Link zur Online-Ausgabe                | wenn SFz, dann nach 020, sonst löschen                           |
| 776.{0,8}                      | Link zur Druck-Ausgabe                 | einfügen (siehe 020)                                             |
| 830                            | Link zum Gesamttitel                   | löschen                                                          |
| 856.{4,2}.3.Inhaltsverzeichnis | Link                                   | löschen                                                          |
| 856.{4,2}.3.Inhaltstext        | Link                                   | löschen                                                          |
| 856.{4,2}.3.Umschlagbild       | Link                                   | löschen                                                          |
| 856.{4,0}                      | Link                                   | einfügen mit leerem Sfu und Sf3 Volltext                         |
| 912                            | Produktsigel                           | einfügen                                                         |
| 970                            | diverse Verbund-lokale Daten           | alle bis auf Fachgruppe löschen                                  | y |
| 972                            | Local Owner                            | Feldlöschen                                                      |
| 974.{0,*}                      | "Wickelfelder"                         | Feld löschen                                                     |

