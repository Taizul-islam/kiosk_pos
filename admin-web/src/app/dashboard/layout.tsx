'use client';

import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import { getCurrentUser, logout } from '@/lib/auth';
import { User } from '@/types';
import Sidebar from '@/components/ui/sidebar';

export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const router = useRouter();
  const [user, setUser] = useState<User | null>(null);
  const [sidebarOpen, setSidebarOpen] = useState(true);

  useEffect(() => {
    const currentUser = getCurrentUser();
    if (!currentUser) {
      router.push('/');
    } else {
      setUser(currentUser);
    }
  }, [router]);

  if (!user) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-gray-50">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-[#FF6B35]" />
      </div>
    );
  }

  const handleLogout = () => {
    logout();
    router.push('/');
  };

  return (
    <div className="min-h-screen bg-gray-50 flex">
      {/* Sidebar */}
      <Sidebar
        user={user}
        isOpen={sidebarOpen}
        onToggle={() => setSidebarOpen(!sidebarOpen)}
        onLogout={handleLogout}
      />

      {/* Main Content */}
      <div className={`flex-1 transition-all duration-300 ${sidebarOpen ? 'ml-64' : 'ml-20'}`}>
        {/* Top bar */}
        <header className="h-16 bg-white border-b border-gray-200 flex items-center justify-between px-6 sticky top-0 z-10">
          <div>
            <h1 className="text-lg font-semibold text-gray-900">Burger House</h1>
            <p className="text-sm text-gray-500">Welcome back, {user.name}</p>
          </div>
          <div className="flex items-center gap-3">
            <span className={`px-3 py-1 rounded-full text-xs font-bold uppercase ${
              user.role === 'admin' ? 'bg-red-100 text-red-700' :
              user.role === 'manager' ? 'bg-purple-100 text-purple-700' :
              'bg-orange-100 text-orange-700'
            }`}>
              {user.role}
            </span>
          </div>
        </header>

        {/* Page Content */}
        <main className="p-6">
          {children}
        </main>
      </div>
    </div>
  );
}