'use client';

import { useState } from 'react';
import { demoIngredients, demoSuppliers, demoPurchaseOrders } from '@/lib/inventory-data';
import { formatCurrency } from '@/lib/utils';
import { Search, Plus, AlertTriangle, Package, Truck, ShoppingCart, TrendingDown, ArrowDown, ArrowUp } from 'lucide-react';

export default function InventoryPage() {
  const [activeTab, setActiveTab] = useState<'stock' | 'suppliers' | 'orders'>('stock');
  const [searchQuery, setSearchQuery] = useState('');
  const [ingredients] = useState(demoIngredients);
  const [suppliers] = useState(demoSuppliers);
  const [purchaseOrders] = useState(demoPurchaseOrders);

  const filteredIngredients = ingredients.filter(i => {
    if (!searchQuery) return true;
    const q = searchQuery.toLowerCase();
    return i.name.toLowerCase().includes(q) || i.category.toLowerCase().includes(q) || i.supplier.toLowerCase().includes(q);
  });

  const lowStockItems = ingredients.filter(i => i.currentStock <= i.minStock);
  const totalInventoryValue = ingredients.reduce((sum, i) => sum + (i.currentStock * i.costPerUnit), 0);

  const getStockStatus = (current: number, min: number) => {
    if (current <= 0) return { label: 'Out of Stock', color: 'text-red-600', bg: 'bg-red-50' };
    if (current <= min) return { label: 'Low Stock', color: 'text-orange-600', bg: 'bg-orange-50' };
    if (current <= min * 2) return { label: 'Reorder Soon', color: 'text-yellow-600', bg: 'bg-yellow-50' };
    return { label: 'In Stock', color: 'text-green-600', bg: 'bg-green-50' };
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Inventory Management</h1>
          <p className="text-gray-500 mt-1">{ingredients.length} items • {lowStockItems.length} low stock alerts</p>
        </div>
        <div className="flex gap-2">
          <button className="btn-primary flex items-center gap-2">
            <Plus size={18} />
            New Purchase Order
          </button>
        </div>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <div className="card">
          <div className="flex items-center gap-3 mb-2">
            <div className="w-10 h-10 rounded-xl bg-blue-100 flex items-center justify-center">
              <Package size={20} className="text-blue-600" />
            </div>
            <span className="text-sm text-gray-500">Total Items</span>
          </div>
          <p className="text-2xl font-bold">{ingredients.length}</p>
        </div>
        <div className="card">
          <div className="flex items-center gap-3 mb-2">
            <div className="w-10 h-10 rounded-xl bg-green-100 flex items-center justify-center">
              <ShoppingCart size={20} className="text-green-600" />
            </div>
            <span className="text-sm text-gray-500">Stock Value</span>
          </div>
          <p className="text-2xl font-bold">{formatCurrency(totalInventoryValue)}</p>
        </div>
        <div className="card">
          <div className="flex items-center gap-3 mb-2">
            <div className="w-10 h-10 rounded-xl bg-red-100 flex items-center justify-center">
              <AlertTriangle size={20} className="text-red-600" />
            </div>
            <span className="text-sm text-gray-500">Low Stock</span>
          </div>
          <p className="text-2xl font-bold text-red-600">{lowStockItems.length}</p>
        </div>
        <div className="card">
          <div className="flex items-center gap-3 mb-2">
            <div className="w-10 h-10 rounded-xl bg-purple-100 flex items-center justify-center">
              <Truck size={20} className="text-purple-600" />
            </div>
            <span className="text-sm text-gray-500">Suppliers</span>
          </div>
          <p className="text-2xl font-bold">{suppliers.length}</p>
        </div>
      </div>

      {/* Tabs */}
      <div className="flex gap-1 bg-gray-100 p-1 rounded-xl w-fit">
        {[
          { id: 'stock' as const, label: 'Stock', icon: Package },
          { id: 'suppliers' as const, label: 'Suppliers', icon: Truck },
          { id: 'orders' as const, label: 'Purchase Orders', icon: ShoppingCart },
        ].map((tab) => (
          <button
            key={tab.id}
            onClick={() => setActiveTab(tab.id)}
            className={`flex items-center gap-2 px-5 py-2 rounded-lg text-sm font-semibold transition-all ${
              activeTab === tab.id
                ? 'bg-white text-gray-900 shadow-sm'
                : 'text-gray-500 hover:text-gray-700'
            }`}
          >
            <tab.icon size={16} />
            {tab.label}
          </button>
        ))}
      </div>

      {/* ============ STOCK TAB ============ */}
      {activeTab === 'stock' && (
        <>
          {/* Low stock alert banner */}
          {lowStockItems.length > 0 && (
            <div className="bg-red-50 border border-red-200 rounded-2xl p-4 flex items-center gap-3">
              <AlertTriangle size={24} className="text-red-600" />
              <div className="flex-1">
                <p className="font-bold text-red-700">Low Stock Alert</p>
                <p className="text-sm text-red-600">
                  {lowStockItems.map(i => i.name).join(', ')} need reordering
                </p>
              </div>
              <button className="px-4 py-2 bg-red-600 text-white rounded-lg text-sm font-semibold hover:bg-red-700">
                Create Order
              </button>
            </div>
          )}

          <div className="relative">
            <Search size={18} className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" />
            <input
              type="text"
              placeholder="Search ingredients..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="input-field pl-10"
            />
          </div>

          <div className="card overflow-x-auto">
            <table className="w-full">
              <thead>
                <tr className="text-left text-sm text-gray-500 border-b border-gray-100">
                  <th className="pb-3 font-semibold">Item</th>
                  <th className="pb-3 font-semibold">Category</th>
                  <th className="pb-3 font-semibold">Stock</th>
                  <th className="pb-3 font-semibold">Min</th>
                  <th className="pb-3 font-semibold">Status</th>
                  <th className="pb-3 font-semibold">Cost/Unit</th>
                  <th className="pb-3 font-semibold">Value</th>
                  <th className="pb-3 font-semibold">Last Restocked</th>
                  <th className="pb-3 font-semibold">Actions</th>
                </tr>
              </thead>
              <tbody>
                {filteredIngredients.map((item) => {
                  const status = getStockStatus(item.currentStock, item.minStock);
                  const stockPercent = Math.min((item.currentStock / (item.minStock * 3)) * 100, 100);
                  return (
                    <tr key={item.id} className="border-b border-gray-50 hover:bg-gray-50 transition-colors">
                      <td className="py-3 font-semibold text-gray-900">{item.name}</td>
                      <td className="py-3">
                        <span className="px-2 py-1 rounded-md text-xs font-semibold bg-gray-100 text-gray-600">
                          {item.category}
                        </span>
                      </td>
                      <td className="py-3">
                        <div className="flex items-center gap-2">
                          <span className="font-bold">{item.currentStock}</span>
                          <span className="text-gray-400 text-sm">{item.unit}</span>
                        </div>
                        <div className="w-20 h-1.5 bg-gray-200 rounded-full mt-1">
                          <div
                            className={`h-full rounded-full ${
                              item.currentStock <= item.minStock ? 'bg-red-500' :
                              item.currentStock <= item.minStock * 2 ? 'bg-orange-500' : 'bg-green-500'
                            }`}
                            style={{ width: `${stockPercent}%` }}
                          />
                        </div>
                      </td>
                      <td className="py-3 text-gray-500">{item.minStock} {item.unit}</td>
                      <td className="py-3">
                        <span className={`px-2 py-1 rounded-full text-xs font-bold ${status.bg} ${status.color}`}>
                          {status.label}
                        </span>
                      </td>
                      <td className="py-3 text-gray-600">{formatCurrency(item.costPerUnit)}</td>
                      <td className="py-3 font-semibold">{formatCurrency(item.currentStock * item.costPerUnit)}</td>
                      <td className="py-3 text-sm text-gray-500">
                        {item.lastRestocked.toLocaleDateString()}
                      </td>
                      <td className="py-3">
                        <div className="flex gap-1">
                          <button className="p-1.5 rounded-lg bg-blue-50 text-blue-600 hover:bg-blue-100" title="Add Stock">
                            <ArrowUp size={14} />
                          </button>
                          <button className="p-1.5 rounded-lg bg-orange-50 text-orange-600 hover:bg-orange-100" title="Reduce Stock">
                            <ArrowDown size={14} />
                          </button>
                        </div>
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        </>
      )}

      {/* ============ SUPPLIERS TAB ============ */}
      {activeTab === 'suppliers' && (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {suppliers.map((supplier) => (
            <div key={supplier.id} className="card hover:shadow-md transition-all">
              <div className="flex items-center gap-3 mb-3">
                <div className="w-12 h-12 rounded-xl bg-purple-100 flex items-center justify-center">
                  <Truck size={22} className="text-purple-600" />
                </div>
                <div>
                  <h3 className="font-bold text-gray-900">{supplier.name}</h3>
                  <p className="text-sm text-gray-500">{supplier.contactPerson}</p>
                </div>
              </div>
              <div className="space-y-1 text-sm text-gray-600 mb-4">
                <p>📞 {supplier.phone}</p>
                <p>✉️ {supplier.email}</p>
                <p>📦 {supplier.items.length} items supplied</p>
              </div>
              <button className="w-full py-2 rounded-lg border border-[#FF6B35] text-[#FF6B35] text-sm font-semibold hover:bg-[#FF6B35] hover:text-white transition-all">
                Create Order
              </button>
            </div>
          ))}
        </div>
      )}

      {/* ============ PURCHASE ORDERS TAB ============ */}
      {activeTab === 'orders' && (
        <div className="space-y-3">
          {purchaseOrders.map((po) => (
            <div key={po.id} className="card hover:shadow-md transition-all">
              <div className="flex items-center justify-between mb-3">
                <div className="flex items-center gap-3">
                  <h3 className="font-bold text-gray-900">#{po.id}</h3>
                  <span className={`px-2 py-0.5 rounded-full text-xs font-bold uppercase ${
                    po.status === 'received' ? 'bg-green-100 text-green-700' :
                    po.status === 'ordered' ? 'bg-blue-100 text-blue-700' :
                    po.status === 'pending' ? 'bg-yellow-100 text-yellow-700' :
                    'bg-red-100 text-red-700'
                  }`}>
                    {po.status}
                  </span>
                </div>
                <span className="text-lg font-bold text-[#FF6B35]">{formatCurrency(po.totalCost)}</span>
              </div>
              <div className="space-y-1 mb-3">
                {po.items.map((item, i) => {
                  const ingredient = ingredients.find(ing => ing.id === item.ingredientId);
                  return (
                    <div key={i} className="flex justify-between text-sm">
                      <span className="text-gray-600">{ingredient?.name || item.ingredientId}</span>
                      <span className="text-gray-500">{item.quantity} × {formatCurrency(item.cost / item.quantity)}</span>
                    </div>
                  );
                })}
              </div>
              <div className="text-sm text-gray-500">
                Ordered: {po.orderedDate.toLocaleDateString()}
                {po.receivedDate && ` • Received: ${po.receivedDate.toLocaleDateString()}`}
              </div>
              {po.status !== 'received' && po.status !== 'cancelled' && (
                <div className="flex gap-2 mt-3">
                  {po.status === 'pending' && (
                    <button className="flex-1 py-1.5 rounded-lg bg-blue-600 text-white text-sm font-semibold hover:bg-blue-700">
                      Mark Ordered
                    </button>
                  )}
                  {po.status === 'ordered' && (
                    <button className="flex-1 py-1.5 rounded-lg bg-green-600 text-white text-sm font-semibold hover:bg-green-700">
                      Mark Received
                    </button>
                  )}
                  <button className="flex-1 py-1.5 rounded-lg border border-red-300 text-red-500 text-sm font-semibold hover:bg-red-50">
                    Cancel
                  </button>
                </div>
              )}
            </div>
          ))}
        </div>
      )}
    </div>
  );
}