//
//  ViewController.swift
//  MyPacking
//
//  Created by 洪德晟 on 2016/10/18.
//  Copyright © 2016年 洪德晟. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var journeyTableView: UITableView!
    
    var journey: [Journey] =
        [
            Journey(
                name: "First Trip",
                categories: [
                    ["cateName" : "Coldplay",
                     "items" : ["Ghost Stories", "A Head Full of Dreams","Mylo Xyloto"]],
                    ["cateName" : "Coldplay2",
                     "items" : ["Ghost Stories2", "A Head Full of Dreams2","Mylo Xyloto2"]]]
                    ),
            Journey(
                name:"Second Trip",
                categories: [
                        ["cateName" : "David Guetta",
                        "items" : ["Lovers on the Sun EP", "Nothing But the Beat Ultimate"]
                        ],
                        ["cateName" : "David Guetta2",
                        "items" : ["Lovers on the Sun EP2", "Nothing But the Beat Ultimate2"]
                        ]]
                        )
                    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - TableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return journey.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
     
        let currentJourney = self.journey[indexPath.row]
        let journeyName: String = currentJourney.name! 
        
        cell.textLabel?.text = journeyName
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "showDetail" {
            if let indexPath = journeyTableView.indexPathForSelectedRow {
                let dvc = segue.destination as? DetailTableViewController
                dvc?.journey = journey[indexPath.row]
            }
        }
    }
}

