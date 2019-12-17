//
//  StatusView.swift
//  DesafioIos
//
//  Created by Kacio on 15/12/19.
//  Copyright © 2019 Kacio Henrique Couto Batista. All rights reserved.
//

import UIKit
import Foundation
class StatusView: UIView {
    var image:UIImage?
    var descriptionScreen:String?
    var state:StatusConnection? {
        didSet{
            self.upadateUI()
        }
    }
    var vSpinner:UIView?
    lazy var imageDescriptionProblem:UIImageView = {
        let view = UIImageView(frame: .zero)
        view.adjustsImageSizeForAccessibilityContentSizeCategory = true
        view.image = self.image
        return view
    }()
    lazy var textDescriptionProblem:UILabel = {
        let view = UILabel(frame: .zero)
        view.font = UIFont(name: "Times New Roman", size: 32)
        view.text = self.descriptionScreen
        view.numberOfLines = 10
        view.textAlignment = .center
        return view
    }()
    init(state:StatusConnection){
        self.state = state
        super.init(frame: UIScreen.main.bounds)
        self.upadateUI()
        setupView()
    }
    init(image:UIImage,descriptionScreen:String){
        super.init(frame: UIScreen.main.bounds)
        self.imageDescriptionProblem.image = image
        self.textDescriptionProblem.text = descriptionScreen
        self.setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func upadateUI(){
        if self.state == .sending {
            DispatchQueue.main.async {
                self.imageDescriptionProblem.image = #imageLiteral(resourceName: "FilterIcon")
                self.textDescriptionProblem.text = "carregando"
                self.showSpinner()
            }
        }
        if self.state == .dontConnection{
            DispatchQueue.main.async {
                self.imageDescriptionProblem.image = #imageLiteral(resourceName: "list_icon")
                self.textDescriptionProblem.text = "sem concetion"
                self.removeSpinner()
            }
        }
        else {
            self.removeSpinner()
        }
    }
    func showSpinner() {
        let spinnerView = UIView.init(frame: self.bounds)
        spinnerView.backgroundColor = .white
        let ai = UIActivityIndicatorView(style: .large)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            self.addSubview(spinnerView)
        }
        self.vSpinner = spinnerView
    }
    func removeSpinner() {
         DispatchQueue.main.async {
            self.vSpinner?.removeFromSuperview()
            self.vSpinner = nil
         }
     }
}
extension StatusView:CodeView{
    func buildViewHierarchy() {
        self.addSubview(imageDescriptionProblem)
        self.addSubview(textDescriptionProblem)
    }
    
    func setupConstraints() {
        imageDescriptionProblem.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalToSuperview().multipliedBy(0.2)
        }
        textDescriptionProblem.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageDescriptionProblem.snp.bottom).offset(15)
            make.width.equalToSuperview().multipliedBy(0.8)
        }
    }
    
    func setupAdditionalConfiguration() {
        self.backgroundColor = .white
    }
}


