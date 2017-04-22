//
//  MenuItemListViewController.swift
//  Pay-hub
//
//  Created by RSTI E-Services on 18/04/17.
//  Copyright © 2017 RSTI E-Services. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class MenuItemListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var CollectionViewList: UICollectionView!
    public var selectedGroup: NSDictionary = [:]
    var itemArray : NSArray = []

    override func viewDidLoad() {
        super.viewDidLoad()
        CollectionViewList.dataSource = self
        CollectionViewList.delegate = self
        
        
        self.navigationItem.title = "Veg Starters"
        print("Selected Dictionary group is \(selectedGroup)")
        
        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let HEADERS: HTTPHeaders = [
            "Token": "d75542712c868c1690110db641ba01a",
            "Accept": "application/json",
            "user_name" : "admin",
            "user_id" : "3"
        ]
        
        let MenuID = selectedGroup.value(forKey: "menu_id") as! String
        let Parameters = ["menu_id":MenuID] as Dictionary<String, String>
        
        //create the url with URL
        Alamofire.request(
            URL(string: "https://pay-hub.in/payhub%20api/v1/item_detail.php")!,
            method: .post,
            parameters: Parameters,
            headers: HEADERS
            )
            .validate()
            
            .responseJSON { response in
                debugPrint(response)
                
                
                if let json = response.result.value {
                    let dict = json as! NSDictionary
                    self.itemArray = (dict.value(forKeyPath: "Response.data.item") as? NSArray)!
                    self.CollectionViewList.reloadData()
                   
                    
                }
                
        }
        
        
    }

    

    func numberOfSections(in collectionView: UICollectionView) -> Int {
         return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = CollectionViewList.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MenuItemCollectionViewCell
        
        let dict = itemArray[indexPath.row] as? NSDictionary
        let imageaddress  = dict?.value(forKey: "item_image") as! String
        let imageURL = String(format: "https://pay-hub.in/tpl/web_admin_3/img/%@",imageaddress)
        cell.itemImageView.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "loading"))
        
        
//        let imageURL = String(format: "https://pay-hub.in/tpl/web_admin_3/img/%@",imageaddress)
//        let url = NSURL(string:imageURL)
//        let data = NSData(contentsOf: (url as URL?)!)
//        cell.itemImageView.image = UIImage(data:(data as Data?)!)
        
        
        cell.itemtName.text = dict?.value(forKey: "item_name") as? String
        cell.itemdescripion.text = dict?.value(forKey: "item_content") as? String
        
        let pricestring = String(format: " ₹ %@", (dict?.value(forKey: "item_price") as? String)!)
        cell.priceLabel.text = pricestring
        return cell
        
        
     
        
       
        
    }
    

}