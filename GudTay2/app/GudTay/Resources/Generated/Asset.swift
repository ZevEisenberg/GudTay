// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSImage
  internal typealias AssetColorTypeAlias = NSColor
  internal typealias Image = NSImage
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIImage
  internal typealias AssetColorTypeAlias = UIColor
  internal typealias Image = UIImage
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

@available(*, deprecated, renamed: "ImageAsset")
internal typealias AssetType = ImageAsset

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  internal var image: Image {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    let image = bundle.image(forResource: NSImage.Name(name))
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else { fatalError("Unable to load image named \(name).") }
    return result
  }
}

internal struct ColorAsset {
  internal fileprivate(set) var name: String

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  internal var color: AssetColorTypeAlias {
    return AssetColorTypeAlias(asset: self)
  }
}

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal enum Clock {
    internal static let face = ImageAsset(name: "Clock/Face")
    internal static let hourHand = ImageAsset(name: "Clock/Hour Hand")
    internal static let minuteHand = ImageAsset(name: "Clock/Minute Hand")
  }
  internal enum Colors {
    internal static let black = ColorAsset(name: "Black")
    internal static let blue = ColorAsset(name: "Blue")
    internal static let darkGray = ColorAsset(name: "Dark Gray")
    internal static let day = ColorAsset(name: "Day")
    internal static let night = ColorAsset(name: "Night")
    internal static let orange = ColorAsset(name: "Orange")
    internal static let translucentWhite = ColorAsset(name: "Translucent White")
    internal static let white = ColorAsset(name: "White")
    internal static let yellow = ColorAsset(name: "Yellow")
  }
  internal enum Small {
    internal static let clearDay = ImageAsset(name: "Small/clear-day")
    internal static let clearNight = ImageAsset(name: "Small/clear-night")
  }
  internal static let calvinUmbrella = ImageAsset(name: "calvin-umbrella")
  internal static let clearDay = ImageAsset(name: "clear-day")
  internal static let clearNight = ImageAsset(name: "clear-night")
  internal static let cloudy = ImageAsset(name: "cloudy")
  internal static let fog = ImageAsset(name: "fog")
  internal static let gudTay = ImageAsset(name: "gud-tay")
  internal static let gun = ImageAsset(name: "gun")
  internal static let partlyCloudyDay = ImageAsset(name: "partly-cloudy-day")
  internal static let partlyCloudyNight = ImageAsset(name: "partly-cloudy-night")
  internal static let rain = ImageAsset(name: "rain")
  internal static let sleet = ImageAsset(name: "sleet")
  internal static let snow = ImageAsset(name: "snow")
  internal static let wind = ImageAsset(name: "wind")

  // swiftlint:disable trailing_comma
  internal static let allColors: [ColorAsset] = [
    Colors.black,
    Colors.blue,
    Colors.darkGray,
    Colors.day,
    Colors.night,
    Colors.orange,
    Colors.translucentWhite,
    Colors.white,
    Colors.yellow,
  ]
  internal static let allImages: [ImageAsset] = [
    Clock.face,
    Clock.hourHand,
    Clock.minuteHand,
    Small.clearDay,
    Small.clearNight,
    calvinUmbrella,
    clearDay,
    clearNight,
    cloudy,
    fog,
    gudTay,
    gun,
    partlyCloudyDay,
    partlyCloudyNight,
    rain,
    sleet,
    snow,
    wind,
  ]
  // swiftlint:enable trailing_comma
  @available(*, deprecated, renamed: "allImages")
  internal static let allValues: [AssetType] = allImages
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

internal extension Image {
  @available(iOS 1.0, tvOS 1.0, watchOS 1.0, *)
  @available(OSX, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init!(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = Bundle(for: BundleToken.self)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

internal extension AssetColorTypeAlias {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  convenience init!(asset: ColorAsset) {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

private final class BundleToken {}
