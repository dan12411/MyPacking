//
//  DetailTableViewController.swift
//  MyPacking
//
//  Created by 洪德晟 on 2016/10/18.
//  Copyright © 2016年 洪德晟. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {
    
    var journey: Journey?
    
    var index: Int?
    
    // 按下按鈕，社群分享
    @IBAction func socialShare(_ sender: UIBarButtonItem) {
        
        if let name = journey?.name {
            let defaultText = "請跟我要" + name + "的旅程，需要打包的東西！"
            let activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
            self.present(activityController, animated:true, completion: nil)
        }
    }
    
    // 按下按鈕，新增Category
    @IBAction func addCate(_ sender: UIBarButtonItem) {
        // 使用我們寫好的函式
        askInfoWithDefault(nil) {
            (sucess: Bool, toDo: String?) in
            
            // 如果成功有輸入文字的話
            if sucess == true {
                if let okToDo = toDo {
                    
                    // creat & reload
                    self.journey?.categories.append(["cateName": okToDo,"items":
                        [["itemName": "修改名稱", "isPack":false, "number":1]]])
                    self.tableView.reloadData()
                    // save data
                    self.saveData()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 修改標題
        self.title = journey?.name
        // 增加修改按鈕
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        // Remove the separators of the empty rows
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        //        // Cell 自動調整列高(未成功)
        //        tableView.estimatedRowHeight = 56.0
        //        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - TableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return (journey?.categories.count)!
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let eachCate = self.journey?.categories[section]
        let items = eachCate?["items"] as! Array<Any>
        return (items.count + 1)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let items = self.journey?.categories[indexPath.section]["items"] as! Array<Any>
        
        print("cellForRowAt: \(indexPath.row), \(items.count+1)")
        
        if indexPath.row < (items.count) {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemTableViewCell
            
            let eachCate = (self.journey?.categories[indexPath.section])! as [String:Any]
            let item = (eachCate["items"] as! Array<Any>)[indexPath.row] as! [String:Any]
            let itemName = item["itemName"] as! String
            if let count = item["number"] {
                cell.itemCount.text = String(describing: count)
            }
            cell.itemLabel.text = itemName
            // 點選後持續反灰
            if (item["isPack"]) as! Bool == true {
                cell.imageButton.isHidden = false
                cell.imageButton.setImage(UIImage(named: "Done"), for: .normal)
                cell.itemCount.textColor = .white
            } else {
                cell.imageButton.isHidden = true
            }
            cell.itemLabel.textColor = (item["isPack"]) as! Bool ? UIColor.lightGray : UIColor.black
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "newCell", for: indexPath)
            return cell
        }
    }
    
    // Section Title
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return journey?.categories[section]["cateName"] as? String
    }
    // Section Color (字體顏色未變)
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header :UITableViewHeaderFooterView = UITableViewHeaderFooterView()
        
        header.contentView.backgroundColor = UIColor(red: 135.0/255.0, green: 216.0/255.0, blue: 209.0/255.0, alpha: 1)
        header.textLabel?.textColor = UIColor.white
        return header
    }
    
    // MARK: - UITableViewDelegate
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let items = self.journey?.categories[indexPath.section]["items"] as! Array<Any>
        if indexPath.row < (items.count) {
            return true
        } else {
            return false
        }
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            var eachCate = self.journey?.categories[indexPath.section]
            var items = eachCate?["items"] as! Array<Any>
            items.remove(at: indexPath.row)
            eachCate?["items"] = items
            self.journey?.categories[indexPath.section] = eachCate!
            
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
            // save data
            self.saveData()
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // 設定 Row 重新排列
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        var currentCate = self.journey?.categories[fromIndexPath.section]
        var items = currentCate?["items"] as! Array<Any>
        let tempText = items[to.row]
        items[to.row] = items[fromIndexPath.row]
        items[fromIndexPath.row] = tempText
        
        // Update item
        currentCate?["items"] = items
        
        // Update catgory data back
        self.journey?.categories[fromIndexPath.section] = currentCate!
        // save data
        self.saveData()
    }
    
    // 按壓某列，切換打包與否
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let items = self.journey?.categories[indexPath.section]["items"] as! Array<Any>
        if indexPath.row < (items.count) {
            
            var eachCate = journey?.categories[indexPath.section]
            var eachItem = ((eachCate?["items"]) as? [[String:Any]])?[indexPath.row]
            var isPack = eachItem?["isPack"] as! Bool
            var number = eachItem?["number"] as! Int
            let cell = tableView.cellForRow(at: indexPath) as! ItemTableViewCell
            
            if isPack {
                cell.itemLabel.textColor = UIColor.black
                cell.itemCount.textColor = UIColor.black
                cell.imageButton.isHidden = true
                var newCate = (eachCate?["items"] as! [[String:Any]])
                isPack = false
                eachItem?["isPack"] = isPack
                if let count = cell.itemCount.text {
                    number = Int(count)!
                }
                eachItem?["number"] = number
                newCate[indexPath.row] = eachItem!
                print("=============\(eachItem)===============")
                self.journey?.categories[indexPath.section]["items"] = newCate
                // save data
                self.saveData()
            } else {
                cell.imageButton.isHidden = false
                let checkImage = UIImage(named: "Done")
                cell.imageButton.setImage(checkImage, for: .normal)
                cell.itemLabel.textColor = UIColor.lightGray
                cell.itemCount.textColor = UIColor.white
                var newCate = (eachCate?["items"] as! [[String:Any]])
                isPack = true
                eachItem?["isPack"] = isPack
                if let count = cell.itemCount.text {
                    number = Int(count)!
                }
                eachItem?["number"] = number
                newCate[indexPath.row] = eachItem!
                print("=============\(eachItem)===============")
                self.journey?.categories[indexPath.section]["items"] = newCate
                // save data
                self.saveData()
            }
        } else {
            // 使用我們寫好的函式
            askInfoWithDefault(nil) {
                (sucess: Bool, toDo: String?) in
                
                // 如果成功有輸入文字的話
                if sucess == true {
                    if let okToDo = toDo {
                        
                        // Create & reload
                        var items = self.journey?.categories[indexPath.section]["items"] as! Array<Any>
                        items.append(["itemName": okToDo, "isPack":false, "number":1])
                        self.journey?.categories[indexPath.section]["items"] = items
                        self.journey?.categories[indexPath.section]["number"] = 0
                        self.tableView.reloadData()
                        // save data
                        self.saveData()
                    }
                }
            }
        }
    }
    
    // 設定哪些item可移動
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    // 按下 i 之後要修改 toDo
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        // 找到按下的文字
        var eachCate = (self.journey?.categories[indexPath.section])! as [String:Any]
        var item = (eachCate["items"] as! Array<Any>)[indexPath.row] as! [String:Any]
        var itemName = item["itemName"] as! String
        var newCate = (eachCate["items"] as! [[String:Any]])
        // 用該列文字呼叫 askInfoWithDefault
        askInfoWithDefault(itemName){
            (sucess: Bool, toDo: String?) in
            // 如果成功有輸入文字的話
            if sucess == true {
                if let okToDo = toDo {
                    
                    // update & reload
                    itemName = okToDo
                    item["itemName"] = itemName
                    newCate[indexPath.row] = item
                    self.journey?.categories[indexPath.section]["items"] = newCate
                    self.tableView.reloadData()
                    // save data
                    self.saveData()
                }
            }
        }
    }
    
    // 新增項目功能
    // 給 completion 取小名
    typealias AskInfoCompletion = (Bool,String?) -> ()
    
    // Alert (*@escaping)
    func askInfoWithDefault(_ defaultToDo: String?, withCompletionHandler completion: @escaping AskInfoCompletion) {
        let myAlert = UIAlertController(title: "項目調整", message: nil, preferredStyle: .alert)
        
        // 新增文字輸入框並設定參數
        myAlert.addTextField { (textField: UITextField) in
            textField.placeholder = "請輸入文字"   // 設定文字輸入框的placeholder
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
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPlay" {
            if let dvc = segue.destination as? DetailCollectionViewController {
                dvc.journey = self.journey
            }
        }
    }
    
    func saveData() {
        // Call journey array
        let controller = self.navigationController?.viewControllers.first as! ViewController
        var allJourney = controller.journey
        allJourney[self.index!] = self.journey!
        
        func archiveJourney(journey:[Journey]) -> NSData {
            let archivedObject = NSKeyedArchiver.archivedData(withRootObject: journey)
            return archivedObject as NSData
        }
        let archivedObject = archiveJourney(journey: allJourney)
        // Save to UserDefaults & 同步
        UserDefaults.standard.set(archivedObject, forKey: "Journey")
        UserDefaults.standard.synchronize()
    }
    
    
}

// MARK: - Extension
// Add Done button for Keyboard
extension UITextField {
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.addHideinputAccessoryView()
    }
    
    func addHideinputAccessoryView() {
        
        let button = UIButton(frame: CGRect(x: 0,y: 0,width: 50,height: 44))
        button.setTitle("Done", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(self.resignFirstResponder), for: .touchUpInside)
        
        
        let barButton = UIBarButtonItem(customView: button)
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let toolbar = UIToolbar(frame: CGRect(x:0, y:0, width:self.frame.size.width, height:44))
        
        toolbar.items = [space, barButton]
        self.inputAccessoryView = toolbar
    }
    
}
