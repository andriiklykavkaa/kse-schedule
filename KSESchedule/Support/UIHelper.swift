//
//  UIHelper.swift
//  KSE Schedule Beta
//
//  Created by Andrii Klykavka on 01.10.2024.
//

import Foundation

final class UIHelper {
    static func filterSearchResult(in students: [Student], with filter: String) -> [Student] {
        let filterLowercased = filter.lowercased()
        let components = filterLowercased.components(separatedBy: " ").filter { !$0.isEmpty }
        return students.filter {
            
            let surnameLowercased = $0.surname.lowercased()
            let nameLowercased = $0.name.lowercased()
            
            switch components.count {
            case 1:
                return  surnameLowercased.contains(filterLowercased) || nameLowercased.contains(filterLowercased)
            case 2:
                return  (surnameLowercased.contains(components[0]) && nameLowercased.contains(components[1])) ||
                        (surnameLowercased.contains(components[1]) && nameLowercased.contains(components[0]))
            default:
                return false
            }
        }
    }
}
