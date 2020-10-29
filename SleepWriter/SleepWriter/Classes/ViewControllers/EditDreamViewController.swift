//
//  EditDreamViewController.swift
//  SleepWriter
//
//  Created by Tamerlan Satualdypov on 29.10.2020.
//  Copyright © 2020 Artyom Artamonov. All rights reserved.
//

import UIKit
import STTextView

class EditDreamViewController: UIViewController {

    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var dreamTextView: STTextView!
    
    @IBOutlet private weak var helpButton: UIButton!
    @IBOutlet private weak var saveButton: UIButton!
    
    @IBOutlet private weak var bottomConstraint : NSLayoutConstraint!
    
    @objc private func keyboardWillShow(notification: NSNotification) -> () {
        guard let userInfo = notification.userInfo,
              let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let safeAreaBottomInset = UIApplication.shared.windows.first?.safeAreaInsets.bottom
        else { return }
        
        /*
         
         Получаем фрейм открытой клавиатуры,
         заводим переменную с размером pageControl'а
         внизу нашей вьюхи. Т.к. калькуляции ведутся
         в контейнере и self.view.bounds.height не даст
         нам достоверного размера всего контента.
         
         Параметры:
         
         – keyboardFrame: фрейм открывшейся клавиатуры.
         
         – pageControlHeight: высота pageControl'a, чтобы можно
         было отнять от размера клавиатуры и получить правильное
         значение.
         
         – safeAreaBottomInset: высота отступа от безопасной зоны,
         используется для того, чтобы получать корректные вычисления
         на устройствах без рамки.
         
        */
        
        let keyboardFrame : CGRect = keyboardSize.cgRectValue
        let pageControlHeight : CGFloat = 32
        
        self.bottomConstraint.constant = keyboardFrame.height - safeAreaBottomInset - pageControlHeight
        
        UIView.animate(withDuration: 0.3) {
            self.dreamTextView.backgroundColor = .applicationDarkColor
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) -> () {
        self.bottomConstraint.constant = 8
        
        UIView.animate(withDuration: 0.3) {
            self.dreamTextView.backgroundColor = .applicationLightColor
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func forceEndEditing() -> () {
        self.view.endEditing(true)
    }
    
    private func addTapGesture() -> () {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(forceEndEditing))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    private func initialConfiguration() -> () {
        [self.dreamTextView, self.helpButton, self.saveButton].forEach { $0?.layer.cornerRadius = 25 }
        
        self.dreamTextView.textContainerInset = .init(top: 16, left: 16, bottom: 16, right: 16)
        
        self.addTapGesture()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) -> () {
        super.viewWillAppear(animated)
        self.initialConfiguration()
    }
}
