'use client';

import { useEffect, useState } from 'react';
import { getCurrentUser } from '@/lib/auth';
import { User } from '@/types';
import AdminDashboard from '@/components/dashboard/admin-dashboard';
import ManagerDashboard from '@/components/dashboard/manager-dashboard';
import CashierDashboard from '@/components/dashboard/cashier-dashboard';

export default function DashboardPage() {
  const [user, setUser] = useState<User | null>(null);

  useEffect(() => {
    setUser(getCurrentUser());
  }, []);

  if (!user) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-[#FF6B35]" />
      </div>
    );
  }

  if (user.role === 'admin') return <AdminDashboard />;
  if (user.role === 'manager') return <ManagerDashboard />;
  return <CashierDashboard />;
}