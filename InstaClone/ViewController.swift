//  ViewController.swift
//  InstaClone
//
//  Created by Furkan Kaya on 4.01.2024.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func signinClicked(_ sender: Any) {
        // Giriş yap butonuna basıldığında
        if emailText.text != "" && passwordText.text != "" {
            // Kullanıcı adı ve şifre boş değilse
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { authdata, error in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                } else {
                    // Başarılı giriş yapıldığında
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        } else {
            makeAlert(title: "Error", message: "Username or password cannot be left blank")
        }
    }

    @IBAction func signupClicked(_ sender: Any) {
        // Kayıt ol butonuna basıldığında
        if emailText.text != "" && passwordText.text != "" {
            // Kullanıcı adı ve şifre boş değilse
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { authdata, error in
                if error != nil {
                    // Kayıt sırasında bir hata olursa
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                } else {
                    // Başarılı kayıt yapıldığında
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }

        } else {
            // Kullanıcı adı veya şifre boşsa
            makeAlert(title: "Error", message: "Username or password cannot be left blank")
        }
    }

    func makeAlert(title: String, message: String) {
        // Hata mesajı için bir alert gösteren fonksiyon
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
}
