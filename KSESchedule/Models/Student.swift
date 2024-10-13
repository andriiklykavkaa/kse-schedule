//
//  Student.swift
//  KSE Schedule Beta
//
//  Created by Andrii Klykavka on 05.09.2024.
//

import Foundation


struct Student: Codable, Hashable {
    var rowIndex: UInt
    var surname: String
    var name: String
    var specialty: String
}
