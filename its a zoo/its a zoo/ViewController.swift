//
//  ViewController.swift
//  its a zoo
//
//  Created by Lester Arguello on 1/20/25.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet var animalLabel: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    var animals: [Animal] = []
    var audioPlayer: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        scrollView.contentSize = CGSize(width: 1179, height: 600)
        scrollView.delegate = self
        
        let catName = "Axel"
        let catSpecies = "Cat"
        let catAge = 2
        let catImage = UIImage(named: "cat")
        let catSoundPath = Bundle.main.path(forResource: "meow", ofType: "wav")
        let catId = UUID()
        
        let dogName = "Max"
        let dogSpecies = "Dog"
        let dogAge = 3
        let dogImage = UIImage(named: "dog")
        let dogSoundPath = Bundle.main.path(forResource: "bark", ofType: "wav")
        let dogId = UUID()
        
        let owlName = "Hoots"
        let owlSpecies = "Owl"
        let owlAge = 5
        let owlImage = UIImage(named: "owl")
        let owlSoundPath = Bundle.main.path(forResource: "shriek", ofType: "wav")
        let owlId = UUID()
        
        if let catImage = catImage, let catSoundPath = catSoundPath {
            let cat = Animal(name: catName, species: catSpecies, age: catAge, image: catImage, soundPath: catSoundPath, id: catId)
            animals.append(cat)
        } else {
            print("Failed to create animal due to missing image or sound path.")
        }
        
        if let dogImage = dogImage, let dogSoundPath = dogSoundPath {
            let dog = Animal(name: dogName, species: dogSpecies, age: dogAge, image: dogImage, soundPath: dogSoundPath, id: dogId)
            animals.append(dog)
        } else {
            print("Failed to create animal due to missing image or sound path.")
        }
        
        if let owlImage = owlImage, let owlSoundPath = owlSoundPath {
            let owl = Animal(name: owlName, species: owlSpecies, age: owlAge, image: owlImage, soundPath: owlSoundPath, id: owlId)
            animals.append(owl)
        } else {
            print("Failed to create animal due to missing image or sound path.")
        }
        
        animals.shuffle()
        animalLabel.text = animals[0].species
        
        for i in 0..<3 {
            var config = UIButton.Configuration.filled()
            config.title = animals[i].name
            
            let button = UIButton(configuration: config)
            button.frame = CGRect(
                x: i * 393 + 100,
                y: 200,
                width: 100,
                height: 50
            )
            button.tag = i
            
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            
            let imageView = UIImageView(image: animals[i].image)
            imageView.contentMode = .scaleAspectFit
            imageView.frame = CGRect(
                x: i * 393,
                y: 0,
                width: 393,
                height: 393
            )
            
            scrollView.addSubview(imageView)
            scrollView.addSubview(button)
        }
    }
    
    @objc func buttonTapped(_ button: UIButton) {
        let buttonTag = button.tag
        let animal = animals[buttonTag]
        
        let alertController = UIAlertController(title: animal.name, message: "This \(animal.species) is \(animal.age) years old.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            // Handle Cancel Action
        }
        let playSoundAction = UIAlertAction(title: "Play Sound", style: .default) { (_) in
            // Handle Play Sound Action
            let soundURL = URL(fileURLWithPath: animal.soundPath)
            
            do {
                self.audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                self.audioPlayer?.play()
            } catch {
                print("Failed to play sound for \(animal.name): \(error)")
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(playSoundAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
}

// MARK: - UIScrollViewDelegate
extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x / 393)
        let distanceFromCenter = abs(scrollView.contentOffset.x - CGFloat(currentPage) * 393)
        let alpha = max(0, 1 - (distanceFromCenter / (393 / 2)))
        
        animalLabel.text = animals[currentPage].species
        animalLabel.alpha = alpha
    }
}

