//
//  MainScreenViewController.swift
//  iCan
//
//  Created by Kendrick Choate on 9/27/16.
//  Copyright © 2016 Kendrick Choate. All rights reserved.
//

import UIKit
//an extension to the UIViewController that allows for the keyboard to be closed when the screen is tapped anywhere. Call self.hideKeyboardWhenTappedAround() in ViewDidLoad to enable the function for the view controller you are on
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

class MainScreenViewController: UITableViewController, NewJobDelegate {
    var allVisibleJobs: [[NewJob]] = [[], [], [], []]
    var chosenCell = (0,0)
    var atLeastOneJob = false
    var jobCategories = ["Housework", "Landscaping", "Painting", "Woodwork"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func addJobButtonPressed(aNewJob: NewJob) {
        //when the delegate is performed here we simply add the job from the previous page into the list of jobs and then call the reloadData() function which updates the tableview with any new data added to the list
        if aNewJob.jobCategory == jobCategories[0] {
            allVisibleJobs[0].append(aNewJob)
        }
        else if aNewJob.jobCategory == jobCategories[1] {
            allVisibleJobs[1].append(aNewJob)
        }
        else if aNewJob.jobCategory == jobCategories[2] {
            allVisibleJobs[2].append(aNewJob)
        }
        else if aNewJob.jobCategory == jobCategories[3] {
            allVisibleJobs[3].append(aNewJob)
        }
        atLeastOneJob = true
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        //returning 0 makes it so that 0 cells are dispaled. We just set the number of sections to 1 to get around this.
        return jobCategories.count
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return jobCategories[section]
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allVisibleJobs[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //In order to have detailTextLabel, we must setup the cell with the .subtitle style as done below
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "reuseIdentifier")
        //if atLeastOneJob {
            cell.textLabel!.text = allVisibleJobs[indexPath.section][indexPath.row].jobTitle
            cell.detailTextLabel!.text = allVisibleJobs[indexPath.section][indexPath.row].jobDetails
        //}
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenCell = (indexPath.section, indexPath.row)
        performSegue(withIdentifier: "SelectedJobSegue", sender: self)
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //When we first perform the segue to the add a job page we set this class as the delegate so that we can get the data back from the next view controller
        if segue.identifier == "FromMainToNewJob" {
            let backitem = UIBarButtonItem()
            backitem.title = "Jobs in Your Area"
            navigationItem.backBarButtonItem = backitem
            let targetVC = segue.destination as! NewJobViewController
            targetVC.delegate = self
        }
        if segue.identifier == "SelectedJobSegue" {
            let myDateFormatter = DateFormatter()
            myDateFormatter.dateStyle = .short
            myDateFormatter.timeStyle = .short
            myDateFormatter.locale = Locale(identifier: "en_US")
            let backitem = UIBarButtonItem()
            backitem.title = "Back"
            navigationItem.backBarButtonItem = backitem
            let targetVC = segue.destination as! SelectedJobViewController
            targetVC.detailsText = allVisibleJobs[chosenCell.0][chosenCell.1].jobDetails
            targetVC.priceText = allVisibleJobs[chosenCell.0][chosenCell.1].jobPrice
            targetVC.locationText = allVisibleJobs[chosenCell.0][chosenCell.1].jobLocation
            targetVC.titleText = allVisibleJobs[chosenCell.0][chosenCell.1].jobTitle
            targetVC.dateText = myDateFormatter.string(from: allVisibleJobs[chosenCell.0][chosenCell.1].jobDate)
        }
    }

}
