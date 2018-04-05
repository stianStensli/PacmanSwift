//
//  GhostRndCtrl.swift
//  Pacman
//
//  Created by Stian  Stensli on 3/11/17.
//  Copyright © 2017 Stian  Stensli. All rights reserved.
//

import Foundation

class GhostRndCtrl : GhostCtrl{
    
    
    let board: [[Int]]
    var ghostPosx : Int
    var ghostPosy : Int
    
    var lastDir : Int
    var lastOppDir : Int
    
    var isdead : Bool = false
    
    let spawn: ArrayNode = ArrayNode(xCor: 13, yCor: 10)
    
    
    
    init(board: Board, shapeString: String, size: Double) {
        self.board = board.getBoard()
        
        ghostPosx = spawn.getX()
        ghostPosy = spawn.getY()

        
        lastDir = -1
        lastOppDir = -1
        
        super.init(shapeString: shapeString, size: size)
    }
    
    override func move() -> MoveResult {
        
        let moveResult =  MoveResult()
        
        var possibleDir: [Int] = []
        
        for index in 0...3{
            if(lastOppDir == -1){
                if moveLook(dir: index){
                    possibleDir.append(index)
                }
            }else{
                if index != lastOppDir{
                    if moveLook(dir: index){
                        possibleDir.append(index)
                    }
                }
            }
        }
        
        let isNotInSpawn: Bool = board[ghostPosy][ghostPosx] != 4
        
        if possibleDir.endIndex == 1 && isNotInSpawn && !super.reCalculate{
            lastDir = possibleDir[0]
        } else if !isdead{
            if(board[ghostPosy][ghostPosx] == 4){
                let resultAstar = GameFunction.aStar(board: board, startNode: ArrayNode(xCor: ghostPosx, yCor: ghostPosy), goalNode: super.outOfSpawn)
                
                lastDir = resultAstar
            }else{
                let _dir = Int(arc4random_uniform(UInt32(possibleDir.endIndex)))
                lastDir = possibleDir[_dir]
            }
            
        }else{
            let resultAstar = GameFunction.aStar(board: board, startNode: ArrayNode(xCor: ghostPosx, yCor: ghostPosy), goalNode: spawn)
            
            if resultAstar == -1 {
                respawn()
                moveResult.didReachRespawn(reach: true)
            }else{
                lastDir = resultAstar
            }
            super.reCalculate = false
        }
        
        lastOppDir = GameFunction.getOppDir(dir: lastDir)
        
        move(dir: lastDir, result: moveResult)
        
        return moveResult
    }
    
     private func move(dir: Int, result: MoveResult ) {
        
        if dir == 0
        {
            //Left
            if ghostPosx == 0{
                ghostPosx = 26
                result.didLeap(leap: true)
            }else if board[ghostPosy][ghostPosx - 1] != 0{
                ghostPosx -= 1
            }
        }
        if dir == 1
        {
            
            //Rigth
            if ghostPosx == 26{
                ghostPosx = 0
                result.didLeap(leap: true)
            }else if board[ghostPosy][ghostPosx + 1] != 0{
                ghostPosx += 1
            }
        }
        if dir == 2
        {
            //Down
            if board[ghostPosy + 1][ghostPosx] != 0{
                ghostPosy += 1
            }
        }
        if dir == 3
        {
            //UP
            if board[ghostPosy - 1][ghostPosx] != 0{
                ghostPosy -= 1
            }
        }
        
    }
    private func moveLook(dir: Int ) -> Bool {
        if dir == 0
        {
            //Left
            if ghostPosx == 0{
                return true;
            }else if board[ghostPosy][ghostPosx - 1] != 0{
                return true;
            }
        }
        if dir == 1
        {
            
            //Rigth
            if ghostPosx == 26{
                return true;
            }else if board[ghostPosy][ghostPosx + 1] != 0{
                return true;
            }
        }
        if dir == 2
        {
            //Down
            if board[ghostPosy + 1][ghostPosx] != 0{
                return true;
            }
        }
        if dir == 3
        {
            //UP
            if board[ghostPosy - 1][ghostPosx] != 0{
                return true;
            }
        }
        
        return false
    }
    
    
    override func ghostPos() -> [Int] {
        
        let pos: [Int] = [ghostPosx, ghostPosy]
        
        return pos
    }
    
    
    override func die() -> Void {
        isdead = true
        super.reCalculate = true
        
    }
    
    override func reset() -> Void{
        isdead = false
        
        ghostPosx = spawn.getX()
        ghostPosy = spawn.getY()
        
        lastDir = -1
        lastOppDir = -1
        
    }
    
    override func isDead() -> Bool {
        return isdead
    }
    
    override func respawn() -> Void {
        isdead = false
        
    }
    
    
}
