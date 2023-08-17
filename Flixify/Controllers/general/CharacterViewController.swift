//
//  CharacterViewController.swift
//  Flixify
//
//  Created by Pranav Choudhary on 10/08/23.
//

import Foundation
import UIKit

//https://api.themoviedb.org/3/person/976/images
//https://api.themoviedb.org/3/person/{person_id}

class CharacterViewController: UIViewController {

   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
    }
    

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationController?.navigationBar.isHidden = false
    }
    
    
    
    
    
    
    
    
    
    
    
    

}

