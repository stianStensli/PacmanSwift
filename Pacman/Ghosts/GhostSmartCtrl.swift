//
//  GhostSmartCtrl.swift
//  Pacman
//
//  Created by Stian  Stensli on 12/11/17.
//  Copyright © 2017 Stian  Stensli. All rights reserved.
//

import Foundation

class GhostSmartCtrl : GhostCtrl{
    
    
    let boardObj: Board
    let board: [[Int]]
    
    var ghostPosx : Int
    var ghostPosy : Int
    
    var lastDir : Int
    var lastOppDir : Int
    
    var isdead : Bool = false
    
    let spawn: ArrayNode = ArrayNode(xCor: 11, yCor: 10)
    
    init(board: Board, shapeString: String, size: Double) {
        self.boardObj = board
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
        }   else if isBlue() && !isdead {
            //Alive and Blue
            let thisNode = ArrayNode(xCor: ghostPosx, yCor: ghostPosy)
            let pacNode = boardObj.getPacPos().getNode()
            possibleDir.append(lastOppDir)
            lastDir = aliveNBlueDir(board: board, possibleDir: possibleDir, ghostNode: thisNode, pacNode: pacNode, lastDir: lastDir, lastOpDir: lastOppDir)
            super.reCalculate = false
        }else if !isdead{
            //alive wite more then one option
            let goalLink = boardObj.getPacPos()
            let revertNode = GameFunction.getNodeWithDir(xCor: ghostPosx, yCor: ghostPosy, dir: lastOppDir)
            let restrictNodes:[ArrayNode] = [revertNode]
            
            let resultAstar = GameFunction.aStar(board: board, startNode: ArrayNode(xCor: ghostPosx, yCor: ghostPosy), goalNode: goalLink.getNode(), restrictions: restrictNodes)
            
            if resultAstar == -1 {
                reset()
                moveResult.didReachTarget(reach: true)
            }else{
                lastDir = resultAstar
            }
            
        }else{
            //Dead
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
        }else if dir == 1
        {
            //Rigth
            if ghostPosx == 26{
                ghostPosx = 0
                result.didLeap(leap: true)
            }else if board[ghostPosy][ghostPosx + 1] != 0{
                ghostPosx += 1
            }
        }else if dir == 2
        {
            //Down
            if board[ghostPosy + 1][ghostPosx] != 0{
                ghostPosy += 1
            }
        }else if dir == 3
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
        }else if dir == 1
        {
            //Rigth
            if ghostPosx == 26{
                return true;
            }else if board[ghostPosy][ghostPosx + 1] != 0{
                return true;
            }
        }else if dir == 2
        {
            //Down
            if board[ghostPosy + 1][ghostPosx] != 0{
                return true;
            }
        }else if dir == 3
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
