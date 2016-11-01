//
//  DetailCollectionViewController.swift
//  MyPacking
//
//  Created by 洪德晟 on 2016/10/26.
//  Copyright © 2016年 洪德晟. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class DetailCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    @IBAction func exitButton(_ sender: UIBarButtonItem) {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    var journey: Journey?
    
    var index: Int?
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let eachCate = (self.journey?.categories[indexPath.section])! as [String:Any]
        let item = (eachCate["items"] as! Array<Any>)[indexPath.row] as! [String:Any]
        let itemPacked = item["isPack"] as! Bool
        
        if itemPacked {
            let cellSize = CGSize(width: (view.frame.width) - 30, height: 0)
            return cellSize
        } else {
            let cellSize = CGSize(width: (view.frame.width) - 30, height: (view.frame.height) / 6)
            return cellSize
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // 修改標題
        self.title = journey?.name
        // hiden back button
        self.navigationItem.hidesBackButton = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return (journey?.categories.count)!
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let eachCate = self.journey?.categories[section]
        let items = eachCate?["items"] as! Array<Any>
        
        return items.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ItemCollectionViewCell
        
        let eachCate = (self.journey?.categories[indexPath.section])! as [String:Any]
        let item = (eachCate["items"] as! Array<Any>)[indexPath.row] as! [String:Any]
        let itemName = item["itemName"] as! String
//        let itemPacked = item["isPack"] as! Bool
        if let count = item["number"] {
            cell.numberLabel.text = "X " + String(describing: count)
        }
        cell.itemLabel.text = itemName
//        if itemPacked {
//            cell.isHidden = true
//        }
//        cell.itemLabel.textColor = itemPacked ? UIColor.lightGray : UIColor.black
//        cell.numberLabel.textColor = itemPacked ? UIColor.lightGray : UIColor.black
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var eachCate = journey?.categories[indexPath.section]
        var eachItem = ((eachCate?["items"]) as? [[String:Any]])?[indexPath.row]
        var newCate = (eachCate?["items"] as! [[String:Any]])
        var isPack = eachItem?["isPack"] as! Bool
        isPack = true
        eachItem?["isPack"] = isPack
        newCate[indexPath.row] = eachItem!
        self.journey?.categories[indexPath.section]["items"] = newCate
        collectionView.reloadData()
        print("===================\(eachItem)====================")
        // save data
        self.saveData()
    }

    func saveData() {
        // Call journey array
        let controller = self.navigationController?.viewControllers[0] as! ViewController
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
