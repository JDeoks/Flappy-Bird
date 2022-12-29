//
//  GameScene.swift
//  Flappy-Bird
//
//  Created by 서정덕 on 2022/12/24.
//

import SpriteKit

enum GameState {
    case ready
    case playing
    case dead
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let cameraNode =  SKCameraNode()
    var bgmPlayer = SKAudioNode()
    var gameSpeed: TimeInterval = 2
    var bird = SKSpriteNode()
    let land = SKSpriteNode(imageNamed: "land")
    var gamestate = GameState.ready
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "\(score)"
        }
    }
    var scoreLabel = SKLabelNode()
    

    // 뷰컨에 의해서 scene이 present되었을 때
    override func didMove(to view: SKView) {
        

        let bgColor = SKColor(red: 114.0/255.0, green: 130.0/255.0, blue: 205.0/255.0, alpha: 1.0)
        self.backgroundColor = bgColor
        
        //  접촉 델리게이트
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        
        createBird()
        createEnviroment()
        createScore()
        
        bgmPlayer = SKAudioNode(fileNamed: "bgm.mp3")
        bgmPlayer.autoplayLooped = true
        self.addChild(bgmPlayer)
        // 카메라 추가
        camera = cameraNode
        cameraNode.position.x = self.size.width / 2
        cameraNode.position.y = self.size.height / 2
        self.addChild(cameraNode)

    }
    
    // MARK: -  스프라이트 생성
    func createScore() {
        scoreLabel = SKLabelNode()
        scoreLabel.fontSize = 30
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: self.size.width / 2 , y: self.size.height - 100)
        scoreLabel.zPosition = Layer.hud
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.text = "\(score)"

        addChild(scoreLabel)
    }
    
    func createBird() {
        // 스프라이트 아틀라스

        
        bird = SKSpriteNode(imageNamed: "bird1")
        bird.position = CGPoint(x:self.size.width / 4, y: self.size.height / 2)
        bird.zPosition = Layer.bird
        self.addChild(bird)
        
//    // 애니메이션 부분
//        let birdTexture = SKTextureAtlas(named: "Bird")
//        // 스프라이트 아틀라스 요소 SKTexture배열에 추가
//        var aniArray = [SKTexture]()
//        for i in 1...birdTexture.textureNames.count {
//            aniArray.append(SKTexture(imageNamed: "bird\(i)"))
//        }
//        let flyingAnimation = SKAction.animate(with: aniArray, timePerFrame: 0.1)
//        // 영원히 반복하는 SKAction 만들기
//        let flyingForever = SKAction.repeatForever(flyingAnimation)
//        //bird가 해당 액션 수행하게 함
//        bird.run(flyingForever)
//
    //  히트박스 구현
        //  버드 스프라이트에 대해서 물리바디를 설정해줄 것임
        //  스프라이트의 center에서 반지름 범위 만큼의 히트박스 생성
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.width / 2)
        //  constants.swift에 있는 PhysicsCategory사용해서 contactTestBitMask 설정
        bird.physicsBody?.categoryBitMask = PhysicsCategory.bird
        
    //  충돌, 접촉 판정할 요소 설정
        //   접촉
        bird.physicsBody?.contactTestBitMask = PhysicsCategory.land | PhysicsCategory.pipe | PhysicsCategory.ceiling | PhysicsCategory.score
        //  충돌
        bird.physicsBody?.collisionBitMask = PhysicsCategory.land | PhysicsCategory.pipe | PhysicsCategory.ceiling
        //  물리적 상호작용을 할 것인가요?
        bird.physicsBody?.isDynamic = false
        
        
        
    // SpriteKit Action으로 액션 구현
        guard let flyingBySKS = SKAction(named: "flying") else { return }
        bird.run(flyingBySKS)
    }
    
    func createEnviroment() {
        
        // Enviroment아틀라스 불러오기
        let envAtlas = SKTextureAtlas(named: "Enviroment")
        let landTexture = envAtlas.textureNamed("land")
        //화면크기에 따라 반복할 땅의 수 설정함 ceil로 무조건 화면크기보다 많은 땅 개수 반복시킴
        let landRepeatNum = Int(ceil(self.size.width / landTexture.size().width))
    
    //  land 반복
        for i in 0...landRepeatNum {
            // 텍스쳐 이용해서 스프라이트 노드 만들기
            let land = SKSpriteNode(texture: landTexture)
            land.anchorPoint = CGPoint.zero
            land.position = CGPoint(x: CGFloat(i) * land.size.width, y: 0)
            land.zPosition = Layer.land
            
        //  physicsbody 주기
            land.physicsBody = SKPhysicsBody(rectangleOf: land.size, center: CGPoint(x: land.size.width / 2, y: land.size.height / 2))
            //  카테고리비트마스크 주기
            land.physicsBody?.categoryBitMask = PhysicsCategory.land
            // 충돌했을 때 튕겨나감 여부
            land.physicsBody?.isDynamic = false
            //  중력의 영향 받는지 여부
            land.physicsBody?.affectedByGravity = false
            //  요소 씬에 추가
            self.addChild(land)

        //  애니메이션 주기
            //20초동안 설정한 방향으로 이동
            //moveBy: 현재 좌표를 기준으로 설정한 좌표로 움직임 지속시간동안에 걸쳐서
            let moveLeft = SKAction.moveBy(x: -landTexture.size().width, y: 0, duration: gameSpeed)
            let moveReset = SKAction.moveBy(x: landTexture.size().width, y: 0, duration: 0)
            // 두 가지의 skaction으로 배열만들어서 액션시퀀스 생성
            let moveSequence = SKAction.sequence([moveLeft, moveReset])
            let moveSequenceForever = SKAction.repeatForever(moveSequence)
            land.run(moveSequenceForever)
        }
        
//        // land라는 이미지 노드 생성
//        let land = SKSpriteNode(imageNamed: "land")
//        // 위치 잡아줌, 여기서 self는 메소드 정의된 클래스 인스턴스 말함
//        land.position = CGPoint(x:self.size.width / 2, y: 50)
//        // 숫자 클 수록 뒤로
//        land.zPosition = 3
//        // 씬에 노트 추가
//        self.addChild(land)
        
    //  sky반복
        let skyTexture = envAtlas.textureNamed("sky")
        let skyRepeatNum = Int(ceil(self.size.width / skyTexture.size().width))
         
        for i in 0...skyRepeatNum {
            let sky = SKSpriteNode(texture: skyTexture)
            sky.anchorPoint = CGPoint(x: 0, y: 0)
            sky.position = CGPoint(x: CGFloat(i) * sky.size.width, y: envAtlas.textureNamed("land").size().height)
            sky.zPosition = Layer.sky

            self.addChild(sky)
            let moveLeft = SKAction.moveBy(x: -sky.size.width, y: 0, duration: gameSpeed * 2)
            let moveReset = SKAction.moveBy(x: sky.size.width, y: 0, duration: 0)
            // 두 가지의 skaction으로 배열만들어서 액션시퀀스 생성
            let moveSequence = SKAction.sequence([moveLeft, moveReset])
            let moveSequenceForever = SKAction.repeatForever(moveSequence)
            sky.run(moveSequenceForever)
            
        }
        

    //  ceiling 반복
        
        let ceilingTexture = envAtlas.textureNamed("ceiling")
        let ceilingRepeatNum = Int(ceil(self.size.width / ceilingTexture.size().width))
        let land = SKSpriteNode(texture: landTexture)
        for i in 0...ceilingRepeatNum {
            let ceiling = SKSpriteNode(texture: ceilingTexture)
            ceiling.anchorPoint = CGPoint(x: 0, y: 1)
            // 앵커포인트가
            ceiling.position = CGPoint(x: CGFloat(i) * ceiling.size.width, y: self.size.height)
            ceiling.zPosition = Layer.ceiling
            
        //  physicsbody 주기
            //  앵커포인트 기준으로 좌표만큼 떨어진 자리를 센터로 갖는 사각형을 히트박스로 설정함
            ceiling.physicsBody = SKPhysicsBody(rectangleOf: ceiling.size, center: CGPoint(x: ceiling.size.width / 2, y: -ceiling.size.height / 2))
            ceiling.physicsBody?.categoryBitMask = PhysicsCategory.ceiling
            ceiling.physicsBody?.isDynamic = false
            ceiling.physicsBody?.affectedByGravity = false
            
        
            let moveLeft = SKAction.moveBy(x: -ceiling.size.width, y: 0, duration: CGFloat(gameSpeed) * (ceiling.size.width / land.size.width))
            let moveReset = SKAction.moveBy(x: ceiling.size.width, y: 0, duration: 0)
            let moveSequence = SKAction.sequence([moveLeft, moveReset])
            let moveSequenceForever = SKAction.repeatForever(moveSequence)
            self.addChild(ceiling)
            ceiling.run(moveSequenceForever)
        }
        

    }
    

    func setPipe(pipeDistance: CGFloat) {
        // pipeDistance 파이프 사이의 거리
    //  스프라이트 생성
        let envAtlas = SKTextureAtlas(named: "Enviroment")
        let pipeTexture = envAtlas.textureNamed("pipe")
        
        let pipeDown = SKSpriteNode(texture: pipeTexture)
        pipeDown.zPosition = Layer.pipe
        pipeDown.physicsBody = SKPhysicsBody(rectangleOf: pipeDown.size)
        pipeDown.physicsBody?.categoryBitMask = PhysicsCategory.pipe
        pipeDown.physicsBody?.isDynamic = false
        pipeDown.physicsBody?.affectedByGravity = false
        
        let pipeUp = SKSpriteNode(texture: pipeTexture)
        //  x축을 n배 늘림 -1이면 좌우 반전
        pipeUp.xScale = -1
        //  pi라디안만큼 반 시계방향으로 돌리기
        pipeUp.zRotation = CGFloat.pi
        
        pipeUp.zPosition = Layer.pipe
        pipeUp.physicsBody = SKPhysicsBody(rectangleOf: pipeDown.size)
        pipeUp.physicsBody?.categoryBitMask = PhysicsCategory.pipe
        pipeUp.physicsBody?.isDynamic = false
        pipeUp.physicsBody?.affectedByGravity = false
        
        let pipeCollision = SKSpriteNode(color: UIColor.red, size: CGSize(width: 3, height: self.size.height))
        pipeCollision.zPosition = Layer.pipe
        pipeCollision.physicsBody = SKPhysicsBody(rectangleOf: pipeCollision.size)
        pipeCollision.physicsBody?.categoryBitMask = PhysicsCategory.score
        pipeCollision.physicsBody?.isDynamic = false
        pipeCollision.physicsBody?.affectedByGravity = false
        pipeCollision.name = "pipeCollision"
        
        self.addChild(pipeUp)
        self.addChild(pipeDown)
        self.addChild(pipeCollision)
        
        
    //  스프라이트 배치
        // 화면 세로 크기의 0.3
        let max: CGFloat = self.size.height * 0.3
        //  x좌표는 화면 밖에서 나오도록 화면 너비+토관 너비
        let xPos: CGFloat = self.size.width + pipeUp.size.width
        //  y좌표는 땅 높이 + (0 ~ 화면 세로 * 0.3)
        let yPos: CGFloat = CGFloat(arc4random_uniform(UInt32(max))) + envAtlas.textureNamed("land").size().height
        let endPos: CGFloat = self.size.width + (pipeDown.size.width * 2)
        // 아래에 있는 파이프는
        pipeDown.position = CGPoint(x: xPos, y: yPos)
        pipeUp.position = CGPoint(x: xPos, y: pipeDown.position.y + pipeDistance + pipeUp.size.height)
        pipeCollision.position = CGPoint(x: xPos, y: self.size.height / 2)
        
    // 파이프에 SKAction 추가
        let moveAct = SKAction.moveBy(x: -endPos, y: 0, duration: gameSpeed * (endPos / land.size.width))
        let moveSeq = SKAction.sequence([moveAct, SKAction.removeFromParent()])
        
        pipeDown.run(moveSeq)
        pipeUp.run(moveSeq)
        pipeCollision.run(moveSeq)
    }
    
    func createInfinityPipe(duration: TimeInterval){
        //  duration: 쉬는 시간
        let create = SKAction.run { [unowned self] in
            self.setPipe(pipeDistance: 150)
        }
        
        let wait = SKAction.wait(forDuration: duration)
        let actseq = SKAction.sequence([create,wait])
        run(SKAction.repeatForever(actseq))
    }
    // MARK: - 게임 알고리즘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        switch gamestate {
        case .ready:
            gamestate = .playing
            self.bird.physicsBody?.isDynamic = true
            self.bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 20))
            createInfinityPipe(duration: 2)

        case .playing:
            self.run(SoundFX.wing)
            self.bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            self.bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 20))
        case .dead:
            //  파라미터인 touches의 제일 첫 번째 요소를 가져옴
            let touch: UITouch? = touches.first
            if let location = touch?.location(in: self){
                let nodesArray = self.nodes(at: location)
                if nodesArray.first?.name == "restartBtn"{
                    self.run(SoundFX.swooshing)
                    let scene: GameScene = GameScene(size: self.size)
                    let transition: SKTransition = SKTransition.doorsOpenHorizontal(withDuration: 1)
                    self.view?.presentScene(scene, transition: transition)
                }
            }

        }
        

    }
    
    
    //  두 바디가 서로 처음 접촉할 때 호출되는 함수
    func didBegin(_ contact: SKPhysicsContact) {
//        print("didBegin")
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        let collideType = secondBody.categoryBitMask
//        print(firstBody.categoryBitMask)
//        print(secondBody.categoryBitMask)
        switch collideType {
        case PhysicsCategory.land:
            print("land")
            if gamestate == .playing{
                gameOver()
            }
        case PhysicsCategory.pipe:
            print("pipe")
            if gamestate == .playing{
                gameOver()
            }
        case PhysicsCategory.ceiling:
            print("ceiling")
            if gamestate == .playing{
                gameOver()
            }
        case PhysicsCategory.score:
            self.run(SoundFX.point)
            print("score")
            score += 1
            
        default:
            print("default")
        }
        
    }
    
    func gameOver() {
        damageEffect()
        cameraShake()
        self.bird.removeAllActions()
        createGameOverBoard()
        self.bgmPlayer.run(SKAction.stop())
        self.gamestate = .dead

        //self.isPaused = true
    }
    // 최고기록 앱 내에 저장
    func recordBestScore() {
        let userDefault = UserDefaults.standard
        var bestScore = userDefault.integer(forKey: "highScore")
        if self.score > bestScore {
            bestScore = self.score
            userDefault.set(bestScore, forKey: "highScore")
        }
        userDefault.synchronize()
    }
    //  게임 오버했을 때 점수판 띄움
    func createGameOverBoard() {
        // 최고기록 업데이트
        recordBestScore()
        let gameOverBoard = SKSpriteNode(imageNamed: "gameoverBoard")
        gameOverBoard.position = CGPoint(x: self.size.width / 2, y:  -self.size.height / 2)
        gameOverBoard.zPosition = Layer.hud
        addChild(gameOverBoard)
        
        // 메달 표시
        var medal = SKSpriteNode()
        if score >= 10{
            medal = SKSpriteNode(imageNamed: "medalPlatinum")
        }
        else if score >= 5 {
            medal = SKSpriteNode(imageNamed: "medalGold")
        }
        else if score >= 3 {
            medal = SKSpriteNode(imageNamed: "medalSilver")
        }
        else if score >= 1 {
            medal = SKSpriteNode(imageNamed: "medalBronze")
        }
        medal.position = CGPoint(x: -gameOverBoard.size.width * 0.27, y: gameOverBoard.size.height * 0.02)
        gameOverBoard.addChild(medal)
        
        // 현재 스코어 라벨
        let scoreLabel = SKLabelNode()
        scoreLabel.fontSize = 13
        scoreLabel.fontColor = .orange
        scoreLabel.text = "\(self.score)"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: gameOverBoard.size.width * 0.35, y: gameOverBoard.size.height * 0.07)
        // 이렇게 하면 zposition hud+0.1됨
        scoreLabel.zPosition = 0.1
        gameOverBoard.addChild(scoreLabel)
        
        //  bestScore 라벨 표시
        let bestScore = UserDefaults.standard.integer(forKey:  "highScore")
        let bestScoreLabel = SKLabelNode()
        bestScoreLabel.fontSize = 13
        bestScoreLabel.fontColor = .orange
        bestScoreLabel.text = "\(bestScore)"
        bestScoreLabel.horizontalAlignmentMode = .left
        bestScoreLabel.position = CGPoint(x: gameOverBoard.size.width * 0.35, y: -gameOverBoard.size.height * 0.07)
        gameOverBoard.addChild(bestScoreLabel)
        
        gameOverBoard.run(SKAction.sequence([SKAction.moveTo(y: self.size.height / 2, duration: 1), SKAction.run {
            self.speed = 0
        }]))
        
        
        let restartBtn = SKSpriteNode(imageNamed: "playBtn")
        //  이름을 붙이면 함수 외에서도 이 버튼을 호출 할 수 있음
        restartBtn.name = "restartBtn"
        restartBtn.position = CGPoint(x: 0, y: -gameOverBoard.size.height * 0.35)
        restartBtn.zPosition = 0.1
        gameOverBoard.addChild(restartBtn)
    }
    // 충돌했을 때 깜빡깜빡 효과
    func damageEffect() {
        let flashNode = SKSpriteNode(color: UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0), size: self.size)
        let actionSequence = SKAction.sequence([SKAction.wait(forDuration: 0.01), SKAction.removeFromParent()])
        flashNode.name = "flashNode"
        flashNode.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        flashNode.zPosition = Layer.hud
        addChild(flashNode)
        flashNode.run(actionSequence)
        let wait = SKAction.wait(forDuration: 1)
        let soundSequence = SKAction.sequence([SoundFX.hit, wait, SoundFX.die])
        self.run(soundSequence)
        
        // 게임 화면에 카메라 추가한 후 흔들기
    }
    
    func cameraShake() {
        let moveLeft = SKAction.moveTo(x: self.size.width / 2 - 5, duration: 0.1)
        let moveRight = SKAction.moveTo(x: self.size.width / 2 + 5, duration: 0.1)
        let moveReset = SKAction.moveTo(x: self.size.width / 2, duration: 0.1)

        let shakeAction = SKAction.sequence([moveLeft, moveRight, moveLeft, moveRight, moveReset])
        shakeAction.timingMode = .easeInEaseOut
        cameraNode.run(shakeAction)
    }
}


