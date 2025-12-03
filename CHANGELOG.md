# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.2.0] - 2025-12-03

### Added

- **Bang Methods** - Exception-raising validation methods
  - `Israeli.valid_id!` raises `InvalidIdError` with reason
  - `Israeli.valid_phone!` raises `InvalidPhoneError` with reason
  - `Israeli.valid_postal_code!` raises `InvalidPostalCodeError` with reason
  - `Israeli.valid_bank_account!` raises `InvalidBankAccountError` with reason

- **Parse Methods** - Rich result objects for detailed validation
  - `Israeli.parse_id` returns `IdResult` with formatting
  - `Israeli.parse_phone` returns `PhoneResult` with type detection
  - `Israeli.parse_postal_code` returns `PostalCodeResult` with formatting
  - `Israeli.parse_bank_account` returns `BankAccountResult` with format detection

- **Phone Type Detection**
  - `Israeli.phone_type` returns `:mobile`, `:landline`, `:voip`, or `nil`
  - `Israeli::Validators::Phone.detect_type` for direct access

- **Invalid Reason Methods** - Detailed validation failure reasons
  - `Israeli::Validators::Id.invalid_reason` returns `:blank`, `:wrong_length`, or `:invalid_checksum`
  - `Israeli::Validators::Phone.invalid_reason` returns `:blank`, `:invalid_format`, or `:wrong_type`
  - `Israeli::Validators::PostalCode.invalid_reason` returns `:blank` or `:wrong_length`
  - `Israeli::Validators::BankAccount.invalid_reason` returns `:blank`, `:wrong_length`, `:invalid_format`, or `:invalid_checksum`

- **Missing Facade Methods**
  - `Israeli.format_postal_code` with `:compact` and `:spaced` styles
  - `Israeli.format_bank_account` with `:domestic`, `:compact` styles

- **Rails errors.details Support**
  - All validators now include `reason` in error details
  - Phone validator includes `expected_type` and `detected_type`
  - Bank account validator includes `expected_format`

- **Error Classes Hierarchy**
  - `Israeli::InvalidIdError` for ID validation errors
  - `Israeli::InvalidPhoneError` for phone validation errors
  - `Israeli::InvalidPostalCodeError` for postal code validation errors
  - `Israeli::InvalidBankAccountError` for bank account validation errors
  - All inherit from `Israeli::InvalidFormatError` with `reason` accessor

### Fixed

- `Id.format()` no longer calls `valid?()` redundantly (minor performance improvement)

## [0.1.0] - 2025-12-03

### Added

- **Israeli ID Validator (Mispar Zehut)**
  - 9-digit validation with Luhn algorithm checksum
  - Automatic left-padding for shorter inputs
  - Format stripping (spaces, hyphens)
  - `Israeli.valid_id?` and `Israeli.format_id` methods
  - `IsraeliIdValidator` for ActiveModel/Rails

- **Phone Number Validator**
  - Mobile numbers (05X prefix, 10 digits)
  - Landline numbers (02-09 area codes, 9 digits)
  - VoIP numbers (07X prefix, 10 digits)
  - International format support (+972 prefix)
  - `Israeli.valid_phone?` with `:type` option
  - `IsraeliPhoneValidator` for ActiveModel/Rails with `:type` option

- **Postal Code Validator (Mikud)**
  - 7-digit format validation
  - Space separator support
  - `Israeli.valid_postal_code?` method
  - `IsraeliPostalCodeValidator` for ActiveModel/Rails

- **Bank Account Validator**
  - Domestic format (13 digits: 2-3-8 structure)
  - IBAN format with mod 97 checksum validation
  - `Israeli.valid_bank_account?` with `:format` option
  - `IsraeliBankAccountValidator` for ActiveModel/Rails with `:format` option

- **Core Utilities**
  - `Israeli::Luhn` - Luhn mod 10 checksum algorithm
  - `Israeli::Sanitizer` - Input normalization utilities
  - `Israeli::Railtie` - Automatic Rails integration

- **Rails Integration**
  - All validators support `allow_nil`, `allow_blank`, and `message` options
  - Automatic loading via Railtie in Rails applications
