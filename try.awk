BEGIN{
  create_chess_board(chessBoard)
  #to keep current location of both king in order to check Check conditon

  whiteKingRow = 8
  whiteKingColoumn = 5
  blackKingRow = 1
  blackKingColoumn = 5

  #start with white
  turn = "White"

  #printing some message reated to game
  print ""
  print "Welcome to Awkward Chess [under beta testing]"
  display_manual()
  #displaying board and asking first input to start the game
  display_board(chessBoard)
  ask_input(turn)
}

$1 ~ /^[Hh][Ee][Ll][Pp]$/{
  display_manual()
  display_board(chessBoard)
  ask_input(turn)
  next
}

{
  split($1,curPos,",")
  curPos["row"] = curPos[1]
  curPos["coloumn"] = curPos[2]
}

( is_wrong_person(chessBoard,turn,curPos) ){
  print "Can't move opponent pieces."
  ask_input(turn)
  next
}

chessBoard[curPos["row"],curPos["coloumn"]] ~ /[♟♙]/{
 if(is_pawn_movable(chessBoard,curPos,destPos,$2)){
    determine_destination(chessBoard,curPos,destPos)
  }else{
    print "Your Pawn can't move. Please give right input. [type help<-| to see manual]"
  }
}

chessBoard[curPos["row"],curPos["coloumn"]] ~ /[♞♘]/{
  if(is_knight_movable(chessBoard,curPos,destPos,$2)){
    determine_destination(chessBoard,curPos,destPos)
  }else{
    print "Your Knight can't move. Please give right input. [type help<-| to see manual]"
  }
}

chessBoard[curPos["row"],curPos["coloumn"]] ~ /[♜♖]/{
  if(is_rook_movable(chessBoard,curPos,destPos,$2,$3)){
    determine_destination(chessBoard,curPos,destPos)
  }else{
    print "Your Rook can't move. Please give right input. [type help<-| to see manual]"
  }
}

chessBoard[curPos["row"],curPos["coloumn"]] ~ /[♝♗]/{
  if(is_bishop_movable(chessBoard,curPos,destPos,$2,$3)){
    determine_destination(chessBoard,curPos,destPos)
  }else{
    print "Your Bishop can't move. Please give right input. [type help<-| to see manual]"
  }
}

chessBoard[curPos["row"],curPos["coloumn"]] ~ /[♛♕]/{
 if(move_queen(chessBoard,curPos,destPos,$2,$3)){
    determine_destination(chessBoard,curPos,destPos)
  }else{
    print "Your Queen can't move. Please give right input. [type help<-| to see manual]"
  }
}

chessBoard[curPos["row"],curPos["coloumn"]] ~ /[♚♔]/{
  if(move_king(chessBoard,curPos,destPos,$2)){
    determine_destination(chessBoard,curPos,destPos)
  }else{
    print "Your King can't move. Please give right input. [type help<-| to see manual]"
  }
}

{
  ask_input(turn)
}


END{
}

function create_chess_board(chessBoard){
  chessBoard[1,1] = "♖ "
  chessBoard[1,2] = "♘ "
  chessBoard[1,3] = "♗ "
  chessBoard[1,4] = "♕ "
  chessBoard[1,5] = "♔ "
  chessBoard[1,6] = "♗ "
  chessBoard[1,7] = "♘ "
  chessBoard[1,8] = "♖ "

  for(coloumn=1; coloumn <= 8; coloumn++)
    chessBoard[2,coloumn] = "♟ "

  for(row=3; row <= 6; row++)
    for(coloumn = 1; coloumn <= 8; coloumn++)
      chessBoard[row,coloumn] = "  "
  
  for(coloumn=1;coloumn<=8;coloumn++)
    chessBoard[7,coloumn] = "♙ "

  chessBoard[8,1] = "♜ "
  chessBoard[8,2] = "♞ "
  chessBoard[8,3] = "♝ "
  chessBoard[8,4] = "♛ "
  chessBoard[8,5] = "♚ "
  chessBoard[8,6] = "♝ "
  chessBoard[8,7] = "♞ "
  chessBoard[8,8] = "♜ "

}

function display_board(chessBoard){
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

function ask_input(turn){
  printf "Turn "turn":Location(x,y) option ....: "
}

function is_wrong_person(chessBoard,turn,curPos){
  return ((turn == "White")&&(chessBoard[curPos["row"],curPos["coloumn"]] ~ /[♟♖♘♗♕♔]/)) || ((turn == "Black")&&(chessBoard[curPos["row"],curPos[2]] ~ /[♙♜♞♝♛♚]/))
}

function change_input(){
  if(turn == "Black")
    turn = "White"
  else
    turn = "Black"
}

function determine_destination(chessBoard,curPos,destPos){
  chessBoard[destPos["row"],destPos["coloumn"]] = chessBoard[curPos["row"],curPos["coloumn"]]
  chessBoard[curPos["row"],curPos["coloumn"]] = "  "
  change_king_position(destPos["row"],destPos["coloumn"])

  if(is_my_king_check(chessBoard,turn)){
    print "Your king is or will be in check. Please save your King. (** Unless you will loss the match **)"
    chessBoard[curPos["row"],curPos["coloumn"]] = chessBoard[destPos["row"],destPos["coloumn"]]
    chessBoard[destPos["row"],destPos["coloumn"]] = "  "
    change_king_position(curPos["row"],curPos["coloumn"])
  }else{
    chessBoard[curPos["row"],curPos["coloumn"]] = ".."
    display_board(chessBoard)
    chessBoard[curPos["row"],curPos["coloumn"]] = "  "
    change_input()
    is_my_king_check(chessBoard,turn)
  }
}

function is_pawn_movable(chessBoard,curPos,destPos,option){
  create_pawn_moves(pawnMoves)

  destPos["row"] = curPos["row"] + (pawnMoves[turn,option,"row"])
  destPos["coloumn"] = curPos["coloumn"] + (pawnMoves[turn,option,"coloumn"])

  if(turn == "Black" && $2 == "ff" && curPos["row"] == "2"){
    destPos["row"] = curPos["row"] + 2
    destPos["coloumn"] = curPos["coloumn"]
  }
  if(turn == "White" && $2 == "ff" && curPos["row"] == "7"){
    destPos["row"] = curPos["row"] - 2
    destPos["coloumn"] = curPos["coloumn"]
  }

  delete pawnMoves
  return (isCommonFailCasePass(chessBoard,curPos,destPos) && ((chessBoard[destPos["row"],destPos["coloumn"]] != "  " && ($2 == "fr"|| $2 == "fl")) || (chessBoard[destPos["row"],destPos["coloumn"]] == "  " && ($2 == "f" || $2 =="ff"))) )

}

function create_pawn_moves(pawnMoves){
  pawnMoves["White","f","row"] = -1
  pawnMoves["White","f","coloumn"] = 0 
  pawnMoves["White","fl","row"] = -1
  pawnMoves["White","fl","coloumn"] = -1
  pawnMoves["White","fr","row"] = -1
  pawnMoves["White","fr","coloumn"] = 1
  pawnMoves["Black","f","row"] = 1
  pawnMoves["Black","f","coloumn"] = 0
  pawnMoves["Black","fl","row"] = 1
  pawnMoves["Black","fl","coloumn"] = 1
  pawnMoves["Black","fr","row"] = 1
  pawnMoves["Black","fr","coloumn"] = -1
}

function is_knight_movable(chessBoard,curPos,destPos,option){
  create_knight_moves(knightMoves)

  destPos["row"] = curPos["row"] + (knightMoves[turn,option,"row"])
  destPos["coloumn"] = curPos["coloumn"] + (knightMoves[turn,option,"coloumn"])

  delete knightMoves
  return isCommonFailCasePass(chessBoard,curPos,destPos)
}

function create_knight_moves(knightMoves){
  knightMoves["White","fr","row"] = -2
  knightMoves["White","fr","coloumn"] = 1
  knightMoves["Black","bl","row"] = -2
  knightMoves["Black","bl","coloumn"] = 1
  knightMoves["White","fl","row"] = -2
  knightMoves["White","fl","coloumn"] = -1
  knightMoves["Black","br","row"] = -2
  knightMoves["Black","br","coloumn"] = -1
  knightMoves["White","br","row"] = 2
  knightMoves["White","br","coloumn"] = 1
  knightMoves["Black","fl","row"] = 2
  knightMoves["Black","fl","coloumn"] = 1
  knightMoves["White","bl","row"] = 2
  knightMoves["White","bl","coloumn"] = -1
  knightMoves["Black","fr","row"] = 2
  knightMoves["Black","fr","coloumn"] = -1
  knightMoves["White","rf","row"] = -1
  knightMoves["White","rf","coloumn"] = 2
  knightMoves["Black","rf","row"] = -1
  knightMoves["Black","rf","coloumn"] = 2
  knightMoves["White","rb","row"] = 1
  knightMoves["White","rb","coloumn"] = 2
  knightMoves["Black","lf","row"] = 1
  knightMoves["Black","lf","coloumn"] = 2
  knightMoves["White","lf","row"] = -1
  knightMoves["White","lf","coloumn"] = -2
  knightMoves["Black","rb","row"] = -1
  knightMoves["Black","rb","coloumn"] = -2
  knightMoves["White","lb","row"] = 1
  knightMoves["White","lb","coloumn"] = -2
  knightMoves["Black","rf","row"] = 1
  knightMoves["Black","rf","coloumn"] = -2
}

function is_rook_movable(chessBoard,curPos,destPos,option,noOfSteps){
  create_rook_moves(rookMoves)

  row = curPos["row"] + rookMoves[turn,option,"row"]
  coloumn = curPos["coloumn"] + rookMoves[turn,option,"coloumn"]
  rowIncDec = rookMoves[turn,option,"row"]
  coloumnIncDec = rookMoves[turn,option,"coloumn"]
  rowNoOfSteps = noOfSteps * rookMoves[turn,option,"row"]
  coloumnNoOfSteps = noOfSteps * rookMoves[turn,option,"coloumn"]

  destPos["row"] = curPos["row"] + rowNoOfSteps
  destPos["coloumn"] = curPos["coloumn"] + coloumnNoOfSteps

  return ( isCommonFailCasePass(chessBoard,curPos,destPos) && is_fields_empty(chessBoard,row,coloumn,rowNoOfSteps,coloumnNoOfSteps) )
}

function create_rook_moves(rookMoves){
  rookMoves["White","f","row"] = -1
  rookMoves["White","f","coloumn"] = 0
  rookMoves["Black","b","row"] = -1
  rookMoves["Black","b","coloumn"] = 0
  rookMoves["White","r","row"] = 0
  rookMoves["White","r","coloumn"] = 1
  rookMoves["Black","l","row"] = 0
  rookMoves["Black","l","coloumn"] = 1
  rookMoves["White","b","row"] = 1
  rookMoves["White","b","coloumn"] = 0
  rookMoves["Black","f","row"] = 1
  rookMoves["Black","f","coloumn"] = 0
  rookMoves["White","l","row"] = 0
  rookMoves["White","l","coloumn"] = -1
  rookMoves["Black","r","row"] = 0
  rookMoves["Black","r","coloumn"] = -1
}

function is_bishop_movable(chessBoard,curPos,destPos,option,noOfSteps){
  create_bishop_moves(bishopMoves)

  row = curPos["row"] + bishopMoves[turn,option,"row"]
  coloumn = curPos["coloumn"] + bishopMoves[turn,option,"coloumn"]
  rowIncDec = bishopMoves[turn,option,"row"]
  coloumnIncDec = bishopMoves[turn,option,"coloumn"]
  rowNoOfSteps = noOfSteps * bishopMoves[turn,option,"row"]
  coloumnNoOfSteps = noOfSteps * bishopMoves[turn,option,"coloumn"]

  destPos["row"] = curPos["row"] + rowNoOfSteps
  destPos["coloumn"] = curPos["coloumn"] + coloumnNoOfSteps

  delete bishopMoves
  return ( isCommonFailCasePass(chessBoard,curPos,destPos) && is_fields_empty(chessBoard,row,coloumn,rowNoOfSteps,coloumnNoOfSteps) )
}

function is_fields_empty(chessBoard,row,coloumn,rowNoOfSteps,coloumnNoOfSteps){
  while(row != curPos["row"] + rowNoOfSteps || coloumn !=  curPos["coloumn"] + coloumnNoOfSteps){
    if(chessBoard[row,coloumn] != "  "){
      return 0
    }
    row += rowIncDec
    coloumn += coloumnIncDec
   }
   return 1
}

function create_bishop_moves(bishopMoves){
  bishopMoves["White","fr","row"] = -1
  bishopMoves["White","fr","coloumn"] = 1
  bishopMoves["Black","bl","row"] = -1
  bishopMoves["Black","bl","coloumn"] = 1
  bishopMoves["White","fl","row"] = -1
  bishopMoves["White","fl","coloumn"] = -1
  bishopMoves["Black","br","row"] = -1
  bishopMoves["Black","br","coloumn"] = -1
  bishopMoves["White","br","row"] = 1
  bishopMoves["White","br","coloumn"] = 1
  bishopMoves["Black","fl","row"] = 1
  bishopMoves["Black","fl","coloumn"] = 1
  bishopMoves["White","bl","row"] = 1
  bishopMoves["White","bl","coloumn"] = -1
  bishopMoves["Black","fr","row"] = 1
  bishopMoves["Black","fr","coloumn"] = -1
}

function move_queen(chessBoard,curPos,destPos,option,noOfSteps){
  if(option  ~ /^[fbrl]$/){
    return is_rook_movable(chessBoard,curPos,destPos,option,noOfSteps)
  }
  if(option ~ /^[fb][lr]$/){
    return is_bishop_movable(chessBoard,curPos,destPos,option,noOfSteps)
  }
}

function move_king(chessBoard,curPos,destPos,option){
  if(option ~ /^[fbrl]$/){
    return is_rook_movable(chessBoard,curPos,destPos,option,1)
  }
  if(option ~ /^[fb][lr]$/){
    return is_bishop_movable(chessBoard,curPos,destPos,option,1)
  }
}

function isCommonFailCasePass(chessBoard,curPos,destPos){
  return (destPos["row"] >= 1) && (destPos["row"] <= 8) && (destPos["coloumn"] >= 1) && (destPos["coloumn"] <= 8) && (is_opposite_colour(chessBoard,turn,destPos["row"],destPos["coloumn"]))
}

function is_my_king_check(chessBoard,turn){
  if(turn == "White" && is_check(chessBoard,whiteKingRow,whiteKingColoumn,turn)){
      print turn" King check alert."
      return 1
    }
  if(turn == "Black" && is_check(chessBoard,blackKingRow,blackKingColoumn,turn)){
      print turn" King check alert."
      return 
    }
    return 0
}

function change_king_position(row,coloumn){
  if(chessBoard[row,coloumn] ~ /♔/){
    whiteKingRow = row
    whiteKingColoumn = coloumn
  }
  if(chessBoard[row,coloumn] ~ /♚/){
    blackKingRow = row
    blackKingColoumn = coloumn
  }
}

function is_check(chessBoard,kingRow,kingColoumn,turn){
  return (check_parallelly(chessBoard,kingRow,kingColoumn,turn) || check_diagonally(chessBoard,kingRow,kingColoumn,turn) || check_knights_way(chessBoard,kingRow,kingColoumn,turn))
}

function check_parallelly(chessBoard,kingRow,kingColoumn,turn){
  #WF BB
  row = kingRow - 1
  coloumn = kingColoumn
  rowIncDec = -1 
  coloumnIncDec = 0
  if( is_opponent_rook_queen(chessBoard,turn,row,coloumn,rowIncDec,coloumnIncDec) || is_opponent_king(chessBoard,turn,row,coloumn) ){
    return 1
  }

  #WB BF
  row = kingRow + 1
  rowIncDec = 1
if( is_opponent_rook_queen(chessBoard,turn,row,coloumn,rowIncDec,coloumnIncDec) || is_opponent_king(chessBoard,turn,row,coloumn) ){
    return 1
  }

  #WL BR
  row = kingRow
  coloumn = kingColoumn - 1
  rowIncDec = 0
  coloumnIncDec = -1
  if( is_opponent_rook_queen(chessBoard,turn,row,coloumn,rowIncDec,coloumnIncDec) || is_opponent_king(chessBoard,turn,row,coloumn) ){
    return 1
  }

  #WR BL  
  coloumn = kingColoumn + 1
  coloumnIncDec = -1
  if( is_opponent_rook_queen(chessBoard,turn,row,coloumn,rowIncDec,coloumnIncDec) || is_opponent_king(chessBoard,turn,row,coloumn) ){
    return 1
  }
  return 0
}

function is_opponent_rook_queen(chessBoard,turn,row,coloumn,rowIncDec,coloumnIncDec){
  while(row > 0 && row < 9 && coloumn > 0 && coloumn < 9){
    if( is_opposite_colour(chessBoard,turn,row,coloumn) && chessBoard[row,coloumn] ~ /[♖♜♕♛]/){
      return 1
    }
    if(chessBoard[row,coloumn] != "  "){
      break
    }
    row += rowIncDec
    coloumn += coloumnIncDec
  }
  return 0
}

function check_diagonally(chessBoard,kingRow,kingColoumn,turn){
  #WFL #BBR
  row = kingRow - 1
  coloumn = kingColoumn - 1
  rowIncDec = -1
  coloumnIncDec = -1
  if( is_opponent_bishop_queen(chessBoard,turn,row,coloumn,rowIncDec,coloumnIncDec) || is_opponent_king(chessBoard,turn,row,coloumn) || is_black_pawn(chessBoard,turn,row,coloumn) ){
    return 1
  }

  #WFR #BBL
  row = kingRow - 1
  coloumn = kingColoumn + 1
  rowIncDec = -1
  coloumnIncDec = 1
  if( is_opponent_bishop_queen(chessBoard,turn,row,coloumn,rowIncDec,coloumnIncDec) || is_opponent_king(chessBoard,turn,row,coloumn) || is_black_pawn(chessBoard,turn,row,coloumn) ){
    return 1
  }

  #WBL BFR
  row = kingRow + 1
  coloumn = kingColoumn - 1
  rowIncDec = 1
  coloumnIncDec = -1
  if( is_opponent_bishop_queen(chessBoard,turn,row,coloumn,rowIncDec,coloumnIncDec) || is_opponent_king(chessBoard,turn,row,coloumn) || is_white_pawn(chessBoard,turn,row,coloumn) ){
    return 1
  }

  #WBR BFL
  row = kingRow + 1
  coloumn = kingColoumn + 1
  rowIncDec = 1
  coloumnIncDec = 1
  if( is_opponent_bishop_queen(chessBoard,turn,row,coloumn,rowIncDec,coloumnIncDec) || is_opponent_king(chessBoard,turn,row,coloumn) || is_white_pawn(chessBoard,turn,row,coloumn) ){
    return 1
  }
  return 0
}

function is_opponent_bishop_queen(chessBoard,turn,row,coloumn,rowIncDec,coloumnIncDec){
  while(row > 0 && row < 9 && coloumn > 0 && coloumn < 9){
    if( is_opposite_colour(chessBoard,turn,row,coloumn) && chessBoard[row,coloumn] ~ /[♕♛♗♝]/){
      return 1
    }
    if(chessBoard[row,coloumn] != "  "){
      break
    }
    row += rowIncDec
    coloumn += coloumnIncDec
  }
  return 0
}

function is_opponent_king(chessBoard,turn,row,coloumn){
  return (chessBoard[row,coloumn] ~ /[♔♚]/ && is_opposite_colour(chessBoard,turn,row,coloumn))
}

function is_white_pawn(chessBoard,turn,row,coloumn){
  return (chessBoard[row,coloumn] ~ /♙/ && turn == "Black")
}

function is_black_pawn(chessBoard,turn,row,coloumn){
  return (chessBoard[row,coloumn] ~ /♟/ && turn == "White")
}

function check_knights_way(chessBoard,kingRow,kingColoumn,turn){
  #WFL BBR
	row = kingRow - 2
	coloumn = kingColoumn - 1
	if(is_opposite_colour(chessBoard,turn,row,coloumn) && chessBoard[row,coloumn] ~ /[♘♞]/){
	   return 1
	 }

	#WFR BBR
	row = kingRow - 2
	coloumn = kingColoumn + 1
	if(is_opposite_colour(chessBoard,turn,row,coloumn) && chessBoard[row,coloumn] ~ /[♘♞]/){
	   return 1
	 }

	#WLF BRB
	row = kingRow - 1
	coloumn = kingColoumn - 2
	if(is_opposite_colour(chessBoard,turn,row,coloumn) && chessBoard[row,coloumn] ~ /[♘♞]/){
	   return 1
	 }

	#WRF BLB
	row = kingRow - 1
	coloumn = kingColoumn + 2
	if(is_opposite_colour(chessBoard,turn,row,coloumn) && chessBoard[row,coloumn] ~ /[♘♞]/){
	   return 1
	 }

  #WLB BRF
	row = kingRow + 1
	coloumn = kingColoumn - 2
	if(is_opposite_colour(chessBoard,turn,row,coloumn) && chessBoard[row,coloumn] ~ /[♞♘]/){
	   return 1
	 }

  #WRB BLF
	row = kingRow + 1
	coloumn = kingColoumn + 2
	if(is_opposite_colour(chessBoard,turn,row,coloumn) && chessBoard[row,coloumn] ~ /[♘♞]/){
	   return 1
	 }

  #WBL BFR
	row = kingRow + 2
	coloumn = kingColoumn - 1
	if(is_opposite_colour(chessBoard,turn,row,coloumn) && chessBoard[row,coloumn] ~ /[♘♞]/){
	   return 1
	 }

  #WBR BFL
	row = kingRow + 2
	coloumn = kingColoumn + 1
	if(is_opposite_colour(chessBoard,turn,row,coloumn) && chessBoard[row,coloumn] ~ /[♘♘]/){
	   return 1
	 }
  return 0
}

function is_opposite_colour(chessBoard,turn,row,coloumn){
  return (turn == "White" && (chessBoard[row,coloumn] ~ /[♚♛♜♝♞♟]/)) || (turn == "Black" && (chessBoard[row,coloumn] ~ /[♔♕♖♗♘♙]/))
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
  print "Input Format:"
  print "row,coloumn option [n]"
  print "Example:"
  print "7,1 f"
  print "2,2 ff"
  print "8,2 fr"
  print "8,1 r 1"
  print "8,3 fr 3"
  print "5,6 br 2"
  print "6,1 b 5"
}
