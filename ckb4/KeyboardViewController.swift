//
//  KeyboardViewController.swift
//  ckb4
//
//  Created by Albion Ka Hei Fung on 2019-03-01.
//  Copyright © 2019 Albion Ka Hei Fung. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {
    var shift: Bool = false
    var caps: Bool = false
    let portraitHeight: CGFloat = 150.0
    let landscapeHeight: CGFloat = 103.0

    @IBOutlet var nextKeyboardButton: UIButton!
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "kbView", bundle: nil)
        let objects = nib.instantiate(withOwner: self, options: nil)
        
        view = objects[0] as? UIView

        // Perform custom UI setup here
        self.nextKeyboardButton = UIButton(type: .system)
        
        self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), for: [])
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        
        self.view.addSubview(self.nextKeyboardButton)
        
        self.nextKeyboardButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.nextKeyboardButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    @IBAction func buttonPressed(button: UIButton) {
        let string = button.titleLabel?.text
        if (string == "<|") {
            // delete
//            let range = (textDocumentProxy as UIKeyInput).selectedTextRange;
            return
        } else if (string == "SHFT") {
            if(!caps && shift) {
                caps = true
            } else if(caps) {
                caps = false
                shift = true
            }
            
            shift = !shift

            changeCase()
            return
        }

        (textDocumentProxy as UIKeyInput).insertText("\(string!)")
        if(shift) {
            shift = false
            changeCase()
        }
    }
    
    func changeCase() {
        var string: String?;
        for button in self.view.subviews {
            if(button is UIButton) {
                string = (button as! UIButton).titleLabel?.text
                if(string == "SHFT") {
                    continue
                }
                if(caps != shift) {
                    string = string?.uppercased()
                } else {
                    string = string?.lowercased()
                }

                (button as! UIButton).setTitle(string, for: UIControl.State.normal)
            }
        }
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            textColor = UIColor.white
        } else {
            textColor = UIColor.black
        }
        self.nextKeyboardButton.setTitleColor(textColor, for: [])
    }

}
