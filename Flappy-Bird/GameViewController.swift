//
//  GameViewController.swift
//  Flappy-Bird
//
//  Created by 서정덕 on 2022/12/24.
//

import SpriteKit


class GameViewController: UIViewController {

    override func viewDidLoad() {
        // 뷰가 로드된 뒤 제일 먼저 실행
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // GameScene이라는 SKScene 클래스 인스턴스 가져옴
            let scene = GameScene(size: view.bounds.size)
            // scaleMode를 눕혔을때 위아래를 자르는 aspectFill로 설정
            scene.scaleMode = .aspectFill
            
            // view에 scene 표시
            view.presentScene(scene)
            
            // 노드들의 생성순서를 컴파일러에게 맡김
            view.ignoresSiblingOrder = true
            
            // 화면 우측 하단에 FPS 표시
            view.showsFPS = true
            // 화면 우측 하단에 노드 개수 표시
            view.showsNodeCount = true
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
//    override var shouldAutorotate: Bool {
//        return true
//    }
//    iOS 16 부터 쓰이지 않음
    
    override var prefersStatusBarHidden: Bool {
        //시계있는 상태바 없애기
        return true
    }
    
    
}
