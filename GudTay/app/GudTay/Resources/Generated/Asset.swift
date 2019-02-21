// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSImage
  internal typealias AssetColorTypeAlias = NSColor
  internal typealias AssetImageTypeAlias = NSImage
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIImage
  internal typealias AssetColorTypeAlias = UIColor
  internal typealias AssetImageTypeAlias = UIImage
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal enum Clock {

    internal static let face = ImageAsset(name: "Clock/Face")
    internal static let hourHand = ImageAsset(name: "Clock/Hour Hand")
    internal static let minuteHand = ImageAsset(name: "Clock/Minute Hand")
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
    internal static let frame = ImageAsset(name: "Clothing/frame")
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
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal struct ColorAsset {
  internal fileprivate(set) var name: String

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  internal var color: AssetColorTypeAlias {
    return AssetColorTypeAlias(asset: self)
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

internal struct DataAsset {
  internal fileprivate(set) var name: String

  #if os(iOS) || os(tvOS) || os(OSX)
  @available(iOS 9.0, tvOS 9.0, OSX 10.11, *)
  internal var data: NSDataAsset {
    return NSDataAsset(asset: self)
  }
  #endif
}

#if os(iOS) || os(tvOS) || os(OSX)
@available(iOS 9.0, tvOS 9.0, OSX 10.11, *)
internal extension NSDataAsset {
  convenience init!(asset: DataAsset) {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    self.init(name: asset.name, bundle: bundle)
    #elseif os(OSX)
    self.init(name: NSDataAsset.Name(asset.name), bundle: bundle)
    #endif
  }
}
#endif

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  internal var image: AssetImageTypeAlias {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    let image = AssetImageTypeAlias(named: name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    let image = bundle.image(forResource: NSImage.Name(name))
    #elseif os(watchOS)
    let image = AssetImageTypeAlias(named: name)
    #endif
    guard let result = image else { fatalError("Unable to load image named \(name).") }
    return result
  }
}

internal extension AssetImageTypeAlias {
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

private final class BundleToken {}
