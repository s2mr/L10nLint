# L10nLint

Lint tool for your Localizable.strings

## Usage

Lint based on your `.l10nlint.yml`:
```
l10nlint
```

When run with Xcode prebuild script, shows warning and errors.

## Rules

```
duplicate_key     Duplicated key should be resolved.
empty_key         Empty localized key should be resolved.
empty_value       Empty localized value should be resolved.
key_order         Between Base and each language file's key should be same order.
mark_syntax       Annotation should have around one space.
multi_linefeed    Linefeed should be one.
space_in_key      Key should not have space.
todo              TODOs and FIXMEs should be resolved.
```

### Command completion

This command is built on [swift-argument-parser](https://github.com/apple/swift-argument-parser).

Please refer to [this article](https://github.com/apple/swift-argument-parser/blob/main/Sources/ArgumentParser/Documentation.docc/Articles/InstallingCompletionScripts.md#installing-zsh-completions
).

Replace `example` with `l10nlint`.

## Installation

### [Homebrew](https://brew.sh/)

```shell
brew install s2mr/tap/l10nlint
```

### [Swift Package Manager](https://github.com/apple/swift-package-manager)

Add the following to the dependencies of your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/s2mr/L10nLint.git", from: "L10nLint version"),
]
```

Run command:

```sh
swift run -c release l10nlint [COMMAND] [OPTIONS]
```

### [Mint](https://github.com/yonaskolb/Mint)

Install with Mint by following command:

```sh
mint install s2mr/l10nlint
```

Run command:

```sh
mint run s2mr/l10nlint [COMMAND] [OPTIONS]
```

### Using a pre-built binary

You can also install l10nlint by downloading `l10nlint.zip` from the latest GitHub release.

# Setup
Place `.l10nlint.yml` file at your repository root.
`base_path` is directory path that is contains `Localizable.strings`

Example:
```.yml
base_path: YourApp/Resources/

disabled_rules:
  - empty_value

todo:
  is_summary_enabled: true
  summary_violation_limit: 20
```

## Help

```
l10nlint --help

---
OVERVIEW: Lint tool for your Localizable.strings

USAGE: l10nlint [--config <config>] <subcommand>

OPTIONS:
  --config <config>       Custom config file path
  -h, --help              Show help information.

SUBCOMMANDS:
  lint (default)          Lint your Localizable.strings
  rules                   Show all rules whether enabled or disabled

  See 'l10nlint help <subcommand>' for detailed help.

```

```
l10nlint rules --help

---
Building for debugging...
Build complete! (0.16s)
OVERVIEW: Show all rules whether enabled or disabled

USAGE: l10nlint rules [--config <config>] [--print-parameters]

OPTIONS:
  --config <config>       Custom config file path
  --print-parameters      Show your rule's parameters in config
  -h, --help              Show help information.

```