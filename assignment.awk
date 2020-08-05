# print only the field score

#{
#  match($0,/([^,]*,){9}[^,]*$/)
#  print substr($0,RSTART,RLENGTH)
#}

# print only first 10 lines

#(NR > 10 && NR <= 20){
#  print $0
#}

{
  a[NR] = $0
}

END{
  for(i=NR-9;i<=NR;i++){
    print a[i]
  }
}
