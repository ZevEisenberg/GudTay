// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum Onboarding {
    internal enum Buttons {
      /// Join
      internal static let join = L10n.tr("Localizable", "Onboarding.Buttons.Join", fallback: "Join")
      /// Already have an account? Sign in.
      internal static let signIn = L10n.tr("Localizable", "Onboarding.Buttons.SignIn", fallback: "Already have an account? Sign in.")
      /// Skip
      internal static let skip = L10n.tr("Localizable", "Onboarding.Buttons.Skip", fallback: "Skip")
    }
    internal enum Pages {
      internal enum Sample {
        /// This is body copy for the onboarding and should be replaced with real text!
        internal static let body = L10n.tr("Localizable", "Onboarding.Pages.Sample.Body", fallback: "This is body copy for the onboarding and should be replaced with real text!")
        /// HEADING TEXT
        internal static let heading = L10n.tr("Localizable", "Onboarding.Pages.Sample.Heading", fallback: "HEADING TEXT")
      }
    }
  }
  internal enum Title {
    /// GudTay
    internal static let navigation = L10n.tr("Localizable", "Title.Navigation", fallback: "GudTay")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
