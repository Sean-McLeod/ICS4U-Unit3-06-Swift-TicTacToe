/* This program is the
   Tic Tac Toe program.

   Sean McLeod
   2021/05/16
*/

func WinOrLost(board: [String], playerCheck: String) -> Bool {
  return (board[0] == playerCheck && board[1] == playerCheck
                                       && board[2] == playerCheck)
            || (board[3] == playerCheck && board[4] == playerCheck
                                       && board[5] == playerCheck)
            || (board[6] == playerCheck && board[7] == playerCheck
                                       && board[8] == playerCheck)
            || (board[0] == playerCheck && board[3] == playerCheck
                                       && board[6] == playerCheck)
            || (board[1] == playerCheck && board[4] == playerCheck
                                       && board[7] == playerCheck)
            || (board[2] == playerCheck && board[5] == playerCheck
                                       && board[8] == playerCheck)
            || (board[0] == playerCheck && board[4] == playerCheck
                                       && board[8] == playerCheck)
            || (board[2] == playerCheck && board[4] == playerCheck
                                       && board[6] == playerCheck)
}

func Bestmove(currentBoard: [String]) -> Int {
  // AI's turn
  var gotBoard = currentBoard
  var bestScore = Int.min
  var move = -1

  if (IsNumeric(strNum: gotBoard[4])) {
    // Always take middle if possible
    return 4
  } else {
    for item in 0..<gotBoard.count {
      // accessing each element of array
      if (IsNumeric(strNum: gotBoard[item])) {
        // this means the spot is free
        gotBoard[item] = "O"
        let score = MiniMax(liveBoard: gotBoard, isMaximizing: false)
        gotBoard[item] = String(item + 1)
        if (score > bestScore) {
          bestScore = score
          move = item
        }
      }
    }
  }
  return move
}

func MiniMax(liveBoard: [String], isMaximizing: Bool) -> Int {
  var symbol: String
  var bestScore: Int
  var newBoard = liveBoard

  if (WinOrLost(board: newBoard, playerCheck: "X")) {
    return -1
  } else if (WinOrLost(board: newBoard, playerCheck: "O")) {
    return 1
  } else if (IsFull(presentBoard: newBoard)) {
    return 0
  }
  if (!isMaximizing) {
    bestScore = Int.max
    symbol = "X"
  } else {
    bestScore = Int.min
    symbol = "O"
  }
  for item in 0..<newBoard.count {
    // accessing each element of array
    if (IsNumeric(strNum: newBoard[item])) {
      // this means the spot is free
      newBoard[item] = symbol
      let score = MiniMax(liveBoard: newBoard, isMaximizing: !isMaximizing)
      newBoard[item] = String(item + 1)
      if (isMaximizing) {
        if (score > bestScore) {
          bestScore = score
        }
      } else if (score < bestScore) {
        bestScore = score
      }
    }
  }
  return bestScore
}

func IsFull(presentBoard: [String]) -> Bool {
  var full = true
  for counter in 0..<presentBoard.count {
    if (IsNumeric(strNum: presentBoard[counter])) {
      full = false
      break
    }
  }
  return full
}

func PrintBoard(theBoard: [String]) {
  print("\n----+----+----")
  for item in 0..<theBoard.count {
    if (item % 3 - 2 == 0) {
      print("| \(theBoard[item]) |")
      print("----+----+----")
    } else {
      print("| \(theBoard[item]) ", terminator:"")
    }
  }
}

func IsNumeric(strNum: String) -> Bool {
  if (Int(strNum) == nil) {
    return false
  } else {
    return true
  }
}

enum IntParsingError: Error {
    case overflow
    case invalidInput
}

// main stub, get user input here
var boardFull = false
var checkWinnerX = false;
var checkWinnerO = false;

var board: [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
print("Welcome to tic tac toe!")

repeat {
  do {
    PrintBoard(theBoard: board)
    print("\nWhich space would you like to put the X?", terminator: " ")
    guard let space = Int(readLine()!) else {
      throw IntParsingError.invalidInput
    }
    if (space > board.count || space < 0) {
      print("That spot is invalid!")
    } else if (board[space - 1] == "X" || board[space - 1] == "O") {
      print("That spot's taken!")
    } else if (IsNumeric(strNum: board[space - 1])) {
      board[space - 1] = "X"
      // check for "X"
      checkWinnerX = WinOrLost(board: board, playerCheck: "X");
      if (checkWinnerX) {
        print("\nX has won.")
        PrintBoard(theBoard: board)
        break
      }
      // place a function call here to get the best move for O
      if (!IsFull(presentBoard: board)) {
        let goodComputerMove = Bestmove(currentBoard: board)
        board[goodComputerMove] = "O"
        // check for "O"
        checkWinnerO = WinOrLost(board: board, playerCheck: "O");
        if (checkWinnerO) {
          print("\nO has won.")
          PrintBoard(theBoard: board)
          break
        }
      } else {
        print("\nTie.")
        PrintBoard(theBoard: board)
      }
    } else {
      print("Error")
    }
  } catch {
    print("\nPlease enter an integer")
    break;
  }
  boardFull = IsFull(presentBoard: board)
} while !boardFull

print("\nGame Over.")
