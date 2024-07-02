// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// swiftlint:disable explicit_type_interface identifier_name line_length nesting type_body_length type_name
internal enum L10n {

  internal enum Onboarding {

    internal enum Buttons {
      /// Join
      internal static let join = L10n.tr("Localizable", "Onboarding.Buttons.Join")
      /// Already have an account? Sign in.
      internal static let signIn = L10n.tr("Localizable", "Onboarding.Buttons.SignIn")
      /// Skip
      internal static let skip = L10n.tr("Localizable", "Onboarding.Buttons.Skip")
    }

    internal enum Pages {

      internal enum Sample {
        /// This is body copy for the onboarding and should be replaced with real text!
        internal static let body = L10n.tr("Localizable", "Onboarding.Pages.Sample.Body")
        /// HEADING TEXT
        internal static let heading = L10n.tr("Localizable", "Onboarding.Pages.Sample.Heading")
      }
    }
  }

  internal enum Title {
    /// GudTay
    internal static let navigation = L10n.tr("Localizable", "Title.Navigation")
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length nesting type_body_length type_name

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
