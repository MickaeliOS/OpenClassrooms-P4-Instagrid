//
//  Extensions.swift
//  Instagrid
//
//  Created by Mickaël Horn on 28/02/2022.
//

import Foundation
import UIKit

extension UIView {
    
    // Permet de transformer une View en Image
    func asImage() -> UIImage {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
    }
    
    // Permet d'ajouter une couleur de fonds à notre StackView
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}

// Permet l'affichage de de la fênetre de sélection d'images
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImagePickerController() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagesPickersButtonsList[currentPickButton].setImage(originalImage, for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }
}
