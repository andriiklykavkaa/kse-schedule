//
//  StudentCell.swift
//  KSE Schedule Beta
//
//  Created by Andrii Klykavka on 01.10.2024.
//

import UIKit

class StudentCell: UITableViewCell {
    
    static let reuseID = "StudentCell"
    var avatarImageView = KSImageView(frame: .zero)
    var initialsLabel = KSTitleLabel(textAlignment: .left, fontSize: 20)
    var specialtyLabel = KSBodyLabel(fontSize: 18)
        
    var student: Student!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(_ student: Student) {
        self.student = student
        initialsLabel.text = "\(student.surname) \(student.name)"
        specialtyLabel.text = student.specialty
    }
    
    
    private func setupViews() {
        addSubview(initialsLabel)
        addSubview(specialtyLabel)
        addSubview(avatarImageView)
//        addSubview(actionButton)
        
        
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            avatarImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            avatarImageView.heightAnchor.constraint(equalToConstant: 48),
            avatarImageView.widthAnchor.constraint(equalTo: avatarImageView.heightAnchor),
            
            initialsLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            initialsLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: padding),
            initialsLabel.heightAnchor.constraint(equalToConstant: 24),
            initialsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            
            specialtyLabel.topAnchor.constraint(equalTo: initialsLabel.bottomAnchor, constant: 4),
            specialtyLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: padding),
            specialtyLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            specialtyLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            
//            actionButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
//            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
//            actionButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
//            actionButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
}
