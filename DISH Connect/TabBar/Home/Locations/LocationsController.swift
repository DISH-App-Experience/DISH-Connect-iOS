//
//  LocationsController.swift
//  DISH Connect
//
//  Created by JJ Zapata on 4/6/21.
//

import UIKit
import MapKit
import Firebase
import MBProgressHUD

class LocationsController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    // MARK: - Constants
    
    let collectCellId = "CollectionViewCellLocations"
    
    // MARK: - Variables
    
    var locations = [Location]()
    
    var collectionView : UICollectionView?
    
    // MARK: - View Objects
    
    let nilView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let nilImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "emptyLocation")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        return imageView
    }()
    
    let nilTitleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "mainTextColor")!
        label.text = "No Locations here...\nAdd some now!"
        label.numberOfLines = 3
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    let floatingActionButton : UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setImage(UIImage(systemName: "plus"), for: UIControl.State.normal)
        button.tintColor = UIColor.white
        button.layer.cornerRadius = 28
        button.backgroundColor = UIColor.mainBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addFABTapped), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    // MARK: - Overriden Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "backgroundColor")!
        
        title = "Locations"
    
        collectionViewStuff()
        updateViewConstraints()
        delegates()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = UIColor.mainBlue
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.backButtonTitle = "Back"
        
        backend()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        constraints()
    }
    
    // MARK: - Private Functions
    
    private func collectionViewStuff() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    }
    
    private func constraints() {
        view.addSubview(collectionView!)
        collectionView?.register(LocationsCell.self, forCellWithReuseIdentifier: collectCellId)
        collectionView?.backgroundColor = UIColor(named: "backgroundColor")
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.alwaysBounceVertical = true
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        collectionView?.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        collectionView?.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        collectionView?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        
        view.addSubview(floatingActionButton)
        floatingActionButton.widthAnchor.constraint(equalToConstant: 56).isActive = true
        floatingActionButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        floatingActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        floatingActionButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
    }
    
    private func backend() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        locations.removeAll()
        Database.database().reference().child("Apps").child(globalAppId).child("locations").observe(DataEventType.childAdded) { (snapshot) in
            if let value = snapshot.value as? [String : Any] {
                let location = Location()
                location.image = value["image"] as? String ?? "nil"
                location.long = value["long"] as? Double
                location.lat = value["lat"] as? Double
                location.street = value["street"] as? String ?? "nil"
                location.city = value["city"] as? String ?? "nil"
                location.zip = value["zip"] as? String ?? "nil"
                location.state = value["state"] as? String ?? "nil"
                location.key = snapshot.key
                if location.long != nil, location.lat != nil {
                    self.locations.append(location)
                }
            }
            self.collectionView!.reloadData()
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    private func delegates() {
        collectionView?.delegate = self
        collectionView?.dataSource = self
    }
    
    private func showNilValue() {
        view.addSubview(nilView)
        nilView.widthAnchor.constraint(equalToConstant: 249).isActive = true
        nilView.heightAnchor.constraint(equalToConstant: 232).isActive = true
        nilView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        nilView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        nilView.addSubview(nilImageView)
        nilImageView.topAnchor.constraint(equalTo: nilView.topAnchor).isActive = true
        nilImageView.leftAnchor.constraint(equalTo: nilView.leftAnchor).isActive = true
        nilImageView.rightAnchor.constraint(equalTo: nilView.rightAnchor).isActive = true
        nilImageView.heightAnchor.constraint(equalToConstant: 161).isActive = true
        
        nilView.addSubview(nilTitleLabel)
        nilTitleLabel.topAnchor.constraint(equalTo: nilImageView.bottomAnchor).isActive = true
        nilTitleLabel.leftAnchor.constraint(equalTo: nilImageView.leftAnchor).isActive = true
        nilTitleLabel.rightAnchor.constraint(equalTo: nilImageView.rightAnchor).isActive = true
        nilTitleLabel.bottomAnchor.constraint(equalTo: nilView.bottomAnchor).isActive = true
    }
    
    private func hideNilValue() {
        nilView.removeFromSuperview()
    }
    
    private func presentDetailedController(withAction action: String, withPostId postId: String?) {
        let controller = LocationDetailController()
        controller.action = action
        if postId != "none" {
            controller.locationId = postId
        }
        controller.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Objective-C Functions
    
    @objc func addFABTapped() {
        presentDetailedController(withAction: "POST", withPostId: "none")
    }
    
    // MARK: - UICollectionView Delegate & Data Source Functions
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if locations.count == 0 {
            showNilValue()
            return 0
        } else {
            hideNilValue()
            return locations.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectCellId, for: indexPath) as! LocationsCell
        
        if let title = self.locations[indexPath.row].street {
            cell.firstTitle.text = title
        } else {
            cell.firstTitle.text = "Untitled Location"
        }
        
        if let image = self.locations[indexPath.row].image {
            if image == "nil" {
                cell.isNil()
                let annotation = MKPointAnnotation()
                annotation.title = "Location"
                let coordinate = CLLocationCoordinate2D(latitude: self.locations[indexPath.row].lat!, longitude: self.locations[indexPath.row].long!)
                annotation.coordinate = coordinate
                let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                cell.mapView.setRegion(region, animated: false)
                cell.mapView.addAnnotation(annotation)
            } else {
                cell.firstServiceImage.loadImage(from: URL(string: image)!)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presentDetailedController(withAction: "GET", withPostId: locations[indexPath.row].key)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (self.collectionView!.frame.width / 2) - 10
        return CGSize(width: size, height: size)
    }

}
