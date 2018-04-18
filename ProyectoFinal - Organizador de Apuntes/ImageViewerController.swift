//
//  ImageViewerController.swift
//  ProyectoFinal - Organizador de Apuntes
//
//  Created by Alumno on 4/18/18.
//  Copyright © 2018 itesm. All rights reserved.
//

import UIKit

class ImageViewerController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    var imageView: UIImageView!
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView = UIImageView(image: image)
        scrollView.addSubview(imageView)
        scrollView.setZoomScale(0.4, animated: false)
        scrollView.contentSize = image.size
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Métodos de delegado de Scroll View
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
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
