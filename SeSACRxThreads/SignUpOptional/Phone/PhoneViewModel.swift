//
//  PhoneViewModel.swift
//  SeSACRxThreads
//
//  Created by Chaewon on 2023/11/02.
//

import Foundation
import RxSwift
import RxCocoa

class PhoneViewModel {
    
    let phoneText = BehaviorSubject(value: "010")
    let buttonEnabled = BehaviorSubject(value: false)
    
    let disposeBag = DisposeBag()
    
    init() {
        phoneText
            .map { $0.count > 10 }
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, value in
                owner.buttonEnabled.onNext(value)
            }
            .disposed(by: disposeBag)
    }
}
