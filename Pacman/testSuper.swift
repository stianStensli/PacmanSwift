//
//  testSuper.swift
//  Pacman
//
//  Created by Stian  Stensli on 27/12/17.
//  Copyright © 2017 Stian  Stensli. All rights reserved.
//

import Foundation
class superClass{
    var state: Bool = false
    
}

class subClass: superClass {
    func funcSet(set: Bool) {
        print("before: " + String(super.state))
        super.state = set
        print("after: " + String(super.state))
        
    }
}
