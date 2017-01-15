//
//  TableViewController.swift
//  MemeMe
//
//  Created by Etjen Ymeraj on 9/21/16.
//  Copyright © 2016 Etjen Ymeraj. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {
    
    @IBOutlet weak var memesTableView: UITableView!
    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        memesTableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        memesTableView.reloadData()
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, let selectedMeme = sender as? Meme{
            if identifier == "tableSegue" {
                let destination = segue.destination as? ViewController
                destination?.meme = selectedMeme
                destination?.index = self.memesTableView.indexPathForSelectedRow!.row

            }
        }
    }
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = memesTableView.dequeueReusableCell(withIdentifier: "tableMemeCell", for: indexPath)
        cell.textLabel?.text = memes[indexPath.row].topText
        cell.imageView?.image = memes[indexPath.row].newimage
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //memesTableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "tableSegue", sender: memes[indexPath.row])
    }

    
    
}


