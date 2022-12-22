//
//  ViewController.swift
//  MeditationB
//
//  Created by user on 19.09.2022.
//

import UIKit
import Alamofire
import SwiftyJSON
class SingInViewController: UIViewController {
    @IBOutlet weak var inputLogin: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    
    let userDef = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func signInAction(_ sender: UIButton) {
        
        guard inputPassword.text?.isEmpty == false && inputPassword.text?.isEmpty == false else {return showAlert(message: "Поля пустые")}
        guard isValidEmail(emailID: inputLogin.text!) else { return showAlert(message: "Проверьте правильность пароля")}
        let url = "http://mskko2021.mad.hakta.pro/api/user/login"
        
        let param: [String: String] = [
            "email": inputLogin.text!,
            "password": inputPassword.text!
        ]
        
        AF.request(url, method: .post, parameters: param, encoder: JSONParameterEncoder.default).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let token = json["token"].stringValue
                self.userDef.setValue(token, forKey: "userToken")
            case .failure(let error):
                let errorJSON = JSON(response.data)
                let errorDescription = errorJSON["error"].stringValue
                self.showAlert(message: errorDescription)
            }
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Уведомление", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func isValidEmail(emailID: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-0.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailID)
    }
}


