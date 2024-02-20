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
    
checkdays=(\
	$(date -d "${set_date[6]} - 12 days" +%d-%m-%Y) \
	$(date -d "${set_date[6]} - 11 days" +%d-%m-%Y) \
	$(date -d "${set_date[6]} - 10 days" +%d-%m-%Y) \
	$(date -d "${set_date[6]} - 7 days" +%d-%m-%Y) \
	$(date -d "${set_date[6]} - 6 days" +%d-%m-%Y) \
	$(date -d "${set_date[6]} - 5 days" +%d-%m-%Y) \
	$(date -d "${set_date[6]} - 4 days" +%d-%m-%Y) \
	$(date -d "${set_date[6]} - 2 days" +%d-%m-%Y) \
	$(date -d "${set_date[6]} + 3 days" +%d-%m-%Y) \
	$(date -d "${set_date[6]} + 4 days" +%d-%m-%Y))

if [ $(date +%s) -le $(date -d ${days[6]} +%s) ];
then
	now=$(date +%Y%m%d)
else
	now=${days[6]}
fi

brood=(\
	"" \
	"croissant" \
	"kaascroissant" \
	"roomboter-croissant" \
	"ham-kaas-croissant" \
	"croissant-framboos" \
	"choco-brood" \
	"beemster-broodje" \
	"frikandellenbroodje" \
	"saucijzenbroodje" \
	"curryworst" \
	"appelflap" \
	"appeltaart" \
	"pecannotenkoek" \
	"koffiebroodje" \
	"kaiserbroodje" \
	"pistolet" \
	"ciabatta" \
	"tijgerbol" \
	"baguelino" \
	"maisbroodje" \
	"stokbrood" \
	"boerenbol" \
	"sparretjes"
)
afbak=(\
	"" \
	"croissant" \
	"croissant" \
	"croissant" \
	"croissant" \
	"croissant" \
	"croissant" \
	"saucijzenroyaal" \
	"saucijzenroyaal" \
	"saucijzenroyaal" \
	"saucijzenroyaal" \
	"appelflap" \
	"appeltaart" \
	"gevuldekoek" \
	"gevuldekoek" \
	"gevuldekoek" \
	"petit pain" \
	"petit pain" \
	"petit pain" \
	"petit pain" \
	"petit pain" \
	"petit pain" \
	"petit pain" \
	"petit pain"
)
temp_it () {
	num=$((${set_date[1]}%$((${set_date[2]#0}+${set_date[3]#0}+$2+$3))%21))
	printf %.1f "$(($((10**3 * $1*1))-$((10**3 * $num/10))))e-3" 
	echo "°C"
}

ret () {
	if [ -z ${brood[${set_date[4]#0}]} ]
	then
		exit
	else
		for testtimes in 1 2 3 4 5 6 7 8 9 10
		do
			echo "| $testtimes | ${checkdays[$testtimes-1]} | &check; | $(temp_it 87 12 $testtimes) |"
		done
	fi
}

if [ -z ${brood[${set_date[4]#0}]} ]
then
	exit
else
	path="../spar-haccp-website/content/haccp/${set_date[1]#0}/${set_yw[0]#0}/"
	mkdir -p $path
	cat > "$path${set_yw[0]#0}-kerntemperatuur.md" <<-EOF
---
title: 'Validatie kern temperatuur van ${brood[${set_date[4]}]} week ${set_date[4]} jaar ${set_date[1]}'
date: $(date -d "$now" "+%F")
author: Spar Pater
description: 'Kerntemperatuur logboek'
categories:
    - 'HACCP'
tags:
    - '${set_date[1]}'
    - 'Kern-temperatuur'
---

## ${brood[${set_date[4]#0}]}

Programma: ${afbak[${set_date[4]#0}]}
Minimale temperatuur: 75°C

| Baksessie | Datum | Visueel beoordeling | Temperatuur |
|:---|:---|:---|:---|
$(printf "%s\n" "$(ret)")

## Opmerkingen


EOF

# Update website
fi
