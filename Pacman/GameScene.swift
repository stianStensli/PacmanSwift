//
//  GameScene.swift
//  Pacman
//
//  Created by Stian  Stensli on 22/10/17.
//  Copyright © 2017 Stian  Stensli. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var paclabel : SKLabelNode?
    
    private let pacman : SKSpriteNode = SKSpriteNode()
    
    private var currentTimeGame : Double = 0.0;
    private var moveDir : Int = 0
    private var gameStarted : Bool = false
    private let lengthMoved : CGFloat = 100.0
    
    private var board : Board?
    
    private var boardNodes : [[SKSpriteNode]] = []
    
    private var lifeNodes : [SKNode] = []
    
    private let startposX = 0.0
    private let startPosY = 300.0
    private var blockSize : Double!
    
    private var ghostCtrls: [GhostCtrl] = []
    
    
    private let durOfMove = 0.35
    private let durOfBlueMove = 0.6
    private let durOfDeadMove = 0.2
    private var pacmanController: PacmanController?
    
    
    override func didMove(to view: SKView) {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        blockSize = Double(screenWidth) / 13
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        self.paclabel = self.childNode(withName: "//pacmanLabel") as? SKLabelNode
        let node = SKSpriteNode(imageNamed: "Pacman_test.png")
        node.scale(to: CGSize(width: blockSize, height: blockSize))
        node.name = "pacChild"
        
        pacman.addChild(node)
        
        board = Board()
        
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func updateMovement(x : Double, y: Double) {
        
        let tempX = abs(x)
        let tempY = abs(y)
        let tempdir = moveDir
        
        if tempX > tempY {
            if x < 0{
                //Move Rigth
                moveDir = 0
            }else {
                //Move Left
                moveDir = 1
            }
        }else {
            if y < 0{
                //Move Up
                moveDir = 2
            }else {
                //Move down
                moveDir = 3
            }
        }
        if tempdir != moveDir
        {
            if (!pacman.hasActions()){
                move()
            }
            
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    func removeN(node:SKNode) {
        let nodes: [SKNode] = [node]
        self.removeChildren(in: nodes)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse1")!, completion: {() -> Void in self.removeN(node: label)})
        
        }
        
        if !self.children.contains(pacman){
            pacman.position  = CGPoint(x: 0, y: 0)
            pacman.zPosition = 2
            self.addChild(pacman)
            creatNodeArr()
            
            initGhosts()
            initLifeNScore()
            
        }
            
        if !gameStarted{
            gameStarted = true
            setPosPacman()
            move()
            startMoveGhosts(ghostNumber: 0)
            
        }else{
            //gameStarted = false;
            /*for ghost in ghostCtrls{
                ghost.die()
                ghost.dieShape()
            }*/
            superEat(x: 0, y: 0)
            //resetGhosts()
        }
            
            
         
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
    }
    
    func move() {
        
        if gameStarted {
            if let ctrl = pacmanController{
                
                let moveResult = ctrl.move(dir: moveDir)

                if moveResult.didReachTarget(){
                    //setPosPacman()
                    if(moveDir == 1){
                        pacman.zRotation = 0
                        if(pacman.xScale < 0){
                            pacman.xScale *= -1
                        }
                    }else if(moveDir == 0){
                        if( pacman.xScale > 0){
                            pacman.zRotation = 0
                            pacman.xScale *= -1
                        }
                    }else if(moveDir == 3){
                        if(pacman.zRotation !=   CGFloat(Double.pi/2)){
                            pacman.xScale = abs(pacman.xScale)
                            pacman.zRotation =  CGFloat(Double.pi/2)
                        }
                    }else if(moveDir == 2){
                        if(pacman.zRotation !=  -CGFloat(Double.pi/2)){
                            pacman.xScale = abs(pacman.xScale)
                            pacman.zRotation =  -CGFloat(Double.pi/2)
                        }
                    }
                    
                    if moveResult.didLeap(){
                        setPosPacman()
                    }
                    pacman.run(SKAction.move(to: getPosPacman(), duration: durOfMove), completion: {
                        self.move();
                    })
                    pacman.childNode(withName: "pacChild")?.run(SKAction.init(named: "WhabaWhaba")!)
                    if ghostCtrls.endIndex != 0 {
                        for index in 0...(ghostCtrls.endIndex - 1)
                        {
                            hitScan(Gctrl: ghostCtrls[index])
                        }
                        
                    }
                    if (pacmanController?.canEat())!{
                        var pos = ctrl.pacmanPos()
                        eat(x: pos[0], y: pos[1])
                        
                    }else if(pacmanController?.canEatSuper())!{
                        var pos = ctrl.pacmanPos()
                        superEat(x: pos[0], y: pos[1])
                    }
                }
            }
        }
    }
    
    
    func creatNodeArr(){
        if let arr = board?.getBoard(){
            var tempy = 0
            //Temp selution
            if boardNodes.endIndex > 0{
             return
            }
            for i in arr{
                
                var tempx = 0
                if boardNodes.endIndex <= tempy{
                    boardNodes.append([])
                    
                }
                for j in i{
                    if j == 0{
                        boardNodes[tempy].append(SKSpriteNode(imageNamed: "Block.png"))
                    }else if j == 1
                    {
                        boardNodes[tempy].append(SKSpriteNode(imageNamed: "Food.png"))
                        
                    }else if j == 2
                    {
                        boardNodes[tempy].append(SKSpriteNode(imageNamed: "Free.png"))
                        
                    }else if j == 3
                    {
                        boardNodes[tempy].append(SKSpriteNode(imageNamed: "Super.png"))
                    }else if j == 4
                    {
                        boardNodes[tempy].append(SKSpriteNode(imageNamed: "Free.png"))
                    }
                    let posx = Double(tempx)*blockSize
                    var posy = Double(-tempy)*blockSize - blockSize/2
                    posy -= startPosY
                    boardNodes[tempy][tempx].position = CGPoint(x: posx, y: posy)
                    
                    boardNodes[tempy][tempx].scale(to: CGSize(width: blockSize, height: blockSize))
                    self.addChild(boardNodes[tempy][tempx])
                    tempx += 1
                }
                
                tempy += 1
            }
        }
        pacmanController = PacmanController(board: board!)
    }
    
    func setPosPacman() {
        if let ctrl = pacmanController{
            var pos = ctrl.pacmanPos()
            let posx = Double(pos[0])*blockSize
            let posy = Double(pos[1])*blockSize + startPosY + blockSize/2
            
            pacman.position = CGPoint(x: posx, y: -posy)
        }
    }
    
    func getPosPacman() -> CGPoint{
        if let ctrl = pacmanController{
            var pos = ctrl.pacmanPos()
            let posx = Double(pos[0])*blockSize
            let posy = Double(pos[1])*blockSize + startPosY + blockSize/2
            
            
            return CGPoint(x: posx, y: -posy)
        }
        return CGPoint(x: 0, y: 0)
    }
    
    func eat(x: Int, y: Int) {
        removeN(node: boardNodes[y][x])
        let temp = boardNodes[y][x].position
        
        boardNodes[y][x] = SKSpriteNode(imageNamed: "Free.png")
        boardNodes[y][x].position = temp
        boardNodes[y][x].scale(to: CGSize(width: blockSize, height: blockSize))
        
        self.addChild(boardNodes[y][x])
        
        board?.eatFood()
        
        if(board?.getFood() == 0){
            paclabel?.text = "Get a Life!"
        }
        
        
    }
    
    func superEat(x: Int, y: Int) {
        for ghost in ghostCtrls{
            ghost.turnBlue()
        }
        eat(x: x, y: y)
    }
    
    func initLifeNScore() {
        lifeNodes.append(SKLabelNode(text: "Life: "))
        
        lifeNodes.append(SKSpriteNode(imageNamed: "Pacman_test.png"))
        lifeNodes.append(SKSpriteNode(imageNamed: "Pacman_test.png"))
        lifeNodes.append(SKSpriteNode(imageNamed: "Pacman_test.png"))
        let life: SKTileMapNode = SKTileMapNode()
        
        life.addChild(lifeNodes[0])
        life.addChild(lifeNodes[1])
        life.addChild(lifeNodes[2])
        
        let yPos = -(Double(boardNodes.endIndex + 1) * blockSize + startPosY)
        var xPos = 85.0
        for node in lifeNodes {
            if node is SKSpriteNode{
                let nodePol = node as! SKSpriteNode
                nodePol.scale(to: CGSize(width: blockSize, height: blockSize))
                
            }
            /*node.position  = CGPoint(x: xPos, y: yPos)
            node.zPosition = 3
            self.addChild(node)
            
            xPos += blockSize + 5*/
        }
        life.position  = CGPoint(x: xPos, y: yPos)
        self.addChild(life)
        
    }
    func initGhosts(){
        ghostCtrls.append(GhostRndCtrl(board: board!, shapeString: "ghost_pink.png", size: blockSize) )
        ghostCtrls.append(GhostStalkCtrl(board: board!, shapeString: "ghost_red.png", size: blockSize))
        ghostCtrls.append(GhostInterveneCtrl(board: board!, shapeString: "ghost_ligth.png", size: blockSize))
        ghostCtrls.append(GhostSmartCtrl(board: board!, shapeString: "ghost_orange.png", size: blockSize))
        
        for ghost in ghostCtrls{
            
            ghost.setPositionShape(position: getPosGhostCtrl(ctrl: ghost))
            ghost.setZPositionShape(zIndex: 3.0)
            ghost.setScaleShape(scale: CGSize(width: blockSize, height: blockSize))
            
            ghost.initToScene(scene: self)
            
        }
        
    }
    
    func startMoveGhosts(ghostNumber: Int) {
        if(ghostNumber >= ghostCtrls.count){
            return 
        }
        let ghost = ghostCtrls[ghostNumber]
        GameFunction.delay(bySeconds: 3, dispatchLevel: .background) {
           
            if !ghost.isMoving()
            {
                self.moveGhostInvd(ghostCtrl: ghost)
            }
            
            self.startMoveGhosts(ghostNumber: ghostNumber + 1)
        }
    }
    
    func moveGhostInvd(ghostCtrl: GhostCtrl) {
        
        if gameStarted {
            //userInteractive
            GameFunction.delay(bySeconds: 0, dispatchLevel: .userInteractive){
                let moveResult = ghostCtrl.move()
            
                if(moveResult.didLeap()){
                    ghostCtrl.setPositionShape(position: self.getPosGhostCtrl(ctrl: ghostCtrl))
                }
                if moveResult.reachRespawn{
                ghostCtrl.respawnShape()
                ghostCtrl.respawn()
                }
                ghostCtrl.moveShape(topoint: self.getPosGhostCtrl(ctrl: ghostCtrl), comp: {
                    self.moveGhostInvd(ghostCtrl: ghostCtrl);
                })
                
                if(self.gameStarted){
                    self.hitScan(Gctrl: ghostCtrl)
                    
                }
            }
           
        }
    }
    
    
    func getPosGhost(ghostNr: Int) -> CGPoint {
        let ctrl: GhostCtrl = ghostCtrls[ghostNr]
        var pos = ctrl.ghostPos()
        let posx = Double(pos[0])*blockSize
        let posy = Double(pos[1])*blockSize + startPosY + blockSize/2
        
        
        return CGPoint(x: posx, y: -posy)
       
    }
    
    func getPosGhostCtrl(ctrl: GhostCtrl) -> CGPoint {
        var pos = ctrl.ghostPos()
        let posx = Double(pos[0])*blockSize
        let posy = Double(pos[1])*blockSize + startPosY + blockSize/2
        
        return CGPoint(x: posx, y: -posy)
        
    }

    func hitScan(Gctrl: GhostCtrl) {
        if Gctrl.ghostPos().elementsEqual(pacmanController!.pacmanPos()){
            if !Gctrl.isDead() {
                if !Gctrl.isBlue(){
                    pacman.removeAllActions()
                    pacmanController?.die()
            
                    resetGhosts()
                    setPosPacman()
                    
                }else{
                    Gctrl.die()
                    Gctrl.dieShape()
                }
            }
        }
    }
    
    func resetGhosts() {
        var tempx = 11
        for ghost in ghostCtrls{
            ghost.reset()
            
            let posx = Double(tempx)*blockSize
            let posy = Double(10)*blockSize + startPosY + blockSize/2
            ghost.resetShape(position: CGPoint(x: posx, y: -posy))
            tempx += 1
            
        }
    }
    
}
