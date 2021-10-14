//
//  ViewController.swift
//  CoreDataIos
//
//  Created by Ayodejii Ayankola on 12/10/2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }


}

