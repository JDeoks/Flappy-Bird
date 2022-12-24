//
//  GameScene.swift
//  Flappy-Bird
//
//  Created by 서정덕 on 2022/12/24.
//

import SpriteKit

class GameScene: SKScene {
    
    // 뷰컨에 의해서 scene이 present되었을 때
    override func didMove(to view: SKView) {
        let bgColor = SKColor(red: 81.0/255.0, green: 892.0/255.0, blue: 201.0/255.0, alpha: 1.0)
        self.backgroundColor = bgColor
        createBird()
        createEnviroment()
        setupPipe()
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
            self.addChild(land)
            
            //애니메이션 주기
            //20초동안 설정한 방향으로 이동
            //moveBy: 현재 좌표를 기준으로 설정한 좌표로 움직임 지속시간동안에 걸쳐서
            let moveLeft = SKAction.moveBy(x: -landTexture.size().width, y: 0, duration: 20)
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
            let moveLeft = SKAction.moveBy(x: -sky.size.width, y: 0, duration: 40)
            let moveReset = SKAction.moveBy(x: sky.size.width, y: 0, duration: 0)
            // 두 가지의 skaction으로 배열만들어서 액션시퀀스 생성
            let moveSequence = SKAction.sequence([moveLeft, moveReset])
            let moveSequenceForever = SKAction.repeatForever(moveSequence)
            sky.run(moveSequenceForever)
            
        }
        

    //  ceiling 반복
        
        let ceilingTexture = envAtlas.textureNamed("ceiling")
        let ceilingRepeatNum = Int(ceil(self.size.width / ceilingTexture.size().width))
        
        for i in 0...ceilingRepeatNum {
            let landTexture = envAtlas.textureNamed("land")
            let land = SKSpriteNode(texture: landTexture)
            let ceiling = SKSpriteNode(texture: ceilingTexture)
            ceiling.anchorPoint = CGPoint(x: 0, y: 1)
            ceiling.position = CGPoint(x: CGFloat(i) * ceiling.size.width, y: self.size.height)
            let moveLeft = SKAction.moveBy(x: -ceiling.size.width, y: 0, duration: 20 * (ceiling.size.width / land.size.width))
            let moveReset = SKAction.moveBy(x: ceiling.size.width, y: 0, duration: 0)
            let moveSequence = SKAction.sequence([moveLeft, moveReset])
            let moveSequenceForever = SKAction.repeatForever(moveSequence)
            self.addChild(ceiling)
            ceiling.run(moveSequenceForever)
        }
        

    }
    
    func setupPipe() {
        let pipeUp = SKSpriteNode(imageNamed: "pipe")
        pipeUp.position = CGPoint(x:self.size.width / 2, y: 100)
        pipeUp.zPosition = Layer.pipe
        self.addChild(pipeUp)
        
        let pipeDown = SKSpriteNode(imageNamed: "pipe")
        pipeDown.position = CGPoint(x:self.size.width / 2, y: self.size.height)
        pipeDown.zPosition = Layer.pipe
        // y축에 대해서 좌우반전
        pipeDown.xScale = -1
        // pi라디안만큼 반 시계방향으로 돌리기
        pipeDown.zRotation = .pi
        self.addChild(pipeDown)
    }
}
