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
                name:"日本行",
                categories: [
                    ["cateName" : "衣物",
                     "items" : ["上衣", "外套", "內衣", "襪子"]],
                    ["cateName" : "盆洗用具",
                     "items" : ["牙刷", "刮鬍刀","洗面乳"]],
                    ["cateName" : "電器",
                     "items" : ["手機", "Macbook","充電器", "充電線", "wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww"]]]
                    ),
            Journey(
                name:"冰島自助",
                categories: [
                        ["cateName" : "衣物",
                        "items" : ["上衣", "外套", "內衣", "襪子"]],
                        ["cateName" : "盆洗用具",
                        "items" : ["牙刷", "刮鬍刀","洗面乳"]]]
                        )
                    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set title
        self.title = "My Packing"
        
        // Remove the separators of the empty rows
        journeyTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // Change the color of the separator
        journeyTableView.separatorColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.8)
        
        // Remove the title of the back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
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

