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
    case Foreground
    case Player
}

class GameScene: SKScene {
    // MARK: - 常量
    let kGravity:CGFloat = -100.0    //重力
    let kImpulse:CGFloat = 80        //上升力
    
    let FOREGROUND_SPEED:CGFloat = -40.0
    let FOREGROUND_NAME = "foreground"
    
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
    
    let player = SKSpriteNode(imageNamed: "Bird0")
    
    var lastUpdateTime :NSTimeInterval = 0    //记录上次更新时间
    var dt:NSTimeInterval = 0                //两次时间差值
    var playerVelocity = CGPoint.zero    //速度 注意变量类型为一个点
    
    override func didMoveToView(view: SKView) {
        addChild(worldNode)
        setupBackground()
        setupForeground()
        setupPlayer()
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
        worldNode.addChild(player)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        flapPlayer()
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
        
        updatePlayer()
        updateForeground()
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
            node.position.x += CGFloat( self.dt ) * self.FOREGROUND_SPEED
            if node.position.x + self.size.width < 0 {
                node.position.x += 2 * self.size.width
            }
        }
    }
}
