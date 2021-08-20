//
//  AnalyticsBoard.swift
//  DISH Connect
//
//  Created by JJ Zapata on 7/26/21.
//

import UIKit
import MBProgressHUD

class AnalyticsBoard: UIViewController {
    
    // MARK: - Constants

    // MARK: - Variables

    // MARK: - View Objects

    // MARK: - Overriden Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        view.backgroundColor = UIColor(named: "backgroundColor")!

        navigationItem.title = "Analytical Board"

        updateViewConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = UIColor.mainBlue
        navigationController?.navigationBar.prefersLargeTitles = true

        backend()
    }

    override func updateViewConstraints() {
        super.updateViewConstraints()

        constraints()
    }

    // MARK: - Private Functions

    private func constraints() {
        //
    }

    func backend() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        MBProgressHUD.hide(for: self.view, animated: true)
    }

    // MARK: - Objective-C Functions

}
