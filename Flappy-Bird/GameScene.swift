//
//  GameScene.swift
//  Flappy-Bird
//
//  Created by 서정덕 on 2022/12/24.
//

import SpriteKit

class GameScene: SKScene {
    
    var gameSpeed: Int = 5
    
    let land = SKSpriteNode(imageNamed: "land")
    // 뷰컨에 의해서 scene이 present되었을 때
    override func didMove(to view: SKView) {
        let bgColor = SKColor(red: 81.0/255.0, green: 892.0/255.0, blue: 201.0/255.0, alpha: 1.0)
        self.backgroundColor = bgColor
        createBird()
        createEnviroment()
        createInfinityPipe(duration: 4)
    }
    
    func createBird() {
        // 스프라이트 아틀라스

        
        let bird = SKSpriteNode(imageNamed: "bird1")
        bird.position = CGPoint(x:self.size.width / 2, y: self.size.height / 2)
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
        bird.physicsBody?.contactTestBitMask = PhysicsCategory.bird
        
    //  충돌, 접촉 판정할 요소 설정
        //   접촉
        bird.physicsBody?.contactTestBitMask = PhysicsCategory.land | PhysicsCategory.pipe | PhysicsCategory.ceiling | PhysicsCategory.score
        //  충돌
        bird.physicsBody?.collisionBitMask = PhysicsCategory.land | PhysicsCategory.pipe | PhysicsCategory.ceiling
        //  물리적 상호작용을 할 것인가요?
        bird.physicsBody?.isDynamic = true
        
        
        
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
            let moveLeft = SKAction.moveBy(x: -landTexture.size().width, y: 0, duration: TimeInterval(gameSpeed))
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
            let moveLeft = SKAction.moveBy(x: -sky.size.width, y: 0, duration: TimeInterval(gameSpeed * 2))
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
        let moveAct = SKAction.moveBy(x: -endPos, y: 0, duration: TimeInterval(gameSpeed) * (endPos / land.size.width))
        let moveSeq = SKAction.sequence([moveAct, SKAction.removeFromParent()])
        
        pipeDown.run(moveSeq)
        pipeUp.run(moveSeq)
        pipeCollision.run(moveSeq)
    }
    
    func createInfinityPipe(duration: TimeInterval){
        //  duration: 쉬는 시간
        let create = SKAction.run { [unowned self] in
            self.setPipe(pipeDistance: 100)
        }
        
        let wait = SKAction.wait(forDuration: duration)
        let actseq = SKAction.sequence([create,wait])
        run(SKAction.repeatForever(actseq))
    }
}
