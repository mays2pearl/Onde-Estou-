//
//  ViewController.swift
//  Onde estou Aula
//
//  Created by Maysa on 03/12/21.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate  {
    
    @IBOutlet weak var mapa: MKMapView!
    var gerenciadorLocalizacao = CLLocationManager()
    
    @IBOutlet weak var velocidadeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var enderecoLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gerenciadorLocalizacao.delegate = self
        gerenciadorLocalizacao.desiredAccuracy = kCLLocationAccuracyBest
        gerenciadorLocalizacao.requestWhenInUseAuthorization()
        gerenciadorLocalizacao.startUpdatingLocation()
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let localizacaoUsuario = locations.last!
        
        let longitude = localizacaoUsuario.coordinate.longitude
        let latitude = localizacaoUsuario.coordinate.latitude
        
        self.longitudeLabel.text = String(longitude)
        self.latitudeLabel.text = String(latitude)
        
        if localizacaoUsuario.speed > 0 {
            velocidadeLabel.text = String( localizacaoUsuario.speed )
        }
        
        let deltaLat: CLLocationDegrees = 0.01
        let deltaLon: CLLocationDegrees = 0.01
        
        let localizacao: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let areaExibicao: MKCoordinateSpan = MKCoordinateSpanMake(deltaLat, deltaLon)
        let regiao: MKCoordinateRegion = MKCoordinateRegionMake(localizacao, areaExibicao)
        mapa.setRegion(regiao, animated: true)
        
        CLGeocoder().reverseGeocodeLocation( localizacaoUsuario) { (detalhesLocal, erro) in
            
            if erro == nil {
                
                if let dadosLocal = detalhesLocal?.first {
                
                    var thoroughfare = ""
                    if dadosLocal.thoroughfare != nil {
                        thoroughfare = dadosLocal.thoroughfare!
                    }
                    
                    var subThoroughfare = ""
                    if dadosLocal.subThoroughfare != nil {
                        subThoroughfare = dadosLocal.subThoroughfare!
                    }
                    
                    var locality = ""
                    if dadosLocal.locality != nil {
                        locality = dadosLocal.locality!
                    }
                    
                    var subLocality = ""
                    if dadosLocal.subLocality != nil {
                        subLocality = dadosLocal.subLocality!
                    }
                    
                    var postalCode = ""
                    if dadosLocal.postalCode != nil {
                        postalCode = dadosLocal.postalCode!
                    }
                    
                    var country = ""
                    if dadosLocal.country != nil {
                        country = dadosLocal.country!
                    }
                    
                    var administrativeArea = ""
                    if dadosLocal.administrativeArea != nil {
                        administrativeArea = dadosLocal.administrativeArea!
                    }
                    
                    var subAdministrativeArea = ""
                    if dadosLocal.subAdministrativeArea != nil {
                        subAdministrativeArea = dadosLocal.subAdministrativeArea!
                    }
                    
                    self.enderecoLabel.text = thoroughfare + " - "
                                              + subThoroughfare + " / "
                                              + locality + " / "
                                              + country
                    
                    print(
                            "\n / thoroughfare:" + thoroughfare +
                            "\n / subThoroughfare:" + subThoroughfare +
                            "\n / locality:" + locality +
                            "\n / subLocality:" + subLocality +
                            "\n / postalCode:" + postalCode +
                            "\n / country:" + country +
                            "\n / administrativeArea:" + administrativeArea +
                            "\n / subAdministrativeArea:" + subAdministrativeArea
                    )
                    
                
                }
                
            }else{
                print(erro ?? "")
            }
            
        }

        
    }
    
    
    @available(iOS 14.0, *)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {



    if manager.authorizationStatus == .denied {
            
            let alertaController = UIAlertController(title: "Permissão de localização",
                                                     message: "Necessário permissão para acesso à sua localização!! por favor habilite.",
                                                     preferredStyle: .alert )
            
            let acaoConfiguracoes = UIAlertAction(title: "Abrir configurações", style: .default , handler: { (alertaConfiguracoes) in
                
                if let configuracoes = NSURL(string: UIApplicationOpenSettingsURLString ) {
                    UIApplication.shared.open( configuracoes as URL )
                }
                
            })

            let acaoCancelar = UIAlertAction(title: "Cancelar", style: .default , handler: nil )
            
            alertaController.addAction( acaoConfiguracoes )
            alertaController.addAction( acaoCancelar )
            
            present( alertaController , animated: true, completion: nil )
            
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

