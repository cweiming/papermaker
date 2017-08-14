#!/bin/bash
  
################################################################################
# @Author Wei-Ming Chen, PhD                                                   #
# @trimtag.sh                                                                  #
# @version: v0.4                                                               #
################################################################################

# example: sh trimtag.sh pmcid.txt /home/user/pmcid

plist="$1"
savepath="$2"

$(echo "<h1>$savepath Cancer List</h1>" > $savepath/index.html)
for f in $(cat "$plist"); do
  echo "$savepath/${f}"
  if [ -d "$savepath/${f}" ]; then 
    # copy xml to html if need: cp "$savepath/${f}/OPS/${f:3:100}.xml" "$savepath/${f}/OPS/${f:3:100}.html"
    # example: perl -pe 's/\&quot\;/\"/g' | perl -pe 's/\&amp\;/\&/g' | perl -pe 's/\&gt\;/>/g' | perl -pe 's/\&lt;/</g' | perl -pe 's/\&nbsp\;/\s/g' | \
    
	echo "${f} exist."
	
    # Part 1 -Remove HTML tags 
    $(less "$savepath/${f}/OPS/${f:3:100}.html" | \
    perl -pe 's/ \(<sup><a[^>].+?<\/sup>\)//g' | perl -pe 's/\(<sup><a[^>].+?<\/sup>\)//g' | \
    perl -pe 's/ <sup><a[^>].+?<\/sup>//g' | perl -pe 's/<sup><a[^>].+?<\/sup>//g' | perl -pe 's/<sup>–<\/sup>//g' | perl -pe 's/<sup>, <\/sup>//g' | \
    perl -pe 's/ \[<a[^>].+?<\/a>\]//g' | perl -pe 's/\[<a[^>].+?<\/a>\]//g' | \
    perl -pe 's/ \(<a[^>].+?<\/a>\)//g' | perl -pe 's/\(<a[^>].+?<\/a>\)//g' | \
    perl -pe 's/ \(.[^\)]+?<a[^>].+?<\/a>\)//g' | perl -pe 's/\(.[^\)]+?<a[^>].+?<\/a>\)//g' | \
    perl -pe 's/ <a[^>].[^\/]+?<\/a>–<a[^>].[^\/]+?<\/a>//g' | perl -pe 's/<a[^>].[^\/]+?<\/a>–<a[^>].[^\/]+?<\/a>//g' | \
    perl -pe 's/ <a[^>].[^\/]+?<\/a>\,<a[^>].[^\/]+?<\/a>//g' | perl -pe 's/<a[^>].[^\/]+?<\/a>\,<a[^>].[^\/]+?<\/a>//g' | \
    perl -pe 's/ <a[^>].+?\[.+?\]<\/a>//g' | perl -pe 's/<a[^>].+?\[.+?\]<\/a>//g' | \
    perl -pe 's/ <a[^>].+?>\d{1,10}<\/a>//g' | perl -pe 's/<a[^>].+?>\d{1.10}<\/a>//g' | \
    perl -pe 's/<span[^>]*>//g' | perl -pe 's/<\/span[^>]*>//g' | \
    perl -pe 's/<sup[^>]*>/^/g' | perl -pe 's/<\/sup[^>]*>//g'| \
    perl -pe 's/<sub[^>]*>/[/g' | perl -pe 's/<\/sub[^>]*>/]/g'| \
    perl -pe 's/<a[^>]*>//g' | perl -pe 's/<\/a[^>]*>//g' |
    perl -pe 's/\/>/>/g' | perl -pe 's/\r//g' | perl -pe 's/\n//g' > "$savepath/${f}/OPS/${f:3:100}.tmp.html")

    # part 2 - Remove HTML tags
    $(less "$savepath/${f}/OPS/${f:3:100}.tmp.html" | \
    perl -pe 's/\,{2,10}/,/g' | \
    perl -pe 's/<\// <\//g' | perl -pe 's/ {2,100}/ /g' | \
    perl -pe 's/> </></g' | \
    perl -pe 's/\,\./\./g'> "$savepath/${f}/OPS/${f:3:100}.trimmed.html")
    
    # part 3 - Remove special HTML tags
    $(less "$savepath/${f}/OPS/${f:3:100}.trimmed.html" | \
    perl -pe 's/ / /g' > "$savepath/${f}/OPS/${f:3:100}.trimmed2.html" )

	# remove temp file
    $(rm -rf "$savepath/${f}/OPS/${f:3:100}.tmp.html")

	# make a pure text file without any tag
    $(lynx --dump "$savepath/${f}/OPS/${f:3:100}.trimmed2.html" > "$savepath/${f}/OPS/${f:3:100}.txt")

	# Set a delay time to avoid the crash if need
    delay=$(($RANDOM%300))
    echo "delay time: $delay"
    sleep $delay
  fi
  $(echo "<h4><a href='http://localhost/user/$savepath/${f}/OPS/${f:3:100}.trimmed.html'>${f:3:100}.trimmed.html</a></h4>" >> $savepath/$savepath.html)
done
