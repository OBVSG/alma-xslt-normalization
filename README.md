# XSLT-Normalisierung in Alma

Dieses Repo enthält die XSLT-Normalisierungen, die in Alma verwendet werden.

## Grundsätzliches
Damit die Normalisierungen, die hier entwickelt werden, in Alma verwendbar sind, muss ein gewisser Workflow eingehalten werden. 

Es gibt keine Möglichkeit, via API Normalisierungen zu aktualisieren. Das heißt, dass die hier erstellten Stylesheets mit Copy Paste in den Alma MDE eingefügt werden. 

Bei komplexeren Stylesheets ist es oft zweckdienlich, diese in mehrere Quelldateien aufzuteilen und diese via `include` in eine Hauptdatei einzubinden. In Alma kann allerdings immer nur eine monolithische Datei hinterlegt werden. Damit gleichzeitig die Entwicklung übersichtlich bleibt, Library Code eingebunden werden kann et cetera, und eine gebündelte Datei zum Laden in Alma vorhanden ist, gibt es einen Prozess, der die Dateien bündelt. Das passiert mit dem (xslt-bundler)[https://gitlab.obvsg.at/AlmaConfig/xslt-bundler], der als Submodul hier eingebunden ist.

Die Dokumentation wird vom (xslt-documentation-generator)[https://gitlab.obvsg.at/AlmaConfig/xslt-documentation-generator] erzeugt. Dieser ist auch als Submodul eingebunden.

In der CI von GitLab werden aus voneinander abhängigen Stylesheets einzelne Stylesheets gebaut, die in Alma geladen werden können. Die Tests werden dann gegen diese gebündelten Stylesheets gefahren. Gleichzeitig wird auch noch Dokumentation erstellt. Damit das funktioniert, müssen beim Erstellen von Code und Tests einige Dinge eingehalten werden. Siehe weiter unten. 

## Voraussetzungen und Abhängigkeiten

Es handelt sich hier um ein XSLT-Projekt. Es hat nur wenige Abhängigkeiten:
- Saxon 12.5J
- Xspec 3.3.2
- Java (openjdk 21.0.8)

Die angegebenen Versionen sind die, mit denen ich (Stefan Schuh) derzeit arbeite. Wahrscheinlich geht es auch mit älteren Versionen.

## Weitere Dokumentation

- [Coding Conventions](doc/coding-conventions.md)
- [Build-Prozess und Continuous Integration](doc/build-ci.md)
- [Dokumentation](doc/documentation.md)
