# GudTay

## Development Process

### Setup
```bash
git clone git@bitbucket.org:ZevEisenberg/gud-tay.git
cd gud-tay
bundle install
cd app
bundle exec fastlane test
```

### Dependencies
When adding a dependency is necessary it should be managed using CocoaPods. After running `bundle exec pod install` the built version should be committed to the repository.

### Synx
To keep the Application structure orderly, organize code logically into groups using Xcode and run [synx](https://github.com/venmo/synx) (`bundle exec fastlane synx`) before commiting.
