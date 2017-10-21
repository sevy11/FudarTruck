//
//  ViewController.swift
//  FudarTruck
//
//  Created by Michael Sevy on 10/21/17.
//  Copyright © 2017 Michael Sevy. All rights reserved.
//

import UIKit
import FirebaseAuth
import JVTextField

final class TruckSignUpViewController: UIViewController {

    // IBOutlets
    
    @IBOutlet weak var createTruckTextField: UIButton!
    @IBOutlet weak var truckNameTextField: JVFloatLabeledTextField!
    @IBOutlet weak var descriptionTextField: JVFloatLabeledTextField!
    @IBOutlet weak var confirmTextField: JVFloatLabeledTextField!
    @IBOutlet weak var passwordTextField: JVFloatLabeledTextField!
    @IBOutlet weak var truckDescriptionTextField: JVFloatLabeledTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    deinit {
        enableKeyboardManagement(false)
    }

    @IBAction func createTruckTapped(_ sender: UIButton) {
        if emailFieldEntered {
            if confirmTextField.text == passwordTextField.text {
                showProgressHud()
                AuthenticationManager.shared.createUser(email: emailTextField.text!, password: passwordTextField.text!, success: { [weak self] (user) in
                    guard let strongSelf = self else { return }
                    AuthenticationManager.shared.login(email: strongSelf.emailTextField.text!, password: strongSelf.passwordTextField.text!, success: { [weak self] (user) in
                        guard let strongSelf = self else { return }
                        strongSelf.dismissProgressHud()
                        AuthenticationManager.shared.user = user
                    }, failure: { [weak self] (error) in
                        guard let strongSelf = self else { return }
                        strongSelf.dismissProgressHud()
                        strongSelf.showErrorAlert(title:"Error", subTitle: error.localizedDescription)
                    })
                }, failure: { [weak self] (error: Error) in
                    guard let strongSelf = self else { return }
                    strongSelf.dismissProgressHud()
                    strongSelf.showErrorAlert(title:"Error", subTitle: error.localizedDescription)
                })
            } else {
                showErrorAlert(title: "Oops", subTitle: "Passwords do not match :(")
            }
        } else {
            showErrorAlert(title: "Ooops", subTitle: "Username error :(")
        }
    }
}

extension TruckSignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            if (textField.text?.characters.count)! > 5 {
                confirmTextField.becomeFirstResponder()
            } else {
                return false
            }
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextField {
            if textField.text != nil {
                if isValidEmail(emailString: textField.text!) {
                    //email = textField.text!
                    emailFieldEntered = true
                } else {
                    showErrorAlert(title: NSLocalizedString("Alert.Oops", comment: "get error title"), subTitle: NSLocalizedString("Login.UsernameError", comment: "get string for email error details"))
                    return
                }
            }
        } else if textField == passwordTextField {
            if textField.text != nil {
                if (textField.text?.characters.count)! > 5 {
                    //password = textField.text!
                } else {
                    showErrorAlert(title: NSLocalizedString("Alert.Error", comment: "get password error title"), subTitle: NSLocalizedString("Login.PasswordError", comment: "get string for password length error details"))
                    textField.resignFirstResponder()
                    return
                }
            }
        } else if textField == confirmTextField {
            if textField.text != nil {
                //confirm = textField.text!
            }
            if password == confirm {
                passwordsMatch = true
            } else {
                showErrorAlert(title: NSLocalizedString("Alert.Oops", comment: "get error title"), subTitle: NSLocalizedString("Create.PasswordMatch", comment: "get password match subTitle string"))
                passwordTextField.text = ""
                confirmTextField.text = ""
            }
        }
    }
}


// MARK: - Public Instance Methods
extension TruckSignUpViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        passwordTextField.resignFirstResponder()
        confirmTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
    }
}

// MARK: - Private Instance Methods
fileprivate extension TruckSignUpViewController {
    func isValidEmail(emailString: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailString)
    }

    func setup() {
        enableKeyboardManagement(true)
        AuthenticationManager.shared.stateChangeListener(success: { [weak self] in
            guard let strongSelf = self,
                let user = AuthenticationManager.shared.user else { return }
            print(user)
            strongSelf.dismissProgressHud()
            NotificationCenter.default.post(name: .ShowTutorial, object: nil)
            }, failure: { [weak self] (error) in
                guard let strongSelf = self else { return }
                strongSelf.dismissProgressHud()
                print(error.description)
        })

    }
}
