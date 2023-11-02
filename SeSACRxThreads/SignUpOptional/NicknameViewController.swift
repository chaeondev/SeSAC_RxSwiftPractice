//
//  NicknameViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

// TODO: - 1101
/// nickname 2글자 이상 6글자 미만인 경우 버튼 hidden 처리하기

class NicknameViewController: UIViewController {
   
    let nicknameTextField = SignTextField(placeholderText: "닉네임을 입력해주세요")
    let nextButton = PointButton(title: "다음")
    
    let nickname = BehaviorSubject(value: "")
    let buttonHidden = BehaviorSubject(value: true)
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
       
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        
        bind()

    }
    
    func bind() {
        nicknameTextField.rx.text.orEmpty
            .bind(to: nickname)
            .disposed(by: disposeBag)
        
        buttonHidden
            .bind(to: nextButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        nickname
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, value in
                let age = !((value.count >= 2) && (value.count < 6))
                owner.buttonHidden.onNext(age)
            }
            .disposed(by: disposeBag)
    }
    
    @objc func nextButtonClicked() {
        navigationController?.pushViewController(BirthdayViewController(), animated: true)
    }

    
    func configureLayout() {
        view.addSubview(nicknameTextField)
        view.addSubview(nextButton)
         
        nicknameTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
