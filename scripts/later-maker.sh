#!/bin/bash

# Variables
download_epoch=$(date +%s)
url="https://mask-api.icloud.com/egress-ip-ranges.csv"
lookup_index="private_relay"

# Does the lookup directory exist?
lookups_dir="$(pwd)/lookups"
if test -d "$lookups_dir";
  then
  echo "Lookups directory exists"
else
  mkdir -p $lookups_dir
fi

# Grab the file
curl $url > $lookups_dir/$download_epoch-egress-ip-ranges.csv

# Check download worked
file=$lookups_dir/$download_epoch-egress-ip-ranges.csv
if test -f "$file";
  then
  echo "Successfully downloaded file"
else
  echo "Something went wrong with the download"
fi

# Hash it
sha256sum $lookups_dir/$download_epoch-egress-ip=ranges.csv > $lookups_dir/$download_epoch-egress-ip=ranges.hash

# Check hashing worked
file_hash=$lookups_dir/$download_epoch-egress-ip-ranges.hash
if test -f "$file_hash";
  then
  echo "Successfully hashed the file"
else
  echo "Something went wrong with the hash function"
fi

# Trim the hash
cut -f1 -d" " $lookups_dir/$download_epoch-egress-ip-ranges.hash > $lookups_dir/$download_epoch-egress-ip-ranges.sha256
rm -f $lookups_dir/$download_epoch-egress-ip-ranges.hash

# Populate comparison variables
most_recent=$(ls -t $lookups_dir/ | grep "sha" | head -1)
previous=$(ls -t $lookups_dir/ | grep "sha" | tail -1)

echo

# Do the comparison
if cmp -b -s $lookups_dir/$most_recent $lookups_dir/$previous;
then
  # Files match - do nothing
else 
  # Files don't match, do something

