# Israeli

[![Gem Version](https://img.shields.io/gem/v/israeli.svg)](https://rubygems.org/gems/israeli)
[![CI](https://github.com/dpaluy/israeli/actions/workflows/ci.yml/badge.svg)](https://github.com/dpaluy/israeli/actions/workflows/ci.yml)

Validation utilities for Israeli identifiers including ID numbers (Mispar Zehut), phone numbers, postal codes, and bank accounts.

## Features

- **Israeli ID (Mispar Zehut)** - 9-digit validation with Luhn checksum
- **Phone Numbers** - Mobile (05X), landline (02-09), and VoIP (07X)
- **Postal Codes** - 7-digit Israeli postal codes (Mikud)
- **Bank Accounts** - Domestic (13-digit) and IBAN formats with mod 97 validation
- **Rails Integration** - ActiveModel validators with standard options
- **Zero Dependencies** - Pure Ruby, no external runtime dependencies

## Installation

Add to your Gemfile:

```ruby
gem "israeli"
```

Then run:

```bash
bundle install
```

Or install directly:

```bash
gem install israeli
```

## Usage

### Standalone Validation

```ruby
require "israeli"

# Israeli ID (Mispar Zehut)
Israeli.valid_id?("123456782")     # => true
Israeli.valid_id?("12345678-2")    # => true (formatted input OK)
Israeli.valid_id?("123456789")     # => false (invalid checksum)

# Phone Numbers
Israeli.valid_phone?("0501234567")                    # => true (any type)
Israeli.valid_phone?("0501234567", type: :mobile)     # => true
Israeli.valid_phone?("+972501234567", type: :mobile)  # => true (international format)
Israeli.valid_phone?("021234567", type: :landline)    # => true (Jerusalem)
Israeli.valid_phone?("0721234567", type: :voip)       # => true

# Postal Codes
Israeli.valid_postal_code?("2610101")    # => true
Israeli.valid_postal_code?("26101 01")   # => true (with space)

# Bank Accounts
Israeli.valid_bank_account?("4985622815429")              # => true (domestic)
Israeli.valid_bank_account?("49-856-22815429")            # => true (formatted)
Israeli.valid_bank_account?("IL620108000000099999999")    # => true (IBAN)
Israeli.valid_bank_account?("IL62 0108 0000 0009 9999 999") # => true (spaced IBAN)
```

### Formatting

```ruby
# Format ID to 9 digits
Israeli.format_id("12345678-2")  # => "123456782"
Israeli.format_id("12345678")    # => "012345678" (pads with zero)

# Format phone numbers
Israeli.format_phone("0501234567")                      # => "050-123-4567"
Israeli.format_phone("0501234567", style: :international) # => "+972-501234567"
Israeli.format_phone("021234567")                       # => "02-123-4567"
```

### Rails / ActiveModel Integration

When used in a Rails application, validators are automatically loaded via Railtie.

```ruby
class Person < ApplicationRecord
  validates :id_number, israeli_id: true
  validates :mobile_phone, israeli_phone: { type: :mobile }
  validates :postal_code, israeli_postal_code: { allow_blank: true }
  validates :bank_account, israeli_bank_account: { format: :iban }
end
```

#### Validator Options

All validators support standard ActiveModel options:

```ruby
# Allow nil/blank values
validates :id_number, israeli_id: { allow_nil: true }
validates :postal_code, israeli_postal_code: { allow_blank: true }

# Custom error messages
validates :id_number, israeli_id: { message: "is not a valid Mispar Zehut" }

# Phone type restriction
validates :mobile, israeli_phone: { type: :mobile }    # Mobile only (05X)
validates :office, israeli_phone: { type: :landline }  # Landline only (02-09)
validates :voip,   israeli_phone: { type: :voip }      # VoIP only (072-079)

# Bank account format restriction
validates :account, israeli_bank_account: { format: :domestic }  # 13-digit only
validates :iban,    israeli_bank_account: { format: :iban }      # IBAN only
```

### Direct Validator Access

For more control, you can use the validator classes directly:

```ruby
# ID Validator
Israeli::Validators::Id.valid?("123456782")  # => true
Israeli::Validators::Id.format("12345678-2") # => "123456782"

# Phone Validator
Israeli::Validators::Phone.valid?("0501234567", type: :mobile) # => true
Israeli::Validators::Phone.mobile?("0501234567")               # => true
Israeli::Validators::Phone.landline?("021234567")              # => true

# Postal Code Validator
Israeli::Validators::PostalCode.valid?("2610101")                    # => true
Israeli::Validators::PostalCode.format("2610101", style: :spaced)    # => "26101 01"

# Bank Account Validator
Israeli::Validators::BankAccount.valid?("4985622815429", format: :domestic) # => true
Israeli::Validators::BankAccount.valid_iban?("IL620108000000099999999")     # => true
```

## Validation Rules

### Israeli ID (Mispar Zehut)
- Exactly 9 digits (shorter inputs are left-padded with zeros)
- Validated using Luhn algorithm (mod 10 checksum)
- Accepts formatted input (spaces, hyphens are stripped)

### Phone Numbers

| Type | Format | Example |
|------|--------|---------|
| Mobile | 05X-XXX-XXXX (10 digits) | 050-123-4567 |
| Landline | 0X-XXX-XXXX (9 digits) | 02-123-4567 |
| VoIP | 07X-XXX-XXXX (10 digits) | 072-123-4567 |

- International format (+972) is automatically converted to domestic format
- Area codes: 02 (Jerusalem), 03 (Tel Aviv), 04 (Haifa), 08 (South), 09 (Sharon)

### Postal Codes
- Exactly 7 digits
- Format validation only (no geographic range checking)
- Accepts with or without space separator

### Bank Accounts

| Format | Structure | Example |
|--------|-----------|---------|
| Domestic | XX-XXX-XXXXXXXX (13 digits) | 49-856-22815429 |
| IBAN | IL + 2 check + 19 digits (23 chars) | IL62 0108 0000 0009 9999 999 |

- IBAN validated with mod 97 checksum

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests.

```bash
bundle install
bundle exec rake test      # Run tests
bundle exec rubocop        # Run linter
bundle exec rake           # Run both
```

## Advanced Usage

### Bang Methods (Exception-raising)

For fail-fast validation, use bang methods that raise exceptions:

```ruby
Israeli.valid_id!("123456789")
# => raises Israeli::InvalidIdError with reason: :invalid_checksum

Israeli.valid_phone!("021234567", type: :mobile)
# => raises Israeli::InvalidPhoneError with reason: :wrong_type

# Catch specific errors
begin
  Israeli.valid_id!(user_input)
rescue Israeli::InvalidIdError => e
  puts "Invalid ID: #{e.reason}"  # => :blank, :wrong_length, or :invalid_checksum
end
```

### Parse Methods (Rich Result Objects)

For more detailed validation information, use parse methods:

```ruby
# Phone parsing with type detection
result = Israeli.parse_phone("0501234567")
result.valid?   # => true
result.type     # => :mobile
result.mobile?  # => true
result.formatted(style: :dashed)        # => "050-123-4567"
result.formatted(style: :international) # => "+972-501234567"

# ID parsing
result = Israeli.parse_id("123456789")
result.valid?  # => false
result.reason  # => :invalid_checksum

# Bank account with format detection
result = Israeli.parse_bank_account("IL620108000000099999999")
result.iban?      # => true
result.domestic?  # => false
result.format     # => :iban
```

### Phone Type Detection

Detect phone number type without validation:

```ruby
Israeli.phone_type("0501234567")  # => :mobile
Israeli.phone_type("021234567")   # => :landline
Israeli.phone_type("0721234567")  # => :voip
Israeli.phone_type("invalid")     # => nil
```

### Invalid Reason Detection

Get detailed validation failure reasons:

```ruby
Israeli::Validators::Id.invalid_reason("123456789")  # => :invalid_checksum
Israeli::Validators::Id.invalid_reason("")           # => :blank
Israeli::Validators::Phone.invalid_reason("021234567", type: :mobile)  # => :wrong_type
```

### Rails errors.details Support

Validators include structured error details for Rails 5+:

```ruby
# Model definition
class Person < ApplicationRecord
  validates :id_number, israeli_id: true
  validates :mobile_phone, israeli_phone: { type: :mobile }
end

# Usage
person = Person.new(id_number: "123456789", mobile_phone: "021234567")
person.valid?  # => false

person.errors.details[:id_number]
# => [{error: :invalid, reason: :invalid_checksum}]

person.errors.details[:mobile_phone]
# => [{error: :invalid, reason: :wrong_type, expected_type: :mobile, detected_type: :landline}]
```

## Roadmap

Future versions may include:

- [ ] **Business/Company Number (Mispar Osek/Hevra)** - 9-digit with checksum validation
- [ ] **Vehicle License Plates** - Format validation for Israeli plates
- [ ] **Non-Profit (Amuta) Numbers** - 580-prefix validation
- [ ] **Luhn Checksum Generator** - Generate valid IDs for testing

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dpaluy/israeli.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
