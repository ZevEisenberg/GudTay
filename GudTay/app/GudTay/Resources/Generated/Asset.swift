// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal enum Clock {
    internal static let face = ImageAsset(name: "Clock/Face")
    internal static let hourHand = ImageAsset(name: "Clock/Hour Hand")
    internal static let minuteHand = ImageAsset(name: "Clock/Minute Hand")
    internal static let pivot = ImageAsset(name: "Clock/Pivot")
    internal static let secondHand = ImageAsset(name: "Clock/Second Hand")
  }
  internal enum Clothing {
    internal static let _19andBelow = ImageAsset(name: "Clothing/19andBelow")
    internal static let _20to24 = ImageAsset(name: "Clothing/20to24")
    internal static let _25to29 = ImageAsset(name: "Clothing/25to29")
    internal static let _30to34 = ImageAsset(name: "Clothing/30to34")
    internal static let _35to40 = ImageAsset(name: "Clothing/35to40")
    internal static let _41to47 = ImageAsset(name: "Clothing/41to47")
    internal static let _48to53 = ImageAsset(name: "Clothing/48to53")
    internal static let _54to59 = ImageAsset(name: "Clothing/54to59")
    internal static let _60to65 = ImageAsset(name: "Clothing/60to65")
    internal static let _66to75 = ImageAsset(name: "Clothing/66to75")
    internal static let _76to80 = ImageAsset(name: "Clothing/76to80")
    internal static let _81to86 = ImageAsset(name: "Clothing/81to86")
    internal static let _87to91 = ImageAsset(name: "Clothing/87to91")
    internal static let _92andOver = ImageAsset(name: "Clothing/92andOver")
    internal static let frameBackground = ImageAsset(name: "Clothing/frameBackground")
    internal static let frameEdges = ImageAsset(name: "Clothing/frameEdges")
    internal static let umbrella19andBelow = ImageAsset(name: "Clothing/umbrella19andBelow")
    internal static let umbrella20to47 = ImageAsset(name: "Clothing/umbrella20to47")
    internal static let umbrella48to53 = ImageAsset(name: "Clothing/umbrella48to53")
    internal static let umbrella54to59 = ImageAsset(name: "Clothing/umbrella54to59")
    internal static let umbrella60to91 = ImageAsset(name: "Clothing/umbrella60to91")
    internal static let umbrella92andOver = ImageAsset(name: "Clothing/umbrella92andOver")
  }
  internal static let black = ColorAsset(name: "Black")
  internal static let blue = ColorAsset(name: "Blue")
  internal static let darkGray = ColorAsset(name: "Dark Gray")
  internal static let day = ColorAsset(name: "Day")
  internal static let lightGray = ColorAsset(name: "Light Gray")
  internal static let night = ColorAsset(name: "Night")
  internal static let orange = ColorAsset(name: "Orange")
  internal static let translucentWhite = ColorAsset(name: "Translucent White")
  internal static let white = ColorAsset(name: "White")
  internal static let yellow = ColorAsset(name: "Yellow")
  internal enum Doodle {
    internal static let eraser = ImageAsset(name: "Doodle/Eraser")
    internal static let marker = ImageAsset(name: "Doodle/Marker")
    internal static let gun = ImageAsset(name: "Doodle/gun")
  }
  internal static let gudTay = ImageAsset(name: "gud-tay")
  internal static let wifi = ImageAsset(name: "wifi")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = Color(asset: self)

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init!(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image named \(name).")
    }
    return result
  }
}

internal extension ImageAsset.Image {
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init!(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    Bundle(for: BundleToken.self)
  }()
}
// swiftlint:enable convenience_type
