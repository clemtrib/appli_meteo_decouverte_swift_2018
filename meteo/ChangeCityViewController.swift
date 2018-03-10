//
//  ChangeCityViewController.swift
//  meteo
//
//  Created by tribouillard on 06/03/2018.
//  Copyright © 2018 tribouillard. All rights reserved.
//

import UIKit

class ChangeCityViewController: UITableViewController {
    var cityList = ["Paris", "Mexico city", "Cuzco", "Annecy"]
    
    var selectedCity: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = cityList[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCity = cityList[indexPath.row]
        self.performSegue(withIdentifier: "unwindCitySegue", sender: self)
    }
    
    
 
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
