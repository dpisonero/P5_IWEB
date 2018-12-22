//
//  RespuestaViewController.swift
//  Quiz
//
//  Created by user145055 on 11/24/18.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

class RespuestaViewController: UIViewController, UITextFieldDelegate {
    
    struct Answer: Codable{
        let quizId: Int
        let answer: String
        let result: Bool
    }

    @IBOutlet weak var answerTF: UITextField!
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var imagenIV: UIImageView!
    
    var tips = [String]()
    var question = String()
    var questionId = Int()
    var imagen = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.answerTF.delegate = self
        
        questionLabel.text = question
        imagenIV.image = imagen
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func testAction(_ sender: Any) {
        
        let url = "https://quiz2019.herokuapp.com/api/quizzes/\(questionId)/check?answer=\(answerTF.text ?? "")&token=c5b1bc6f39dadb0bd675"
        
        if let urlSegura = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            
            guard let urlPeticion = URL(string: urlSegura)
                else {
                    return
            }
            
            DispatchQueue.global().async{
                
                let decoder = JSONDecoder()
                
                if let respuesta = try? Data(contentsOf: urlPeticion),
                    let answer = try? decoder.decode(Answer.self, from: respuesta) {
                    
                    DispatchQueue.main.async {
                        
                        if answer.result {
                            let alert = UIAlertController(title: "Correto", message: "Has acertado", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default))
                            self.present(alert, animated: true)
                        } else {
                            let alert = UIAlertController(title: "Muy mal", message: "Prueba otra vez", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default))
                            self.present(alert, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()

        return true
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Show Pistas" {
            
            if let pvc = segue.destination as? PistasTableViewController {
                
                pvc.tips = self.tips
            }
        }
    }

}
