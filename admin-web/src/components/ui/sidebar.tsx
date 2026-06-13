'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { User } from '@/types';
import {
  LayoutDashboard,
  ShoppingCart,
  ClipboardList,
  BarChart3,
  UtensilsCrossed,
  Users,
  CreditCard,
  Settings,
  ChevronLeft,
  ChevronRight,
  LogOut,
  Package
} from 'lucide-react';

interface SidebarProps {
  user: User;
  isOpen: boolean;
  onToggle: () => void;
  onLogout: () => void;
}

const menuItems = [
  { href: '/dashboard', icon: LayoutDashboard, label: 'Dashboard', roles: ['admin', 'manager', 'cashier'] },
  { href: '/dashboard/orders', icon: ClipboardList, label: 'Active Orders', roles: ['admin', 'manager', 'cashier'] },
  { href: '/dashboard/inventory', icon: Package, label: 'Inventory', roles: ['admin', 'manager'] },
  { href: '/dashboard/reports', icon: BarChart3, label: 'Reports', roles: ['admin', 'manager'] },
  { href: '/dashboard/menu', icon: UtensilsCrossed, label: 'Menu Management', roles: ['admin', 'manager'] },
  { href: '/dashboard/staff', icon: Users, label: 'Staff Management', roles: ['admin', 'manager'] },
  { href: '/dashboard/cards', icon: CreditCard, label: 'Card Management', roles: ['admin', 'manager'] },
  { href: '/dashboard/settings', icon: Settings, label: 'Settings', roles: ['admin', 'manager'] },
];

export default function Sidebar({ user, isOpen, onToggle, onLogout }: SidebarProps) {
  const pathname = usePathname();

  const filteredItems = menuItems.filter(item => item.roles.includes(user.role));

  return (
    <aside
      className={`fixed left-0 top-0 h-full bg-gray-900 text-white transition-all duration-300 z-20 ${
        isOpen ? 'w-64' : 'w-20'
      }`}
    >
      {/* Logo */}
      <div className="flex items-center justify-between h-16 px-4 border-b border-gray-800">
        {isOpen && <span className="text-lg font-bold text-[#FF6B35]">BURGER HOUSE</span>}
        <button
          onClick={onToggle}
          className="p-2 rounded-lg hover:bg-gray-800 transition-colors"
        >
          {isOpen ? <ChevronLeft size={20} /> : <ChevronRight size={20} />}
        </button>
      </div>

      {/* Navigation */}
      <nav className="mt-4 px-2 space-y-1">
        {filteredItems.map((item) => {
          const isActive = pathname === item.href;
          return (
            <Link
              key={item.href}
              href={item.href}
              className={`flex items-center gap-3 px-3 py-3 rounded-xl transition-all duration-200 group ${
                isActive
                  ? 'bg-[#FF6B35] text-white shadow-lg shadow-[#FF6B35]/20'
                  : 'text-gray-400 hover:bg-gray-800 hover:text-white'
              }`}
            >
              <item.icon size={20} />
              {isOpen && <span className="text-sm font-medium">{item.label}</span>}
            </Link>
          );
        })}
      </nav>

      {/* Logout */}
      <div className="absolute bottom-4 left-0 right-0 px-2">
        <button
          onClick={onLogout}
          className="flex items-center gap-3 px-3 py-3 rounded-xl text-gray-400 hover:bg-red-500/10 hover:text-red-400 transition-all duration-200 w-full"
        >
          <LogOut size={20} />
          {isOpen && <span className="text-sm font-medium">Logout</span>}
        </button>
      </div>
    </aside>
  );
}