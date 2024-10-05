//
//  SavedGamesViewController.swift
//  tic-turing-toe
//
//  Created by Priyank Ahuja on 10/4/24.
//

import UIKit

class SavedGamesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var games: [Game]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "SavedGameTableViewCell", bundle: nil), forCellReuseIdentifier: "SavedGameTableViewCell")
        // Do any additional setup after loading the view.
        fetchData()
    }
    
    func fetchData() {
        do {
            self.games = try context.fetch(Game.fetchRequest())
            print("games", games?.count ?? -1)
            
            if (games?.count == 0) {
                print("games", games?.count ?? -1)
                //self.emptyListLabel.isHidden = false
            } else {
                print("games", games?.count ?? -1)
                //self.emptyListLabel.isHidden = true
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            
        }
        
    }
}

extension SavedGamesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + (self.games?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedGameTableViewCell", for: indexPath) as! SavedGameTableViewCell
        if(indexPath.item != 0) {
            guard let game = games?[indexPath.item-1] else {return cell}
            let model = SavedGameCellModel(game: game, sno: "\(indexPath.item)")
            cell.setupInterface(model: model)
        } else {
            cell.setupInterface()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
