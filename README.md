# XSLT-Normalisierung in Alma

Dieses Repo enthält die XSLT-Normalisierungen, die in Alma verwendet werden.

## Grundsätzliches
Damit die Normalisierungen, die hier entwickelt werden, in Alma verwendbar sind, muss ein gewisser Workflow eingehalten werden. 

Es gibt keine Möglichkeit, via API Normalisierungen zu aktualisieren. Das heißt, dass die hier erstellten Stylesheets mit Copy Paste in den Alma MDE eingefügt werden. 

Bei komplexeren Stylesheets ist es oft zweckdienlich, diese in mehrere Quelldateien aufzuteilen und diese via `include` in eine Hauptdatei einzubinden. In Alma kann allerdings immer nur eine monolithische Datei hinterlegt werden. Damit gleichzeitig die Entwicklung übersichtlich bleibt, Library Code eingebunden werden kann et cetera, und eine gebündelte Datei zum Laden in Alma vorhanden ist, gibt es einen Prozess, der die Dateien bündelt. 

In der CI von GitLab werden aus voneinander abhängigen Stylesheets einzelne Stylesheets gebaut, die in Alma geladen werden können. Die Tests werden dann gegen diese gebündelten Stylesheets gefahren. Gleichzeitig wird auch noch Dokumentation erstellt. Damit das funktioniert, müssen beim Erstellen von Code und Tests einige Dinge eingehalten werden. Siehe weiter unten. 
