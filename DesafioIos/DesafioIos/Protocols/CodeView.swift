//
//  CodeView.swift
//  viewCode
//
//  Created by Kacio Henrique Couto Batista on 03/12/19.
//  Copyright © 2019 Kacio Henrique Couto Batista. All rights reserved.
//

import Foundation
protocol CodeView {
    func buildViewHierarchy()
    func setupConstraints()
    func setupAdditionalConfiguration()
    func setupView()
}
extension CodeView{
    func setupView(){
        buildViewHierarchy()
        setupConstraints()
        setupAdditionalConfiguration()
    }
}
