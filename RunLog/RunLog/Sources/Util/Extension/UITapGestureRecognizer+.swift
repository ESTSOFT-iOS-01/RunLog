//
//  UITapGestureRecognizer+.swift
//  RunLog
//
//  Created by 도민준 on 3/25/25.
//

import UIKit
import Combine

extension UITapGestureRecognizer {
    /// UITapGestureRecognizer를 Combine에서 Publisher로 사용하기 위한 커스텀 구현
    struct TapPublisher: Publisher {
        typealias Output = UITapGestureRecognizer
        typealias Failure = Never
        
        private let gesture: UITapGestureRecognizer
        
        init(gesture: UITapGestureRecognizer) {
            self.gesture = gesture
        }
        
        func receive<S>(subscriber: S) where S: Subscriber, S.Failure == Failure, S.Input == Output {
            // Subscription 생성 후 Subscriber에 전달
            let subscription = TapGestureSubscription(gesture: gesture, subscriber: subscriber)
            subscriber.receive(subscription: subscription)
        }
        
        /// 내부 Subscription 객체
        private final class TapGestureSubscription<S: Subscriber>: NSObject, Subscription
        where S.Input == UITapGestureRecognizer, S.Failure == Never {
            
            private var subscriber: S?
            private let gesture: UITapGestureRecognizer
            
            init(gesture: UITapGestureRecognizer, subscriber: S) {
                self.gesture = gesture
                self.subscriber = subscriber
                super.init()
                
                // gesture가 발생하면 self의 handleTap 메서드가 호출됨
                gesture.addTarget(self, action: #selector(handleTap))
            }
            
            func request(_ demand: Subscribers.Demand) {
                // 수요(demand)에 따른 별도 처리 없음
            }
            
            func cancel() {
                // 구독이 취소되면 제스처의 target 제거
                gesture.removeTarget(self, action: #selector(handleTap))
                subscriber = nil
            }
            
            @objc private func handleTap() {
                // 제스처 발생 시 subscriber에게 이벤트 전달
                _ = subscriber?.receive(gesture)
            }
        }
    }
    
    /// UITapGestureRecognizer에서 TapPublisher를 만들 수 있도록 하는 프로퍼티
    var tapPublisher: TapPublisher {
        TapPublisher(gesture: self)
    }
}
