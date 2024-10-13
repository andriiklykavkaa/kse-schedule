//
//  StudentVC.swift
//  KSE Schedule Beta
//
//  Created by Andrii Klykavka on 05.10.2024.
//

import UIKit
import WebKit

class StudentVC: UIViewController {
    
    var student: Student!
    var values: [Int] = []
    
    var webView: WKWebView!
    
    var isFormSubmited: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let classes = ExcelManager.shared.getStudentClasses(for: student)
        
        print(classes)
        print(student.rowIndex)
        values = classes.compactMap { classValueDictionary[$0] }
        setupViewController()
        setupWebkit()
    }
    
    func setupViewController() {
        view.backgroundColor = .systemBackground
        title = "\(student.surname) \(student.name)"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    func setupWebkit() {
        webView = WKWebView(frame: view.bounds)
        view.addSubview(webView)
        webView.navigationDelegate = self
        
        let url = URL(string: "https://schedule.kse.ua/")!
        let request = URLRequest(url: url)
        webView.load(request)
    }
}


extension StudentVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if isFormSubmited { return }
        isFormSubmited = true
        
        let openFormJS = """
        document.querySelector('.search-button').click();
        """
        
        webView.evaluateJavaScript(openFormJS) { [weak self] (result, error) in
            if let error = error {
                print("Form validation error: \(error.localizedDescription)")
            } else {
                print("Form opened successfully")
                
                self?.fillAndSubmitForm()
            }
        }
    }
    
    
    private func fillAndSubmitForm() {
        
        var codeToEvaluateJS = ""
                
        for i in 0..<values.count {
            
            var codeForValueJS = ""
            if i == 0 {
                codeForValueJS = """
                
                    let existingDiv = document.querySelector('.small-12.multi-select');
                    existingDiv.querySelector('input[name="KOD_GROUP[]"]').value = "\(values[i])";
                
                    let newDiv = existingDiv.cloneNode(true);
                """
            } else {
                codeForValueJS = """
                    newDiv = existingDiv.cloneNode(true);
                    existingDiv.parentNode.insertBefore(newDiv, existingDiv.nextSibling);
                    newDiv.querySelector('input[name="KOD_GROUP[]"]').value = "\(values[i])";
                """
            }
            codeToEvaluateJS += codeForValueJS
        }
        
        let submitFormJS = """
            setTimeout(function() {
                document.querySelector('input[type="submit"].button.m-t').click();
            }, 50)
        """
        
        codeToEvaluateJS += submitFormJS

        webView.evaluateJavaScript(codeToEvaluateJS) { (result, error) in
            if let error = error {
              print("Error compiling JavaScript: \(error.localizedDescription)")
          } else {
              print("Form submited successfully")
          }
        }
    }
}
