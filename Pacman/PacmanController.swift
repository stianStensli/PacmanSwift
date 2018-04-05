//
//  PacmanController.swift
//  Pacman
//
//  Created by Stian  Stensli on 25/10/17.
//  Copyright © 2017 Stian  Stensli. All rights reserved.
//

import Foundation

class PacmanController{
    var boardObj:Board
    var board: [[Int]]
    var pacmanPosx : Int
    var pacmanPosy : Int
    
    var nrOfLife : Int
    
    init(board: Board) {
        self.boardObj = board
        self.board = board.getBoard()
        pacmanPosx = 13
        pacmanPosy = 16
        
        nrOfLife = 3
    }
    
    func move(dir: Int ) -> MoveResult {
        let result = MoveResult()
        
        if dir == 0
        {
            //Left
            if pacmanPosx == 0{
                pacmanPosx = 26
                
                result.didLeap(leap: true)
                result.didReachTarget(reach: true)
            }else if board[pacmanPosy][pacmanPosx - 1] != 0{
                pacmanPosx -= 1
                result.didReachTarget(reach: true)
            }
        } else if dir == 1
        {
            //Rigth
            if pacmanPosx == 26{
                pacmanPosx = 0
                
                result.didLeap(leap: true)
                result.didReachTarget(reach: true)
            }else if board[pacmanPosy][pacmanPosx + 1] != 0{
                pacmanPosx += 1
                result.didReachTarget(reach: true)
                
            }
        }else if dir == 2
        {
            //Down
            if board[pacmanPosy + 1][pacmanPosx] != 0{
                pacmanPosy += 1
                result.didReachTarget(reach: true)
                
            }
        }else if dir == 3
        {
            //UP
            if board[pacmanPosy - 1][pacmanPosx] != 0{
                pacmanPosy -= 1
                result.didReachTarget(reach: true)
            }
        }
        
        if result.didReachTarget(){
            boardObj.setPacPos(pos: NodeDirLink(node: ArrayNode(xCor: pacmanPosx, yCor: pacmanPosy), dir: dir))
            
        }
        return result
    }
    func canEat() -> Bool {
        if board[pacmanPosy][pacmanPosx] == 1{
            board[pacmanPosy][pacmanPosx] = 2
            return true
        }
        return false
    }
    
    func canEatSuper() -> Bool {
        if board[pacmanPosy][pacmanPosx] == 3{
            board[pacmanPosy][pacmanPosx] = 2
            return true
        }
        return false
    }
    
    func pacmanPos() -> [Int] {
        let pos: [Int] = [pacmanPosx, pacmanPosy]
        
        return pos
    }
    
    func die() {
        nrOfLife -= 1
        
        pacmanPosx = 13
        pacmanPosy = 16
        
        boardObj.setPacPos(pos: NodeDirLink(node: ArrayNode(xCor: pacmanPosx, yCor: pacmanPosy), dir: -1))
    }
    
    func resetLife() {
        nrOfLife = 3
    }
    func oneUp() -> Int {
        nrOfLife += 1
        return nrOfLife
    }
    func getNrOfLife() -> Int {
        return nrOfLife
    }
    
}
