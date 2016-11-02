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
                     "items" : [["itemName":"護照", "isPack":false, "number":1],
                                ["itemName":"身分證", "isPack":false, "number":1],
                                ["itemName":"錢包", "isPack":false, "number":1],
                                ["itemName":"手錶", "isPack":false, "number":1]]],
                    ["cateName" : "衣物",
                     "items" : [["itemName":"上衣", "isPack":false, "number":1],
                                ["itemName":"外套", "isPack":false, "number":1],
                                ["itemName":"褲子", "isPack":false, "number":1],
                                ["itemName":"襪子", "isPack":false, "number":1]]],
                    ["cateName" : "盆洗用具",
                     "items" : [["itemName":"牙膏", "isPack":false, "number":1],
                                ["itemName":"牙刷", "isPack":false, "number":1],
                                ["itemName":"刮鬍刀", "isPack":false, "number":1]]],
                    ["cateName" : "電器",
                     "items" : [["itemName":"手機", "isPack":false, "number":1],
                                ["itemName":"Macbook", "isPack":false, "number":1],
                                ["itemName":"充電器", "isPack":false, "number":1],
                                ["itemName":"臣亮言：先帝創業未半，而中道崩殂。今天下三分，益州 疲弊，此誠危急存亡之秋也。然侍衛之臣，不懈於內；忠志之 士，忘身於外者，蓋追先帝之殊遇，欲報之於陛下也。誠宜開 張聖聽，以光先帝遺德，恢弘志士之氣；不宜妄自菲薄，引喻 失義，以塞忠諫之路也。宮中府中，俱為一體，陟罰臧否，不 宜異同。若有作姦犯科，及為忠善者，宜付有司，論其刑賞， 以昭陛下平明之治，不宜篇私，使內外異法也。", "isPack":false, "number":1]]]
                ]
            ),
            Journey(
                name:"冰島自助(預設)",
                categories: [
                    ["cateName" : "衣物",
                     "items" : [["itemName":"上衣", "isPack":false, "number":1],
                                ["itemName":"外套", "isPack":false, "number":1],
                                ["itemName":"褲子", "isPack":false, "number":1],
                                ["itemName":"襪子", "isPack":false, "number":1]]],
                    ["cateName" : "盆洗用具",
                     "items" : [["itemName":"牙膏", "isPack":false, "number":1],
                                ["itemName":"牙刷", "isPack":false, "number":1],
                                ["itemName":"刮鬍刀", "isPack":false, "number":1]]]
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
                    let newJourney = Journey(name: "", categories: [["cateName": "","items":
                        [["itemName": "修改名稱", "isPack":false, "number":1]]]])
                    newJourney.name = okToDo
                    self.journey.append(newJourney)
                    self.journeyTableView.reloadData()
                    // save data
                    self.saveJourney()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.journeyTableView.reloadData()
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! JourneyTableViewCell
        
        let currentJourney = self.journey[indexPath.row]
        let journeyName: String = currentJourney.name!
        let numberOfCate = currentJourney.categories.count
        var numberOfEachItems = 0
        var numberOfItems = 0
//        var numberOfPacked = 0
        var totalOfPacked = 0
        for i in 0..<numberOfCate {
            let items = currentJourney.categories[i]["items"] as! [[String:Any]]
            numberOfEachItems = items.count
//            numberOfItems += items.count
            for j in 0..<numberOfEachItems {
                    let count = (items[j]["number"]) as! Int
                if items[j]["isPack"] as! Bool == true {
//                    let packed = (items[j]["number"]) as! Int
//                    numberOfPacked += 1
                    totalOfPacked += count
                }
                numberOfItems += count
            }
        }
        
        let ratio  = Int((Double(totalOfPacked) / Double((numberOfItems))) * 100)
        
        cell.journeyLabel.text = journeyName
        cell.ratioLabel?.text = String(ratio) + "%"
        cell.ratioProgress.progress = Float(ratio)/100.0

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
    
    // 按下 i 之後要修改
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        // 找到按下的文字
        var journeyName = journey[indexPath.row].name as String!
        // 用該列文字呼叫 askInfoWithDefault
        askInfoWithDefault(journeyName){
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
            // copy data
            let copyJourney = (self.journey[indexPath.row]).copy() as! Journey
            self.journey.append(copyJourney)
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
    
    // 解編碼 ＆ 儲存
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



