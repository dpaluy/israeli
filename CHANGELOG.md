# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
