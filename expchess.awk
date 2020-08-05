BEGIN{
  chessBoard[1,1] = "BR"
  chessBoard[1,2] = "BN"
  chessBoard[1,3] = "BB"
  chessBoard[1,4] = "BQ"
  chessBoard[1,5] = "BK"
  chessBoard[1,6] = "BB"
  chessBoard[1,7] = "BN"
  chessBoard[1,8] = "BR"

  for(coloumn=1; coloumn <= 8; coloumn++)
    chessBoard[2,coloumn] = "BP"

  for(row=3; row <= 6; row++)
    for(coloumn = 1; coloumn <= 8; coloumn++)
      chessBoard[row,coloumn] = "  "
  
  for(coloumn=1;coloumn<=8;coloumn++)
    chessBoard[7,coloumn] = "WP"

  chessBoard[8,1] = "WR"
  chessBoard[8,2] = "WN"
  chessBoard[8,3] = "WB"
  chessBoard[8,4] = "WQ"
  chessBoard[8,5] = "WK"
  chessBoard[8,6] = "WB"
  chessBoard[8,7] = "WN"
  chessBoard[8,8] = "WR"

  whiteKingRow = 8
  whiteKingColoumn = 5
  blackKingRow = 1
  blackKingColoumn = 5
  
  turn = "White"

  print ""
  print "Welcome to Awk Chess [under development]"
  display_manual()

  display_board()
  ask_input()
}

{
  split($1,curPos,",")
}

( is_wrong_person() ){
  print "Can't move opponent pieces."
  ask_input()
  next
}

chessBoard[curPos[1],curPos[2]] ~ /[BW]P/{
  move_pawn()
}

chessBoard[curPos[1],curPos[2]] ~ /[BW]N/{
  move_knight()
}

chessBoard[curPos[1],curPos[2]] ~ /[BW]R/{
  move_rook($3)
}

chessBoard[curPos[1],curPos[2]] ~ /[BW]B/{
  move_bishop($3)
}

chessBoard[curPos[1],curPos[2]] ~ /[BW]Q/{
  move_queen()
}

chessBoard[curPos[1],curPos[2]] ~ /[BW]K/{
  move_king()
}

{
  ask_input()
}


END{
 
}

function display_board(){
  print ""
  print ""
  print "    1    2    3    4    5    6    7    8 "
  for(row=1; row <= 8; row++){
    print " ----------------------------------------"
    printf row"|"
    for(coloumn=1; coloumn <= 8; coloumn++){
        printf " "chessBoard[row,coloumn]" |"
    }
    printf row
    print ""
    }
    print " -----------------------------------------"
    print "    1    2    3    4    5    6    7    8 "
    print ""

}

function ask_input(){
  printf "Turn "turn":Location(x,y) option ....: "
}

function is_wrong_person(){
  return ((turn == "White")&&(chessBoard[curPos[1],curPos[2]] ~ /^B.$/)) || ((turn == "Black")&&(chessBoard[curPos[1],curPos[2]] ~ /^W.$/))
}

function change_input(){
    if(turn == "Black")
      turn = "White"
    else
      turn = "Black"
}

function move_pawn(){
  destPos[2] = curPos[2]
  if(substr(chessBoard[curPos[1],curPos[2]],1,1) == "B"){
    if($2 == "ff" && curPos[1] == "2"){
      destPos[1] = curPos[1] + 2
    }else{
      destPos[1] = curPos[1] + 1

    }
    if($2 == "fl"){
      destPos[2] = curPos[2] + 1
    }
    if($2 == "fr"){
      destPos[2] = curPos[2] - 1
    }
  }
  if(substr(chessBoard[curPos[1],curPos[2]],1,1) == "W"){
    if($2 == "ff" && curPos[1] == "7"){
      destPos[1] = curPos[1] - 2
    }else{
      destPos[1] = curPos[1] - 1
    }

    if($2 == "fl"){
      destPos[2] = curPos[2] - 1
    }
    if($2 == "fr"){
      destPos[2] = curPos[2] + 1
    }
  }

  if( isCommonFailCasePass() && ((chessBoard[destPos[1],destPos[2]] != "  " && ($2 == "fr"|| $2 == "fl")) || (chessBoard[destPos[1],destPos[2]] == "  " && ($2 == "f" || $2 =="ff"))) ){
chessBoard[destPos[1],destPos[2]] = chessBoard[curPos[1],curPos[2]]
    chessBoard[curPos[1],curPos[2]] = "  "
    change_king_position(destPos[1],destPos[2])
    if(is_my_king_check()){
      print "Mr./Mrs. your king is or will be in check. Please save your King. (** Unless you will loss the match **)"
      chessBoard[curPos[1],curPos[2]] = chessBoard[destPos[1],destPos[2]]
      chessBoard[destPos[1],destPos[2]] = "  "
      change_king_position(curPos[1],curPos[2])
    }else{
      chessBoard[curPos[1],curPos[2]] = ".."
      display_board()
      chessBoard[curPos[1],curPos[2]] = "  "
      change_input()
      tell_opponet_king_check()
    }
  }else{
    print "Can't go."
  }

}

function move_knight(){
  colour = chessBoard[curPos[1],curPos[2]]
  if((colour ~ /WN/ && $2 ~ /^fr$/) || (colour ~ /BN/ && $2 ~ /^bl$/)){
    destPos[2] = curPos[2] + 1
    destPos[1] = curPos[1] - 2
  }
  if((colour ~ /WN/ && $2 ~ /^fl$/) || (colour ~ /BN/ && $2 ~ /^br$/)){
    destPos[2] = curPos[2] - 1
    destPos[1] = curPos[1] - 2
  }
  if((colour ~ /WN/ && $2 ~ /^br$/) || (colour ~ /BN/ && $2 ~ /^fl$/)){
    destPos[2] = curPos[2] + 1
    destPos[1] = curPos[1] + 2
  }
  if((colour ~ /WN/ && $2 ~ /^bl$/) || (colour ~ /BN/ && $2 ~ /^fr$/)){
    destPos[2] = curPos[2] - 1
    destPos[1] = curPos[1] + 2
  }
  if((colour ~ /WN/ && $2 ~ /^rf$/) || (colour ~ /BN/ && $2 ~ /^lb$/)){
    destPos[1] = curPos[1] - 1
    destPos[2] = curPos[2] + 2
  }
  if((colour ~ /WN/ && $2 ~ /^rb$/) || (colour ~ /BN/ && $2 ~ /^lf$/)){
    destPos[1] = curPos[1] + 1
    destPos[2] = curPos[2] + 2
  }
  if((colour ~ /WN/ && $2 ~ /^lf$/) || (colour ~ /BN/ && $2 ~ /^rb$/)){
    destPos[1] = curPos[1] - 1
    destPos[2] = curPos[2] - 2
  }
  if((colour ~ /WN/ && $2 ~ /^lb$/) || (colour ~ /BN/ && $2 ~ /^rf$/)){
    destPos[1] = curPos[1] + 1
    destPos[2] = curPos[2] - 2
  }

  if( isCommonFailCasePass() && ( $2 ~ /^[fb][rl]$|^[rl][fb]$/ ) ){
chessBoard[destPos[1],destPos[2]] = chessBoard[curPos[1],curPos[2]]
    chessBoard[curPos[1],curPos[2]] = "  "
    change_king_position(destPos[1],destPos[2])
    if(is_my_king_check()){
      print "Mr./Mrs. your king is or will be in check. Please save your King. (** Unless you will loss the match **)"
      chessBoard[curPos[1],curPos[2]] = chessBoard[destPos[1],destPos[2]]
      chessBoard[destPos[1],destPos[2]] = "  "
      change_king_position(curPos[1],curPos[2])
    }else{
      chessBoard[curPos[1],curPos[2]] = ".."
      display_board()
      chessBoard[curPos[1],curPos[2]] = "  "
      change_input()
      tell_opponet_king_check()
    }
  }else{
    print "Can't go."
  }

}

function move_rook(noOfSteps){
  emptyIndicator = 1
  colour = chessBoard[curPos[1],curPos[2]]
  if((colour ~ /W[KRQ]/ && $2 ~ /^f$/) || (colour ~ /B[KRQ]/)&&($2 ~ /^b$/)){
    for(row = curPos[1]-1; row > curPos[1] - noOfSteps; row--){
      if(chessBoard[row,curPos[2]] != "  "){
        emptyIndicator = 0
      }
    }
    destPos[1] = curPos[1] - noOfSteps
    destPos[2] = curPos[2]
  }
  if((colour ~ /W[KRQ]/ && $2 ~ /^b$/) || (colour ~ /B[KRQ]/ && $2 ~ /^f$/)){
    for(row = curPos[1] + 1; row < curPos[1] + noOfSteps; row++){
      if(chessBoard[row,curPos[2]] != "  "){
        emptyIndicator = 0
      }
    }
    destPos[1] = curPos[1] + noOfSteps
    destPos[2] = curPos[2]
  }
  if((colour ~ /W[KRQ]/ && $2 ~ /^l$/) || (colour ~ /B[KRQ]/ && $2 ~ /^r$/)){
    for(coloumn = curPos[2] - 1; coloumn > curPos[2] - noOfSteps; coloumn--){
      if(chessBoard[curPos[1],coloumn] != "  "){
        emptyIndicator = 0
      }
    }
    destPos[2] = curPos[2] - noOfSteps
    destPos[1] = curPos[1]
  }
  if((colour ~ /W[KRQ]/ && $2 ~ /^r$/) || (colour ~ /B[KRQ]/ && $2 ~ /^l$/)){
    for(coloumn = curPos[2] + 1; coloumn < curPos[2] + noOfSteps; coloumn++){
      if(chessBoard[curPos[1],coloumn] != "  "){
        emptyIndicator = 0
      }
    }
    destPos[2] = curPos[2] + noOfSteps
    destPos[1] = curPos[1]
  }
  
  if( isCommonFailCasePass() && emptyIndicator && ($2 ~ /^[fbrl]$/)){
chessBoard[destPos[1],destPos[2]] = chessBoard[curPos[1],curPos[2]]
    chessBoard[curPos[1],curPos[2]] = "  "
    change_king_position(destPos[1],destPos[2])
    if(is_my_king_check()){
      print "Mr./Mrs. your king is or will be in check. Please save your King. (** Unless you will loss the match **)"
      chessBoard[curPos[1],curPos[2]] = chessBoard[destPos[1],destPos[2]]
      chessBoard[destPos[1],destPos[2]] = "  "
      change_king_position(curPos[1],curPos[2])
    }else{
      chessBoard[curPos[1],curPos[2]] = ".."
      display_board()
      chessBoard[curPos[1],curPos[2]] = "  "
      change_input()
      tell_opponet_king_check()
    }
  }else{
    print "Can't go."
  }

}

function move_bishop(noOfSteps){
  emptyIndicator = 1
  colour = chessBoard[curPos[1],curPos[2]]

  if((colour ~ /^W[KQB]$/ && $2 ~ /^fr$/) || (colour ~ /^B[KQB]/ && $2 ~ /^bl$/)){
    destPos[2] = curPos[2] + noOfSteps
    destPos[1] = curPos[1] - noOfSteps
    row = curPos[1] - 1
    coloumn = curPos[2] + 1
    while(row > curPos[1] - noOfSteps && coloumn < curPos[2]+noOfSteps){
      if(chessBoard[row,coloumn] != "  "){
        emptyIndicator = 0
        break
      }
      row--
      coloumn++
    }
  }
  if((colour ~ /^W[KQB]$/ && $2 ~ /^fl$/) || (colour ~ /^B[KQB]/ && $2 ~ /^br$/)){
    destPos[1] = curPos[1] - noOfSteps
    destPos[2] = curPos[2] - noOfSteps
    row = curPos[1] - 1
    coloumn = curPos[2] - 1
    while(row > curPos[1] - noOfSteps && coloumn < curPos[2] - noOfSteps){
      if(chessBoard[row,coloumn] != "  "){
        emptyIndicator = 0
        break
      }
      row--
      coloumn--
    }
  }
  if((colour ~ /^W[KQB]$/ && $2 ~ /^br$/) || (colour ~ /^B[KQB]/ && $2 ~ /^fl$/)){
    destPos[2] = curPos[2] + noOfSteps
    destPos[1] = curPos[1] + noOfSteps
    row = curPos[1] + 1
    coloumn = curPos[2] + 1
    while(row > curPos[1] + noOfSteps && coloumn < curPos[2] + noOfSteps){
      if(chessBoard[row,coloumn] != "  "){
        emptyIndicator = 0
        break
      }
      row++
      coloumn++
    }
  }
  if((colour ~ /^W[KQB]$/ && $2 ~ /^bl$/) || (colour ~ /^B[KQB]/ && $2 ~ /^fr$/)){
    destPos[1] = curPos[1] + noOfSteps
    destPos[2] = curPos[2] - noOfSteps
    row = curPos[1] + 1
    coloumn = curPos[2] - 1
    while(row > curPos[1] + noOfSteps && coloumn < curPos[2]-noOfSteps){
      if(chessBoard[row,coloumn] != "  "){
        emptyIndicator = 0
        break
      }
      row++
      coloumn--
    }
  }
  
  if( isCommonFailCasePass() && emptyIndicator && ($2 ~ /^[fb][rl]$/)){
    chessBoard[destPos[1],destPos[2]] = chessBoard[curPos[1],curPos[2]]
    chessBoard[curPos[1],curPos[2]] = "  "
    change_king_position(destPos[1],destPos[2])
    if(is_my_king_check()){
      print "Mr./Mrs. your king is or will be in check. Please save your King. (** Unless you will loss the match **)"
      chessBoard[curPos[1],curPos[2]] = chessBoard[destPos[1],destPos[2]]
      chessBoard[destPos[1],destPos[2]] = "  "
      change_king_position(curPos[1],curPos[2])
    }else{
    	chessBoard[curPos[1],curPos[2]] = ".."
    	display_board()
    	chessBoard[curPos[1],curPos[2]] = "  "
    	change_input()
    	tell_opponet_king_check()
    }
  }else{
    print "Can't go."
  }
}

function move_queen(){
  if($2 ~ /^[fbrl]$/){
    move_rook($3)
  }
  if($2 ~ /^[fb][lr]$/){
    move_bishop($3)
  }
}

function move_king(){
  if($2 ~ /^[fbrl]$/){
    move_rook(1)
  }
  if($2 ~ /^[fb][lr]$/){
    move_bishop(1)
  }

}
function isCommonFailCasePass(){
  return (destPos[1] >= 1) && (destPos[1] <= 8) && (destPos[2] >= 1) && (destPos[2] <= 8) && ( substr(chessBoard[curPos[1],curPos[2]],1,1) != substr(chessBoard[destPos[1],destPos[2]],1,1) )
}

function is_my_king_check(){
 return (turn == "White" && is_check(whiteKingRow,whiteKingColoumn,"W")) || (turn == "Black" && is_check(blackKingRow,blackKingColoumn,"B"))
}
function tell_opponet_king_check(){
  if(turn == "White" && is_check(whiteKingRow,whiteKingColoumn,"W")){
      print turn" King is check."
    }
  if(turn == "Black" && is_check(blackKingRow,blackKingColoumn,"B")){
      print turn" King is check."
    }
}

function change_king_position(row,coloumn){
  if(chessBoard[row,coloumn] ~ /^WK$/){
    whiteKingRow = row
    whiteKingColoumn = coloumn
  }
  if(chessBoard[row,coloumn] ~ /^BK$/){
    blackKingRow = row
    blackKingColoumn = coloumn
  }
}
function is_check(kingRow,kingColoumn,colour){
  return (check_parallelly(colour,kingRow,kingColoumn) || check_diagonally(colour,kingRow,kingColoumn) || check_knights_way(colour,kingRow,kingColoumn))
}

function check_parallelly(colour,kingRow,kingColoumn){
  #WF BB
  row = kingRow - 1
  while(row > 0){
    if( is_opposite_colour(colour,row,kingColoumn) && (chessBoard[row,kingColoumn] ~ /[WB][RQ]/ || (chessBoard[row,kingColoumn] ~ /[WB]K/ && row == kingRow - 1)) ){
      return 1
    }
    if(chessBoard[row, kingColoumn] != "  "){
      break
    }
    row--
  }
  
  #WB BF
  row = kingRow + 1
  while(row < 9){
    if( is_opposite_colour(colour,row,kingColoumn) && (chessBoard[row,kingColoumn] ~ /[WB][RQ]/ || (chessBoard[row,kingColoumn] ~ /[WB]K/ && row == kingRow + 1)) ){
      return 1
    }
    if(chessBoard[row, kingColoumn] != "  "){
      break
    }
    row++
  }

  #WL BR
  coloumn = kingColoumn - 1
  while(coloumn > 0){
    if( is_opposite_colour(colour,kingRow,coloumn) && (chessBoard[kingRow,coloumn] ~ /[WB][RQ]/ || (chessBoard[kingRow,coloumn] ~ /[WB]K/ && coloumn == coloumn - 1)) ){
      return 1
    }
    if(chessBoard[kingRow, coloumn] != "  "){
      break
    }
    coloumn--
  }

  #WR BL  
  coloumn = kingColoumn + 1
  while(coloumn < 9){
    if( is_opposite_colour(colour,kingRow,coloumn) && (chessBoard[kingRow,coloumn] ~ /[WB][RQ]/ || (chessBoard[kingRow,coloumn] ~ /[WB]K/ && coloumn == coloumn + 1)) ){
      return 1
    }
    if(chessBoard[kingRow, coloumn] != "  "){
      break
    }
    coloumn++
  }
  return 0
}

function check_diagonally(colour,kingRow,kingColoumn){
  #WFL #BBR
  row = kingRow - 1
  coloumn = kingColoumn - 1
  while(row > 0 && coloumn > 0){
    if(is_opposite_colour(colour,row,coloumn) && (chessBoard[row,coloumn] ~ /[WB][BQ]/ || (row == kingRow - 1 && ( chessBoard[row,coloumn] ~ /[WB][K]|BP/) ) )){
     return 1
   }
   if(chessBoard[row, coloumn] != "  "){
     break
   }
   row --
   coloumn --
 }

  #WFR #BBL
  row = kingRow - 1
  coloumn = kingColoumn + 1
  while(row > 0 && coloumn < 9){
    if(is_opposite_colour(colour,row,coloumn) && (chessBoard[row,coloumn] ~ /[WB][BQ]/ || (row == kingRow - 1 && ( chessBoard[row,coloumn] ~ /[WB][K]|BP/) ) )){
     return 1
   }
   if(chessBoard[row, coloumn] != "  "){
     break
   }
   row --
   coloumn ++
 }

  #WBL BFR
  row = kingRow + 1
  coloumn = kingColoumn - 1
  while(row < 9 && coloumn > 0){
    if(is_opposite_colour(colour,row,coloumn) && (chessBoard[row,coloumn] ~ /[WB][BQ]/ || (row == kingRow + 1 && ( chessBoard[row,coloumn] ~ /[WB][K]|WP/) ) )){
     return 1
   }
   if(chessBoard[row, coloumn] != "  "){
     break
   }
   row ++
   coloumn --
  }

  #WBR BFL
  row = kingRow + 1
  coloumn = kingColoumn + 1
  while(row < 9 && coloumn < 9){
    if(is_opposite_colour(colour,row,coloumn) && (chessBoard[row,coloumn] ~ /[WB][BQ]/ || (row == kingRow + 1 && ( chessBoard[row,coloumn] ~ /[WB][K]|WP/) ) )){
     return 1
   }
   if(chessBoard[row, coloumn] != "  "){
     break
   }
   row ++
   coloumn ++
 }
  return 0
}

function check_knights_way(colour,kingRow,kingColoumn){
  #WFL BBR
	row = kingRow - 2
	coloumn = kingColoumn - 1
	if(is_opposite_colour(colour,row,coloumn) && chessBoard[row,coloumn] ~ /[WB]N/){
	   return 1
	 }
	#WFR BBR
	row = kingRow - 2
	coloumn = kingColoumn + 1
	if(is_opposite_colour(colour,row,coloumn) && chessBoard[row,coloumn] ~ /[WB]N/){
	   return 1
	 }
	#WLF BRB
	row = kingRow - 1
	coloumn = kingColoumn - 2
	if(is_opposite_colour(colour,row,coloumn) && chessBoard[row,coloumn] ~ /[WB]N/){
	   return 1
	 }
	#WRF BLB
	row = kingRow - 1
	coloumn = kingColoumn + 2
	if(is_opposite_colour(colour,row,coloumn) && chessBoard[row,coloumn] ~ /[WB]N/){
	   return 1
	 }
  #WLB BRF
	row = kingRow + 1
	coloumn = kingColoumn - 2
	if(is_opposite_colour(colour,row,coloumn) && chessBoard[row,coloumn] ~ /[WB]N/){
	   return 1
	 }
  #WRB BLF
	row = kingRow + 1
	coloumn = kingColoumn + 2
	if(is_opposite_colour(colour,row,coloumn) && chessBoard[row,coloumn] ~ /[WB]N/){
	   return 1
	 }
  #WBL BFR
	row = kingRow + 2
	coloumn = kingColoumn - 1
	if(is_opposite_colour(colour,row,coloumn) && chessBoard[row,coloumn] ~ /[WB]N/){
	   return 1
	 }
  #WBR BFL
	row = kingRow + 2
	coloumn = kingColoumn + 1
	if(is_opposite_colour(colour,row,coloumn) && chessBoard[row,coloumn] ~ /[WB]N/){
	   return 1
	 }

  return 0
}



function is_opposite_colour(colour,row,coloumn){
  return (colour == "W" && (chessBoard[row,coloumn] ~ /B./)) || (colour == "B" && (chessBoard[row,coloumn] ~ /W./))
}

function display_manual(){
  print "Please read guide carefully before playing:"
  print ""
  print "Short Name                Stand for"
  print "BP                        Black Pawn"
  print "BR                        Black Rook"
  print "BN                        Black Knight"
  print "BB                        Black Bishop"
  print "BQ                        Black Queen"
  print "BK                        Black King"
  print "WP                        White Pawn"
  print "WR                        White Rook"
  print "WN                        White Knight"
  print "WB                        White Bishop"
  print "WQ                        White Queen"
  print "WK                        White King"
  print ""
  print "Pieces     Options        Action"
  print "Pawn       ff             to go forward two step if it is pawn's first move"
  print "           f              to go forward one step"
  print "           fr             to go forward right one step"
  print "           fl             to go forward left one step"
  print "Knight     fr             to go 2 steps forward and 1 step right"
  print "           fl             to go 2 steps forward and 1 step left"
  print "           br             to go 2 steps backward and 1 step right"
  print "           bl             to go 2 steps backward and 1 step left"
  print "           rf             to go 2 steps right and 1 step forward"
  print "           rb             to go 2 steps right and 1 step backward"
  print "           lf             to go 2 steps left and 1 step forward"
  print "           lb             to go 2 steps left and 1 step backward"
  print "Rook       l n            to go left n steps"
  print "           r n            to go right n steps"
  print "           f n            to go forward n steps"
  print "           b n            to go backward n steps"
  print "Bishop     fr n           to go forward right diagonally n steps"
  print "           fl n           to go forward left diagonally n setps"
  print "           br n           to go backward right diagonally n steps"
  print "           bl n           to go backward left diagonally n steps"
  print "Queen      all Rook and Bishop options"
  print "King       all Rook and Bishop options withou [n] option"
}
