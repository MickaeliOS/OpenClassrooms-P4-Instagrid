//
//  ViewController.swift
//  Instagrid
//
//  Created by Mickaël Horn on 13/12/2021.
//

import UIKit

class ViewController: UIViewController {
    
    // Variables
    var currentPickButton = 0
    var currentDispositionButton = 0
    var destinationFrame = CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
    var topSpace = CGFloat()
    var leftSpace = CGFloat()
    
    // La stackView à déplacer + les swipes
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet var swipeUp: UISwipeGestureRecognizer!
    @IBOutlet var swipeLeft: UISwipeGestureRecognizer!
    
    // Labels
    @IBOutlet weak var instagridLabel: UILabel!
    @IBOutlet weak var swipeLabel: UILabel!
    @IBOutlet weak var swipeLabel2: UILabel!
    
    // Boutons (Outlets)
    @IBOutlet var imagesPickersButtonsList: [UIButton]!
    @IBOutlet var dispositionButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        // On trie la collection en fonction des tag des boutons
        imagesPickersButtonsList = imagesPickersButtonsList.sorted { $0.tag < $1.tag }
        dispositionButtons = dispositionButtons.sorted { $0.tag < $1.tag }
        
        // Ajout de la couleur de fond pour la grille du milieu
        buttonStackView.addBackground(color: UIColor(named: "backgroundImage")!)

        // Paramétrage des labels
        instagridLabel.font = UIFont(name: "ThirstySoftRegular", size: 30)
        instagridLabel.textColor = UIColor(white: 1.0, alpha: 1.0)
        swipeLabel.font = UIFont(name: "Delm-Medium", size: 26)
        swipeLabel.textColor = UIColor(white: 1.0, alpha: 1.0)
        swipeLabel2.font = UIFont(name: "Delm-Medium", size: 26)
        swipeLabel2.textColor = UIColor(white: 1.0, alpha: 1.0)
        
        // On choisit une disposition par défaut
        pressDispositionButtons(dispositionButtons[0])
        
        // On controle le changement d'orientation afin d'activer le bon swipe
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    // Action des boutons contenants les images
    @IBAction func imagesPickersButtons(_ sender: UIButton) {
        currentPickButton = sender.tag
        showImagePickerController()
    }
    
    // Action des boutons de dispositions
    @IBAction func pressDispositionButtons(_ sender: UIButton) {
        // On part sur une base avec tous les boutons d'affichés afin de gérer tous les cas
        allVisible(buttonList: imagesPickersButtonsList)
        
        currentDispositionButton = sender.tag
        sender.imageView?.isHidden = false
        
        // On cache l'image du précédent bouton de disposition
        for index in 0...2 {
            if index != sender.tag {
                dispositionButtons[index].imageView?.isHidden = true
            }
        }
        
        switch sender.tag {
            case 0:
                imagesPickersButtonsList[1].isHidden = true
            case 1:
                imagesPickersButtonsList[3].isHidden = true
            case 2:
                allVisible(buttonList: imagesPickersButtonsList)
            default:
                allVisible(buttonList: imagesPickersButtonsList)
            }
    }
    
    // Action du swipe (Up ou Left)
    @IBAction func swipe(_ sender: UISwipeGestureRecognizer) {
        destinationFrame = buttonStackView.frame
        
        if sender.state == .ended {
            // On regarde de quel swipe il s'agit
            if UIDevice.current.orientation.isLandscape {
                leftSpace = buttonStackView.frame.maxX
                destinationFrame.origin.x -= leftSpace
            } else {
                topSpace = buttonStackView.frame.maxY
                destinationFrame.origin.y -= topSpace
            }
            
            // On converti la grille en image
            let finalImage = buttonStackView.asImage()
            
            // Déplacement de la vue en fonction du Swipe
            UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [], animations: {
                self.buttonStackView.frame = self.destinationFrame
            }, completion: nil)
            
            // Affichage de l'écran de partage
            displayActivityController(img: [finalImage], whichSwipe: sender)
        }
    }
    
    // Gestion du mode portrait et paysage (pour le swipe)
    @objc func rotated() {
        if UIDevice.current.orientation.isLandscape {
            swipeUp.isEnabled = false
            swipeLeft.isEnabled = true
        } else {
            swipeUp.isEnabled = true
            swipeLeft.isEnabled = false
        }
        
        // On remet la précédente disposition, car on la perdait lors du switch de mode
        pressDispositionButtons(dispositionButtons[currentDispositionButton])
    }
    
    // Permet d'afficher tous les boutons en paramètre
    private func allVisible(buttonList: [UIButton]!) {
        for element in buttonList {
            element.isHidden = false
        }
    }
    
    // Affiche l'écran de partage
    private func displayActivityController(img: [UIImage], whichSwipe: UISwipeGestureRecognizer) {
        
        // On remet la disposition initiale de la grille
        if UIDevice.current.orientation.isLandscape {
            destinationFrame.origin.x += leftSpace
        } else {
            destinationFrame.origin.y += topSpace
        }
        
        // On affiche l'écran de partage
        let ac = UIActivityViewController(activityItems: img, applicationActivities: nil)
        ac.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            
            UIView.animate(withDuration: 1) {
                self.buttonStackView.frame = self.destinationFrame
            }
            
            return
        }
        
        self.present(ac, animated: true, completion: nil)
    }
}
