//
//  ViewController.swift
//  FudarTruck
//
//  Created by Michael Sevy on 10/21/17.
//  Copyright © 2017 Michael Sevy. All rights reserved.
//

import UIKit
import FirebaseAuth
import JVFloatLabeledTextField

final class TruckSignUpViewController: UIViewController {

    // IBOutlets
    @IBOutlet weak var createTruckButton: UIButton!
    @IBOutlet weak var truckNameTextField: JVFloatLabeledTextField!
    @IBOutlet weak var descriptionTextField: JVFloatLabeledTextField!
    @IBOutlet weak var confirmTextField: JVFloatLabeledTextField!
    @IBOutlet weak var passwordTextField: JVFloatLabeledTextField!
    @IBOutlet weak var emailTextField: JVFloatLabeledTextField!

    var passwordsMatch = false


    // View Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    deinit {
        enableKeyboardManagement(false)
    }

    @IBAction func createTruckTapped(_ sender: UIButton) {
        if !emailTextField.text!.isEmpty {
            if confirmTextField.text == passwordTextField.text {
                showProgressHud()
                AuthenticationManager.shared.createUser(email: emailTextField.text!, password: passwordTextField.text!, success: { [weak self] (user) in
                    guard let strongSelf = self else { return }
                    AuthenticationManager.shared.login(email: strongSelf.emailTextField.text!, password: strongSelf.passwordTextField.text!, success: { [weak self] (user) in
                        guard let strongSelf = self else { return }
                        strongSelf.dismissProgressHud()
                        AuthenticationManager.shared.user = user
                        // segue to location manager
                    }, failure: { [weak self] (error) in
                        guard let strongSelf = self else { return }
                        strongSelf.dismissProgressHud()
                        
                        strongSelf.showAlert(title:"Error", subTitle: error.localizedDescription)
                    })
                }, failure: { [weak self] (error: Error) in
                    guard let strongSelf = self else { return }
                    strongSelf.dismissProgressHud()
                    strongSelf.showAlert(title:"Error", subTitle: error.localizedDescription)
                })
            } else {
                showAlert(title: "Oops", subTitle: "Passwords do not match :(")
            }
        } else {
            let alert = showAlert(title: "Ooops", subTitle: "Username error :(")
            self.show(alert, sender: nil)
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
                } else {
                    showAlert(title: NSLocalizedString("Alert.Oops", comment: "get error title"), subTitle: NSLocalizedString("Login.UsernameError", comment: "get string for email error details"))
                    return
                }
            }
        } else if textField == passwordTextField {
            if textField.text != nil {
                if (textField.text?.characters.count)! > 5 {
                    //password = textField.text!
                } else {
                    showAlert(title: NSLocalizedString("Alert.Error", comment: "get password error title"), subTitle: NSLocalizedString("Login.PasswordError", comment: "get string for password length error details"))
                    textField.resignFirstResponder()
                    return
                }
            }
        } else if textField == confirmTextField {
            if textField.text != nil {
                //confirm = textField.text!
            }
            if passwordTextField.text! == confirmTextField.text! {
                passwordsMatch = true
            } else {
                showAlert(title: NSLocalizedString("Alert.Oops", comment: "get error title"), subTitle: NSLocalizedString("Create.PasswordMatch", comment: "get password match subTitle string"))
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
            //NotificationCenter.default.post(name: .ShowTutorial, object: nil)
            }, failure: { [weak self] (error) in
                guard let strongSelf = self else { return }
                strongSelf.dismissProgressHud()
                print(error.description)
        })

    }
}
