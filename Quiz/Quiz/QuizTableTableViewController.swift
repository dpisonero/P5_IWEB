//
//  QuizTableTableViewController.swift
//  Quiz
//
//  Created by user145055 on 11/24/18.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

class QuizTableTableViewController: UITableViewController {
    
    struct Page: Codable {
        let quizzes: [Quiz]
        let pageno: Int
        let nextUrl: String
    }
    
    struct Quiz: Codable {
        let id: Int
        let question: String
        let author: Author?
        let attachment: Attachment?
        let favourite: Bool?
        let tips: [String]?
    }
    
    struct Author: Codable {
        let id: Int?
        let isAdmin: Bool?
        let username: String?
    }
    
    struct Attachment: Codable {
        let filename: String?
        let mime: String?
        let url: String?
    }
    
    var todosQuizes = [Quiz]()
    
    let peticion = "https://quiz2019.herokuapp.com/api/quizzes?token=c5b1bc6f39dadb0bd675"

    var imagesCache = [String : UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        download(url: peticion)
        tableView.rowHeight = 100
    }
    
    private func download(url: String) {
        if let urlSegura = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            
            guard let urlPeticion = URL(string: urlSegura)
                else {
                    return
            }
            
            DispatchQueue.global().async{
                
                let decoder = JSONDecoder()
                
                if let respuesta = try? Data(contentsOf: urlPeticion),
                   let pagina = try? decoder.decode(Page.self, from: respuesta) {
                        
                        DispatchQueue.main.async {
                            
                            for quiz in pagina.quizzes {
                                self.todosQuizes.append(quiz)
                            }
                            
                            self.tableView.reloadData()
                            
                            if pagina.nextUrl != "" {
                                self.download(url: pagina.nextUrl)
                            }
                        }
                }
            }
        }
    }
    
    private func downloadImage(urlImage: String, indexPath: IndexPath) {
        
        if let urlSegura = urlImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            
            guard let urlImagen = URL(string: urlSegura)
                else {
                    return
            }
            
            DispatchQueue.global().async {
                
                if let datos = try? Data(contentsOf: urlImagen),
                   let imagen = UIImage(data: datos) {
                    
                    DispatchQueue.main.async {
                        self.imagesCache[urlSegura] = imagen
                        self.tableView.reloadRows(at: [indexPath], with: .fade)
                    }
                } else {
                    self.imagesCache[urlSegura] = UIImage()
                    self.tableView.reloadRows(at: [indexPath], with: .fade)
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todosQuizes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Quiz Cell", for: indexPath) as! QuizTableViewCell

        let quiz = todosQuizes[indexPath.row]

        cell.autorLabel.text = quiz.author?.username
        cell.questionLabel.text = quiz.question
        
        if quiz.attachment == nil {
            cell.imagen.image = UIImage()
        } else {
            if let img = imagesCache[(quiz.attachment?.url)!] {
                cell.imagen.image = img
            } else {
                downloadImage(urlImage: (quiz.attachment?.url)!, indexPath: indexPath)
            }
        }
        
        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Show Respuesta" {
            
            if let rvc = segue.destination as? RespuestaViewController,
               let cell = sender as? UITableViewCell,
               let ip = tableView.indexPath(for: cell){
                
                let quiz = todosQuizes[ip.row]
                rvc.question = quiz.question
                rvc.tips = quiz.tips ?? [""]
                rvc.questionId = quiz.id
                
                if quiz.attachment == nil {
                    rvc.imagen = UIImage()
                } else {
                    rvc.imagen = imagesCache[(quiz.attachment?.url)!]!
                }
            }
        }
        
    }
    
}
