//
//  Board.swift
//  Pacman
//
//  Created by Stian  Stensli on 25/10/17.
//  Copyright © 2017 Stian  Stensli. All rights reserved.
//

import Foundation

class Board {
    private var board: [[Int]] = []
    private var food: Int
    
    private var pacPos: NodeDirLink = NodeDirLink(node: ArrayNode(xCor: 13, yCor: 16), dir: -1)
    /*
     0 == block
     1 == food
     2 == free
     3 == super
     4 == Ghost
    */
    init() {
        for _ in 0...20{
            board.append([])
        }
        for _ in 0...26{
            board[0].append(0)
            board[1].append(1)
            board[2].append(0)
            board[3].append(0)
            board[4].append(1)
            board[5].append(0)
            
            board[6].append(1)
            board[7].append(0)
            board[8].append(0)
            board[9].append(0)
            board[10].append(2)
            
        }
        board[1][13] = 0
        
        board[2][1] = 3
        board[2][6] = 1
        board[2][6] = 1
        board[2][12] = 1
        board[2][1] = 3
        
        
        board[3][1] = 1
        board[3][6] = 1
        board[3][6] = 1
        board[3][12] = 1
        board[3][1] = 1
        
        board[4][0] = 0
        
        board[5][1] = 1
        board[5][6] = 1
        board[5][8] = 1
        
        board[6][0] = 0
        board[6][7] = 0
        board[6][13] = 0
        
        board[7][6] = 1
        board[7][12] = 2
        
        board[8][6] = 1
        board[8][8] = 2
        board[8][9] = 2
        board[8][10] = 2
        board[8][11] = 2
        board[8][12] = 2
        board[8][13] = 2
        
        board[9][6] = 1
        board[9][8] = 2
        
        board[10][6] = 1
        board[10][9] = 0
        
        board[10][10] = 4
        board[10][11] = 4
        board[10][12] = 4
        board[10][13] = 4
        
        
        for index in 0...13{
            for index2 in 0...10{
                board[index2][26 - index] = board[index2][index]
            }
        }
        
        for index in 1...10{
            for index2 in 0...26{
                board[10+index].append(board[10 - index][index2])
            }
        }
        board[16][13] = 2
        board[9][13] = 4
        food = 0
        for numArr in board{
            for num in numArr{
                if num == 1{
                    food += 1
                }
            }
        }
        
    }
    
    public func getBoard() -> [[Int]]
    {
        return board;
    }
    
    public func setPacPos(pos: NodeDirLink){
        self.pacPos = pos
    }
    
    public func getPacPos() -> NodeDirLink{
        return pacPos
    }
    public func eatFood() {
       food -= 1
    }
    public func getFood() -> Int {
        return food
    }
    
    public func getValueFormNode(node: ArrayNode) -> Int{
        
        return board[node.getY()][node.getX()]
    }
}
