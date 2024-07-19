#!/bin/bash

## #{ download_data()
download_data() {
  URL=$1
  DESTINATION_FOLDER=$2
  if wget --no-check-certificate --content-disposition "${URL}" -c -P "${DESTINATION_FOLDER}"; then
    echo "wget of data was successfull"
  else
    echo "wget of data was unsuccessfull"
    echo " url: $URL"
    echo " destination: $DESTINATION_FOLDER"
  fi
}
## #}

######################################################
# Add datasets here:
echo Downloading datasets
URL_BAG_LOOP=https://nasmrs.felk.cvut.cz/index.php/s/Q9O8afoaESZJaGx/download
URL_BAG_RECTANGLE=https://nasmrs.felk.cvut.cz/index.php/s/7ufVl2aAzTpy0e5/download
URL_BAG_FORWARD=https://nasmrs.felk.cvut.cz/index.php/s/7sf3ACvC9ikOqqI/download
URL_BAG_HOVER=https://nasmrs.felk.cvut.cz/index.php/s/sDVdENn7NQOdcTJ/download
URL_BAG_LATERAL=https://nasmrs.felk.cvut.cz/index.php/s/o1iaKH6JaYA2Lru/download
URL_BAG_VERTICAL=https://nasmrs.felk.cvut.cz/index.php/s/qh66dYeiRAjbKAs/download

# URLs for files and their respective subdirectories
URL=( "$URL_BAG_LOOP" "$URL_BAG_RECTANGLE" "$URL_BAG_FORWARD" "$URL_BAG_HOVER" "$URL_BAG_LATERAL" "$URL_BAG_VERTICAL" )
DATA_FOLDERS=( "bag_files/" "bag_files/" "bag_files/" "bag_files/" "bag_files/" "bag_files/" )
######################################################

mkdir -p bag_files
# Do not change below!
SCRIPT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
for (( j=0; j<${#URL[@]}; j++ ));
do
  download_data "${URL[$j]}" "$SCRIPT_PATH/${DATA_FOLDERS[$j]}"
done
