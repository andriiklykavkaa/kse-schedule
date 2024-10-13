//
//  StorageManager.swift
//  KSE Schedule Beta
//
//  Created by Andrii Klykavka on 13.09.2024.
//

import Foundation

class StudentStorage {
    
    static var shared = StudentStorage()
    private var storageKey = "Recent"
    private var storage = UserDefaults.standard
    
    private(set) var recentStudents: [Student] = []
    
    init() {
        recentStudents = loadStudents()
    }
    
    
    func addStudent(_ student: Student) {
        if let index = recentStudents.firstIndex(where: { $0.rowIndex == student.rowIndex}) {
            recentStudents.remove(at: index)
        }
        
        recentStudents.insert(student, at: 0)
        
        if recentStudents.count > 12 {
            recentStudents.removeLast()
        }
        
        self.saveStudents(recentStudents)
    }
    
    
    func removeStudent(_ student: Student) {
        if let index = recentStudents.firstIndex(where: { $0.rowIndex == student.rowIndex }) {
            recentStudents.remove(at: index)
        }
        
        self.saveStudents(recentStudents)
    }
    
    
    private func saveStudents(_ students: [Student]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(students) {
            storage.set(encoded, forKey: storageKey)
        }
    }
    
    
    private func loadStudents() -> [Student] {
        guard let data = storage.data(forKey: storageKey) else {
            return []
        }
        
        let decoder = JSONDecoder()
        if let decoded = try? decoder.decode([Student].self, from: data) {
            return decoded
        }
        return []
    }
}
