//
//  MainScreenNavigationController.swift
//  uService
//
//  Created by Kendrick Choate on 10/19/16.
//  Copyright © 2016 Kendrick Choate. All rights reserved.
//

/*A tab view controller does not play well with directing straight to a tableviewcontroller. We embed the tableviewcontroller in a navigation controller which the tab view controller directs to to resolve the issue. We then hide the navigation controller's navigation bar so that the tableviewcontroller's navigation bar is usable in the viewDidLoad function*/

import UIKit

class MainScreenNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //hiding the navigiation controller's navigation bar allows for the tableviewcontroller's navigation bar to function. We also hide the toolbar so that there are not two toolbars on the tableviewcontroller.
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.toolbar.isHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.toolbar.isHidden = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
