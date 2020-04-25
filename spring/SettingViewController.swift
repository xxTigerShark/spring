//
//  SettingViewController.swift
//  spring
//
//  Created by Kevin on 4/9/20.
//  Copyright © 2020 Kevin Makens. All rights reserved.
//

import UIKit


// This class has been retired.


class SettingViewController: UIViewController {
	@IBOutlet var slider1 : UISlider!
	@IBOutlet var slider2 : UISlider!
	@IBOutlet var slider3 : UISlider!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
		if segue.destination is GameViewController
		{
			UserDefaults.standard.set(slider1.value, forKey: "sl1")
			UserDefaults.standard.set(slider2.value, forKey: "sl2")
			UserDefaults.standard.set(slider3.value, forKey: "sl3")
		}
    }
	

}
