# 🚀 Instructions to Run the Ruby URL Shortener
---
## 📦 Requirements

- Ruby >= 3.2.x
- Rails >= 8.0.2
- SQLite3
---

## 🔧 Setup Instructions

### 1. Clone the project

```bash
git clone https://github.com/thuy13705/ShortLink.git
cd ShortLink
```

### 2. Install dependencies

```bash
bundle install
```

### 3. Set up the database

```bash
rails db:create
rails db:migrate
```

### 4. Run the Rails server

```bash
rails server
```

Visit the app at [http://localhost:3000](http://localhost:3000)

---

## 🖥 Web Interface

- Homepage: [http://localhost:3000/](http://localhost:3000/)
- Features: Encode and decode using input forms.
- After encoding, users can **copy the shortened URL** with a single click.

---

## 📡 API Endpoints

### 🔐 Encode a URL

- **POST** `/api/v1/encode`
- **Content-Type:** `application/json`

#### Request:
```json
{
  "url": "https://example.com"
}
```

#### Response:
```json
{
  "short_url": "http://localhost:3000/AbC123"
}
```

---

### 🔓 Decode a Short URL

- **POST** `/api/v1/decode`
- **Content-Type:** `application/json`

#### Request:
```json
{
  "url": "http://localhost:3000/AbC123"
}
```

#### Response:
```json
{
  "original_url": "https://example.com"
}
```

---

## 🧪 Running Tests

This project uses RSpec.

```bash
rails db:create RAILS_ENV=test 
rails db:migrate RAILS_ENV=test 
bundle exec rspec
```
