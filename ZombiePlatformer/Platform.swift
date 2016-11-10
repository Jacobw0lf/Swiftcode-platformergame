//
//  Platform.swift
//  Platformer
//
//  Created by iD Student on 7/28/16.
//  Copyright © 2016 iD Tech. All rights reserved.
//

import SpriteKit

class Platform: SKSpriteNode {
    
    init(platformSize: CGSize) {
        
        let spriteNode = SKSpriteNode(color: SKColor.black, size: platformSize)

        super.init(texture: spriteNode.texture, color: spriteNode.color, size: platformSize)
        
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = BodyType.Platform
        self.physicsBody?.contactTestBitMask = BodyType.Hero | BodyType.Zombie
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.mass = 1000
        //self.physicsBody?.pinned = true
        self.physicsBody?.affectedByGravity = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    func random() -> CGFloat
    {
        
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        
    }
    
    func randomizeLength(_ screenWidth: CGFloat) -> CGFloat
    {
        let rand = (random()*screenWidth)
        return rand
    }
    
    func randomizeY(_ screenHeight: CGFloat) -> CGFloat
    {
        let rand = (random()*screenHeight/2)
        return rand
    }
}


