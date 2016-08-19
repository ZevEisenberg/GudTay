// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

#if os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIImage
  typealias Image = UIImage
#elseif os(OSX)
  import AppKit.NSImage
  typealias Image = NSImage
#endif

enum Asset: String {
  case Calvin_Umbrella = "calvin-umbrella"
  case Clear_Day = "clear-day"
  case Clear_Night = "clear-night"
  case Cloudy = "cloudy"
  case Fog = "fog"
  case Gud_Tay = "gud-tay"
  case Partly_Cloudy_Day = "partly-cloudy-day"
  case Partly_Cloudy_Night = "partly-cloudy-night"
  case Rain = "rain"
  case Sleet = "sleet"
  case Snow = "snow"
  case Wind = "wind"

  var image: Image {
    return Image(asset: self)
  }
}

extension Image {
  convenience init!(asset: Asset) {
    self.init(named: asset.rawValue)
  }
}
