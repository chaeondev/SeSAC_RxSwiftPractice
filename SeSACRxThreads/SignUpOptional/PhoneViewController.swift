//
//  PhoneViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

// TODO: - 1101
/// 1. button color, textfield color, textfield border color를 우선 red로, buttonEnabled도 우선 false, textfield에 기본 010 추가하기
/// 2. 사용자가 textfield작성 -> formatted해서 데이터로 넘기기
/// 3. text가 10자 이상이면 color blue, button enabled상태로 바꾸기
// TODO: -

class PhoneViewController: UIViewController {
   
    let phoneTextField = SignTextField(placeholderText: "연락처를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    
    let phoneText = BehaviorSubject(value: "010")
    let enabledColor = BehaviorSubject(value: UIColor.red)
    let buttonEnabled = BehaviorSubject(value: false)
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        
        bind()
    }
    
    func bind() {
        phoneText
            .bind(to: phoneTextField.rx.text)
            .disposed(by: disposeBag)
        
        enabledColor
            .bind(to: nextButton.rx.backgroundColor,
                  phoneTextField.rx.tintColor)
            .disposed(by: disposeBag)
        
        enabledColor
            .map { $0.cgColor }
            .bind(to: phoneTextField.layer.rx.borderColor)
            .disposed(by: disposeBag)
        
        buttonEnabled
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        //---
        
        phoneTextField.rx.text.orEmpty
            .subscribe(with: self) { owner, value in
                let result = value.formated(by: "###-####-####")
                owner.phoneText.onNext(result)
            }
            .disposed(by: disposeBag)
        //---
        
        phoneText
            .map { $0.count > 10 }
            .subscribe(with: self) { owner, value in
                let color = value ? UIColor.blue : UIColor.red
                owner.enabledColor.onNext(color)
                owner.buttonEnabled.onNext(value)
            }
            .disposed(by: disposeBag)
    }
    
    @objc func nextButtonClicked() {
        navigationController?.pushViewController(NicknameViewController(), animated: true)
    }

    
    func configureLayout() {
        view.addSubview(phoneTextField)
        view.addSubview(nextButton)
         
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(phoneTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
