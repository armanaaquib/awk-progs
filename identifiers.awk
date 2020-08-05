#! /usr/bin/awk -f
$0 ~ /const|let|var/{
  field = 1;
  while(field <= NF){
    if($field ~ /const|let|var/){
      print $(field + 1);
    }
    field += 1;
  }
}

$0 ~ /^function/{
  print $2
}

