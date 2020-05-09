// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift

import Foundation
import Rswift
import UIKit

/// This `R` struct is code generated, and contains references to static resources.
struct R: Rswift.Validatable {
  static func validate() throws {
    try intern.validate()
  }
  
  /// This `R.color` struct is generated, and contains static references to 0 color palettes.
  struct color {
    private init() {}
  }
  
  /// This `R.file` struct is generated, and contains static references to 2 files.
  struct file {
    /// Resource file `GoogleService-Info.plist`.
    static let googleServiceInfoPlist = FileResource(bundle: _R.hostingBundle, name: "GoogleService-Info", pathExtension: "plist")
    /// Resource file `StreamBeam.entitlements`.
    static let streamBeamEntitlements = FileResource(bundle: _R.hostingBundle, name: "StreamBeam", pathExtension: "entitlements")
    
    /// `bundle.URLForResource("GoogleService-Info", withExtension: "plist")`
    static func googleServiceInfoPlist(_: Void) -> NSURL? {
      let fileResource = R.file.googleServiceInfoPlist
      return fileResource.bundle.URLForResource(fileResource)
    }
    
    /// `bundle.URLForResource("StreamBeam", withExtension: "entitlements")`
    static func streamBeamEntitlements(_: Void) -> NSURL? {
      let fileResource = R.file.streamBeamEntitlements
      return fileResource.bundle.URLForResource(fileResource)
    }
    
    private init() {}
  }
  
  /// This `R.font` struct is generated, and contains static references to 0 fonts.
  struct font {
    private init() {}
  }
  
  /// This `R.image` struct is generated, and contains static references to 14 images.
  struct image {
    /// Image `back`.
    static let back = ImageResource(bundle: _R.hostingBundle, name: "back")
    /// Image `bgstars`.
    static let bgstars = ImageResource(bundle: _R.hostingBundle, name: "bgstars")
    /// Image `exit`.
    static let exit = ImageResource(bundle: _R.hostingBundle, name: "exit")
    /// Image `facebook`.
    static let facebook = ImageResource(bundle: _R.hostingBundle, name: "facebook")
    /// Image `googleplus`.
    static let googleplus = ImageResource(bundle: _R.hostingBundle, name: "googleplus")
    /// Image `icon-close`.
    static let iconClose = ImageResource(bundle: _R.hostingBundle, name: "icon-close")
    /// Image `instagram`.
    static let instagram = ImageResource(bundle: _R.hostingBundle, name: "instagram")
    /// Image `launchicon`.
    static let launchicon = ImageResource(bundle: _R.hostingBundle, name: "launchicon")
    /// Image `more`.
    static let more = ImageResource(bundle: _R.hostingBundle, name: "more")
    /// Image `playicon`.
    static let playicon = ImageResource(bundle: _R.hostingBundle, name: "playicon")
    /// Image `refresh`.
    static let refresh = ImageResource(bundle: _R.hostingBundle, name: "refresh")
    /// Image `settingsblack`.
    static let settingsblack = ImageResource(bundle: _R.hostingBundle, name: "settingsblack")
    /// Image `settingswhite`.
    static let settingswhite = ImageResource(bundle: _R.hostingBundle, name: "settingswhite")
    /// Image `twitter`.
    static let twitter = ImageResource(bundle: _R.hostingBundle, name: "twitter")
    
    /// `UIImage(named: "back", bundle: ..., traitCollection: ...)`
    static func back(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.back, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "bgstars", bundle: ..., traitCollection: ...)`
    static func bgstars(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.bgstars, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "exit", bundle: ..., traitCollection: ...)`
    static func exit(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.exit, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "facebook", bundle: ..., traitCollection: ...)`
    static func facebook(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.facebook, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "googleplus", bundle: ..., traitCollection: ...)`
    static func googleplus(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.googleplus, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "icon-close", bundle: ..., traitCollection: ...)`
    static func iconClose(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.iconClose, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "instagram", bundle: ..., traitCollection: ...)`
    static func instagram(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.instagram, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "launchicon", bundle: ..., traitCollection: ...)`
    static func launchicon(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.launchicon, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "more", bundle: ..., traitCollection: ...)`
    static func more(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.more, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "playicon", bundle: ..., traitCollection: ...)`
    static func playicon(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.playicon, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "refresh", bundle: ..., traitCollection: ...)`
    static func refresh(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.refresh, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "settingsblack", bundle: ..., traitCollection: ...)`
    static func settingsblack(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.settingsblack, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "settingswhite", bundle: ..., traitCollection: ...)`
    static func settingswhite(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.settingswhite, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "twitter", bundle: ..., traitCollection: ...)`
    static func twitter(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.twitter, compatibleWithTraitCollection: traitCollection)
    }
    
    private init() {}
  }
  
  private struct intern: Rswift.Validatable {
    static func validate() throws {
      try _R.validate()
    }
    
    private init() {}
  }
  
  /// This `R.nib` struct is generated, and contains static references to 0 nibs.
  struct nib {
    private init() {}
  }
  
  /// This `R.reuseIdentifier` struct is generated, and contains static references to 1 reuse identifiers.
  struct reuseIdentifier {
    /// Reuse identifier `LocalViewCell`.
    static let localViewCell: ReuseIdentifier<LocalViewCell> = ReuseIdentifier(identifier: "LocalViewCell")
    
    private init() {}
  }
  
  /// This `R.segue` struct is generated, and contains static references to 1 view controllers.
  struct segue {
    /// This struct is generated for `HomeViewController`, and contains static references to 1 segues.
    struct homeViewController {
      /// Segue identifier `gotosettings`.
      static let gotosettings: StoryboardSegueIdentifier<UIStoryboardSegue, HomeViewController, SettingsNavController> = StoryboardSegueIdentifier(identifier: "gotosettings")
      
      /// Optionally returns a typed version of segue `gotosettings`.
      /// Returns nil if either the segue identifier, the source, destination, or segue types don't match.
      /// For use inside `prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)`.
      static func gotosettings(segue segue: UIStoryboardSegue) -> TypedStoryboardSegueInfo<UIStoryboardSegue, HomeViewController, SettingsNavController>? {
        return TypedStoryboardSegueInfo(segueIdentifier: R.segue.homeViewController.gotosettings, segue: segue)
      }
      
      private init() {}
    }
    
    private init() {}
  }
  
  /// This `R.storyboard` struct is generated, and contains static references to 1 storyboards.
  struct storyboard {
    /// Storyboard `Main`.
    static let main = _R.storyboard.main()
    
    /// `UIStoryboard(name: "Main", bundle: ...)`
    static func main(_: Void) -> UIStoryboard {
      return UIStoryboard(resource: R.storyboard.main)
    }
    
    private init() {}
  }
  
  /// This `R.string` struct is generated, and contains static references to 1 localization tables.
  struct string {
    /// This `R.string.localizable` struct is generated, and contains static references to 22 localization keys.
    struct localizable {
      /// Base translation: AWAKE...
      /// 
      /// Locales: Base
      static let liveoverlayBabyawake = StringResource(key: "liveoverlay.Babyawake", tableName: "Localizable", bundle: _R.hostingBundle, locales: ["Base"], comment: nil)
      /// Base translation: Are you sure you want to exit the entire session? If you only want to exit the camera-view, press the camera button instead.
      /// 
      /// Locales: Base
      static let audienceQuitmessage = StringResource(key: "audience.Quitmessage", tableName: "Localizable", bundle: _R.hostingBundle, locales: ["Base"], comment: nil)
      /// Base translation: Babycall Wifi  The app is currently only for iOS but Android version is currently not on plan but if there is a significant demand, plans may change, so please use the contact us form to send feedback!
      /// 
      /// Locales: Base
      static let settingsAboutUs = StringResource(key: "settings.AboutUs", tableName: "Localizable", bundle: _R.hostingBundle, locales: ["Base"], comment: nil)
      /// Base translation: Babydevice disconnected!
      /// 
      /// Locales: Base
      static let liveoverlayBabydisconnect = StringResource(key: "liveoverlay.Babydisconnect", tableName: "Localizable", bundle: _R.hostingBundle, locales: ["Base"], comment: nil)
      /// Base translation: Cancel
      /// 
      /// Locales: Base
      static let generalCancel = StringResource(key: "general.Cancel", tableName: "Localizable", bundle: _R.hostingBundle, locales: ["Base"], comment: nil)
      /// Base translation: Change settings
      /// 
      /// Locales: Base
      static let generalLowpowermodechange = StringResource(key: "general.Lowpowermodechange", tableName: "Localizable", bundle: _R.hostingBundle, locales: ["Base"], comment: nil)
      /// Base translation: Connected
      /// 
      /// Locales: Base
      static let liveoverlayConnected = StringResource(key: "liveoverlay.Connected", tableName: "Localizable", bundle: _R.hostingBundle, locales: ["Base"], comment: nil)
      /// Base translation: Could not find session with code, make sure the babydevice is turned on
      /// 
      /// Locales: Base
      static let serverSESSION_NOT_FOUND = StringResource(key: "server.SESSION_NOT_FOUND", tableName: "Localizable", bundle: _R.hostingBundle, locales: ["Base"], comment: nil)
      /// Base translation: Do not forget to turn on night mode AND set it to be always silenced. Otherwise incoming calls may disturb your baby.
      /// 
      /// Locales: Base
      static let broadcasterSilenceMode = StringResource(key: "broadcaster.SilenceMode", tableName: "Localizable", bundle: _R.hostingBundle, locales: ["Base"], comment: nil)
      /// Base translation: Done
      /// 
      /// Locales: Base
      static let generalDone = StringResource(key: "general.Done", tableName: "Localizable", bundle: _R.hostingBundle, locales: ["Base"], comment: nil)
      /// Base translation: Error
      /// 
      /// Locales: Base
      static let generalError = StringResource(key: "general.Error", tableName: "Localizable", bundle: _R.hostingBundle, locales: ["Base"], comment: nil)
      /// Base translation: Exit session
      /// 
      /// Locales: Base
      static let audienceQuitSession = StringResource(key: "audience.QuitSession", tableName: "Localizable", bundle: _R.hostingBundle, locales: ["Base"], comment: nil)
      /// Base translation: Go back
      /// 
      /// Locales: Base
      static let audienceGoback = StringResource(key: "audience.Goback", tableName: "Localizable", bundle: _R.hostingBundle, locales: ["Base"], comment: nil)
      /// Base translation: Lost internet connection!
      /// 
      /// Locales: Base
      static let liveoverlayDisconnect = StringResource(key: "liveoverlay.Disconnect", tableName: "Localizable", bundle: _R.hostingBundle, locales: ["Base"], comment: nil)
      /// Base translation: Malformed request, please update app
      /// 
      /// Locales: Base
      static let serverMALFORMED_REQUEST = StringResource(key: "server.MALFORMED_REQUEST", tableName: "Localizable", bundle: _R.hostingBundle, locales: ["Base"], comment: nil)
      /// Base translation: No nearby stations located, you must be on same WIFI
      /// 
      /// Locales: Base
      static let serverNEARBY_NOT_FOUND = StringResource(key: "server.NEARBY_NOT_FOUND", tableName: "Localizable", bundle: _R.hostingBundle, locales: ["Base"], comment: nil)
      /// Base translation: Noise detected (%f)
      /// 
      /// Locales: Base
      static let liveoverlayNoisedetected = StringResource(key: "liveoverlay.Noisedetected", tableName: "Localizable", bundle: _R.hostingBundle, locales: ["Base"], comment: nil)
      /// Base translation: Quit
      /// 
      /// Locales: Base
      static let generalQuit = StringResource(key: "general.Quit", tableName: "Localizable", bundle: _R.hostingBundle, locales: ["Base"], comment: nil)
      /// Base translation: SLEEPING...
      /// 
      /// Locales: Base
      static let liveoverlayBabysleep = StringResource(key: "liveoverlay.Babysleep", tableName: "Localizable", bundle: _R.hostingBundle, locales: ["Base"], comment: nil)
      /// Base translation: Starting video, it may take few seconds
      /// 
      /// Locales: Base
      static let liveoverlayToastStartingVideo = StringResource(key: "liveoverlay.ToastStartingVideo", tableName: "Localizable", bundle: _R.hostingBundle, locales: ["Base"], comment: nil)
      /// Base translation: Write your message
      /// 
      /// Locales: Base
      static let settingsWriteyourMessage = StringResource(key: "settings.WriteyourMessage", tableName: "Localizable", bundle: _R.hostingBundle, locales: ["Base"], comment: nil)
      /// Base translation: Your phone is in low power mode, which turns off the phones screen automatically. Audio and video functionality will not work if screen is turned off. Please turn off low power mode.
      /// 
      /// Locales: Base
      static let generalLowpowermode = StringResource(key: "general.Lowpowermode", tableName: "Localizable", bundle: _R.hostingBundle, locales: ["Base"], comment: nil)
      
      /// Base translation: AWAKE...
      /// 
      /// Locales: Base
      static func liveoverlayBabyawake(_: Void) -> String {
        return NSLocalizedString("liveoverlay.Babyawake", bundle: _R.hostingBundle, comment: "")
      }
      
      /// Base translation: Are you sure you want to exit the entire session? If you only want to exit the camera-view, press the camera button instead.
      /// 
      /// Locales: Base
      static func audienceQuitmessage(_: Void) -> String {
        return NSLocalizedString("audience.Quitmessage", bundle: _R.hostingBundle, comment: "")
      }
      
      /// Base translation: Babycall Wifi  The app is currently only for iOS but Android version is currently not on plan but if there is a significant demand, plans may change, so please use the contact us form to send feedback!
      /// 
      /// Locales: Base
      static func settingsAboutUs(_: Void) -> String {
        return NSLocalizedString("settings.AboutUs", bundle: _R.hostingBundle, comment: "")
      }
      
      /// Base translation: Babydevice disconnected!
      /// 
      /// Locales: Base
      static func liveoverlayBabydisconnect(_: Void) -> String {
        return NSLocalizedString("liveoverlay.Babydisconnect", bundle: _R.hostingBundle, comment: "")
      }
      
      /// Base translation: Cancel
      /// 
      /// Locales: Base
      static func generalCancel(_: Void) -> String {
        return NSLocalizedString("general.Cancel", bundle: _R.hostingBundle, comment: "")
      }
      
      /// Base translation: Change settings
      /// 
      /// Locales: Base
      static func generalLowpowermodechange(_: Void) -> String {
        return NSLocalizedString("general.Lowpowermodechange", bundle: _R.hostingBundle, comment: "")
      }
      
      /// Base translation: Connected
      /// 
      /// Locales: Base
      static func liveoverlayConnected(_: Void) -> String {
        return NSLocalizedString("liveoverlay.Connected", bundle: _R.hostingBundle, comment: "")
      }
      
      /// Base translation: Could not find session with code, make sure the babydevice is turned on
      /// 
      /// Locales: Base
      static func serverSESSION_NOT_FOUND(_: Void) -> String {
        return NSLocalizedString("server.SESSION_NOT_FOUND", bundle: _R.hostingBundle, comment: "")
      }
      
      /// Base translation: Do not forget to turn on night mode AND set it to be always silenced. Otherwise incoming calls may disturb your baby.
      /// 
      /// Locales: Base
      static func broadcasterSilenceMode(_: Void) -> String {
        return NSLocalizedString("broadcaster.SilenceMode", bundle: _R.hostingBundle, comment: "")
      }
      
      /// Base translation: Done
      /// 
      /// Locales: Base
      static func generalDone(_: Void) -> String {
        return NSLocalizedString("general.Done", bundle: _R.hostingBundle, comment: "")
      }
      
      /// Base translation: Error
      /// 
      /// Locales: Base
      static func generalError(_: Void) -> String {
        return NSLocalizedString("general.Error", bundle: _R.hostingBundle, comment: "")
      }
      
      /// Base translation: Exit session
      /// 
      /// Locales: Base
      static func audienceQuitSession(_: Void) -> String {
        return NSLocalizedString("audience.QuitSession", bundle: _R.hostingBundle, comment: "")
      }
      
      /// Base translation: Go back
      /// 
      /// Locales: Base
      static func audienceGoback(_: Void) -> String {
        return NSLocalizedString("audience.Goback", bundle: _R.hostingBundle, comment: "")
      }
      
      /// Base translation: Lost internet connection!
      /// 
      /// Locales: Base
      static func liveoverlayDisconnect(_: Void) -> String {
        return NSLocalizedString("liveoverlay.Disconnect", bundle: _R.hostingBundle, comment: "")
      }
      
      /// Base translation: Malformed request, please update app
      /// 
      /// Locales: Base
      static func serverMALFORMED_REQUEST(_: Void) -> String {
        return NSLocalizedString("server.MALFORMED_REQUEST", bundle: _R.hostingBundle, comment: "")
      }
      
      /// Base translation: No nearby stations located, you must be on same WIFI
      /// 
      /// Locales: Base
      static func serverNEARBY_NOT_FOUND(_: Void) -> String {
        return NSLocalizedString("server.NEARBY_NOT_FOUND", bundle: _R.hostingBundle, comment: "")
      }
      
      /// Base translation: Noise detected (%f)
      /// 
      /// Locales: Base
      static func liveoverlayNoisedetected(value1: Double) -> String {
        return String(format: NSLocalizedString("liveoverlay.Noisedetected", bundle: _R.hostingBundle, comment: ""), locale: _R.applicationLocale, value1)
      }
      
      /// Base translation: Quit
      /// 
      /// Locales: Base
      static func generalQuit(_: Void) -> String {
        return NSLocalizedString("general.Quit", bundle: _R.hostingBundle, comment: "")
      }
      
      /// Base translation: SLEEPING...
      /// 
      /// Locales: Base
      static func liveoverlayBabysleep(_: Void) -> String {
        return NSLocalizedString("liveoverlay.Babysleep", bundle: _R.hostingBundle, comment: "")
      }
      
      /// Base translation: Starting video, it may take few seconds
      /// 
      /// Locales: Base
      static func liveoverlayToastStartingVideo(_: Void) -> String {
        return NSLocalizedString("liveoverlay.ToastStartingVideo", bundle: _R.hostingBundle, comment: "")
      }
      
      /// Base translation: Write your message
      /// 
      /// Locales: Base
      static func settingsWriteyourMessage(_: Void) -> String {
        return NSLocalizedString("settings.WriteyourMessage", bundle: _R.hostingBundle, comment: "")
      }
      
      /// Base translation: Your phone is in low power mode, which turns off the phones screen automatically. Audio and video functionality will not work if screen is turned off. Please turn off low power mode.
      /// 
      /// Locales: Base
      static func generalLowpowermode(_: Void) -> String {
        return NSLocalizedString("general.Lowpowermode", bundle: _R.hostingBundle, comment: "")
      }
      
      private init() {}
    }
    
    private init() {}
  }
  
  private init() {}
}

struct _R: Rswift.Validatable {
  static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap(NSLocale.init) ?? NSLocale.currentLocale()
  static let hostingBundle = NSBundle(identifier: "com.gressquel.StreamBeam") ?? NSBundle.mainBundle()
  
  static func validate() throws {
    try storyboard.validate()
  }
  
  struct nib {
    private init() {}
  }
  
  struct storyboard: Rswift.Validatable {
    static func validate() throws {
      try main.validate()
    }
    
    struct main: StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = HomeViewController
      
      let bundle = _R.hostingBundle
      let localMediaController = StoryboardViewControllerResource<LocalMediaController>(identifier: "LocalMediaController")
      let name = "Main"
      let remoteUrlController = StoryboardViewControllerResource<RemoteUrlController>(identifier: "RemoteUrlController")
      
      func localMediaController(_: Void) -> LocalMediaController? {
        return UIStoryboard(resource: self).instantiateViewController(localMediaController)
      }
      
      func remoteUrlController(_: Void) -> RemoteUrlController? {
        return UIStoryboard(resource: self).instantiateViewController(remoteUrlController)
      }
      
      static func validate() throws {
        if UIImage(named: "more") == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'more' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIImage(named: "refresh") == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'refresh' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIImage(named: "twitter") == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'twitter' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIImage(named: "exit") == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'exit' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIImage(named: "facebook") == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'facebook' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIImage(named: "back") == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'back' is used in storyboard 'Main', but couldn't be loaded.") }
        if _R.storyboard.main().localMediaController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'localMediaController' could not be loaded from storyboard 'Main' as 'LocalMediaController'.") }
        if _R.storyboard.main().remoteUrlController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'remoteUrlController' could not be loaded from storyboard 'Main' as 'RemoteUrlController'.") }
      }
      
      private init() {}
    }
    
    private init() {}
  }
  
  private init() {}
}