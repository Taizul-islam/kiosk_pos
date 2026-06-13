'use client';

import { useRouter } from 'next/navigation';
import {
  Plus, ClipboardList, BarChart3, UtensilsCrossed,
  Users, CreditCard, Settings, ArrowRight
} from 'lucide-react';

const menuButtons = [
  { label: 'NEW ORDER', subtitle: 'Create a new order for a customer', icon: Plus, color: '#FF6B35', href: '/dashboard/orders' },
  { label: 'ACTIVE ORDERS', subtitle: 'View and manage current orders', icon: ClipboardList, color: '#3498DB', href: '/dashboard/orders' },
  { label: 'REPORTS', subtitle: 'Daily sales, revenue & summaries', icon: BarChart3, color: '#00B894', href: '/dashboard/reports' },
  { label: 'MENU MANAGEMENT', subtitle: 'Edit categories, products & prices', icon: UtensilsCrossed, color: '#E74C3C', href: '/dashboard/menu' },
  { label: 'STAFF MANAGEMENT', subtitle: 'Manage cashiers', icon: Users, color: '#F39C12', href: '/dashboard/staff' },
  { label: 'CARD MANAGEMENT', subtitle: 'Issue, top up & manage loyalty cards', icon: CreditCard, color: '#6C5CE7', href: '/dashboard/cards' },
  { label: 'SETTINGS', subtitle: 'Store info, printers & tax configuration', icon: Settings, color: '#6B7280', href: '/dashboard/settings' },
];

export default function ManagerDashboard() {
  const router = useRouter();

  return (
    <div className="space-y-3">
      <h2 className="text-xl font-bold text-gray-900 mb-4">Manager Dashboard</h2>
      {menuButtons.map((button, index) => (
        <button
          key={index}
          onClick={() => router.push(button.href)}
          className="w-full flex items-center gap-4 p-5 bg-white rounded-2xl border border-gray-100 hover:shadow-md hover:border-gray-200 transition-all group"
        >
          <div
            className="w-14 h-14 rounded-2xl flex items-center justify-center flex-shrink-0"
            style={{ backgroundColor: `${button.color}15` }}
          >
            <button.icon size={28} style={{ color: button.color }} />
          </div>
          <div className="flex-1 text-left">
            <h3 className="text-base font-bold text-gray-900">{button.label}</h3>
            <p className="text-sm text-gray-500 mt-0.5">{button.subtitle}</p>
          </div>
          <ArrowRight size={20} className="text-gray-400 group-hover:text-gray-600 transition-colors" />
        </button>
      ))}
    </div>
  );
}