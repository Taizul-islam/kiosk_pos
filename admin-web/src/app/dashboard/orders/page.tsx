'use client';

import { useState } from 'react';
import { demoOrders } from '@/lib/demo-data';
import { Order } from '@/types';
import { formatCurrency, getTimeAgo, getStatusColor, getNextStatus } from '@/lib/utils';
import { Search, Filter, CreditCard, Banknote, Gift, Clock, User, Table2 } from 'lucide-react';

const statusFilters = ['All', 'Pending', 'Preparing', 'Ready', 'Completed'];

export default function OrdersPage() {
  const [selectedFilter, setSelectedFilter] = useState('All');
  const [searchQuery, setSearchQuery] = useState('');
  const [expandedOrder, setExpandedOrder] = useState<string | null>(null);

  const filteredOrders = demoOrders
    .filter((o) => selectedFilter === 'All' || o.status.toLowerCase() === selectedFilter.toLowerCase())
    .filter((o) => {
      if (!searchQuery) return true;
      const q = searchQuery.toLowerCase();
      return (
        o.orderNumber.toLowerCase().includes(q) ||
        (o.customerName && o.customerName.toLowerCase().includes(q)) ||
        (o.tableNumber && o.tableNumber.includes(q))
      );
    });

  const getPaymentIcon = (method: string) => {
    switch (method) {
      case 'card': return <CreditCard size={16} className="text-[#3498DB]" />;
      case 'cash': return <Banknote size={16} className="text-[#00B894]" />;
      case 'member': return <Gift size={16} className="text-[#6C5CE7]" />;
      default: return null;
    }
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Active Orders</h1>
          <p className="text-gray-500 mt-1">{filteredOrders.length} orders found</p>
        </div>
      </div>

      {/* Search + Filters */}
      <div className="flex flex-col sm:flex-row gap-4">
        <div className="relative flex-1">
          <Search size={18} className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" />
          <input
            type="text"
            placeholder="Search by order number, customer, or table..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="input-field pl-10"
          />
        </div>
        <div className="flex gap-2 overflow-x-auto">
          {statusFilters.map((filter) => (
            <button
              key={filter}
              onClick={() => setSelectedFilter(filter)}
              className={`px-4 py-2 rounded-lg text-sm font-semibold whitespace-nowrap transition-all ${
                selectedFilter === filter
                  ? 'bg-[#FF6B35] text-white'
                  : 'bg-white text-gray-600 border border-gray-200 hover:bg-gray-50'
              }`}
            >
              {filter}
            </button>
          ))}
        </div>
      </div>

      {/* Orders List */}
      <div className="space-y-3">
        {filteredOrders.length === 0 ? (
          <div className="text-center py-12 bg-white rounded-2xl">
            <div className="text-4xl mb-3">📋</div>
            <p className="text-gray-500 font-medium">No orders found</p>
            <p className="text-gray-400 text-sm mt-1">Try a different filter</p>
          </div>
        ) : (
          filteredOrders.map((order) => {
            const isExpanded = expandedOrder === order.orderNumber;
            return (
              <div
                key={order.orderNumber}
                className="bg-white rounded-2xl border border-gray-100 overflow-hidden hover:shadow-md transition-all"
              >
                {/* Order Header */}
                <button
                  onClick={() => setExpandedOrder(isExpanded ? null : order.orderNumber)}
                  className="w-full p-5 flex items-center gap-4 text-left"
                >
                  <div className="flex-1">
                    <div className="flex items-center gap-3 mb-2">
                      <span className="text-lg font-bold text-gray-900">#{order.orderNumber}</span>
                      <span className={`px-2 py-0.5 rounded-full text-xs font-bold uppercase ${
                        order.source === 'kiosk' ? 'bg-purple-100 text-purple-700' : 'bg-blue-100 text-blue-700'
                      }`}>
                        {order.source}
                      </span>
                      <span
                        className="px-3 py-1 rounded-full text-xs font-bold uppercase"
                        style={{
                          backgroundColor: `${getStatusColor(order.status)}20`,
                          color: getStatusColor(order.status),
                        }}
                      >
                        {order.status}
                      </span>
                    </div>
                    <div className="flex items-center gap-4 text-sm text-gray-500">
                      {order.customerName && (
                        <span className="flex items-center gap-1">
                          <User size={14} /> {order.customerName}
                        </span>
                      )}
                      {order.tableNumber && (
                        <span className="flex items-center gap-1">
                          <Table2 size={14} /> Table {order.tableNumber}
                        </span>
                      )}
                      <span className="flex items-center gap-1">
                        <Clock size={14} /> {getTimeAgo(order.createdAt)}
                      </span>
                    </div>
                  </div>
                  <div className="text-right">
                    <p className="text-xl font-bold text-[#FF6B35]">{formatCurrency(order.total)}</p>
                    <div className="flex items-center gap-1 text-sm text-gray-500 mt-1">
                      {getPaymentIcon(order.paymentMethod)}
                      <span className="uppercase">{order.paymentMethod}</span>
                    </div>
                  </div>
                </button>

                {/* Expanded Details */}
                {isExpanded && (
                  <div className="px-5 pb-5 border-t border-gray-100">
                    <div className="pt-4 space-y-3">
                      <div className="grid grid-cols-2 gap-4 text-sm">
                        <div>
                          <span className="text-gray-500">Order Type:</span>
                          <span className="ml-2 font-semibold capitalize">{order.orderType.replace('_', ' ')}</span>
                        </div>
                        <div>
                          <span className="text-gray-500">Payment:</span>
                          <span className="ml-2 font-semibold uppercase">{order.paymentMethod}</span>
                        </div>
                        <div>
                          <span className="text-gray-500">Subtotal:</span>
                          <span className="ml-2 font-semibold">{formatCurrency(order.subtotal)}</span>
                        </div>
                        <div>
                          <span className="text-gray-500">Tax:</span>
                          <span className="ml-2 font-semibold">{formatCurrency(order.tax)}</span>
                        </div>
                      </div>

                      <div className="flex gap-2 pt-2">
                        {order.status !== 'completed' && (
                          <button className="btn-primary text-sm flex-1">
                            {getNextStatus(order.status)}
                          </button>
                        )}
                        <button className="btn-outline text-sm flex-1">
                          Reprint Receipt
                        </button>
                      </div>
                    </div>
                  </div>
                )}
              </div>
            );
          })
        )}
      </div>
    </div>
  );
}