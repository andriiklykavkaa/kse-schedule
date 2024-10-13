//
//  KSTableView.swift
//  KSE Schedule Beta
//
//  Created by Andrii Klykavka on 30.09.2024.
//

import UIKit

class KSTableView: UITableView {
    
    enum CellIdentifier: String {
        case recent
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        register(StudentCell.self, forCellReuseIdentifier: StudentCell.reuseID)
        
        translatesAutoresizingMaskIntoConstraints = false
    }
}

