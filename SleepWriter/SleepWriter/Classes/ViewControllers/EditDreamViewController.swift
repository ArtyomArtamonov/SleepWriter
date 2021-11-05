//
//  EditDreamViewController.swift
//  SleepWriter
//
//  Created by Tamerlan Satualdypov on 29.10.2020.
//  Copyright © 2020 Artyom Artamonov. All rights reserved.
//

import UIKit
import STTextView

class EditDreamViewController: UIViewController{

    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var dreamTextView: STTextView!
    
    @IBOutlet private weak var helpButton: UIButton!
    @IBOutlet private weak var saveButton: UIButton!
    
    @IBOutlet private weak var bottomConstraint : NSLayoutConstraint!
    
    public weak var delegate : MainPageControllerDelegate?
    
    @IBAction func helpButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "showHelp", sender: self)
    }
    
    @IBAction private func saveButtonPressed(_ sender : UIButton) -> () {
        let generator = UINotificationFeedbackGenerator()
        
        let titleText = self.titleTextField.text!.filter({c in c != Character(" ")})
        let dreamText = self.dreamTextView.text!.filter({c in c != Character(" ")})
        
        if titleText.isEmpty || dreamText.isEmpty{
            generator.notificationOccurred(.warning)
            
            if self.titleTextField.text!.isEmpty{
                shake(titleTextField)
            }
            
            if self.dreamTextView.text.isEmpty{
                shake(dreamTextView)
            }
            
            return
        }
        
        let newDream = Dream(title: self.titleTextField.text!,
                             text: self.dreamTextView.text,
                             date: .init(), lastOpened: .init())
        
        self.titleTextField.text = ""
        self.dreamTextView.text = ""
        
        self.delegate?.add(dream: newDream)
        PersistanceLayer.coreData.save()
        
        generator.notificationOccurred(.success)
        delegate?.switchPage(to: 1)
    }
    
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
    
    private func shake(_ view : UIView) -> () {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.08
        animation.repeatCount = 1
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: view.center.x - 5, y: view.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: view.center.x + 5, y: view.center.y))

        view.layer.add(animation, forKey: "position")
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

extension EditDreamViewController : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textField.text!.count < 20 || string == ""
    }
}
