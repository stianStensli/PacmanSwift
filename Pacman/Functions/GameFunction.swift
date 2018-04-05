//
//  GameFunction.swift
//  Pacman
//
//  Created by Stian  Stensli on 7/11/17.
//  Copyright © 2017 Stian  Stensli. All rights reserved.
//

import Foundation

class GameFunction {
    public enum DispatchLevel {
        case main, userInteractive, userInitiated, utility, background
        var dispatchQueue: DispatchQueue {
            switch self {
            case .main:                 return DispatchQueue.main
            case .userInteractive:      return DispatchQueue.global(qos: .userInteractive)
            case .userInitiated:        return DispatchQueue.global(qos: .userInitiated)
            case .utility:              return DispatchQueue.global(qos: .utility)
            case .background:           return DispatchQueue.global(qos: .background)
            }
        }
    }
    
    public static func delay(bySeconds seconds: Double, dispatchLevel: DispatchLevel = .main, closure: @escaping () -> Void) {
        let dispatchTime = DispatchTime.now() + seconds
        dispatchLevel.dispatchQueue.asyncAfter(deadline: dispatchTime, execute: closure)
    }
    
    static func getNodeWithDir(xCor: Int, yCor: Int, dir: Int) -> ArrayNode{
        var node: ArrayNode
        if(dir == 0){
            node = ArrayNode(xCor: xCor - 1, yCor: yCor)
        }else if(dir == 1){
            node = ArrayNode(xCor: xCor + 1, yCor: yCor)
        }else if(dir == 2){
            node = ArrayNode(xCor: xCor, yCor: yCor + 1)
        }else {
            node = ArrayNode(xCor: xCor, yCor: yCor - 1)
        }
        
        return node
    }
    
    static func getOppDir(dir: Int) -> Int {
        var oppdir:Int = -1
        if(dir == 0){
            oppdir = 1
        }else if(dir == 1){
            oppdir = 0
        }else if(dir == 2){
            oppdir = 3
        }else if(dir == 3){
            oppdir = 2
        }
        return oppdir
    }
    
    static func aStar(board: [[Int]], startNode: ArrayNode, goalNode: ArrayNode) -> Int
    {
        let res: [ArrayNode] = []
        return aStar(board: board, startNode: startNode, goalNode: goalNode, restrictions: res)
    }
    
    static func aStar(board: [[Int]], startNode: ArrayNode, goalNode: ArrayNode, restrictions: [ArrayNode]) -> Int
    {
        if(startNode.equals(node: goalNode)){
            return -1
        }
        
        var infoMap: [NodeDirLink] = []
        var closedInfoMap: [NodeDirLink] = []
        //var lowPriInfoMap: [NodeDirLink] = []
        
        let startLink = NodeDirLink(node: startNode, dir: 0, gScor: 1, fScor: fScorCalc(curNode: startNode, goalNode: goalNode))
        
        closedInfoMap.append(startLink)
        
        
        //Need to restict first gen
        if moveLook(board: board, cur: startNode ,dir: 0){
            let next: ArrayNode = ArrayNode(xCor: startNode.getX() - 1, yCor: startNode.getY())
            
            if !containsNode(map: restrictions, node: next){
                let info = NodeDirLink(node: next, dir: 0, gScor: 1, fScor: fScorCalc(curNode: next, goalNode: goalNode))
                infoMap.append(info)
                
            }
        }
        if moveLook(board: board, cur: startNode, dir: 1){
            let next: ArrayNode = ArrayNode(xCor: startNode.getX() + 1, yCor: startNode.getY())
            
            if !containsNode(map: restrictions, node: next){
                let info = NodeDirLink(node: next, dir: 1, gScor: 1, fScor: fScorCalc(curNode: next, goalNode: goalNode))
                infoMap.append(info)
            }
        }
        if moveLook(board: board, cur: startNode ,dir: 2){
            let next: ArrayNode = ArrayNode(xCor: startNode.getX(), yCor: startNode.getY() + 1)
            
            if !containsNode(map: restrictions, node: next){
                let info = NodeDirLink(node: next, dir: 2, gScor: 1, fScor: fScorCalc(curNode: next, goalNode: goalNode))
                infoMap.append(info)
                
            }
        }
        if moveLook(board: board, cur: startNode ,dir: 3){
            let next: ArrayNode = ArrayNode(xCor: startNode.getX(), yCor: startNode.getY() - 1)
           
            if !containsNode(map: restrictions, node: next){
                let info = NodeDirLink(node: next, dir: 3, gScor: 1, fScor: fScorCalc(curNode: next, goalNode: goalNode))
                infoMap.append(info)
            }
        }
        
        
        
        while !infoMap.isEmpty
        {
            var curLink: NodeDirLink = infoMap.first!
            var position = 0
            var tempPosition = 0
            
            for node in infoMap{
                
                if node.getGScor() < curLink.getGScor()
                {
                    curLink = node
                    position = tempPosition
                }
                
                tempPosition += 1
            }
            if curLink.getNode().equals(node: goalNode)
            {
                return curLink.getDir()
            }
            
            infoMap.remove(at: position)
            closedInfoMap.append(curLink)
            
            let curNode = curLink.getNode()
            
            if moveLook(board: board, cur: curNode ,dir: 0){
                var next: ArrayNode
                
                if(curNode.getX()  == 0){
                    next = ArrayNode(xCor: 26, yCor: curNode.getY())
                }else{
                    next = ArrayNode(xCor: curNode.getX() - 1, yCor: curNode.getY())
                }
                let info = NodeDirLink(node: next, dir: curLink.getDir(), gScor: curLink.getGScor() + 1, fScor: fScorCalc(curNode: next, goalNode: goalNode))
               
                if !containsNode(map: closedInfoMap, node: next){
                    if !containsNode(map: infoMap, node: next){
                        if !containsNode(map: restrictions, node: next){
                            infoMap.append(info)
                        }
                    }
                    
                }
            }
            
            if moveLook(board: board, cur: curNode ,dir: 1){
                var next: ArrayNode
                if(curNode.getX()  == 26){
                    next = ArrayNode(xCor: 0, yCor: curNode.getY())
                }else{
                    next = ArrayNode(xCor: curNode.getX() + 1, yCor: curNode.getY())
                }
                
                let info = NodeDirLink(node: next, dir: curLink.getDir(), gScor: curLink.getGScor() + 1, fScor: fScorCalc(curNode: next, goalNode: goalNode))
                
                if !containsNode(map: restrictions, node: next){
                    if !containsNode(map: closedInfoMap, node: next){
                        if !containsNode(map: infoMap, node: next){
                            infoMap.append(info)
                        
                        }
                    }
                }
                
            }
            
            if moveLook(board: board, cur: curNode ,dir: 2){
                let next: ArrayNode = ArrayNode(xCor: curNode.getX(), yCor: curNode.getY() + 1)
                let info = NodeDirLink(node: next, dir: curLink.getDir(), gScor: curLink.getGScor() + 1, fScor: fScorCalc(curNode: next, goalNode: goalNode))
                if !containsNode(map: restrictions, node: next){
                    if !containsNode(map: closedInfoMap, node: next){
                        if !containsNode(map: infoMap, node: next){
                            infoMap.append(info)
                        
                        }
                    }
                }
            }
            if moveLook(board: board, cur: curNode ,dir: 3){
                let next: ArrayNode = ArrayNode(xCor: curNode.getX(), yCor: curNode.getY() - 1)
                let info = NodeDirLink(node: next, dir: curLink.getDir(), gScor: curLink.getGScor() + 1, fScor: fScorCalc(curNode: next, goalNode: goalNode))
                if !containsNode(map: restrictions, node: next){
                    
                    if !containsNode(map: closedInfoMap, node: next){
                        if !containsNode(map: infoMap, node: next){
                            infoMap.append(info)
                            
                        }
                    
                    }
                }
                
            }
        
        }
        return -1
    }
    
    static func containsNode(map: [NodeDirLink], node: ArrayNode) -> Bool{
        for link in map{
            if node.equals(node: link.getNode()){
                return true
            }
        }
        
        return false
        
    }
    static func containsNode(map: [ArrayNode], node: ArrayNode) -> Bool{
        for link in map{
            if node.equals(node: link){
                return true
            }
        }
        
        return false
        
    }
    
    /*
     Needs to know about Teleport.
    */
    static func fScorCalc(curNode: ArrayNode, goalNode: ArrayNode) -> Double {
       /* var xLength = Double(abs(curNode.getX().distance(to: goalNode.getX())))
        var yLength = Double(abs(curNode.getY().distance(to: goalNode.getY())))
        
        if xLength == 0 && yLength == 0{
            return 0
        }
        
        xLength = pow(xLength, 2)
        yLength = pow(yLength, 2)
 
        let scor = sqrt(xLength + yLength)
        
        return scor*/
        return 0
        
    }
    
    static private func moveLook(board: [[Int]], cur: ArrayNode ,dir: Int ) -> Bool {
        if(cur.getY() > 20){
            return false
        }
        if(cur.getY() < 0){
            return false
        }
        if(cur.getX() > 26){
            return false
        }
        if(cur.getX() < 0){
            return false
        }
        if dir == 0
        {
            if(cur.getX() < 0){
                return false
            }
            //Left
            if cur.getX() == 0{
                return true;
            }else if board[cur.getY()][cur.getX() - 1] != 0{
                return true;
            }
        }
        if dir == 1
        {
            if(cur.getX() > 26){
                return false
            }
            //Rigth
            if cur.getX() == 26{
                return true;
            }else if board[cur.getY()][cur.getX() + 1] != 0{
                return true;
            }
        }
        if dir == 2
        {
            if(cur.getY() > 19){
                return false
            }
            //Down
            if board[cur.getY() + 1][cur.getX()] != 0{
                return true;
            }
        }
        if dir == 3
        {
            //UP
            if(cur.getY() < 1){
                return false
            }
            if board[cur.getY() - 1][cur.getX()] != 0{
                return true;
            }
        }
        
        return false
    }
    
}
