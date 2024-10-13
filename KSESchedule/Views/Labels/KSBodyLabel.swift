//
//  KSBodyLabel.swift
//  KSE Schedule Beta
//
//  Created by Andrii Klykavka on 01.10.2024.
//

import UIKit

class KSBodyLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(fontSize: CGFloat) {
        super.init(frame: .zero)
        self.font = UIFont.systemFont(ofSize: fontSize)
        configure()
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        textColor                   = .secondaryLabel
        adjustsFontSizeToFitWidth   = true
        lineBreakMode               = .byWordWrapping
        minimumScaleFactor          = 0.75
        
    }
}
