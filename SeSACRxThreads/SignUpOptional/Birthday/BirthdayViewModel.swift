//
//  BirthdayViewModel.swift
//  SeSACRxThreads
//
//  Created by Chaewon on 2023/11/02.
//

import Foundation
import RxSwift

class BirthdayViewModel {
    
    let birthday: BehaviorSubject<Date> = BehaviorSubject(value: .now)
    
    let year = BehaviorSubject(value: 0)
    let month = BehaviorSubject(value: 0)
    let day = BehaviorSubject(value: 0)
    
    let buttonEnabled = BehaviorSubject(value: false)

    let disposeBag = DisposeBag()
    
    init() {
        birthday
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, date in
                
                let component = Calendar.current.dateComponents([.year, .month, .day], from: date)
                
                owner.year.onNext(component.year!)
                owner.month.onNext(component.month!)
                owner.day.onNext(component.day!)
            }
            .disposed(by: disposeBag)
        
        year
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, value in
                let component = Calendar.current.dateComponents([.year], from: Date())
                let age = (component.year! - value) >= 17
                owner.buttonEnabled.onNext(age)
            }
            .disposed(by: disposeBag)
    }
    
}
