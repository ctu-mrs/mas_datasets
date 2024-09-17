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
echo Downloading processed datasets

URL_BAG_LOOP_PROC=https://nasmrs.felk.cvut.cz/index.php/s/A2GBykCy3aQDF2h/download
URL_BAG_RECTANGLE_PROC=https://nasmrs.felk.cvut.cz/index.php/s/2MsQrukm5ZfV72g/download
URL_BAG_FORWARD_PROC=https://nasmrs.felk.cvut.cz/index.php/s/Tp2XgnZ4vrM4PSj/download
URL_BAG_HOVER_PROC=https://nasmrs.felk.cvut.cz/index.php/s/0Zx0TIlwdoic62r/download
URL_BAG_LATERAL_PROC=https://nasmrs.felk.cvut.cz/index.php/s/R5zEZn4Y3ZKi6mG/download
URL_BAG_VERTICAL_PROC=https://nasmrs.felk.cvut.cz/index.php/s/7uViwwIeJm2YrCh/download

# URLs for files and their respective subdirectories
URL=( "$URL_BAG_LOOP_PROC" "$URL_BAG_RECTANGLE_PROC" "$URL_BAG_FORWARD_PROC" "$URL_BAG_HOVER_PROC" "$URL_BAG_LATERAL_PROC" "$URL_BAG_VERTICAL_PROC" )
DATA_FOLDERS=( "bag_files/processed" "bag_files/processed" "bag_files/processed" "bag_files/processed" "bag_files/processed" "bag_files/processed")
######################################################

mkdir -p bag_files
mkdir -p bag_files/processed

# Do not change below!
SCRIPT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
for (( j=0; j<${#URL[@]}; j++ ));
do
  download_data "${URL[$j]}" "$SCRIPT_PATH/${DATA_FOLDERS[$j]}"
done
