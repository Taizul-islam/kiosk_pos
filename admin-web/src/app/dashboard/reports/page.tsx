'use client';

import { useState } from 'react';
import { formatCurrency } from '@/lib/utils';
import { Calendar, TrendingUp, TrendingDown, DollarSign, ShoppingCart, Receipt } from 'lucide-react';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts';

export default function ReportsPage() {
  const [selectedPeriod, setSelectedPeriod] = useState('Today');

  const periods = ['Today', 'Yesterday', 'Last 7 Days', 'Last 30 Days', 'This Month'];

  const data = {
    totalOrders: 47,
    totalRevenue: 1245.50,
    cashRevenue: 456.00,
    cardRevenue: 689.50,
    memberRevenue: 100.00,
    previousRevenue: 980.00,
  };

  const change = ((data.totalRevenue - data.previousRevenue) / data.previousRevenue) * 100;
  const isUp = change >= 0;

  const paymentBreakdown = [
    { label: 'Card', amount: data.cardRevenue, percent: 55, color: '#3498DB' },
    { label: 'Cash', amount: data.cashRevenue, percent: 37, color: '#00B894' },
    { label: 'Member', amount: data.memberRevenue, percent: 8, color: '#6C5CE7' },
  ];

  const chartData = [
    { label: 'Mon', value: 420 },
    { label: 'Tue', value: 380 },
    { label: 'Wed', value: 450 },
    { label: 'Thu', value: 520 },
    { label: 'Fri', value: 480 },
    { label: 'Sat', value: 610 },
    { label: 'Sun', value: 550 },
  ];

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Reports</h1>
          <p className="text-gray-500 mt-1">Sales & revenue analytics</p>
        </div>
        <button className="flex items-center gap-2 px-4 py-2 bg-white border border-gray-200 rounded-xl text-sm font-semibold hover:bg-gray-50 transition-all">
          <Calendar size={16} />
          Custom Range
        </button>
      </div>

      {/* Period Filters */}
      <div className="flex gap-2 overflow-x-auto">
        {periods.map((period) => (
          <button
            key={period}
            onClick={() => setSelectedPeriod(period)}
            className={`px-4 py-2 rounded-lg text-sm font-semibold whitespace-nowrap transition-all ${
              selectedPeriod === period
                ? 'bg-[#FF6B35] text-white'
                : 'bg-white text-gray-600 border border-gray-200 hover:bg-gray-50'
            }`}
          >
            {period}
          </button>
        ))}
      </div>

      {/* Stats */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        {[
          { label: 'Total Revenue', value: formatCurrency(data.totalRevenue), icon: DollarSign, color: '#00B894' },
          { label: 'Total Orders', value: data.totalOrders.toString(), icon: ShoppingCart, color: '#3498DB' },
          { label: 'Avg Order', value: formatCurrency(data.totalOrders > 0 ? data.totalRevenue / data.totalOrders : 0), icon: Receipt, color: '#6C5CE7' },
        ].map((stat, i) => (
          <div key={i} className="card">
            <div className="flex items-center gap-3 mb-3">
              <div className="w-10 h-10 rounded-xl flex items-center justify-center" style={{ backgroundColor: `${stat.color}15` }}>
                <stat.icon size={20} style={{ color: stat.color }} />
              </div>
              <span className="text-sm text-gray-500">{stat.label}</span>
            </div>
            <p className="text-2xl font-bold text-gray-900">{stat.value}</p>
          </div>
        ))}
      </div>

      {/* Revenue Chart */}
      <div className="card">
        <h2 className="text-lg font-bold text-gray-900 mb-4">Revenue Overview</h2>
        <ResponsiveContainer width="100%" height={300}>
          <BarChart data={chartData}>
            <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
            <XAxis dataKey="label" stroke="#9CA3AF" fontSize={12} />
            <YAxis stroke="#9CA3AF" fontSize={12} />
            <Tooltip
              contentStyle={{ backgroundColor: '#fff', border: '1px solid #e5e7eb', borderRadius: '12px' }}
              formatter={(value: number) => [formatCurrency(value), 'Revenue']}
            />
            <Bar dataKey="value" fill="#FF6B35" radius={[8, 8, 0, 0]} barSize={40} />
          </BarChart>
        </ResponsiveContainer>
      </div>

      {/* Payment Breakdown + Comparison */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {/* Payment Breakdown */}
        <div className="card">
          <h2 className="text-lg font-bold text-gray-900 mb-4">Payment Breakdown</h2>
          <div className="space-y-4">
            {paymentBreakdown.map((item) => (
              <div key={item.label}>
                <div className="flex justify-between mb-1">
                  <span className="text-sm font-semibold">{item.label}</span>
                  <span className="text-sm font-bold" style={{ color: item.color }}>
                    {formatCurrency(item.amount)} ({item.percent}%)
                  </span>
                </div>
                <div className="h-2 bg-gray-100 rounded-full overflow-hidden">
                  <div
                    className="h-full rounded-full transition-all"
                    style={{ width: `${item.percent}%`, backgroundColor: item.color }}
                  />
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Comparison */}
        <div className="card">
          <h2 className="text-lg font-bold text-gray-900 mb-4">vs Previous Period</h2>
          <div className="flex items-center gap-4 mb-4">
            <div className={`w-14 h-14 rounded-2xl flex items-center justify-center ${isUp ? 'bg-green-100' : 'bg-red-100'}`}>
              {isUp ? <TrendingUp size={28} className="text-green-600" /> : <TrendingDown size={28} className="text-red-600" />}
            </div>
            <div>
              <p className={`text-2xl font-bold ${isUp ? 'text-green-600' : 'text-red-600'}`}>
                {isUp ? '+' : ''}{change.toFixed(1)}%
              </p>
              <p className="text-sm text-gray-500">from previous period</p>
            </div>
          </div>
          <div className="flex justify-between text-sm">
            <div>
              <p className="text-gray-500">Current</p>
              <p className="font-bold text-gray-900">{formatCurrency(data.totalRevenue)}</p>
            </div>
            <div className="text-right">
              <p className="text-gray-500">Previous</p>
              <p className="font-semibold text-gray-600">{formatCurrency(data.previousRevenue)}</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}