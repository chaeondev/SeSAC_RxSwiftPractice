//
//  NicknameViewModel.swift
//  SeSACRxThreads
//
//  Created by Chaewon on 2023/11/02.
//

import Foundation
import RxSwift

class NicknameViewModel {
    
    let nickname = BehaviorSubject(value: "")
    let buttonHidden = BehaviorSubject(value: true)
    
    let disposeBag = DisposeBag()
    
    init() {
        
        nickname
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, value in
                let age = !((value.count >= 2) && (value.count < 6))
                owner.buttonHidden.onNext(age)
            }
            .disposed(by: disposeBag)
    }
}
