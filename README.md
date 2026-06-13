# 🍔 Burger House - Restaurant POS & Kiosk System

A complete restaurant management system with self-service kiosk, staff tablet apps, kitchen display, and web admin dashboard.

---

## 📱 Apps Overview

| App | Platform | Users | Description |
|-----|----------|-------|-------------|
| **Kiosk App** | Flutter Android | Customers | Self-service ordering kiosk |
| **Cashier/Manager App** | Flutter Android | Staff | Order taking, management, inventory |
| **Kitchen Display** | Flutter Android | Kitchen Staff | Live order queue with status updates |
| **Web Dashboard** | Next.js | Admin/Manager | Analytics, menu management, reports |

---

## ✨ Features

### 🛒 Kiosk App (Customer)
- Self-service food ordering
- Menu browsing with categories
- Product customization (sizes, toppings, flavors)
- Cart management
- Payment flow (CUB terminal integration)
- Loyalty/membership card support
- Receipt printing

### 💼 Cashier/Manager App (Staff Tablet)
- **3 Role System:** Admin, Manager, Cashier
- New order creation (walk-in, phone orders)
- Active order management
- Table management with floor plan
- Payment confirmation (Cash, Card, Membership)
- Menu management (Categories & Products CRUD)
- Staff management with role hierarchy
- Card issuance & top-up
- Reports with date filters
- Inventory management (Stock, Suppliers, Purchase Orders)
- Dual printer configuration

### 👨‍🍳 Kitchen Display System (KDS)
- 3-column layout (NEW → PREPARING → READY)
- Touch to update order status
- Auto-simulate new orders (demo mode)
- Urgent order highlighting
- Color-coded status indicators
- Landscape-optimized for wall mounting

### 🌐 Web Dashboard (Admin/Manager)
- Role-based access (Admin, Manager, Cashier)
- Analytics dashboard with charts (Recharts)
- Revenue tracking (Daily/Weekly/Monthly/Yearly)
- Top selling items
- Peak hours analysis
- Payment breakdown
- Menu CRUD management
- Staff management
- Card management
- Inventory management
- Floor plan builder
- Reports with custom date ranges
- Settings (Store info, Tax, Dual printers)

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| **Mobile Apps** | Flutter 3.24+ |
| **Web Dashboard** | Next.js 16, TypeScript, Tailwind CSS v4 |
| **State Management** | GetX (Flutter) |
| **Charts** | Recharts (Web), Custom (Flutter) |
| **Icons** | Lucide React (Web), Material Icons (Flutter) |
| **Backend** | FastAPI + PostgreSQL (Phase 2) |
| **Demo Mode** | All apps work with local demo data |

---

## 📁 Project Structure
kiosk_pos/
├── kiosk_pos_user_app/ # Flutter - Customer Kiosk
├── kiosk_pos_cashier_app/ # Flutter - Cashier/Manager Tablet
├── kitchen_display/ # Flutter - Kitchen Display System
└── admin-web/ # Next.js - Web Admin Dashboard


---

## 🚀 Quick Start

### Prerequisites
- Flutter SDK 3.24+
- Node.js 18+
- Android Studio / Xcode

### Flutter Apps
```bash
cd kiosk_pos_user_app    # or cashier_app / kitchen_display
flutter pub get
flutter run

Web Dashboard

cd admin-web
npm install
npm run dev

Open http://localhost:3000

🔐 Demo Login PINs
PIN	Role	Access
1234	Admin	Full access + Analytics
0000	Manager	Operations + Management
1111	Cashier	Order taking only



🎯 Phase 1 Features (Complete)
Customer self-service kiosk

Cashier order management

Manager dashboard with reports

Admin analytics dashboard

Kitchen display system

Menu management (Categories + Products)

Staff management with role hierarchy

Card/loyalty management

Table management with floor plan

Inventory management

Dual printer configuration

Payment flow (CUB terminal manual)

Web admin dashboard

Demo data for all features

📋 Phase 2 (Planned)
FastAPI backend + PostgreSQL

Real-time WebSocket sync

CUB bank API integration

Real card reader integration

Printer SDK integration

Cloud deployment

Advanced analytics

Multi-location support

📸 Screenshots
Kiosk App
text
Welcome → Order Type → Menu Categories → Menu Grid → Cart → Payment → Confirmed
Kitchen Display
text
[NEW] → [PREPARING] → [READY]  (3-column touch interface)
Web Dashboard
text
Login → Analytics Dashboard → Menu/Staff/Cards/Inventory/Settings
👨‍💻 Developer
Built for GProductions by subcontract.

📄 License
Private project - All rights reserved.

text

---

Save this as `README.md` in your project root (`~/Desktop/kiosk_pos/README.md`), then:

```bash
git add README.md
git commit -m "Add project README"
git push
