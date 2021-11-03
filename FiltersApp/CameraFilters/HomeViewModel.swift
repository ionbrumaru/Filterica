import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

class HomeViewModel : ObservableObject {
    @Published var imagePicker = false
    @Published var imageData = Data(count: 0)
    
    @Published var filteredImage: FilteredImage?
    
    // Main Editing Image....
    @Published var mainView : FilteredImage!
    
    // Slider For Intensity And Radius...etc...
    // Since WE didnt set while reading image
    // so all will be full value....
    @Published var value : CGFloat = 1
    
    // Loading FilterOption WhenEver Image is Selected....
    
    // Use Your Own Filters...
    
    //    let filters : [CIFilter] = [
    //        CIFilter.bloom(),
    //        //CIFilter.colorInvert(),
    //        CIFilter.photoEffectFade(),
    //        CIFilter.colorMonochrome(),
    //        CIFilter.sepiaTone(),
    //        CIFilter.comicEffect(),
    //        CIFilter.photoEffectChrome(),
    //        CIFilter.gaussianBlur()
    //    ]
    
    
    func loadFilter(settings: imageSettings){
        
        let context = CIContext()

        DispatchQueue.main.async {
            // loading Image Into Filter....
            guard let CiImage = CIImage(data: self.imageData) else { return }

            var finalCIImage = CiImage

            let saturation = ((Double(settings.saturation) ?? 0) / 100) + 1
            let contrast = ((Double(settings.contrast) ?? 0) / 100) + 1

            finalCIImage = finalCIImage.applyingFilter("CIColorControls", parameters: [kCIInputImageKey: finalCIImage,
                                                                                  kCIInputSaturationKey:saturation,
                                                                                    kCIInputContrastKey:contrast])

            guard let filter = CIFilter(name: "CIExposureAdjust") else {
                print("Failed to instantiate filter")
                return
            }
            filter.setValue(settings.exposure, forKey: "inputEV")
            filter.setValue(finalCIImage, forKey: kCIInputImageKey)
            finalCIImage = filter.outputImage!

            //            guard let colorControlFilter = CIFilter(name: "CIColorControls")
            //            else { return }
            //
            //            colorControlFilter.setValue(settings.contrast, forKey: kCIInputContrastKey)
            //            colorControlFilter.setValue(settings.brightness, forKey: KCIInrig)
            //
            //            exposureFilter.setValue(settings.exposure, forKey: "inputEV")
            //            exposureFilter.setValue(CiImage, forKey: kCIInputImageKey)
            //            finalCIImage = exposureFilter.outputImage


            let cgimage = context.createCGImage(finalCIImage, from: finalCIImage.extent)
            let filteredData = FilteredImage(name: "Name", image: UIImage(cgImage: cgimage!), filter: CIFilter(), isEditable: true)

            DispatchQueue.main.async {
                self.mainView = filteredData
            }
        }
    }

}

import SwiftUI
import CoreImage

struct FilteredImage: Identifiable {
    
    var id = UUID().uuidString
    var name: String
    var image: UIImage
    var filter: CIFilter
    var isEditable: Bool
}
