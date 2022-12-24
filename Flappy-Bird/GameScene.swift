//
//  GameScene.swift
//  Flappy-Bird
//
//  Created by 서정덕 on 2022/12/24.
//

import SpriteKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        // land라는 이미지 노드 생성
        let land = SKSpriteNode(imageNamed: "land")
        // 위치 잡아줌, 여기서 self는 메소드 정의된 클래스 인스턴스 말함
        land.position = CGPoint(x:self.size.width / 2, y: 50)
        // 숫자 클 수록 뒤로
        land.zPosition = 3
        // 씬에 노트 추가
        self.addChild(land)
        
        let sky = SKSpriteNode(imageNamed: "sky")
        sky.position = CGPoint(x:self.size.width / 2, y: 100)
        sky.zPosition = 1
        self.addChild(sky)
        
        let bird = SKSpriteNode(imageNamed: "bird")
        bird.position = CGPoint(x:self.size.width / 2, y: 200)
        bird.zPosition = 2
        self.addChild(bird)
        
        let ceiling = SKSpriteNode(imageNamed: "ceiling")
        ceiling.position = CGPoint(x:self.size.width / 2, y: 300)
        ceiling.zPosition = 3
        self.addChild(ceiling)
        
        let pipeUp = SKSpriteNode(imageNamed: "pipe")
        pipeUp.position = CGPoint(x:self.size.width / 2, y: 100)
        pipeUp.zPosition = 2
        self.addChild(pipeUp)
        
        let pipeDown = SKSpriteNode(imageNamed: "pipe")
        pipeDown.position = CGPoint(x:self.size.width / 2, y: self.size.height)
        pipeDown.zPosition = 2
        // y축에 대해서 좌우반전
        pipeDown.xScale = -1
        // pi라디안만큼 반 시계방향으로 돌리기
        pipeDown.zRotation = .pi
        self.addChild(pipeDown)
    }
}
