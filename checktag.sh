#!/bin/bash
  
################################################################################
# @Author Wei-Ming Chen, PhD                                                   #
# @trimtag.sh                                                                  #
# @version: v0.4                                                               #
################################################################################

# example: sh checktag.sh pmcid.txt /home/user/pmcid

Link="http://www.ncbi.nlm.nih.gov/pmc/articles/"
plist="$1"
savepath="$2"

for f in $(cat "$plist"); do
  echo "$savepath/${f}"
  if [ -d "$savepath/${f}" ]; then 
    echo "${f} exist."
    
    perl -pe 's/\&quot\;/\"/g' | perl -pe 's/\&amp\;/\&/g' | perl -pe 's/\&gt\;/>/g' | perl -pe 's/\&lt;/</g' | perl -pe 's/\&nbsp\;/\s/g' | \
    
    less "$savepath/${f}/OPS/${f:3:100}.trimmed.html" | grep "\#039"
    
  fi
done
