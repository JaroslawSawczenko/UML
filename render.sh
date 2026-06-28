#!/usr/bin/env bash
# Regeneruje wszystkie diagramy PlantUML (wersja polska i angielska) do katalogu
# diagrams/. Wymaga Java (JRE) oraz pliku plantuml.jar.
#
# Uzycie:
#   ./render.sh
#   PLANTUML_JAR=/sciezka/do/plantuml.jar ./render.sh
set -euo pipefail

cd "$(dirname "$0")"

PLANTUML_JAR="${PLANTUML_JAR:-plantuml.jar}"

if [ ! -f "$PLANTUML_JAR" ]; then
  echo "Nie znaleziono '$PLANTUML_JAR'." >&2
  echo "Pobierz PlantUML ze strony https://plantuml.com/download i umiesc plik" >&2
  echo "w katalogu glownym repozytorium albo wskaz go zmienna PLANTUML_JAR." >&2
  exit 1
fi

echo "Renderowanie diagramow (PL) -> diagrams/"
java -jar "$PLANTUML_JAR" -tpng -o "$(pwd)/diagrams" src/*.puml

echo "Renderowanie diagramow (EN) -> diagrams/en/"
java -jar "$PLANTUML_JAR" -tpng -o "$(pwd)/diagrams/en" src/en/*.puml

echo "Gotowe."
