//
//  ViewController.swift
//  NaverMap-Demo
//
//  Created by corn on 06/03/2019.
//  Copyright © 2019 corn. All rights reserved.
//

import UIKit
import NMapsMap

public let DEFAULT_CAMERA_POSITION = NMFCameraPosition(NMGLatLng(lat: 37.5666102, lng: 126.9783881), zoom: 14, tilt: 0, heading: 0)

class ViewController: UIViewController {
    
    @IBOutlet weak var mapContainerView: UIView!
    private var naverMapView: NMFNaverMapView!
    weak var mapView: NMFMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        naverMapView = NMFNaverMapView(frame: mapContainerView.bounds)
        mapContainerView.addSubview(naverMapView)
        naverMapView.mapView.moveCamera(NMFCameraUpdate(position: DEFAULT_CAMERA_POSITION))
        naverMapView.addObserver(self, forKeyPath: "positionMode", options: [.new, .old, .prior], context: nil)
        naverMapView.showLocationButton = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "None", style: .plain, target: self, action: #selector(handleChangeState))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        naverMapView.frame = mapContainerView.bounds
    }
    
    deinit {
        mapView = nil
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "positionMode" {
            updateStateName()
        }
    }
    
    func updateStateName() {
        var stateStr = ""
        switch naverMapView.positionMode {
        case .disabled:
            stateStr = "None"
        case .normal:
            stateStr = "NoFollow"
        case .direction:
            stateStr = "Follow"
        case .compass:
            stateStr = "Face"
        }
        navigationItem.rightBarButtonItem?.title = stateStr
    }
    
    @objc func handleChangeState() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "None",
                                                style: naverMapView.positionMode == .disabled ? .destructive : .default,
                                                handler: { [weak self] (action) in
                                                    self?.naverMapView.positionMode = .disabled
        }))
        alertController.addAction(UIAlertAction(title: "No Follow",
                                                style: naverMapView.positionMode == .normal ? .destructive : .default,
                                                handler: { [weak self] (action) in
                                                    self?.naverMapView.positionMode = .normal
        }))
        alertController.addAction(UIAlertAction(title: "Follow",
                                                style: naverMapView.positionMode == .direction ? .destructive : .default,
                                                handler: { [weak self] (action) in
                                                    self?.naverMapView.positionMode = .direction
        }))
        alertController.addAction(UIAlertAction(title: "Face",
                                                style: naverMapView.positionMode == .compass ? .destructive : .default,
                                                handler: { [weak self] (action) in
                                                    self?.naverMapView.positionMode = .compass
        }))
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popoverController = alertController.popoverPresentationController {
                popoverController.sourceView = view
                popoverController.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
                present(alertController, animated: true, completion: nil)
            }
        } else {
            present(alertController, animated: true, completion: nil)
        }
    }
}

extension ViewController: NMFMapViewDelegate {
    
}
