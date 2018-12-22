//
//  PistasTableViewController.swift
//  Quiz
//
//  Created by user145055 on 11/24/18.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

class PistasTableViewController: UITableViewController {
    
    var tips = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tips.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Show Pistas", for: indexPath)
        
        let tip = tips[indexPath.row]
        
        print(tip)
        
        cell.textLabel?.text = tip

        return cell
    }
    
}
