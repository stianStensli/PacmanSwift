//
//  NodeDirLink.swift
//  Pacman
//
//  Created by Stian  Stensli on 7/11/17.
//  Copyright © 2017 Stian  Stensli. All rights reserved.
//

import Foundation

class NodeDirLink {
    private let node: ArrayNode
    private let dir: Int
    
    private let gScor: Int
    private let fScor: Double 
    
    
    
    init(node: ArrayNode, dir: Int, gScor: Int, fScor: Double) {
        self.dir = dir
        self.node = node
        self.gScor = gScor
        self.fScor = fScor
    }
    
    init(node: ArrayNode, dir: Int) {
        self.dir = dir
        self.node = node
        self.gScor = -1
        self.fScor = -1
    }
    
    
    
    func getDir() -> Int{
        return dir
    }
    func getNode() -> ArrayNode{
        return node
    }
    func hasNode(node: ArrayNode) -> Bool {
        if node.equals(node: self.node){
            return true
        }
        return false
    }
    
    func getGScor() -> Int {
        return gScor
    }
    func getFScor() -> Double {
        return fScor
    }
    
}
