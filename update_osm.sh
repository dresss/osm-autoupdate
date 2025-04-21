#!/bin/bash
set -e

# tylko co 12 tygodni
week_number=$(date +%V)
if (( week_number % 12 != 0 )); then
  echo "Tydzień $week_number — pomijam aktualizację."
  exit 0
fi

echo "Rozpoczynam aktualizację OSM (tydzień $week_number)..."

# pobieranie
wget -N https://download.geofabrik.de/europe/poland-latest.osm.pbf -P /data
wget -N https://download.geofabrik.de/europe/germany-latest.osm.pbf -P /data
wget -N https://download.geofabrik.de/europe/netherlands-latest.osm.pbf -P /data

# scalanie
docker run --rm -v /volume1/docker/osmmerge:/data ghcr.io/osmcode/osmium-tool:v1.14.0 \
  merge /data/poland-latest.osm.pbf /data/germany-latest.osm.pbf /data/netherlands-latest.osm.pbf \
  -o /data/merged.osm.pbf

# restart Nominatim
docker restart nominatim

echo "Aktualizacja zakończona: $(date)"
