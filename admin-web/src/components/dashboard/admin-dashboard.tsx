'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import {
  TrendingUp, ShoppingCart, DollarSign, Users,
  Plus, ClipboardList, UtensilsCrossed, Settings,
  ArrowUpRight, ArrowDownRight
} from 'lucide-react';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts';
import { revenueData } from '@/lib/demo-data';
import { formatCurrency } from '@/lib/utils';

export default function AdminDashboard() {
  const router = useRouter();
  const [revenueFilter, setRevenueFilter] = useState('Daily');

  const stats = [
    { label: "Today's Revenue", value: formatCurrency(1245.50), change: '+12%', up: true, icon: DollarSign, color: '#00B894' },
    { label: 'Total Orders', value: '47', change: '+8%', up: true, icon: ShoppingCart, color: '#3498DB' },
    { label: 'Avg Order', value: formatCurrency(26.50), change: '+3%', up: true, icon: TrendingUp, color: '#6C5CE7' },
    { label: 'Active Staff', value: '3', change: 'Same', up: true, icon: Users, color: '#F39C12' },
  ];

  return (
    <div className="space-y-6">
      {/* Stats Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        {stats.map((stat, index) => (
          <div key={index} className="card hover:shadow-md transition-shadow">
            <div className="flex items-center justify-between mb-3">
              <div
                className="w-12 h-12 rounded-xl flex items-center justify-center"
                style={{ backgroundColor: `${stat.color}15` }}
              >
                <stat.icon size={24} style={{ color: stat.color }} />
              </div>
              <span className={`flex items-center text-sm font-semibold ${stat.up ? 'text-green-500' : 'text-red-500'}`}>
                {stat.up ? <ArrowUpRight size={16} /> : <ArrowDownRight size={16} />}
                {stat.change}
              </span>
            </div>
            <p className="text-2xl font-bold text-gray-900">{stat.value}</p>
            <p className="text-sm text-gray-500 mt-1">{stat.label}</p>
          </div>
        ))}
      </div>

      {/* Revenue Chart */}
      <div className="card">
        <div className="flex items-center justify-between mb-6">
          <h2 className="text-lg font-bold text-gray-900">Revenue Overview</h2>
          <div className="flex gap-2">
            {['Daily', 'Weekly', 'Monthly', 'Yearly'].map((filter) => (
              <button
                key={filter}
                onClick={() => setRevenueFilter(filter)}
                className={`px-4 py-2 rounded-lg text-sm font-semibold transition-all ${
                  revenueFilter === filter
                    ? 'bg-[#FF6B35] text-white'
                    : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
                }`}
              >
                {filter}
              </button>
            ))}
          </div>
        </div>
        <ResponsiveContainer width="100%" height={300}>
          <BarChart data={revenueData.daily} margin={{ top: 5, right: 20, bottom: 5, left: 0 }}>
            <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
            <XAxis dataKey="label" stroke="#9CA3AF" fontSize={12} />
            <YAxis stroke="#9CA3AF" fontSize={12} />
            <Tooltip
              contentStyle={{
                backgroundColor: '#fff',
                border: '1px solid #e5e7eb',
                borderRadius: '12px',
                boxShadow: '0 4px 6px rgba(0,0,0,0.1)',
              }}
              formatter={(value: number) => [formatCurrency(value), 'Revenue']}
            />
            <Bar
              dataKey="value"
              fill="#FF6B35"
              radius={[8, 8, 0, 0]}
              barSize={40}
            />
          </BarChart>
        </ResponsiveContainer>
      </div>

      {/* Top Items + Peak Hours */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Top Selling Items */}
        <div className="card">
          <h2 className="text-lg font-bold text-gray-900 mb-4">Top Selling Items</h2>
          <div className="space-y-4">
            {revenueData.topItems.map((item, index) => (
              <div key={index} className="flex items-center gap-3">
                <span className="text-sm font-bold text-gray-400 w-6">#{index + 1}</span>
                <div className="flex-1">
                  <div className="flex justify-between mb-1">
                    <span className="text-sm font-semibold">{item.name}</span>
                    <span className="text-sm text-gray-500">{item.sold} sold</span>
                  </div>
                  <div className="h-2 bg-gray-100 rounded-full overflow-hidden">
                    <div
                      className="h-full bg-gradient-to-r from-[#FF6B35] to-[#FF8C42] rounded-full transition-all"
                      style={{ width: `${(item.sold / 42) * 100}%` }}
                    />
                  </div>
                </div>
                <span className="text-sm font-bold text-[#FF6B35] w-20 text-right">
                  {formatCurrency(item.revenue)}
                </span>
              </div>
            ))}
          </div>
        </div>

        {/* Peak Hours */}
        <div className="card">
          <h2 className="text-lg font-bold text-gray-900 mb-4">Peak Hours</h2>
          <div className="space-y-3">
            {revenueData.peakHours.map((item, index) => (
              <div key={index} className="flex items-center gap-3">
                <span className="text-sm text-gray-500 w-14">{item.hour}</span>
                <div className="flex-1 h-2 bg-gray-100 rounded-full overflow-hidden">
                  <div
                    className="h-full bg-gradient-to-r from-[#3498DB] to-[#5DADE2] rounded-full transition-all"
                    style={{ width: `${(item.orders / 22) * 100}%` }}
                  />
                </div>
                <span className="text-sm font-semibold w-8 text-right">{item.orders}</span>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Quick Actions */}
      <div className="card">
        <h2 className="text-lg font-bold text-gray-900 mb-4">Quick Actions</h2>
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
          {[
            { label: 'New Order', icon: Plus, color: '#FF6B35', href: '/dashboard/orders' },
            { label: 'Orders', icon: ClipboardList, color: '#3498DB', href: '/dashboard/orders' },
            { label: 'Menu', icon: UtensilsCrossed, color: '#E74C3C', href: '/dashboard/menu' },
            { label: 'Settings', icon: Settings, color: '#6B7280', href: '/dashboard/settings' },
          ].map((action, index) => (
            <button
              key={index}
              onClick={() => router.push(action.href)}
              className="flex flex-col items-center gap-2 p-4 rounded-xl border border-gray-100 hover:shadow-md hover:border-gray-200 transition-all"
            >
              <div
                className="w-12 h-12 rounded-xl flex items-center justify-center"
                style={{ backgroundColor: `${action.color}15` }}
              >
                <action.icon size={24} style={{ color: action.color }} />
              </div>
              <span className="text-sm font-semibold text-gray-700">{action.label}</span>
            </button>
          ))}
        </div>
      </div>
    </div>
  );
}