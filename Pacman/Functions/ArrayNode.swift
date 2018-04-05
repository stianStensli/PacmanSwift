//
//  ArrayNode.swift
//  Pacman
//
//  Created by Stian  Stensli on 7/11/17.
//  Copyright © 2017 Stian  Stensli. All rights reserved.
//

import Foundation

class ArrayNode {
    private let x: Int
    private let y: Int
    
    init(xCor: Int, yCor: Int) {
        x = xCor
        y = yCor
        
    }
    
    func getX() -> Int {
        return x
    }
    
    func getY() -> Int {
        return y
    }
    
    func equals(node: ArrayNode) -> Bool {
        
        if x == node.getX() && y == node.getY(){
            return true
        }
        return false
    }
}
