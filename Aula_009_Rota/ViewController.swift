
import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController , MKMapViewDelegate{
    
    //MARK: Outlets
    @IBOutlet weak var mapa: MKMapView!
    
    
    //MARK: Propriedades

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapa.delegate = self
        let localizacaoOrigem = CLLocationCoordinate2D(latitude: -23.566403, longitude: -46.652540)
        let localizacaoDestino = CLLocationCoordinate2D(latitude: -23.583396, longitude: -46.656712)

        //Colocando marcação para renderização de rota
        let marcoOrigem = MKPlacemark(coordinate: localizacaoOrigem)
        let marcoDestino = MKPlacemark(coordinate: localizacaoDestino)
        
        let itemMarcoOrigem = MKMapItem(placemark: marcoOrigem)
        let itemMarcoDestino = MKMapItem(placemark: marcoDestino)
        
        let requisicaoDirecao = MKDirectionsRequest()
        requisicaoDirecao.source = itemMarcoOrigem
        requisicaoDirecao.destination = itemMarcoDestino
        requisicaoDirecao.transportType = .automobile
        
        //Calculando a rota
        let direcoes = MKDirections(request: requisicaoDirecao)
        direcoes.calculate{
            (resposta, erro) -> Void in
            
            guard let resposta = resposta else {
                if let erro = erro{
                    print("Erro: \(erro)")
                }
                return
            }
            
            let rota = resposta.routes[0]
            //Adiciona um linha acima do mapa
            self.mapa.add((rota.polyline), level: MKOverlayLevel.aboveRoads)
            
            let retangulo = rota.polyline.boundingMapRect
            self.mapa.setRegion(MKCoordinateRegionForMapRect(retangulo), animated: true)
            
        }
        
        //Incluindo Pinos
        let pinoOrigem = MKPointAnnotation()
        pinoOrigem.title = "Quaddro Treinamentos"
        pinoOrigem.coordinate = localizacaoOrigem
        
        let pinoDestino = MKPointAnnotation()
        pinoDestino.title = "Obelisco Herois de 32"
        pinoDestino.coordinate = localizacaoDestino
        
        mapa.showAnnotations([pinoOrigem,pinoDestino], animated: true)
        
    }
    
    //MARK: Metodos de MKMapViewDelegate
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let linhaRenderizada = MKPolylineRenderer(overlay: overlay)
        linhaRenderizada.strokeColor = UIColor.red
        linhaRenderizada.lineWidth = 4.0
        return linhaRenderizada
    }

}

