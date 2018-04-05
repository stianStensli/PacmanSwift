//
//  GhostCtrl.swift
//  Pacman
//
//  Created by Stian  Stensli on 3/11/17.
//  Copyright © 2017 Stian  Stensli. All rights reserved.
//

import Foundation
import SpriteKit

/*
 Do not initiate as a Ghost, class is meant as abstract.
 */
class GhostCtrl {
    
    //This is not good practice :(
    private let durOfMove = 0.35
    private let durOfBlueMove = 0.6
    private let durOfDeadMove = 0.2
    
    public var reCalculate: Bool = false
    
    let outOfSpawn: ArrayNode = ArrayNode(xCor: 13, yCor: 8)
    
    var shape: SKSpriteNode
    
    init(shapeString: String, size: Double) {
        
        let nodeEye = SKSpriteNode(imageNamed: "ghost_eyes.png")
        let nodeBody = SKSpriteNode(imageNamed: shapeString)
        
        nodeBody.scale(to: CGSize(width: size, height: size))
        nodeEye.scale( to: CGSize(width: size, height: size))
        nodeEye.alpha = 0.0
        
        nodeEye.name  = "eyes"
        nodeBody.name = "body"
        
        shape =  SKSpriteNode()
        shape.addChild(nodeEye)
        shape.addChild(nodeBody)
        
    }
    
    func moveShape(topoint: CGPoint, comp: @escaping () -> Void) {
        if isDead(){
            shape.run(SKAction.move(to: topoint, duration: durOfDeadMove), completion: comp)
        } else if isBlue(){
            shape.run(SKAction.move(to: topoint, duration: durOfBlueMove), completion: comp)
        }
        else{
            shape.run(SKAction.move(to: topoint, duration: durOfMove), completion: comp)
            
        }
    }
    
    func respawnShape() {
        shape.childNode(withName: "body")?.alpha = 1
        shape.childNode(withName: "eyes")?.alpha = 0
    }
    
    func initToScene(scene: SKScene) -> Void {
        scene.addChild(shape)
    }
    func resetShape(position: CGPoint) {
        shape.removeAllActions()
        
        shape.childNode(withName: "body")?.removeAllActions()
        shape.childNode(withName: "body")?.alpha = 1
        shape.childNode(withName: "eyes")?.alpha = 0
        
        shape.position = position
    }
    func setPositionShape(position: CGPoint ) -> Void {
        shape.position = position
    }
    func setZPositionShape(zIndex: CGFloat) -> Void {
        shape.zPosition = zIndex
    }
    func setScaleShape(scale: CGSize) {
        shape.scale(to: scale)
        
    }
    
    func isMoving() -> Bool {
        return shape.hasActions()
    }
    
    func move() -> MoveResult{
        let res = MoveResult()
        return res
    }
    
    func ghostPos() -> [Int]{
        let res: [Int] = []
        return res
    }
    
    func die() -> Void{
        
    }
    
    func respawn() -> Void{
        
    }
    
    func isDead() -> Bool{
        return false
    }
    
    func reset() -> Void {
        
    }
    func dieShape() {
        shape.childNode(withName: "body")?.removeAllActions()
        shape.childNode(withName: "body")?.alpha = 0
        shape.childNode(withName: "eyes")?.alpha = 1
        
    }
    func isBlue() -> Bool{
        return shape.childNode(withName: "body")?.action(forKey: "blue") != nil
    }
    func turnBlue() {
        if !isDead(){
            reCalculate = true
            if((shape.childNode(withName: "body")?.action(forKey: "blue")) == nil){
                shape.childNode(withName: "body")?.run(SKAction.init(named: "Blue")!, withKey: "blue")
            }else{
                shape.childNode(withName: "body")?.removeAction(forKey: "Blue")
                shape.childNode(withName: "body")?.run(SKAction.init(named: "Blue")!, withKey: "blue")
            }
        }
        
    }
    
    func aliveNBlueDir(board: [[Int]],possibleDir: [Int], ghostNode: ArrayNode, pacNode: ArrayNode, lastDir: Int, lastOpDir: Int) -> Int {
        if board[ghostNode.getY()][ghostNode.getX()] == 4{
            return getOutOfSpawn(board: board, ghostNode: ghostNode)
        }

        if outOfSpawn.equals(node: ghostNode){
            if lastDir == 0{
                return 1
            }else{
                return 0
                
            }
        }
        
        let resultAstar = GameFunction.aStar(board: board, startNode:ghostNode, goalNode: pacNode)
        
        if resultAstar == -1 {
            //error should be dead
        }else{
            var newDir: [Int] = []
            for num in possibleDir{
                if num != resultAstar{
                    newDir.append(num)
                }
            }
            if reCalculate {
                if lastOpDir != resultAstar{
                    newDir.append(lastOpDir)
                }
            }
            let _dir = Int(arc4random_uniform(UInt32(newDir.endIndex)))
            if newDir.isEmpty{
                //Pacman has him cornered
                return resultAstar
            }
            return newDir[_dir]
        }
        reCalculate = false
        return -1
    }
    
    func getOutOfSpawn(board: [[Int]], ghostNode: ArrayNode) -> Int{
        
        let resultAstar = GameFunction.aStar(board: board, startNode:ghostNode, goalNode: outOfSpawn)
        return resultAstar
    }
   
    
}
