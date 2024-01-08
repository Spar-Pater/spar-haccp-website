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

path="../spar-haccp-website/content/haccp/${set_date[1]}/${set_yw[0]}/"
mkdir -p $path
cat > "$path${set_yw[0]}-kalibratie.md" <<-EOF
---
title: 'Kalibratie thermometer op $(date -d "$now" "+%d-%m-%Y")'
date: $(date -d "$now" "+%F")
description: 'Kalibratie logboek'
categories:
    - 'HACCP'
tags:
    - '${set_date[1]}'
    - 'kalibratie'
---
Controle uitgevoerd op $(date -d "$now" "+%d-%m-%Y").

Thermometer 'Testo 10630977076'
|---|---|
| 0°C meting | 0.1°C |
| 100°C meting | 99.9°C |

Thermometer 'Dostmann E1034029800'
|---|---|
| 0°C meting | 0.0°C |
| 100°C meting | 100.0°C |

## Opmerkingen


EOF
