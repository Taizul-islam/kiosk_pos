'use client';

import { useState } from 'react';
import { demoCards } from '@/lib/demo-data';
import { MembershipCard } from '@/types';
import { formatCurrency } from '@/lib/utils';
import { Search, Plus, CreditCard, Gift, TrendingUp, ShoppingBag } from 'lucide-react';

export default function CardsPage() {
  const [cards, setCards] = useState(demoCards);
  const [activeTab, setActiveTab] = useState<'all' | 'issue' | 'topup'>('all');
  const [searchQuery, setSearchQuery] = useState('');

  const filteredCards = cards.filter(c => {
    if (!searchQuery) return true;
    const q = searchQuery.toLowerCase();
    return c.name.toLowerCase().includes(q) || c.cardNumber.toLowerCase().includes(q);
  });

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Card Management</h1>
          <p className="text-gray-500 mt-1">{cards.length} active cards</p>
        </div>
        <button className="btn-primary flex items-center gap-2">
          <Plus size={18} />
          Issue New Card
        </button>
      </div>

      {/* Tabs */}
      <div className="flex gap-1 bg-gray-100 p-1 rounded-xl w-fit">
        {[
          { id: 'all' as const, label: 'All Cards' },
          { id: 'issue' as const, label: 'Issue New' },
          { id: 'topup' as const, label: 'Top Up' },
        ].map((tab) => (
          <button
            key={tab.id}
            onClick={() => setActiveTab(tab.id)}
            className={`px-5 py-2 rounded-lg text-sm font-semibold transition-all ${
              activeTab === tab.id
                ? 'bg-white text-gray-900 shadow-sm'
                : 'text-gray-500 hover:text-gray-700'
            }`}
          >
            {tab.label}
          </button>
        ))}
      </div>

      {activeTab === 'all' && (
        <>
          <div className="relative">
            <Search size={18} className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" />
            <input
              type="text"
              placeholder="Search by name or card number..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="input-field pl-10"
            />
          </div>

          <div className="space-y-3">
            {filteredCards.map((card) => (
              <div key={card.cardNumber} className="card hover:shadow-md transition-all">
                <div className="flex items-center gap-4">
                  <div className="w-12 h-12 rounded-xl bg-gradient-to-br from-[#6C5CE7] to-[#8B7CF6] flex items-center justify-center">
                    <CreditCard size={22} className="text-white" />
                  </div>
                  <div className="flex-1">
                    <h3 className="font-bold text-gray-900">{card.name}</h3>
                    <p className="text-sm text-gray-400 font-mono">{card.cardNumber}</p>
                  </div>
                </div>
                <div className="grid grid-cols-3 gap-4 mt-4 pt-4 border-t border-gray-100">
                  <div className="text-center">
                    <p className="text-lg font-bold text-[#00B894]">{formatCurrency(card.balance)}</p>
                    <p className="text-xs text-gray-500">Balance</p>
                  </div>
                  <div className="text-center">
                    <p className="text-lg font-bold text-[#F39C12]">{card.points}</p>
                    <p className="text-xs text-gray-500">Points</p>
                  </div>
                  <div className="text-center">
                    <p className="text-lg font-bold text-[#3498DB]">{card.visits}</p>
                    <p className="text-xs text-gray-500">Visits</p>
                  </div>
                </div>
                <div className="flex gap-2 mt-4">
                  <button className="flex-1 py-2 rounded-lg border border-[#00B894] text-[#00B894] text-sm font-semibold hover:bg-[#00B894] hover:text-white transition-all">
                    Top Up
                  </button>
                  <button className="flex-1 py-2 rounded-lg border border-orange-300 text-orange-600 text-sm font-semibold hover:bg-orange-50 transition-all">
                    Replace
                  </button>
                  <button className="flex-1 py-2 rounded-lg border border-red-300 text-red-500 text-sm font-semibold hover:bg-red-50 transition-all">
                    Delete
                  </button>
                </div>
              </div>
            ))}
          </div>
        </>
      )}

      {activeTab === 'issue' && (
        <div className="card max-w-lg mx-auto text-center py-8">
          <div className="w-20 h-20 rounded-2xl bg-[#6C5CE7]/10 flex items-center justify-center mx-auto mb-4">
            <CreditCard size={36} className="text-[#6C5CE7]" />
          </div>
          <h2 className="text-xl font-bold text-gray-900 mb-2">Issue New Card</h2>
          <p className="text-gray-500 mb-6">Fill in customer details and tap a new card</p>
          <div className="space-y-4 text-left">
            <input type="text" placeholder="Customer Name" className="input-field" />
            <input type="text" placeholder="Phone (optional)" className="input-field" />
            <div className="p-6 border-2 border-dashed border-gray-300 rounded-xl text-center cursor-pointer hover:border-[#6C5CE7] transition-all">
              <Gift size={32} className="text-gray-400 mx-auto mb-2" />
              <p className="text-sm text-gray-500">Tap card on reader</p>
            </div>
            <button className="btn-primary w-full">Issue Card</button>
          </div>
        </div>
      )}

      {activeTab === 'topup' && (
        <div className="card max-w-lg mx-auto text-center py-8">
          <div className="w-20 h-20 rounded-2xl bg-[#00B894]/10 flex items-center justify-center mx-auto mb-4">
            <TrendingUp size={36} className="text-[#00B894]" />
          </div>
          <h2 className="text-xl font-bold text-gray-900 mb-2">Top Up Balance</h2>
          <p className="text-gray-500 mb-6">Add money to an existing card</p>
          <div className="space-y-4 text-left">
            <input type="text" placeholder="Card Number" className="input-field" />
            <div className="grid grid-cols-4 gap-2">
              {[10, 20, 50, 100].map(amount => (
                <button key={amount} className="py-3 rounded-xl border border-gray-200 text-sm font-bold hover:border-[#FF6B35] hover:text-[#FF6B35] transition-all">
                  ${amount}
                </button>
              ))}
            </div>
            <input type="number" placeholder="Custom Amount" className="input-field" />
            <button className="btn-primary w-full">Confirm Top Up</button>
          </div>
        </div>
      )}
    </div>
  );
}