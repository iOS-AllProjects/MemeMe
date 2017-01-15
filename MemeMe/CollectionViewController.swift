//
//  CollectionViewController.swift
//  MemeMe
//
//  Created by Etjen Ymeraj on 9/21/16.
//  Copyright © 2016 Etjen Ymeraj. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController {
    
    @IBOutlet weak var memesCollectionView: UICollectionView!
    
    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        memesCollectionView!.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        memesCollectionView.reloadData()
    }
    

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, let selectedMeme = sender as? Meme{
            if identifier == "collectionSegue" {
                let destination = segue.destination as? ViewController
                destination?.meme = selectedMeme
                destination?.index = self.memesCollectionView.indexPathsForSelectedItems!.first!.row
                
            }
        }
    }
}

extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = memesCollectionView.dequeueReusableCell(withReuseIdentifier: "collectionMemeCell", for: indexPath) as! CollectionViewCell
        cell.memeCellImageView.image = memes[indexPath.row].newimage
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "collectionSegue", sender: memes[indexPath.row])

    }
}
