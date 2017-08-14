#!/bin/bash
  
################################################################################
# @Author Wei-Ming Chen, PhD                                                   #
# @papermaker.sh                                                               #
# @version: v0.4                                                               #
################################################################################

# example: sh papermaker.sh pmcid.txt /home/user/pmcid

Link="http://www.ncbi.nlm.nih.gov/pmc/articles/"
plist="$1"
savepath="$2"

for f in $(cat "$plist"); do
  echo "$savepath/${f}"
  if [ -f "$savepath/${f}.epub" ]; then 
    echo "${f}.epub exist."
  else
    echo "${f}.epub does not exist."
    wget --user-agent="Mozilla/5.0 (Windows NT 5.2; rv:2.0.1) Gecko/20100101 Firefox/4.0.1" \
         -l1 --no-parent -A.epub ${Link}${f}/epub/ -O "$savepath/${f}.epub"
    mv "${f}.epub" "$savepath"
    unzip -o "$savepath/${f}.epub" -d "$savepath/${f}"
    cp "$savepath/${f}/OPS/${f:3:100}.xml" "$savepath/${f}/OPS/${f:3:100}.html"
    
    delay=$(($RANDOM%300))
    echo "delay time: $delay"
    sleep $delay
  fi
done
