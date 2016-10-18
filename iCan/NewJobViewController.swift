//
//  NewJobViewController.swift
//  iCan
//
//  Created by Kendrick Choate on 9/27/16.
//  Copyright © 2016 Kendrick Choate. All rights reserved.
//

import UIKit

protocol NewJobDelegate {
    func addJobButtonPressed (aNewJob: NewJob)
}

class NewJob {
    var jobTitle: String
    var jobLocation: String
    var jobPrice: Float
    var jobDetails: String
    var jobCategory: String
    var jobDate: Date
    init (newJobTitle: String, newJobCategory: String, newJobLocation: String, newJobDate: Date, newJobPrice: Float, newJobDetails: String) {
        jobTitle = newJobTitle
        jobCategory = newJobCategory
        jobLocation = newJobLocation
        jobDate = newJobDate
        jobPrice = newJobPrice
        jobDetails = newJobDetails
    }
}

class NewJobViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var jobLocationTextField: UITextField!
    @IBOutlet weak var jobPriceTextField: UITextField!
    @IBOutlet weak var jobCategoryTextField: UITextField!
    @IBOutlet weak var jobDateTextField: UITextField!
    @IBOutlet weak var jobDetailsTextField: UITextView!
    @IBOutlet weak var bottomAddJobButton: UIBarButtonItem!
    var pickOption = ["Housework", "Landscaping", "Painting", "Woodwork"]
    var delegate: NewJobDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //we set the navigation toolbar to not be hidden as it is hidden by default and our addjob button is on the navigation toolbar
        navigationController?.setToolbarHidden(false, animated: true)
        bottomAddJobButton.isEnabled = false
        
        // We setup the picker view for the category text field here
        let pickerView = UIPickerView()
        pickerView.delegate = self
        jobCategoryTextField.inputView = pickerView
        
        // And here we setup a toolbar addon to the pickerView to close out of the session
        let categoryCloseToolBar = UIToolbar()
        categoryCloseToolBar.barStyle = .default
        categoryCloseToolBar.isTranslucent = true
        categoryCloseToolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        categoryCloseToolBar.sizeToFit()
        let categoryDoneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(categoryOKClicked))
        let categorySpaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let categoryCancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(categoryCancelClicked))
        categoryCloseToolBar.setItems([categoryCancelButton, categorySpaceButton, categoryDoneButton], animated: false)
        categoryCloseToolBar.isUserInteractionEnabled = true
        jobCategoryTextField.inputAccessoryView = categoryCloseToolBar
        
        // We setup a different toolbar for the same functionality for the date selector
        let dateCloseToolBar = UIToolbar()
        dateCloseToolBar.barStyle = .default
        dateCloseToolBar.isTranslucent = true
        dateCloseToolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        dateCloseToolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(dateOKClicked))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(dateCancelClicked))
        dateCloseToolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        dateCloseToolBar.isUserInteractionEnabled = true
        jobDateTextField.inputAccessoryView = dateCloseToolBar
        
        //set the text field delegates to this controller, allowing us to enable/disable the add job button based on text entry as well as format the fields
        jobTitleTextField.delegate = self
        jobLocationTextField.delegate = self
        jobPriceTextField.delegate = self
        jobDetailsTextField.delegate = self
        
        //hide the keyboard when the user clicks on the screen
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addNewJobButtonPressed(_ sender: AnyObject) {
        //We only perform any actions assuming the delegate for this classes protocol has been set. Assuming it as, we call the delegate method when the button is pressed. We then pop the view to go back to the previous screen
        if delegate != nil {
            // The next lines save the price text field string, saves the startIndex of the string, and then creates a substring of the price field w/o the $ character. Finally, we strip commas from the price in case the price includes any commas in it.
            let priceField = jobPriceTextField.text!
            let strippedPriceIndex = priceField.index(after: priceField.startIndex)
            let jobPriceWithCommas = priceField.substring(from: strippedPriceIndex)
            let jobPrice = Float(jobPriceWithCommas.replacingOccurrences(of: ",", with: ""))!
            let jobTitle = jobTitleTextField.text!
            let jobCategory = jobCategoryTextField.text!
            let jobLocation = jobLocationTextField.text!
            let jobDetails = jobDetailsTextField.text!
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short
            let jobDate = dateFormatter.date(from: jobDateTextField.text!)!
            let usersNewJob = NewJob(newJobTitle: jobTitle, newJobCategory: jobCategory, newJobLocation: jobLocation, newJobDate: jobDate, newJobPrice: jobPrice, newJobDetails: jobDetails)
            delegate?.addJobButtonPressed(aNewJob: usersNewJob)
            _ = navigationController?.popViewController(animated: true) // Swift 3 has changed behavior and any function that returns something that can be discarded now gives a warning when doing so. By assigning the result to _ we can get rid of the stupid warning.
        }
    }
    //The next two functions configure the JobDateTextField to open a UIDatePicker and update the text as the UIDatePicker updates
    @IBAction func JobDateTextFieldSelected(_ textField: UITextField) {
        let datePicker = UIDatePicker()
        let todaysDate = Date()
        datePicker.minimumDate = todaysDate
        datePicker.maximumDate = todaysDate.addingTimeInterval(31536000) // a year from the current date
        datePicker.setDate(todaysDate, animated: true)
        jobDateTextField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(datePickerChanged(sender:)), for: .valueChanged)
        
    }
    
    func datePickerChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        jobDateTextField.text = formatter.string(from: sender.date)
    }
    
    
    func dateOKClicked() {
        jobDateTextField.resignFirstResponder()
    }
    func dateCancelClicked() {
        jobDateTextField.text = ""
        jobDateTextField.resignFirstResponder()
    }
    func categoryOKClicked() {
        jobCategoryTextField.resignFirstResponder()
    }
    func categoryCancelClicked() {
        jobCategoryTextField.text = ""
        jobCategoryTextField.resignFirstResponder()
    }
    
    //MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // The next five if statements test the textfields for text to verify that all fields have text in them each time the text field is changed. If any don't have text, the addJobButton is disabled
        
        if textField == jobTitleTextField
        {
            let oldStr = jobTitleTextField.text! as NSString
            let newStr = oldStr.replacingCharacters(in: range, with: string) as NSString
            if newStr.length == 0 || jobLocationTextField.text!.characters.count == 0 || jobPriceTextField.text!.characters.count == 0 || jobCategoryTextField.text!.characters.count == 0 || jobDateTextField.text!.characters.count == 0{
                bottomAddJobButton.isEnabled = false
            }
            else {
                bottomAddJobButton.isEnabled = true
            }
        }
        if textField == jobLocationTextField
        {
            let oldStr = jobLocationTextField.text! as NSString
            let newStr = oldStr.replacingCharacters(in: range, with: string) as NSString
            if newStr.length == 0 || jobTitleTextField.text!.characters.count == 0 || jobPriceTextField.text!.characters.count == 0 || jobCategoryTextField.text!.characters.count == 0 || jobDateTextField.text!.characters.count == 0{
                bottomAddJobButton.isEnabled = false
            }
            else {
                bottomAddJobButton.isEnabled = true
            }
        }
        if textField == jobPriceTextField
        {
            let oldStr = jobPriceTextField.text! as NSString
            let newStr = oldStr.replacingCharacters(in: range, with: string) as NSString
            if newStr.length == 0 || jobTitleTextField.text!.characters.count == 0 || jobLocationTextField.text!.characters.count == 0 || jobCategoryTextField.text!.characters.count == 0 || jobDateTextField.text!.characters.count == 0{
                bottomAddJobButton.isEnabled = false
            }
            else {
                bottomAddJobButton.isEnabled = true
            }
        }
        if textField == jobCategoryTextField
        {
            let oldStr = jobPriceTextField.text! as NSString
            let newStr = oldStr.replacingCharacters(in: range, with: string) as NSString
            if newStr.length == 0 || jobTitleTextField.text!.characters.count == 0 || jobLocationTextField.text!.characters.count == 0 || jobPriceTextField.text!.characters.count == 0 || jobDateTextField.text!.characters.count == 0{
                bottomAddJobButton.isEnabled = false
            }
            else {
                bottomAddJobButton.isEnabled = true
            }
        }
        if textField == jobDateTextField
        {
            let oldStr = jobPriceTextField.text! as NSString
            let newStr = oldStr.replacingCharacters(in: range, with: string) as NSString
            if newStr.length == 0 || jobTitleTextField.text!.characters.count == 0 || jobLocationTextField.text!.characters.count == 0 || jobPriceTextField.text!.characters.count == 0 || jobCategoryTextField.text!.characters.count == 0{
                bottomAddJobButton.isEnabled = false
            }
            else {
                bottomAddJobButton.isEnabled = true
            }
        }
        //and here we limit the text fields to a maximum of 25 characters
        let currentCharacterCount = textField.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.characters.count - range.length
        return newLength <= 25
    }
    
    //limits the jobDetails field to maximum 300 characters
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count
        return numberOfChars <= 300;
    }
    
    //make textfields close the keyboard when pressing the return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //MARK: -  UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickOption.count
    }
    
    //MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickOption[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        jobCategoryTextField.text = pickOption[row]
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
