//
//  IntervalTableViewController.swift
//  EarTraining
//
//  Created by Ariel Todoki on 2/7/18.
//  Copyright © 2018 Ariel Todoki. All rights reserved.
//

import UIKit

class IntervalTableViewController: UITableViewController {
    
//    var intervalExercises = ["Ascending Diatonic", "Descending Diatonic", "Ascending Chromatic", "Descending Chromatic", "Ascending Sing Interval"]
    
    var intervalExercises = [
        ["Ascending", "Descending", "Ascending Sing"],
        ["Ascending", "Descending"]
    ]
    var segueNames = [
    ["Ascending Diatonic", "Descending Diatonic", "Ascending Sing Interval"],
    ["Ascending Chromatic", "Descending Chromatic"]
    ]
    
    var headers = ["Diatonic", "Chromatic"]
    
    var descriptions = [
    ["Test your skills and identify the intervals found in a major scale! Plays bottom note, then top note.",
     "Test your skills and identify the intervals found in a major scale! Plays top note, then bottom note.",
     "Test your skills by singing diatonic intervals above a given note!"],
    ["Test your skills and identify the intervals found in a chromatic scale! Plays bottom note, then top note.",
     "Test your skills and identify the intervals found in a chromatic scale! Plays top note, then bottom note."]
    ]
    
    var imageNames = [["ascendDiatonic","descendDiatonic","ascendDiatonic"],
                      ["ascendDiatonic","descendDiatonic"]]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = headers[section]
        label.font = UIFont.boldSystemFont(ofSize: 30.0)
        label.backgroundColor = UIColor(red: 0.8431, green: 0.6784, blue: 0.8588, alpha: 1.0)
        return label
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return intervalExercises.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return intervalExercises[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ExerciseTableViewCell
        
        // Configure the cell...
        cell.nameLabel?.text = intervalExercises[indexPath.section][indexPath.row]
        cell.descriptionLabel?.text = descriptions[indexPath.section][indexPath.row]
        cell.musicImage.image = UIImage(named: imageNames[indexPath.section][indexPath.row])

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: segueNames[indexPath.section][indexPath.row], sender: self)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
