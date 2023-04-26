#!/bin/bash
KEY=$1
CITY=$2

# KEY=dafe0381eb267c80de47385cecc60a8a

# echo search $CITY - $KEY

data=$(curl -s "https://api.openweathermap.org/geo/1.0/direct?q=$CITY&appid=$KEY")

# echo $data | jq '.[0]'

lat=$(echo $data | jq '.[0].lat')
lon=$(echo $data | jq '.[0].lon')
city=$(echo $data | jq -r '.[0].name')
country=$(echo $data | jq -r '.[0].country')

# echo "$city ($country) - $lat $lon"

data=$(curl -s "https://api.openweathermap.org/data/2.5/weather?units=metric&lat=$lat&lon=$lon&appid=$KEY")

# echo $data | jq '.'

wid=$(echo $data | jq '.weather[0].id')
wmain=$(echo $data | jq -r '.weather[0].main')
wtemp=$(echo $data | jq '.main.temp')
whum=$(echo $data | jq '.main.humidity')
wwind=$(echo $data | jq '.wind.speed')

icon="!"

if (( $wid >= 200 && $wid < 203 )); then
    # echo Rainy thunderstorm
    icon=􀇟
fi
if (( $wid >= 203 && $wid < 300 )); then
    # echo Thunderstorm
    icon=􀇓
fi
if (( $wid >= 300 && $wid < 400 )); then
    # echo Drizzle
    icon=􀇅
fi
if (( $wid >= 500 && $wid < 600 )); then
    if (( $wid == 500 )); then
        # echo light rain
        icon=􀇅
    fi
    if (( $wid == 520 || $wid == 531 )); then
        # echo light rain
        icon=􀇗
    fi
    if (( $wid == 501 || $wid == 521 )); then
        # echo moderate rain
        icon=􀇇
    fi
    if (( $wid == 502 || $wid == 503 || $wid == 504 || $wid == 522 )); then
        # echo heavy rain
        icon=􀇉
    fi
    if (( $wid == 511 )); then
        # echo freezing rain
        icon=􀇑
    fi
fi
if (( $wid >= 600 && $wid < 700 )); then
    # echo Snow
    icon=􀇥
fi
if (( $wid >= 700 && $wid < 800 )); then
    # echo Atmosphere
    icon=􀇋
fi
if (( $wid >= 801 && $wid < 803 )); then
    # echo Cloud
    icon=􀇕
fi
if (( $wid >= 803 && $wid < 804 )); then
    # echo Cloud
    icon=􀇃
fi
if (( $wid >= 800 )); then
    # echo Clear
    icon=􀆮
fi

echo "$icon $wmain $(printf %.0f $wtemp)°C ($city - $country)"
