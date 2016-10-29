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
    
//    var journey = [Journey]()
    
    var journey: [Journey] =
        [
            Journey(
                name:"日本行(預設)",
                categories: [
                    ["cateName" : "證件 & 隨身用品",
                    "items" : [["itemName":"護照", "isPack":false],
                               ["itemName":"身分證", "isPack":false],
                               ["itemName":"錢包", "isPack":false],
                               ["itemName":"手錶", "isPack":false]]],
                    ["cateName" : "衣物",
                     "items" : [["itemName":"上衣", "isPack":false],
                                ["itemName":"外套", "isPack":false],
                                ["itemName":"褲子", "isPack":false],
                                ["itemName":"襪子", "isPack":false]]],
                    ["cateName" : "盆洗用具",
                     "items" : [["itemName":"牙膏", "isPack":false],
                                ["itemName":"牙刷", "isPack":false],
                                ["itemName":"刮鬍刀", "isPack":false]]],
                    ["cateName" : "電器",
                     "items" : [["itemName":"手機", "isPack":false],
                                ["itemName":"Macbook", "isPack":false],
                                ["itemName":"充電器", "isPack":false],
                                ["itemName":"OOOOOOOOOOOOOOOOOOOOOOO", "isPack":false]]]
                            ]
                    ),
            Journey(
                name:"冰島自助(預設)",
                categories: [
                        ["cateName" : "衣物",
                        "items" : [["itemName":"上衣", "isPack":false],
                                   ["itemName":"外套", "isPack":false],
                                   ["itemName":"褲子", "isPack":false],
                                   ["itemName":"襪子", "isPack":false]]],
                        ["cateName" : "盆洗用具",
                        "items" : [["itemName":"牙膏", "isPack":false],
                                   ["itemName":"牙刷", "isPack":false],
                                   ["itemName":"刮鬍刀", "isPack":false]]]
                            ]
                    )
        ]
    
    //按下按鈕，新增旅程
    @IBAction func addNewJorney(_ sender: UIButton) {
        // 使用我們寫好的函式
        askInfoWithDefault(nil) {
            (sucess: Bool, toDo: String?) in
            
            // 如果成功有輸入文字的話
            if sucess == true {
                if let okToDo = toDo {
                    
                    // 把待辦事項存到okToDo 加到toDoArray & reload
                    let newJourney = Journey(name: "", categories: [])
                    newJourney.name = okToDo
                    self.journey.append(newJourney)
                    self.journeyTableView.reloadData()
                    // save data
                    self.saveJourney()
                }
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 新增旅程並重整
        if let archivedObject = UserDefaults.standard.object(forKey: "Journey") {
            if let unarchivedJourney = NSKeyedUnarchiver.unarchiveObject(with: archivedObject as! Data) as? [Journey] {
                self.journey = unarchivedJourney
                self.journeyTableView.reloadData()
            } else {
                print("Failed to unarchive journey")
            }
            journeyTableView.reloadData()
        }
        
        // Set title
        self.title = "My Packing"
        
        // Remove the separators of the empty rows
        journeyTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // Change the color of the separator
        journeyTableView.separatorColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.8)
        
        // Remove the title of the back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
    
    // MARK:- TableViewDelegate
    // Editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            journey.remove(at: indexPath.row)
            // Delete the row from the data source
            journeyTableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // 按下 i 之後要修改 (未完成!!!)
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        // 找到按下的文字
        var journeyName = journey[indexPath.row].name as String!
        // 用該列文字呼叫 askInfoWithDefault
        askInfoWithDefault(nil){
            (sucess: Bool, toDo: String?) in
            // 如果成功有輸入文字的話
            if sucess == true {
                if let okToDo = toDo {
                    journeyName = okToDo
                    self.journey[indexPath.row].name = journeyName
                    self.journeyTableView.reloadData()
                    // save data
                    self.saveJourney()
                }
            }
        }
    }
    
    // 自訂按鈕(copy & delete)
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // Delete Button (刪除)
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) -> Void in
            
            self.journey.remove(at: indexPath.row)
            self.journeyTableView.deleteRows(at: [indexPath], with: .fade)
            // save data
            self.saveJourney()
        })
        
        // Copy Button (複製)
        let copyAction = UITableViewRowAction(style: .default, title: "Copy", handler: { (action, indexPath) -> Void in
            
            self.journey.append(self.journey[indexPath.row])
            self.journeyTableView.reloadData()
            // save data
            self.saveJourney()
        })
        
        // Set the button color (課製按鈕顏色)
        copyAction.backgroundColor = UIColor(red: 135.0/255.0, green: 216.0/255.0, blue: 209.0/255.0, alpha: 1)
        deleteAction.backgroundColor = UIColor(red: 202.0/255.0, green: 202.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        
        // 回傳按鈕
        return [deleteAction, copyAction]
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "showDetail" {
            if let indexPath = journeyTableView.indexPathForSelectedRow {
                let dvc = segue.destination as? DetailTableViewController
                dvc?.journey = journey[indexPath.row]
                dvc?.index = indexPath.row
            }
        }
    }
    
    // 新增 Journey 功能
    // 給 completion 取小名
    typealias AskInfoCompletion = (Bool,String?) -> ()
    
    // Alert (*@escaping)
    func askInfoWithDefault(_ defaultToDo: String?, withCompletionHandler completion: @escaping AskInfoCompletion) {
        let myAlert = UIAlertController(title: "新增旅程名", message: nil, preferredStyle: .alert)
        
        // 新增文字輸入框並設定參數
        myAlert.addTextField { (textField: UITextField) in
            textField.placeholder = "請輸入旅程名"   // 設定文字輸入框的placeholder
            textField.text = defaultToDo  // 如果有預設文字，顯示預設文字
        }
        
        // OK Button
        let okAction = UIAlertAction(title: "OK", style: .default) {
            (action) in
            // 拿到使用者輸入在第一個文字輸入框內的文字(textFields是Array)
            let inputText = myAlert.textFields?[0].text
            
            if inputText != nil && inputText != "" {
                // 使用者真的有輸入文字
                completion(true, inputText)
            } else {
                // 沒有輸入文字
                completion(false, nil)
            }
        }
        
        // Cancel Button
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) {
            (action) in
            completion(false, nil)
        }
        
        // Add Button
        myAlert.addAction(okAction)
        myAlert.addAction(cancelAction)
        
        // Present
        present(myAlert, animated: true, completion: nil)
    }
    
    func saveJourney() {
        func archiveJourney(journey:[Journey]) -> NSData {
            let archivedObject = NSKeyedArchiver.archivedData(withRootObject: journey)
            return archivedObject as NSData
        }
        let archivedObject = archiveJourney(journey: self.journey)
        UserDefaults.standard.set(archivedObject, forKey: "Journey")
        UserDefaults.standard.synchronize()
    }
}



