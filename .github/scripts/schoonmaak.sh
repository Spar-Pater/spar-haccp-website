#! /bin/bash
# 
#
# This is going to be my HACCP auto update script for HUGO
#
#

if [[ $# > 0 ]]; then
    days_ago=$(($1 * 7 - 1))
else
    days_ago=-1
fi

set_date=(\
    $(date -d "$days_ago days ago last Sunday" +%d-%m-%Y) \
    $(date -d "$days_ago days ago last Sunday" +%Y) \
    $(date -d "$days_ago days ago last Sunday" +%m) \
    $(date -d "$days_ago days ago last Sunday" +%d) \
    $(date -d "$days_ago days ago last Sunday" +%V) \
    $(date -d "$days_ago days ago last Sunday" +%Y%V) \
    $(date -d "$days_ago days ago last Sunday" +%Y%m%d))

days=(\
    $(date -d "${set_date[6]} + 0 days" +%Y%m%d) \
    $(date -d "${set_date[6]} + 1 days" +%Y%m%d) \
    $(date -d "${set_date[6]} + 2 days" +%Y%m%d) \
    $(date -d "${set_date[6]} + 3 days" +%Y%m%d) \
    $(date -d "${set_date[6]} + 4 days" +%Y%m%d) \
    $(date -d "${set_date[6]} + 5 days" +%Y%m%d) \
    $(date -d "${set_date[6]} + 6 days" +%Y%m%d))

set_yw=(\
    $(date -d "${days[6]}" +%Y%V))
    
if [ $(date +%s) -le $(date -d ${days[6]} +%s) ];
then
    now=$(date +%Y%m%d)
else
    now=${days[6]}
fi

initials () {
    names=("BK" "BvD" "BK" "MvG" "MvG" "GR" "EH")
    if [ $1 -eq 1 ];
    then
        names=("BK" "BvD" "BK" "MvG" "MvG" "GR" "EH")
    elif [ $1 -eq 2 ];
    then
        names=("YP" "YP" "YP" "YP" "YP" "YP" "EH")
    elif [ $1 -eq 4 ];
    then
        names=("BK" "BvD" "BK" "MvG" "MvG" "GR" "EH")
    elif [ $1 -eq 5 ];
    then
        names=("BK" "BvD" "BK" "MvG" "MvG" "GR" "EH")
    elif [ $1 -eq 6 ];
    then
        names=("BK" "BvD" "BK" "MvG" "MvG" "GR" "EH")
    elif [ $1 -eq 7 ];
    then
        names=("BK" "BvD" "BK" "MvG" "MvG" "GR" "EH")
    fi
    echo ${names[$2]}
}

retn () {
    for n in {0..6};
    do
        if [ $(date -d ${days[n]} +%s) -le $(date +%s) ];
        then
            echo "| $(date -d ${days[n]} +%A) | $(initials $1 $n) | | | |"
        fi
    done
}

rets () {
    for i in {0..6};
    do
        if [ $(date -d ${days[$i]} +%s) -le $(date +%s) ];
        then
            echo "| $(date -d ${days[$i]} +%A) | BK | | | |"
        fi
    done
}

path="../spar-haccp-website/content/haccp/${set_date[1]}/${set_yw[0]}/"
mkdir -p $path
cat > "$path${set_yw[0]}-aftekenlijst-schoonmaak.md" <<-EOF
---
title: 'Aftekenlijst schoonmaken in week ${set_date[4]} jaar ${set_date[1]}'
date: $(date -d "$now" "+%F")
description: 'Ontvangst logboek'
categories:
    - 'HACCP'
tags:
    - '${set_date[1]}'
    - 'schoonmaaklijst'
---
De schoonmaak taken kun je vinden op:  
[Schoonmaakplan]( {{< ref "/haccp/algemeen/schoonmaakplan" >}})

## Algemeen 
| Dag | Dagelijks | Weekelijks | Periodiek | Opmerking |
|:---|:---|:---|:---|:---|
$(printf "%s\n" "$(retn 0)")

## AGF
| Dag | Dagelijks | Weekelijks | Periodiek | Opmerking |
|:---|:---|:---|:---|:---|
$(printf "%s\n" "$(retn 1)")

## Bakkerij
| Dag | Dagelijks | Weekelijks | Periodiek | Opmerking |
|:---|:---|:---|:---|:---|
$(printf "%s\n" "$(retn 2)")

## Kantine en garderobe
| Dag | Dagelijks | Weekelijks | Periodiek | Opmerking |
|:---|:---|:---|:---|:---|
$(printf "%s\n" "$(retn 3)")

## Toilet
| Dag | Dagelijks | Weekelijks | Periodiek | Opmerking |
|:---|:---|:---|:---|:---|
$(printf "%s\n" "$(retn 4)")

## Sappers
| Dag | 10:00 | 13:00 | 16:00 | Einde dag | Bijzonderheden |
|:---|:---|:---|:---|:---|:---|
$(printf "%s\n" "$(rets)")

## Opmerkingen


EOF

# Update website
cd ../spar-haccp-website/
