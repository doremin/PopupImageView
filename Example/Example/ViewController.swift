//
//  ViewController.swift
//  Example
//
//  Created by doremin on 3/6/24.
//

import UIKit

import PopupImageView

class ViewController: UIViewController {

  let popupImageView: PopupImageView = {
    let imageView = PopupImageView()
    imageView.image = UIImage(named: "cat")
    return imageView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    view.addSubview(popupImageView)
    view.backgroundColor = .white
    
    NSLayoutConstraint.activate([
      popupImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      popupImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -30),
      popupImageView.widthAnchor.constraint(equalToConstant: 150),
      popupImageView.heightAnchor.constraint(equalToConstant: 150)
    ])
  }
}

