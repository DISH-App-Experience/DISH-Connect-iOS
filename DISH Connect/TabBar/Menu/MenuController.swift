//
//  MenuViewController.swift
//  DISH Connect
//
//  Created by JJ Zapata on 4/14/21.
//

import UIKit
import Firebase
import MBProgressHUD
import JJFloatingActionButton

class MenuController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Constants
    
    // MARK: - Variables
    
    var categories = [Category]()
    
    var chosenCategory = "All Items"
    
    var chosenCategoryBig : Category?
    
    var items = [MenuItem]()
    
    var otherCatItems = [MenuItem]()
    
    var isOutsideAll = false
    
    var outsideCat : Category?
    
    var categoryCollectionView : UICollectionView?
    
    var barItem : UIBarButtonItem?
    
    // MARK: - View Objects
    
    let contentView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    public var tableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        return tableView
    }()
    
    let editButton : UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.setTitle("Edit Category", for: UIControl.State.normal)
        button.setTitleColor(UIColor.mainBlue, for: UIControl.State.normal)
        button.addTarget(self, action: #selector(editCatTapped), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    let nilView : UIView = {
        let view = UIView()
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let nilTitle : UILabel = {
        let label = UILabel()
        label.text = "Nothing here...\nAdd some menu items now!"
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor(named: "mainTextColor")!
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        return label
    }()
    
    let nilImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "emptyMenu")!
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        return imageView
    }()
    
    // MARK: - Overriden Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor(named: "backgroundColor")!
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        backend()
        removeEditButton()
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = UIColor.mainBlue
        navigationController?.navigationBar.prefersLargeTitles = true
        
//        barItem = UIBarButtonItem(title: "Rearrange", style: UIBarButtonItem.Style.done, target: self, action: #selector(editOrderButtonPressed))
        
        navigationItem.largeTitleDisplayMode = UINavigationItem.LargeTitleDisplayMode.always
//        navigationItem.rightBarButtonItem = barItem
        navigationItem.backButtonTitle = "Back"
        navigationItem.title = "Menu"
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        categoryCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        if let cCV = categoryCollectionView {
            cCV.backgroundColor = UIColor.clear
            cCV.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(cCV)
            cCV.delegate = self
            cCV.showsHorizontalScrollIndicator = false
            cCV.alwaysBounceHorizontal = true
            cCV.alwaysBounceVertical = false
            cCV.register(MenuCategoryCell.self, forCellWithReuseIdentifier: MenuCategoryCell.identifier)
            cCV.dataSource = self
            cCV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 17).isActive = true
            cCV.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
            cCV.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            cCV.heightAnchor.constraint(equalToConstant: 44).isActive = true
        }
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MenuItemCell.self, forCellReuseIdentifier: MenuItemCell.identifier)
        tableView.topAnchor.constraint(equalTo: categoryCollectionView!.bottomAnchor, constant: 27).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25).isActive = true
        
        floatingActionButton()
        
        addNilView()
    }
    
    // MARK: - Private Functions
    
    private func backend() {
        checkCategories()
        checkItems()
    }
    
    private func floatingActionButton() {
        let fab = JJFloatingActionButton()
        fab.addItem(title: "Add Category", image: UIImage(named: "layer")!) { (item) in
            self.presentDetailedController(controller: "category", withAction: "POST", withPostId: "none")
        }
        fab.addItem(title: "Add Menu Item", image: UIImage(named: "food")!) { (item) in
            self.presentDetailedController(controller: "item", withAction: "POST", withPostId: "none")
        }
        fab.buttonColor = UIColor.mainBlue
        fab.buttonImageColor = UIColor.white
        fab.shadowColor = UIColor.clear
        view.addSubview(fab)
        fab.translatesAutoresizingMaskIntoConstraints = false
        fab.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        fab.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
    }
    
    private func checkCategories() {
        categories.removeAll()
        let all = Category()
        all.name = "All Items"
        all.key = "All Items"
        all.selected = true
        categories.append(all)
        Database.database().reference().child("Apps").child(globalAppId).child("menu").child("categories").observe(DataEventType.childAdded) { (snapshot) in
            if let value = snapshot.value as? [String : Any] {
                let category = Category()
                category.name = value["name"] as? String
                category.key = value["key"] as? String
                category.selected = false
                self.categories.append(category)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
            DispatchQueue.main.async {
                self.categoryCollectionView!.reloadData()
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    private func checkItems() {
        items.removeAll()
        Database.database().reference().child("Apps").child(globalAppId).child("menu").child("items").observe(DataEventType.childAdded) { (snapshot) in
            if let value = snapshot.value as? [String : Any] {
                let item = MenuItem()
                item.title = value["title"] as? String
                item.desc = value["description"] as? String
                item.price = value["price"] as? Double
                item.category = value["category"] as? String
                item.listorder = value["listOrder"] as? Int
                item.image = value["image"] as? String
                item.timeStamp = value["time"] as? Int
                item.key = value["key"] as? String ?? snapshot.key
                self.items.append(item)
            }
            DispatchQueue.main.async {
                let sortedList = self.items.sorted(by: { $1.timeStamp! < $0.timeStamp! } )
                self.items.removeAll()
                self.items = sortedList
                self.tableView.reloadData()
            }
        }
    }
    
    private func addEditButton() {
        view.addSubview(editButton)
        editButton.alpha = 1
        editButton.widthAnchor.constraint(equalToConstant: 203).isActive = true
        editButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
        editButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        editButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
    }
    
    private func addNilView() {
        view.addSubview(nilView)
        nilView.widthAnchor.constraint(equalToConstant: 249).isActive = true
        nilView.heightAnchor.constraint(equalToConstant: 232).isActive = true
        nilView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nilView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        nilView.addSubview(nilTitle)
        nilTitle.widthAnchor.constraint(equalTo: nilView.widthAnchor).isActive = true
        nilTitle.centerXAnchor.constraint(equalTo: nilView.centerXAnchor).isActive = true
        nilTitle.bottomAnchor.constraint(equalTo: nilView.bottomAnchor).isActive = true
        nilTitle.heightAnchor.constraint(equalToConstant: 43).isActive = true
        
        nilView.addSubview(nilImageView)
        nilImageView.topAnchor.constraint(equalTo: nilView.topAnchor).isActive = true
        nilImageView.leftAnchor.constraint(equalTo: nilView.leftAnchor).isActive = true
        nilImageView.rightAnchor.constraint(equalTo: nilView.rightAnchor).isActive = true
        nilImageView.bottomAnchor.constraint(equalTo: nilTitle.topAnchor, constant: -32).isActive = true
    }
    
    private func removeEditButton() {
        editButton.alpha = 0
    }
    
    private func showNilView() {
        nilView.alpha = 1
    }
    
    private func hideNilView() {
        nilView.alpha = 0
    }
    
    // MARK: - Objective-C Functions
    
    @objc func editCatTapped() {
        let controller = MenuCategoryDetailController()
        controller.action = "GET"
        controller.categoryId = chosenCategoryBig?.key!
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func editOrderButtonPressed() {
        tableView.isEditing = !tableView.isEditing
        
        switch tableView.isEditing {
        case true:
            barItem?.title = "Done"
        case false:
            barItem?.title = "Rearrange"
        }
    }
    
    // MARK: - UICollectionView Delegate & Data Source Functions
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        MBProgressHUD.hide(for: self.view, animated: true)
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCategoryCell.identifier, for: indexPath) as! MenuCategoryCell
        cell.backgroundColor = UIColor(named: "secondaryBackground")!
        cell.layer.cornerRadius = 10
        cell.category = categories[indexPath.row]
        if categories[indexPath.row].selected! {
            cell.layer.borderColor = UIColor.mainBlue.cgColor
            cell.layer.borderWidth = 2
        } else {
            cell.layer.borderWidth = 0
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for category in categories {
            category.selected! = false
        }
        chosenCategory = categories[indexPath.row].name!
        categories[indexPath.row].selected = true
        chosenCategoryBig = categories[indexPath.row]
        if indexPath.item == 0 {
            isOutsideAll = false
            removeEditButton()
        } else {
            isOutsideAll = true
            otherCatItems.removeAll()
            // edit otherCatItems
            otherCatItems = items.filter { $0.category! == categories[indexPath.row].key! }
            addEditButton()
        }
        categoryCollectionView!.reloadData()
        tableView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: estimateFrameForText(text: categories[indexPath.row].name!).width + 30, height: 44)
    }
    
    // MARK: - UITableView Delegate & Data Source Functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isOutsideAll {
            if otherCatItems.count == 0 {
                print("nil")
                showNilView()
                MBProgressHUD.hide(for: self.view, animated: true)
            } else {
                print("not nil")
                hideNilView()
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            return otherCatItems.count
        } else {
            if items.count == 0 {
                print("nil")
                showNilView()
                MBProgressHUD.hide(for: self.view, animated: true)
            } else {
                print("not nil")
                hideNilView()
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            return items.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isOutsideAll {
            let cell = tableView.dequeueReusableCell(withIdentifier: MenuItemCell.identifier, for: indexPath) as! MenuItemCell
            
            if let imageUrl = otherCatItems[indexPath.row].image {
                cell.itemImageView.loadImageUsingUrlString(urlString: imageUrl)
            } else {
                print("image view not able to define image")
                cell.itemImageView.image = UIImage(named: "unknownItem")!
            }
            
            if let title = otherCatItems[indexPath.row].title {
                cell.itemTitleLabel.text = title
            }
            
            if let desc = otherCatItems[indexPath.row].desc {
                cell.itemDescLabel.text = desc
            }
            
            if let price = otherCatItems[indexPath.row].price {
                cell.itemPriceLabel.text = "$\(price)"
            }
            
            if let category = otherCatItems[indexPath.row].category {
                Database.database().reference().child("Apps").child(globalAppId).child("menu").child("categories").child(category).child("name").observe(DataEventType.value) { (snapshot) in
                    if let value = snapshot.value as? String {
                        cell.itemCatLabel.text = "(\(value))"
                    }
                }
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: MenuItemCell.identifier, for: indexPath) as! MenuItemCell
            
            if let imageUrl = items[indexPath.row].image {
                cell.itemImageView.loadImageUsingUrlString(urlString: imageUrl)
            } else {
                print("image view not able to define image")
                cell.itemImageView.image = UIImage(named: "unknownItem")!
            }
            
            if let title = items[indexPath.row].title {
                cell.itemTitleLabel.text = title
            }
            
            if let desc = items[indexPath.row].desc {
                cell.itemDescLabel.text = desc
            }
            
            if let price = items[indexPath.row].price {
                cell.itemPriceLabel.text = "$\(price)"
            }
            
            if let category = items[indexPath.row].category {
                Database.database().reference().child("Apps").child(globalAppId).child("menu").child("categories").child(category).child("name").observe(DataEventType.value) { (snapshot) in
                    if let value = snapshot.value as? String {
                        cell.itemCatLabel.text = "(\(value))"
                    }
                }
            }
            
            return cell
        }
    }
    
//    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        let item = items[sourceIndexPath.row]
//        let startIndex = sourceIndexPath.row
//        let endIndex = destinationIndexPath.row
//        let difference = (startIndex - endIndex)
//
//        items.remove(at: startIndex)
//        items.insert(item, at: endIndex)
//
////        for item in items {
////            if item.listorder < XXX {
//////                Database.database().reference().child("Apps").child(globalAppId).child("menu").child("items").child(item.key!).child("listOrder").setValue(item.listorder! - 1)
////            } else if item.listorder > XXX {
//////                Database.database().reference().child("Apps").child(globalAppId).child("menu").child("items").child(item.key!).child("listOrder").setValue(item.listorder! - 1)
////            }
////        }
////        Database.database().reference().child("Apps").child(globalAppId).child("menu").child("items").child(item.key!).child("listOrder").setValue(destinationIndexPath.row)
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isOutsideAll {
            print("not all item")
            let controller = AddMenuItemController()
            controller.action = "GET"
            controller.menuItemId = otherCatItems[indexPath.row].key!
            self.navigationController?.pushViewController(controller, animated: true)
        } else {
            print("all items")
            let controller = AddMenuItemController()
            controller.action = "GET"
            controller.menuItemId = items[indexPath.row].key!
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 114
    }

}



let imageCache = NSCache<NSString, UIImage>()

class CustomImageView: UIImageView {
    
    var imageUrlString: String?
    
    func loadImageUsingUrlString(urlString: String) {
        
        imageUrlString = urlString
        
        guard let url = URL(string: urlString) else { return }
        
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            self.image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, respones, error) in
            
            if error != nil {
                print(error ?? "")
                return
            }
            
            DispatchQueue.main.async {
                guard let imageToCache = UIImage(data: data!) else { return }
                
                if self.imageUrlString == urlString {
                    self.image = imageToCache
                }
                
                imageCache.setObject(imageToCache, forKey: urlString as NSString)
            }
            
        }).resume()
    }
    
}

