//
//  MoveResult.swift
//  Pacman
//
//  Created by Stian  Stensli on 7/11/17.
//  Copyright © 2017 Stian  Stensli. All rights reserved.
//

import Foundation

class MoveResult {
    
    var leap: Bool = false
    var reachRespawn: Bool = false
    var reachTarget: Bool = false
    
    
    func didLeap(leap: Bool) -> Void {
        self.leap = leap
        
    }
    
    func didLeap() -> Bool {
        return leap
    }
    
    func didReachRespawn(reach: Bool) -> Void {
        self.reachRespawn = reach
        
    }
    
    func didReachRespawn() -> Bool {
        return reachRespawn
        
    }
    
    func didReachTarget(reach: Bool) -> Void {
        self.reachTarget = reach
        
    }
    
    func didReachTarget() -> Bool {
        return reachTarget
    }
    
    
    
}
