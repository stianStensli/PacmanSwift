//
//  GameViewController.swift
//  Pacman
//
//  Created by Stian  Stensli on 22/10/17.
//  Copyright © 2017 Stian  Stensli. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import CoreMotion

class GameViewController: UIViewController {
    
    var motionManager: CMMotionManager!
    var scene: GameScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let test: subClass = subClass()
        
        test.funcSet(set: true)
        test.funcSet(set: false)
        
        motionManager = CMMotionManager()
        if (motionManager.isAccelerometerAvailable){
            motionManager.startAccelerometerUpdates(
                to: OperationQueue.current!,
                withHandler: {(accelData: CMAccelerometerData?, errorOC: Error?) in
                    self.outputAccelData(acceleration: accelData!.acceleration)
            })
        }
        
        if (motionManager.isGyroAvailable){
            motionManager.startGyroUpdates(
                to: OperationQueue.current!,
                withHandler: { (gyroData: CMGyroData?, errorOC: Error?) in
                    self.outputGyroData(gyro: gyroData!)
            })
        }
        
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            scene = SKScene(fileNamed: "GameScene") as! GameScene
            if  scene != nil {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    func outputAccelData(acceleration: CMAcceleration){
        scene.updateMovement(x: acceleration.x, y: acceleration.y)
        //print(acceleration.z)
    }
    
    func outputGyroData(gyro: CMGyroData){
      //  print("Gyro rotation: \(gyro.rotationRate)")
    }
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
