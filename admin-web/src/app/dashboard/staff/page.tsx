'use client';

import { useState } from 'react';
import { getCurrentUser } from '@/lib/auth';
import { demoUsers } from '@/lib/demo-data';
import { User } from '@/types';
import { Plus, Edit2, Trash2, Search, Shield, UserCircle, Users } from 'lucide-react';

export default function StaffPage() {
  const currentUser = getCurrentUser();
  const isAdmin = currentUser?.role === 'admin';
  const [users, setUsers] = useState(demoUsers);
  const [searchQuery, setSearchQuery] = useState('');

  const filteredUsers = users.filter(u => {
    if (!searchQuery) return true;
    const q = searchQuery.toLowerCase();
    return u.name.toLowerCase().includes(q) || u.role.toLowerCase().includes(q);
  });

  const adminCount = users.filter(u => u.role === 'admin').length;
  const managerCount = users.filter(u => u.role === 'manager').length;
  const cashierCount = users.filter(u => u.role === 'cashier').length;

  const getRoleStyle = (role: string) => {
    switch (role) {
      case 'admin': return { bg: 'bg-red-100', text: 'text-red-700', icon: Shield };
      case 'manager': return { bg: 'bg-purple-100', text: 'text-purple-700', icon: UserCircle };
      case 'cashier': return { bg: 'bg-orange-100', text: 'text-orange-700', icon: Users };
      default: return { bg: 'bg-gray-100', text: 'text-gray-700', icon: Users };
    }
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Staff Management</h1>
          <p className="text-gray-500 mt-1">{users.length} staff members</p>
        </div>
        <button className="btn-primary flex items-center gap-2">
          <Plus size={18} />
          Add Staff
        </button>
      </div>

      {/* Summary */}
      <div className="grid grid-cols-3 gap-4">
        {isAdmin && (
          <div className="card text-center">
            <p className="text-3xl font-bold text-red-500">{adminCount}</p>
            <p className="text-sm text-gray-500 mt-1">Admins</p>
          </div>
        )}
        <div className="card text-center">
          <p className="text-3xl font-bold text-purple-500">{managerCount}</p>
          <p className="text-sm text-gray-500 mt-1">Managers</p>
        </div>
        <div className="card text-center">
          <p className="text-3xl font-bold text-orange-500">{cashierCount}</p>
          <p className="text-sm text-gray-500 mt-1">Cashiers</p>
        </div>
      </div>

      {/* Search */}
      <div className="relative">
        <Search size={18} className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" />
        <input
          type="text"
          placeholder="Search staff..."
          value={searchQuery}
          onChange={(e) => setSearchQuery(e.target.value)}
          className="input-field pl-10"
        />
      </div>

      {/* Staff List */}
      <div className="space-y-2">
        {filteredUsers.map((user) => {
          const style = getRoleStyle(user.role);
          const isMe = user.id === currentUser?.id;
          return (
            <div key={user.id} className={`card flex items-center gap-4 hover:shadow-md transition-all ${isMe ? 'border-green-300 border-2' : ''}`}>
              <div className={`w-12 h-12 rounded-xl flex items-center justify-center ${style.bg}`}>
                <style.icon size={22} className={style.text} />
              </div>
              <div className="flex-1">
                <div className="flex items-center gap-2">
                  <h3 className="font-bold text-gray-900">{user.name}</h3>
                  {isMe && (
                    <span className="px-2 py-0.5 rounded-full text-xs font-bold bg-green-100 text-green-600">YOU</span>
                  )}
                </div>
                <div className="flex items-center gap-3 text-sm mt-1">
                  <span className={`px-2 py-0.5 rounded-md text-xs font-bold ${style.bg} ${style.text}`}>
                    {user.role.toUpperCase()}
                  </span>
                  <span className="text-gray-400 font-mono">PIN: {user.pin}</span>
                </div>
              </div>
              <div className="flex gap-2">
                <button className="p-2 rounded-lg bg-blue-50 text-blue-600 hover:bg-blue-100">
                  <Edit2 size={16} />
                </button>
                {!isMe && (
                  <button className="p-2 rounded-lg bg-red-50 text-red-600 hover:bg-red-100">
                    <Trash2 size={16} />
                  </button>
                )}
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
}