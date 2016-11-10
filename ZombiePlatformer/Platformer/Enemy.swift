//
//  Enemy.swift
//  Platformer
//
//  Created by iD Student on 7/26/16.
//  Copyright © 2016 iD Tech. All rights reserved.
//

import SpriteKit

class Enemy: SKSpriteNode {
    
    //var texture :SKTexture
    
    init(imageNamed: String) {
        
        let texture = SKTexture(imageNamed: "\(imageNamed)")
        
        super.init(texture: texture, color: UIColor(), size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}


