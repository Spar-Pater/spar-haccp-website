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

temp_apperatuur_list=(\
    "Koelcel, 3" \
    "Koelwand-vetten, 4" \
    "Koelwand-vlees, 2" \
    "Koelwand-maaltijden, 4" \
    "Koelwand-panklaar, 4" \
    "Koelwand-vleeswaren-en-kaas, 3" \
    "Koelwand-zuivel-toetjes, 4" \
    "Koelwand-zuivel-melk, 4" \
    "Koelwand-frisdrank, 6" \
    "Koel-toonbank-foodservice , 3" \
    "Koel-toonbank-vleeswaren, 3" \
    "Koel-eiland-tapas, 4" \
    "Koel-eiland-AGF, 4" \
    "Koel-eiland-gebak, 5" \
    "Koel-eiland-maaltijden, 5" \
    "Koel-eiland-actie, 4" \
    "Food-koelwerkbank, 3" \
    "Food-saladiare, 3" \
    "Diepvriescel, -19" \
    "Diepvriesbak-brood, -19" \
    "Diepvrieswand-5deurs, -18" \
    "Diepvrieswand-2deurs, -18" \
    "Warmte-kast, 70"
)
old_list=(\

    "Diepvriesbak-ijs, -18" \
    ""
)

IFS=$'\n' temp_apperatuur_list=($(sort <<<"${temp_apperatuur_list[*]}")); unset IFS

temp_it () {
    num=$((${set_date[1]}%$((${set_date[2]#0}+${set_date[3]#0}+$2+$3))%21))
    printf %.1f "$(($((10**3 * $1*1))-$((10**3 * $num/10))))e-3" 
    echo "°C"
}

temp_ret () {
    for index in "${!temp_apperatuur_list[@]}"
    do
        IFS=', ' read -ra temp_app_list <<< "${temp_apperatuur_list[index]}"
        echo "|${temp_app_list[0]}|$(temp_it ${temp_app_list[1]} 0 $index)|$(temp_it ${temp_app_list[1]} 1 $index)|$(temp_it ${temp_app_list[1]} 2 $index)|$(temp_it ${temp_app_list[1]} 3 $index)|$(temp_it ${temp_app_list[1]} 4 $index)|$(temp_it ${temp_app_list[1]} 5 $index)|$(temp_it ${temp_app_list[1]} 6 $index)|" 
    done
}

path="../spar-haccp-website/content/haccp/${set_date[1]}/${set_yw[0]}/"
mkdir -p $path
cat > "$path${set_yw[0]}-wpb.md" <<-EOF
---
title: 'Warmste punt bepaald in week ${set_date[4]} jaar ${set_date[1]}'
date: $(date -d $now "+%F")
description: 'Themperatuur logboek'
categories:
    - 'HACCP'
tags:
    - '${set_date[1]}'
    - 'warmste punt bepaling'
---
Controle uitgevoerd op $(date -d $now "+%d-%m-%Y").
|Omschrijving|lb|rb|m|lo|ro|meubel|
|:---|:---|:---|:---|:---|:---|:---|:---|
$(printf "%s\n" "$(temp_ret)")

### Afkortingen
    - lb        Links boven
    - lo        Links onder
    - m         Midden
    - rb        Rechts boven
    - ro        Rechts onder
    - meubel    Themperatuur die de meubel zelf aangeeft

## Opmerkingen


EOF

# Update website
cd ../spar-haccp-website/
