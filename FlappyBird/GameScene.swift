//
//  GameScene.swift
//  FlappyBird
//
//  Created by pmst on 15/10/4.
//  Copyright (c) 2015年 pmst. All rights reserved.
//

import SpriteKit

enum Layer: CGFloat {
    case Background
    case Obstacle
    case Foreground
    case Player
}

enum GameState{
    case MainMenu
    case Tutorial
    case Play
    case Falling
    case ShowingScore
    case GameOver
}

struct PhysicsCategory {
    static let None: UInt32 = 0
    static let Player: UInt32 =     0b1 // 1
    static let Obstacle: UInt32 =  0b10 // 2
    static let Ground: UInt32 =   0b100 // 4
}

class GameScene: SKScene, SKPhysicsContactDelegate{
    // MARK: - 常量
    let kGravity:CGFloat = -100.0    //重力
    let kImpulse:CGFloat = 80        //上升力
    let kGroundSpeed: CGFloat = 150.0
    
    //新增三个常量
    let kBottomObstacleMinFraction: CGFloat = 0.1
    let kBottomObstacleMaxFraction: CGFloat = 0.6
    let kGapMultiplier: CGFloat = 3.5
    
    // Constants for Foreground
    let FOREGROUND_NAME = "foreground"
    
    // Constants for Obstacle
    let OBSTACLE_NAME = "obstacle"
    
    let worldNode = SKNode()
    var playableStart:CGFloat = 0
    var playableHeight:CGFloat = 0
    
    // MARK: 音乐Action
    let dingAction = SKAction.playSoundFileNamed("ding.wav", waitForCompletion: false)
    let flapAction = SKAction.playSoundFileNamed("flapping.wav", waitForCompletion: false)
    let whackAction = SKAction.playSoundFileNamed("whack.wav", waitForCompletion: false)
    let fallingAction = SKAction.playSoundFileNamed("falling.wav", waitForCompletion: false)
    let hitGroundAction = SKAction.playSoundFileNamed("hitGround.wav", waitForCompletion: false)
    let popAction = SKAction.playSoundFileNamed("pop.wav", waitForCompletion: false)
    let coinAction = SKAction.playSoundFileNamed("coin.wav", waitForCompletion: false)
    
    let player = SKSpriteNode(imageNamed: "bird0")
    
    var lastUpdateTime :NSTimeInterval = 0    //记录上次更新时间
    var dt:NSTimeInterval = 0                //两次时间差值
    var playerVelocity = CGPoint.zero    //速度 注意变量类型为一个点
    
    var lastObstaclePosition = 0
    
    let sombrero = SKSpriteNode(imageNamed: "Sombrero")
    //1
    var hitGround = false
    //2
    var hitObstacle = false
    //3
    var gameState: GameState = .Play
    
    override func didMoveToView(view: SKView) {
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        addChild(worldNode)
        setupBackground()
        setupForeground()
        setupPlayer()
        
        startSpawning()
        
        flapPlayer()
    }
    
    func setupBackground(){
        // 1
        let background = SKSpriteNode(imageNamed: "Background")
        background.anchorPoint = CGPointMake(0.5, 1)
        background.position = CGPointMake(size.width/2.0, size.height)
        background.zPosition = Layer.Background.rawValue
        worldNode.addChild(background)
        
        // 2
        playableStart = size.height - background.size.height
        playableHeight = background.size.height
        
        let lowerLeft = CGPoint(x: 0, y: playableStart)//地板表面的最左侧一点
        let lowerRight = CGPoint(x: size.width, y: playableStart) //地板表面的最右侧一点
        // 1
        self.physicsBody = SKPhysicsBody(edgeFromPoint: lowerLeft, toPoint: lowerRight)
        self.physicsBody?.categoryBitMask = PhysicsCategory.Ground
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Player
    }
    
    func setupForeground() {
        for i in 0..<2 {
            let foreground = SKSpriteNode(imageNamed: "Ground")
            foreground.anchorPoint = CGPoint(x: 0, y: 1)
            foreground.position = CGPoint(x: 0 + CGFloat( i ) * size.width, y: playableStart)
            foreground.zPosition = Layer.Foreground.rawValue
            foreground.name = FOREGROUND_NAME
            worldNode.addChild(foreground)
        }
    }
    
    func setupPlayer(){
        player.position = CGPointMake(size.width * 0.2, playableHeight * 0.4 + playableStart)
        player.zPosition = Layer.Player.rawValue
        
        let offsetX = player.size.width * player.anchorPoint.x
        let offsetY = player.size.height * player.anchorPoint.y
        
        let path = CGPathCreateMutable()
        
        CGPathMoveToPoint(path, nil, 17 - offsetX, 23 - offsetY)
        CGPathAddLineToPoint(path, nil, 39 - offsetX, 22 - offsetY)
        CGPathAddLineToPoint(path, nil, 38 - offsetX, 10 - offsetY)
        CGPathAddLineToPoint(path, nil, 21 - offsetX, 0 - offsetY)
        CGPathAddLineToPoint(path, nil, 4 - offsetX, 1 - offsetY)
        CGPathAddLineToPoint(path, nil, 3 - offsetX, 15 - offsetY)
        
        CGPathCloseSubpath(path)
        
        player.physicsBody = SKPhysicsBody(polygonFromPath: path)
        player.physicsBody?.categoryBitMask = PhysicsCategory.Player
        player.physicsBody?.collisionBitMask = 0
        player.physicsBody?.contactTestBitMask = PhysicsCategory.Obstacle | PhysicsCategory.Ground
        
        worldNode.addChild(player)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        switch gameState {
        case .MainMenu:
            break
        case .Tutorial:
            break
        case .Play:
            flapPlayer()
            break
        case .Falling:
            break
        case .ShowingScore:
            switchToNewGame()
            break
        case .GameOver:
            break
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let other = contact.bodyA.categoryBitMask == PhysicsCategory.Player ? contact.bodyB : contact.bodyA
        
        if other.categoryBitMask == PhysicsCategory.Ground {
            hitGround = true
        }
        if other.categoryBitMask == PhysicsCategory.Obstacle {
            hitObstacle = true
        }
    }
    
    func createObstacle()->SKSpriteNode{
        let sprite = SKSpriteNode(imageNamed: "Cactus")
        sprite.zPosition = Layer.Obstacle.rawValue
        
        let offsetX = sprite.size.width * sprite.anchorPoint.x
        let offsetY = sprite.size.height * sprite.anchorPoint.y
        
        let path = CGPathCreateMutable()
        
        CGPathMoveToPoint(path, nil, 3 - offsetX, 0 - offsetY)
        CGPathAddLineToPoint(path, nil, 5 - offsetX, 309 - offsetY)
        CGPathAddLineToPoint(path, nil, 16 - offsetX, 315 - offsetY)
        CGPathAddLineToPoint(path, nil, 39 - offsetX, 315 - offsetY)
        CGPathAddLineToPoint(path, nil, 51 - offsetX, 306 - offsetY)
        CGPathAddLineToPoint(path, nil, 49 - offsetX, 1 - offsetY)
        
        CGPathCloseSubpath(path)
        
        sprite.physicsBody = SKPhysicsBody(polygonFromPath: path)
        sprite.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
        sprite.physicsBody?.collisionBitMask = 0
        sprite.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        
        return sprite
    }
    
    func spawnObstacle(){
        //1
        let bottomObstacle = createObstacle()    //实例化一个精灵
        bottomObstacle.name = "BottomObstacle"
        let startX = size.width + bottomObstacle.size.width/2//x轴位置为屏幕最右侧
        //2
        let bottomObstacleMin = (playableStart - bottomObstacle.size.height/2) + playableHeight * kBottomObstacleMinFraction    //计算障碍物超出地表的最小距离
        let bottomObstacleMax = (playableStart - bottomObstacle.size.height/2) + playableHeight * kBottomObstacleMaxFraction //计算障碍物超出地表的最大距离
        bottomObstacle.position = CGPointMake(startX, CGFloat.random(min: bottomObstacleMin, max: bottomObstacleMax))    // 随机生成10%~60%的一个距离赋值给position
        worldNode.addChild(bottomObstacle)    //添加到世界节点中
        //3
        let topObstacle = createObstacle()    //实例化一个精灵
        topObstacle.name = "TopObstacle"
        topObstacle.zRotation = CGFloat(180).degreesToRadians()//翻转180°
        topObstacle.position = CGPoint(x: startX, y: bottomObstacle.position.y + bottomObstacle.size.height/2 + topObstacle.size.height/2 + player.size.height * kGapMultiplier)//设置y位置 相距3.5倍的Player尺寸距离
        worldNode.addChild(topObstacle)//添加至世界节点中
        //4 给障碍物添加动作
        let moveX = size.width + topObstacle.size.width
        let moveDuration = moveX / kGroundSpeed
        let sequence = SKAction.sequence([
            SKAction.moveByX(-moveX, y: 0, duration: NSTimeInterval(moveDuration)),
            SKAction.removeFromParent()
            ])
        topObstacle.runAction(sequence)
        bottomObstacle.runAction(sequence)
    }
    
    func startSpawning(){
        //1
        let firstDelay = SKAction.waitForDuration(1.75)
        //2
        let spawn = SKAction.runBlock(spawnObstacle)
        //3
        let everyDelay = SKAction.waitForDuration(1.5)
        //4
        let spawnSequence = SKAction.sequence([
            spawn,everyDelay
            ])
        //5
        let foreverSpawn = SKAction.repeatActionForever(spawnSequence)
        //6
        let overallSequence = SKAction.sequence([firstDelay,foreverSpawn])
        runAction(overallSequence, withKey: "spawn")
    }
    
    func stopSpawning() {
        
        removeActionForKey("spawn")
        
        worldNode.enumerateChildNodesWithName("TopObstacle", usingBlock: { node, stop in
            node.removeAllActions()
        })
        worldNode.enumerateChildNodesWithName("BottomObstacle", usingBlock: { node, stop in
            node.removeAllActions()
        })
    }
    
    func flapPlayer(){
        // 发出一次煽动翅膀的声音
        runAction(flapAction)
        // 重新设定player的速度！！
        playerVelocity  = CGPointMake(0, kImpulse)
    }
   
    override func update(currentTime: CFTimeInterval) {
        if lastUpdateTime > 0{
            dt = currentTime - lastUpdateTime
        }else{
            dt = 0
        }
        lastUpdateTime = currentTime
        print("时间差值为:\(dt*1000) 毫秒")
        
        switch gameState {
        case .MainMenu:
            break
        case .Tutorial:
            break
        case .Play:
            updateForeground()
            updatePlayer()
            //1
            checkHitObstacle()    //Play状态下检测是否碰撞了障碍物
            //2
            checkHitGround()    //Play状态下检测是否碰撞了地面
            break
        case .Falling:
            updatePlayer()
            //3
            checkHitGround()    //Falling状态下检测是否掉落至地面 此时已经失败了
            break
        case .ShowingScore:
            break
        case .GameOver:
            break
        }
    }
    
    // 与障碍物发生碰撞
    func checkHitObstacle() {
        if hitObstacle {
            hitObstacle = false
            switchToFalling()
        }
    }
    // 掉落至地面
    func checkHitGround() {
        
        if hitGround {
            hitGround = false
            playerVelocity = CGPoint.zero
            player.zRotation = CGFloat(-90).degreesToRadians()
            player.position = CGPoint(x: player.position.x, y: playableStart + player.size.width/2)
            runAction(hitGroundAction)
            switchToShowScore()
        }
    }
    
    // MARK: - Game States
    // 由Play状态变为Falling状态
    func switchToFalling() {
        
        gameState = .Falling
        
        runAction(SKAction.sequence([
            whackAction,
            SKAction.waitForDuration(0.1),
            fallingAction
            ]))
        
        player.removeAllActions()
        stopSpawning()
        
    }
    // 显示分数状态
    func switchToShowScore() {
        gameState = .ShowingScore
        player.removeAllActions()
        stopSpawning()
    }
    // 重新开始一次游戏
    func switchToNewGame() {
        
        runAction(popAction)
        
        let newScene = GameScene(size: size)
        let transition = SKTransition.fadeWithColor(SKColor.blackColor(), duration: 0.5)
        view?.presentScene(newScene, transition: transition)
        
    }
    
    func updatePlayer(){
        print( "Trying to update player.")
        // 只有Y轴上的重力加速度为-1500
        let gravity = CGPoint(x: 0, y: kGravity)
        let gravityStep = gravity * CGFloat(dt) //计算dt时间下速度的增量
        playerVelocity += gravityStep           //计算当前速度
        
        // 位置计算
        let velocityStep = playerVelocity * CGFloat(dt) //计算dt时间中下落或上升距离
        player.position += velocityStep                 //计算player的位置
        
        // 倘若Player的Y坐标位置在地面上了就不能再下落了 直接设置其位置的y值为地面的表层坐标
        if player.position.y - player.size.height/2 < playableStart {
            player.position = CGPoint(x: player.position.x, y: playableStart + player.size.height/2)
        }
    }
    
    func updateForeground(){
        worldNode.enumerateChildNodesWithName( FOREGROUND_NAME ){(node, stop) -> Void in
            if let foregoundNode = node as? SKSpriteNode {
                foregoundNode.position.x -= CGFloat( self.dt ) * self.kGroundSpeed
                if foregoundNode.position.x + self.size.width < 0 {
                    foregoundNode.position.x += 2 * self.size.width
                }
            }
        }
    }
}
