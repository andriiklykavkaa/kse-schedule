//
//  KSDeleteCellButton.swift
//  KSE Schedule Beta
//
//  Created by Andrii Klykavka on 01.10.2024.
//

import UIKit

class KSDeleteCellButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        tintColor = .secondaryLabel
    }
}
