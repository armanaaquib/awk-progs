#! /usr/bin/awk -f

BEGIN{
  FS = "";
}

($0 !~ /^\/\//) && ($0 !~ /^\ *$/) && ($0 ~ /[^{};\0]$/){
  print NR;
}
