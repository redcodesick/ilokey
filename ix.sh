#!/bin/bash

extract() {
    mkdir -p iLo

    echo "Downloading data for $1..."
    curl_output_all=$(curl -ks "https://$1/xmldata?item=All" 2>&1)
    curl_exit_code_all=$?
    if [ $curl_exit_code_all -ne 0 ]; then
        echo "Failed to download data for $1: $curl_output_all"
        return $curl_exit_code_all
    fi
    echo "$curl_output_all" >> "iLo/$1"

    curl_output_key=$(curl -ks "https://$1/xmldata?item=CpqKey" 2>&1)
    curl_exit_code_key=$?
    if [ $curl_exit_code_key -ne 0 ]; then
        echo "Failed to download key for $1: $curl_output_key"
        return $curl_exit_code_key
    fi
    echo "$curl_output_key" >> "iLo/$1"
    echo "Data downloaded for $1"
}

# Create directories
mkdir -p extracted/ilo4
mkdir -p extracted/ilo5

while read in; do
    extract "$in"
done < list

if [ -n "$(grep -lir 'iLO 4' ./iLo/)" ]; then
    grep -lir 'iLO 4' ./iLo/ | xargs mv -t extracted/ilo4/
fi

if [ -n "$(grep -lir 'iLO 5' ./iLo/)" ]; then
    grep -lir 'iLO 5' ./iLo/ | xargs mv -t extracted/ilo5/
fi
