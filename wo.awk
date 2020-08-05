BEGIN{}

{
  s = tolower($0)
}

tolower($0) ~ /smile|new and different|good to have/{
  print "W|"$0
  next
}

s ~ /not good|not nice|we have to|pay|difficult|to change|take care|hard|because|unable to do|sleept/{
  print "O|"$0
  next
}

s ~ /slow|not|small|bye|changed|tired|hurting|rent|too far|No|practice|left|leave|congested|whole day in pg/{
  print "O|"$0
  next
}

s~ /long distance|leaving|weight|low|lacking|lack|injuries|less time|sleepy|bore|feared|foosball table/{
  print "O|"$0
  next
}

s ~/changing weather|go home|boring|vibrant|too cool|remember|no\ |missing|motaaa wala|1st week|lift/{
  print "O|"$0
  next
}

{
  print "W|"$0
  next
}

END{}
