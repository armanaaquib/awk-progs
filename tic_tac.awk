BEGIN{
    split("         ",board,"")
    
    turn = 0

    sign[0] = "X"
    sign[1] = "O"
    noOfLegalInputs = 0
    winner[1] = 0

    print ""
    print "Welcome to Tic Tac Toe Game"
    print ""
    display_board(board)
    ask_input(turn)
}

(is_place_not_free(board,$1)){
  print ""
  print "Oops already exists."
  print "Please try new place."
  print ""
  display_board(board)
  ask_input(turn)
  next
}

($1~/^[1-9]$/){
  board[$1] = sign[turn]         #adding input to board
  check_win(board,winner)        #checking for win
  display_board(board)           #displaying board
  turn = !turn                 #changing next turn
  noOfLegalInputs += 1
}

(winner[1] > 0){
  print "Player "winner[1]" Won the game."
  print "Congratulations."
  exit
}

(noOfLegalInputs == 9){
  print "Match Draw."
  print "Nice Played."
  exit
}

{
  ask_input(turn)
}

END{
  print ""
  print "Bye! Come back soon."  
}

function display_board(board){

    print ""
    printf " "board[1]" | "board[2]" | "board[3]
    print ""
    print "---|---|---"
    printf " "board[4]" | "board[5]" | "board[6]
    print ""
    print "---|---|---"
    printf " "board[7]" | "board[8]" | "board[9]
    print ""
}

function check_win(board,winner){

    winner[board[1] == board[2] && board[2]  == board[3] && board[3] == sign[turn]] = turn + 1
    winner[board[4] == board[5] && board[5]  == board[6] && board[6] == sign[turn]] = turn + 1
    winner[board[7] == board[8] && board[8]  == board[9] && board[9] == sign[turn]] = turn + 1
    winner[board[1] == board[5] && board[5]  == board[9] && board[9] == sign[turn]] = turn + 1
    winner[board[3] == board[5] && board[5]  == board[7] && board[7] == sign[turn]] = turn + 1
    winner[board[1] == board[4] && board[4]  == board[7] && board[7] == sign[turn]] = turn + 1
    winner[board[2] == board[5] && board[5]  == board[8] && board[8] == sign[turn]] = turn + 1
    winner[board[3] == board[6] && board[6]  == board[9] && board[9] == sign[turn]] = turn + 1

}

function is_place_not_free(board,pos){
  return board[pos] != " "
}

function ask_input(turn){
  printf "Player "turn+1":"   
}
