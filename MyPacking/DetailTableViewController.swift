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
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemTableViewCell
        let eachCate = (self.journey?.categories[indexPath.section])! as [String:Any]
        let item = (eachCate["items"] as! Array<Any>)[indexPath.row] as! [String:Any]
        let itemName = item["itemName"] as! String
        cell.itemLabel.text = itemName

        return cell
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
        // Return false if you do not want the specified item to be editable.
        return true
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
    }
    
    // 按壓某列，切換打包與否(按壓過久)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        var eachCate = journey?.categories[indexPath.section]
        var eachItem = ((eachCate?["items"]) as? [[String:Any]])?[indexPath.row]
        var isPack = eachItem?["isPack"] as! Bool
        let cell = tableView.cellForRow(at: indexPath) as! ItemTableViewCell
        
        print(eachItem, isPack)

        if isPack {
            let checkImage = UIImage(named: "UnCheck")
            cell.imageButton.setImage(checkImage, for: .normal)
            cell.itemLabel.textColor = UIColor.black
            var newCate = (eachCate?["items"] as! [[String:Any]])
            isPack = false
            eachItem?["isPack"] = isPack
            newCate[indexPath.row] = eachItem!
            self.journey?.categories[indexPath.section]["items"] = newCate
        } else {
            let checkImage = UIImage(named: "Check")
            cell.imageButton.setImage(checkImage, for: .normal)
            cell.itemLabel.textColor = UIColor.lightGray
            var newCate = (eachCate?["items"] as! [[String:Any]])
            isPack = true
            eachItem?["isPack"] = isPack
            newCate[indexPath.row] = eachItem!
            self.journey?.categories[indexPath.section]["items"] = newCate
        }
    }

    
    // 設定哪些item可移動
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        
        return true
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
