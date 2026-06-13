'use client';

import { useRouter } from 'next/navigation';
import { Plus, ClipboardList, ArrowRight } from 'lucide-react';

const menuButtons = [
  { label: 'NEW ORDER', subtitle: 'Create a new order for a customer', icon: Plus, color: '#FF6B35', href: '/dashboard/orders' },
  { label: 'ACTIVE ORDERS', subtitle: 'View and manage current orders', icon: ClipboardList, color: '#3498DB', href: '/dashboard/orders' },
];

export default function CashierDashboard() {
  const router = useRouter();

  return (
    <div className="space-y-3">
      <h2 className="text-xl font-bold text-gray-900 mb-4">Cashier Dashboard</h2>
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