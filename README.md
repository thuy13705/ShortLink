# 📎 Ruby URL Shortener

A simple URL shortener application implemented in Ruby on Rails. It allows encoding long URLs into short codes and decoding them back, with persistent storage and JSON API responses.

---

## 🚀 Features

- Encode original URL to a shortened code (`/encode`)
- Decode short code back to original URL (`/decode`)

---

## 📦 Requirements

- Ruby >= 3.2.x
- Rails >= 8.0.2
- SQLite3
- Node.js & Yarn (optional for asset management)

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

---

## 📁 Project Structure

```
├── app/
│   ├── controllers/
│   │   └── api/v1/urls_controller.rb  # API logic
│   ├── models/
│   │   └── short_url.rb               # Model for URL handling
│   ├── views/
│   │   └── home/index.html.haml       # Web interface
│   ├── assets/                        # Stylesheets, JS, etc.
├── config/
│   └── routes.rb                      # URL routes
├── db/
│   └── migrate/                       # Database schema
├── spec/
│   ├── models/
│   ├── requests/                      # RSpec tests
├── public/
│   └── 404.html, 500.html             # Error pages
```


## 🛡️ Security Considerations

This application is simple but still vulnerable to multiple attack vectors if left unchecked. Below are common threats and proposed mitigation strategies:

### ✅ Implemented Protections

- **Short Code Uniqueness**  
  Each short code is generated using `SecureRandom.alphanumeric(6)` and checked for uniqueness in the database before saving.

- **Persistent Storage**  
  URLs and short codes are stored in a SQLite database, ensuring data is not lost after a restart.

- **Basic URL Validation**  
  Ensures the input is a non-empty string and follows a valid format (via simple URI regex or parser).

### ⚠️ Potential Attack Vectors & Recommendations

| Attack Vector                    | Description                                                                                  | Recommendation                                                                 |
|----------------------------------|----------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------|
| **XSS (Cross-site Scripting)**   | Malicious URL with `<script>` tag could be encoded and rendered in frontend                 | Sanitize or escape output when rendering in any future frontend                |
| **Phishing / Malicious URLs**    | Users may shorten phishing or dangerous URLs                                                 | Implement domain blacklist, or use external URL reputation APIs                |
| **Brute Force Decoding**         | Attacker tries random short codes to find existing ones                                     | Add rate limiting per IP, and CAPTCHA after repeated failures                 |
| **Private/Internal IP Linking**  | Shorten URLs like `http://localhost` or `192.168.0.1`                                       | Block internal/private IPs and localhost in validation layer                   |
| **CSRF**                         | If later extended with frontend forms                                                       | Enable CSRF protection in Sinatra with `rack-protection`                       |
| **Mass Encoding (Spam)**         | Abuse of `/encode` endpoint to generate millions of URLs                                    | Use rate limiting with `rack-attack` or implement API keys                     |
| **Database Injection**           | Direct SQL via user input (URL fields)                                                      | Prevented by using ActiveRecord with parameterized queries                     |
| **Data Overload / Storage Abuse**| Massive number of encoded URLs may flood the database                                       | Add retention policy for expired/unused URLs                                   |
| **Lack of HTTPS**                | HTTP allows MITM attacks                                                                     | Deploy behind Nginx/Apache with HTTPS in production                            |

---

## 📈 Scalability Considerations

Though this project is intended to demonstrate functionality, here are the scalability concerns and strategies to handle them:

### 🔁 Short Code Collision

Currently using `SecureRandom.alphanumeric(6)`. While it's relatively safe for small scale:

- **Problem**: At scale (millions of records), probability of collision increases.
- **Better Approaches**:
  - Use auto-increment ID (e.g. DB primary key) + Base62 encoding → compact & unique (e.g., ID=125 → "cb")
  - Pre-generate short codes in batch and cache them (queue system)
  - Extend short code length dynamically when reaching thresholds (e.g., move from 6 to 7 chars)

### 🚀 Performance Optimization

| Component                 | Strategy                                                                 |
|--------------------------|--------------------------------------------------------------------------|
| **Lookup Speed**         | Add DB index on `short_code` (already done), use Redis for popular URLs |
| **Read/Write Scaling**   | Use PostgreSQL/MySQL + read replicas; or NoSQL for speed                 |
| **Static Assets**        | Serve frontend assets (if any) via CDN                                  |
| **Background Processing**| Use Sidekiq/Resque for tasks like link validation or reporting           |
| **Monitoring**           | Integrate Prometheus, NewRelic, or logging tools                         |
| **API Limits**           | Introduce API rate limits or tokens for heavy integrations               |

---



## 👤 Author
Thuy Nguyen

Web Developer, [nlpthuy137@gmail.com].
