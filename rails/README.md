# Nathan Hadley's Personal Site

This is my personal site, built with Rails 7/PostgreSQL and deployed with Fly. It includes snow forecasts for some Washington locations. The blog is managed with an ActiveAdmin portal.

## Prerequisites

- Ruby 2.7.5 (managed with rbenv)
- PostgreSQL 14
- Homebrew (for macOS)

## Local Development Setup

### 1. Install Dependencies

**Install rbenv and Ruby:**
```bash
brew install rbenv ruby-build
echo 'eval "$(rbenv init - zsh)"' >> ~/.zshrc
source ~/.zshrc
rbenv install 2.7.5
rbenv local 2.7.5
```

**Install PostgreSQL:**
```bash
brew install postgresql@14
brew services start postgresql@14
export PATH="/usr/local/opt/postgresql@14/bin:$PATH"
```

### 2. Setup the Application

**Install Ruby dependencies:**
```bash
# Note: If you encounter nio4r compilation errors, install it separately first:
gem install nio4r -v '2.5.8' -- --with-cflags="-Wno-error=incompatible-function-pointer-types"

bundle install
```

**Setup databases:**
```bash
bundle exec rails db:create
bundle exec rails db:migrate
bundle exec rails db:seed
```

**Start the development server:**
```bash
bundle exec rails server
```

The application will be available at `http://localhost:3000`

## Features

- Personal blog with articles
- Snow forecast integration for Washington locations  
- Admin panel powered by ActiveAdmin
- User authentication with Devise
- Image storage with Active Storage

## Development

Run tests with:
```bash
bundle exec rspec
```

Check code style with:
```bash
bundle exec rubocop
```
