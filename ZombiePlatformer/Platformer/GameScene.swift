//
//  GameScene.swift
//  Platformer
//
//  Created by iD Student on 7/25/16.
//  Copyright (c) 2016 iD Tech. All rights reserved.
//

import SpriteKit

let start = Date() // <<<<<<<<<< Start time
var timeElapsed : Double = 0.0

struct BodyType {
    static let None: UInt32 = 0
    static let Hero: UInt32 = 1
    static let Platform: UInt32 = 2
    static let Enemy: UInt32 = 3
    static let Zombie: UInt32 = 4
    static let Bullet: UInt32 = 5
    
    
    
    
    
    
    
    
    
        }

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    var scoreLabel = SKLabelNode(fontNamed: "Arial")
    
    let jumpUp = SKAction.moveBy(x: 0, y: 170, duration: 0.3)
    
    var jumpAction = SKAction()
    
    let hero = SKSpriteNode(imageNamed: "Soldier.png")
    let button = SKSpriteNode(imageNamed: "Button.png")
    
    var zombieDuration = 4.7
    
    
    var heroSpeed: CGFloat = 50.0
    
    //didMoveTo starts
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.gravity = CGVector(dx: 0,dy: -4)
        
        self.physicsWorld.contactDelegate = self
        
        //scene is setup here
        
        backgroundColor = SKColor.white
        
        
        let xCoord = size.width * 0.35
        let yCoord = size.height * 0.2
        
        hero.size.height = 50
        hero.size.width = 50
        
        hero.position = CGPoint(x: xCoord, y: yCoord)
        
        hero.physicsBody = SKPhysicsBody(texture: hero.texture!, size: hero.size)
        hero.physicsBody?.isDynamic = true
        hero.physicsBody?.categoryBitMask = BodyType.Hero
        hero.physicsBody?.contactTestBitMask = BodyType.Platform | BodyType.Zombie
        hero.physicsBody?.collisionBitMask = BodyType.Platform | BodyType.Zombie
        hero.physicsBody?.affectedByGravity = true
        hero.physicsBody?.restitution = 0
        hero.physicsBody?.allowsRotation = false
        hero.physicsBody?.mass = 100
        
        addChild(hero)
        
        let floorSize : CGSize = CGSize(width: size.width, height: 30)
        
        let floor = Platform(platformSize: floorSize)
        
        floor.position = CGPoint(x: floor.size.width/2, y: floor.size.height/2)
        
        addChild(floor)
        
        
        
        button.size.height = 75
        button.size.width = 75
        
        
        
        button.position = CGPoint(x: size.width * 0.1, y: size.height * 0.2)
        
        addChild(button)
        
         jumpAction = SKAction.sequence([jumpUp])
        
        //repeatedly runs addZombie function every second.
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addPlatform), SKAction.wait(forDuration: 1.0)])))
        
        scoreLabel.fontColor = UIColor.black
        
        scoreLabel.fontSize = 40
        
        scoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height-50)
        
        addChild(scoreLabel)
        
        scoreLabel.text = "0"
        
    
        
        
        
        
    }
    
    //didMoveTo ends
    
    //creates a random float between 0.0 and 1.0
    
    func random() -> CGFloat {
        
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        
        
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        
        var actionMove: SKAction
        
        actionMove = SKAction.move(to: CGPoint(x: hero.position.x, y: hero.position.y + heroSpeed), duration: TimeInterval(0.5))
        
        guard let touch = touches.first else { return }
        
        let touchLocation = touch.location(in: self)
        
        
        
        let vector = CGVector(dx: -(hero.position.x-touchLocation.x), dy: -(hero.position.y-touchLocation.y))
        
        
        
        
        if(touchLocation.x > button.position.x-25 && touchLocation.x < button.position.x+25 && touchLocation.y > button.position.y - 25 && touchLocation.y < button.position.y + 25){
            
            if hero.action(forKey: "jump") == nil {
                hero.run(jumpAction, withKey:"jump")
            }
        }
            
        else{
            //shoot
           
                let projectileAction = SKAction.sequence([
                    SKAction.repeat(
                        SKAction.move(by: vector, duration: 0.9), count: 5),
                    SKAction.wait(forDuration: 0.0),
                    SKAction.removeFromParent()
                    ])
                
                let bullet = SKSpriteNode()
                
                bullet.color = UIColor.darkGray
                
                bullet.size = CGSize(width: 5, height: 5)
                
                bullet.position = CGPoint(x: hero.position.x + 20, y: hero.position.y)
            
                bullet.physicsBody = SKPhysicsBody(circleOfRadius: bullet.size.width/2)
                bullet.physicsBody?.isDynamic = true
                bullet.physicsBody?.categoryBitMask = BodyType.Bullet
                bullet.physicsBody?.contactTestBitMask = BodyType.Zombie
                bullet.physicsBody?.collisionBitMask = BodyType.Zombie
                bullet.physicsBody?.usesPreciseCollisionDetection = true
                bullet.physicsBody?.affectedByGravity = false
                
                addChild(bullet)
                
                bullet.run(projectileAction)

            
            
        }
        
        
        
        
        
        
    }
    
    
    override func update(_ currentTime: TimeInterval)
    {
        let end = Date()  // <<<<<<<<<<   end time
        
        timeElapsed = end.timeIntervalSince(start)
        
        scoreLabel.text = String(Int(timeElapsed))
        
        if(Int(timeElapsed) % 15 == 0 && timeElapsed > 15)
        {
           zombieDuration *= 0.99
        }
    }
    
    func randomizeLength() -> CGFloat
    {
        let rand = (random()*size.width)
        return rand
    }
    
    func randomizeY() -> CGFloat
    {
        let rand = (random()*size.height/2)
        return rand
    }
    
    func addPlatform()
    {
        var randomPlatform : Platform
        
        
        
        let platSize = CGSize(width: randomizeLength(), height: 30)
        
        randomPlatform = Platform(platformSize: platSize)
        
        var Ypos = 0
        
        let randomNum = random()
        
        if(randomNum < 0.33){
            randomPlatform.position = CGPoint(x: size.width + randomPlatform.size.width/2, y: 100)
        }
        else {
            
            if(randomNum < 0.66){
                randomPlatform.position = CGPoint(x: size.width + randomPlatform.size.width/2, y: 200)
            }
            else{
                randomPlatform.position = CGPoint(x: size.width + randomPlatform.size.width/2, y: 300)
            }
        }
        
        
        
        addChild(randomPlatform)
        
        var movePlatform: SKAction
        
        let dist = size.width + randomPlatform.size.width
        let vel = size.width/5.0
        let time = dist/vel
        
        
        movePlatform = SKAction.moveTo(x: -randomPlatform.size.width/2, duration: TimeInterval(time))
        
        randomPlatform.run(SKAction.sequence([movePlatform, SKAction.removeFromParent()]))
        
        addZombie(randomPlatform)
        
    }
    
    func addZombie(_ platformToSpawnOn : Platform)
    {
        
        
        var Zombie: Enemy
        
        Zombie = Enemy(imageNamed:"newZombie")
        
        Zombie.size.height = 50
        Zombie.size.width = 50
        
        let zombieYPos : CGFloat = 120
        
        let spawnY = platformToSpawnOn.position.y + platformToSpawnOn.size.height/2 + Zombie.size.height/2
        
        Zombie.position = CGPoint(x: CGFloat(size.width + platformToSpawnOn.size.width), y: spawnY)
        
        // Zombie
        
        Zombie.physicsBody = SKPhysicsBody(texture: Zombie.texture!, size: Zombie.size)
        Zombie.physicsBody?.isDynamic = true
        Zombie.physicsBody?.categoryBitMask = BodyType.Zombie
        Zombie.physicsBody?.contactTestBitMask = BodyType.Bullet | BodyType.Hero | BodyType.Platform
        Zombie.physicsBody?.collisionBitMask = BodyType.Bullet | BodyType.Hero | BodyType.Platform
        Zombie.physicsBody?.restitution = 0
        Zombie.physicsBody?.allowsRotation = false
        Zombie.physicsBody?.mass = 100
        
        
        addChild(Zombie)
        
        var moveZombie: SKAction
        
        moveZombie = SKAction.moveTo(x: -Zombie.size.width/2, duration: zombieDuration)
            
        Zombie.run(SKAction.sequence([moveZombie, SKAction.removeFromParent()]))
        
        
        //second zombie
        
        var Zombie2: Enemy
        
        Zombie2 = Enemy(imageNamed:"newZombie")
        
        Zombie2.size.height = 50
        Zombie2.size.width = 50
        
        let zombieYPos2 : CGFloat = 120
        
        let spawnOnFloor = 15 + Zombie2.size.height
        
        Zombie2.position = CGPoint(x: size.width, y: spawnOnFloor)
        
        // Zombie
        
        Zombie2.physicsBody = SKPhysicsBody(texture: Zombie2.texture!, size: Zombie2.size)
        Zombie2.physicsBody?.isDynamic = true
        Zombie2.physicsBody?.categoryBitMask = BodyType.Zombie
        Zombie2.physicsBody?.contactTestBitMask = BodyType.Bullet | BodyType.Hero | BodyType.Platform
        Zombie2.physicsBody?.collisionBitMask = BodyType.Bullet | BodyType.Hero | BodyType.Platform
        Zombie2.physicsBody?.restitution = 0
        Zombie2.physicsBody?.allowsRotation = false
        Zombie2.physicsBody?.mass = 100
        
        
        addChild(Zombie2)
        
        var moveZombie2: SKAction
        
        moveZombie2 = SKAction.moveTo(x: -Zombie2.size.width/2, duration: zombieDuration)
        
        Zombie2.run(SKAction.sequence([moveZombie2, SKAction.removeFromParent()]))
        
        
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let bodyA = contact.bodyA
        
        let bodyB = contact.bodyB
        
        let contactA = bodyA.categoryBitMask
        
        let contactB = bodyB.categoryBitMask
        
        switch contactA {
            
        case BodyType.Zombie:
            
            switch contactB {
                
            case BodyType.Zombie:
                break
                
            case BodyType.Bullet:
                if let bodyBNode = contact.bodyB.node as? SKSpriteNode, let bodyANode = contact.bodyA.node as? Enemy {
                    bulletHitZombie(bodyBNode, Zombie: bodyANode)
                }
                
            case BodyType.Hero:
                if let bodyBNode = contact.bodyB.node as? SKSpriteNode, let bodyANode = contact.bodyA.node as? Enemy {
                    heroHitZombie(bodyBNode, Zombie: bodyANode)
                }
                
            default:
                break
            }
            
        case BodyType.Bullet:
            
            switch contactB {
                
            case BodyType.Zombie:
                if let bodyANode = contact.bodyA.node as? SKSpriteNode, let bodyBNode = contact.bodyB.node as? Enemy {
                    bulletHitZombie(bodyANode, Zombie: bodyBNode)
                }
                
            case BodyType.Bullet:
                break
                
            case BodyType.Hero:
                break
                
            default:
                break
            }
            
        case BodyType.Hero:
            
            switch contactB {
                
            case BodyType.Zombie:
                if let bodyANode = contact.bodyA.node as? SKSpriteNode, let bodyBNode = contact.bodyB.node as? Enemy {
                    heroHitZombie(bodyANode,Zombie: bodyBNode)
                }           
                
            case BodyType.Bullet:
                break     
                
            case BodyType.Hero:
                break       
                
            default:
                break
            }
            
        default:
            break
        }

    }
    


func bulletHitZombie(_ bullet:SKSpriteNode, Zombie: Enemy) {
    
    bullet.removeFromParent()
    
    Zombie.removeFromParent()
    
    explodeZombie(Zombie)
    
}



func heroHitZombie(_ player:SKSpriteNode, Zombie: SKSpriteNode){
    
  
    removeAllChildren()
    
    // Label Code
    let gameOverLabel = SKLabelNode(fontNamed: "Arial")
    
    gameOverLabel.text = "You Died"
    
    let end = Date()  // <<<<<<<<<<   end time
    
    
    timeElapsed = end.timeIntervalSince(start)
    

    
    gameOverLabel.fontColor = UIColor.black
    
    gameOverLabel.fontSize = 40
    
    gameOverLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
    
    
    
    
    
    
    addChild(gameOverLabel)
    
    let showScoreLabel = SKLabelNode(fontNamed: "Arial")
    
    showScoreLabel.text = "Score: \(Int(timeElapsed))"
    showScoreLabel.fontColor = UIColor.black
    
    showScoreLabel.fontSize = 40
    
    showScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2 - 75)
    
    addChild(showScoreLabel)

    
}
    
    func explodeZombie(_ Zombie: Enemy) {
        
          let explosions: [SKSpriteNode] = [SKSpriteNode(), SKSpriteNode(), SKSpriteNode(), SKSpriteNode(), SKSpriteNode()]
        
        for explosion in explosions {
            
            explosion.color = UIColor.red
            explosion.size = CGSize(width: 1, height: 1)
            explosion.position = CGPoint(x: Zombie.position.x, y: Zombie.position.y)
            
            addChild(explosion)
            
            let randomExplosionX = (random() * (1000 + size.width)) - size.width
            
            let randomExplosionY = (random() * (1000 + size.height)) - size.width
            
            let moveExplosion: SKAction
            
            moveExplosion = SKAction.move(to: CGPoint(x: randomExplosionX, y: randomExplosionY), duration: TimeInterval(10.0))
            
            explosion.run(SKAction.sequence([moveExplosion, SKAction.removeFromParent()]))
        
    }


}
   

}



