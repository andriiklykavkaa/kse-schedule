//
//  ExcelManager.swift
//  KSE Schedule Beta
//
//  Created by Andrii Klykavka on 05.09.2024.
//

import UIKit
import CoreXLSX

class ExcelManager {
    
    static let shared = ExcelManager()
    
    
    private func loadFileData() -> Data? {
        return NSDataAsset(name: "schedule")?.data
    }
    
    
    lazy var sharedStrings: SharedStrings? = {
        guard let fileData = loadFileData() else { return nil }
            do {
                
                let spreadSheet = try XLSXFile(data: fileData)
                return try spreadSheet.parseSharedStrings()
            } catch {
                print("Error loading shared strings: \(error)")
            }
        return nil
    }()
    
    
    lazy var worksheet: Worksheet? = {
        guard let fileData = loadFileData() else { return nil }
        do {
            let spreadsheet = try XLSXFile(data: fileData)
            if let firstPath = try spreadsheet.parseWorksheetPaths().first {
                return try spreadsheet.parseWorksheet(at: firstPath)
            }
        } catch {
            print("Error loading worksheet: \(error)")
        }
        return nil
    }()
    
    
    func getListOfStudents() -> [Student] {
        
        guard let worksheet = worksheet else { return [] }
        var studentsArray: [Student] = []
        
        let surnames = worksheet.cells(atColumns: [ColumnReference("A")!])
        let names = worksheet.cells(atColumns: [ColumnReference("B")!])
        let specialties = worksheet.cells(atColumns: [ColumnReference("D")!])
        
        guard surnames.count == names.count && names.count == specialties.count else { return [] }
        
        for (index, surnameCell) in surnames.enumerated() {
            if index > 0,
               let surnameIndex = surnameCell.value,
               let surname = sharedStrings?.items[Int(surnameIndex)!].text,
               let nameIndex = names[index].value,
               let name = sharedStrings?.items[Int(nameIndex)!].text,
               let specialtyIndex = specialties[index].value,
               let specialty = sharedStrings?.items[Int(specialtyIndex)!].text {
                let student = Student(rowIndex: UInt(index + 1), surname: surname, name: name, specialty: specialty)
                studentsArray.append(student)
            }
               
        }
        
        return studentsArray
    }
   
    
    func getStudentClasses(for student: Student) -> [String] {
        guard let worksheet = worksheet else { return [] }
        
        return worksheet.cells(atRows: [student.rowIndex])
            .filter { $0.reference.column >= ColumnReference("E")! }
            .compactMap { cell in
                if let sharedStringIndex = cell.value {
                    return sharedStrings?.items[Int(sharedStringIndex)!].text
                }
                return nil
            }
    }
}
