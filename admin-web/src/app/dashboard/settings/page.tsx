'use client';

import { useState } from 'react';
import { Save, Printer, TestTube } from 'lucide-react';

export default function SettingsPage() {
  const [receiptType, setReceiptType] = useState('network');
  const [kitchenType, setKitchenType] = useState('network');

  return (
    <div className="space-y-6 max-w-2xl">
      <div>
        <h1 className="text-2xl font-bold text-gray-900">Settings</h1>
        <p className="text-gray-500 mt-1">Store info, printers & tax configuration</p>
      </div>

      {/* Store Information */}
      <div className="card">
        <h2 className="text-lg font-bold text-gray-900 mb-4">🏪 Store Information</h2>
        <div className="space-y-4">
          <input type="text" defaultValue="Burger House" placeholder="Store Name" className="input-field" />
          <input type="text" defaultValue="123 Main Street, Kingstown" placeholder="Address" className="input-field" />
          <input type="text" defaultValue="+1-784-123-4567" placeholder="Phone" className="input-field" />
        </div>
      </div>

      {/* Tax & Currency */}
      <div className="card">
        <h2 className="text-lg font-bold text-gray-900 mb-4">💰 Tax & Currency</h2>
        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="text-sm font-semibold text-gray-700 mb-1 block">Tax Rate (%)</label>
            <input type="number" defaultValue="15" className="input-field" />
          </div>
          <div>
            <label className="text-sm font-semibold text-gray-700 mb-1 block">Currency Symbol</label>
            <input type="text" defaultValue="$" className="input-field" />
          </div>
        </div>
      </div>

      {/* Receipt Printer */}
      <div className="card">
        <h2 className="text-lg font-bold text-gray-900 mb-4">🧾 Receipt Printer (Customer)</h2>
        <p className="text-sm text-gray-500 mb-4">Prints customer receipts after payment</p>
        <div className="space-y-4">
          <input type="text" defaultValue="Receipt Printer" placeholder="Printer Name" className="input-field" />
          
          <div>
            <label className="text-sm font-semibold text-gray-700 mb-2 block">Connection Type</label>
            <div className="flex gap-2">
              {['network', 'usb', 'serial'].map(type => (
                <button
                  key={type}
                  onClick={() => setReceiptType(type)}
                  className={`px-4 py-2 rounded-lg text-sm font-semibold capitalize transition-all ${
                    receiptType === type ? 'bg-[#FF6B35] text-white' : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
                  }`}
                >
                  {type}
                </button>
              ))}
            </div>
          </div>

          {receiptType === 'network' && (
            <div className="grid grid-cols-3 gap-4">
              <div className="col-span-2">
                <input type="text" defaultValue="192.168.1.100" placeholder="IP Address" className="input-field" />
              </div>
              <div>
                <input type="number" defaultValue="9100" placeholder="Port" className="input-field" />
              </div>
            </div>
          )}

          <div className="flex items-center gap-4">
            <select className="input-field w-auto">
              <option>80mm</option>
              <option>58mm</option>
            </select>
            <label className="flex items-center gap-2 text-sm">
              <input type="checkbox" defaultChecked className="w-4 h-4 rounded accent-[#FF6B35]" />
              Auto Print
            </label>
          </div>

          <button className="flex items-center gap-2 py-2 px-4 rounded-lg border border-[#FF6B35] text-[#FF6B35] text-sm font-semibold hover:bg-[#FF6B35] hover:text-white transition-all">
            <Printer size={16} />
            Test Receipt Print
          </button>
        </div>
      </div>

      {/* Kitchen Printer */}
      <div className="card">
        <h2 className="text-lg font-bold text-gray-900 mb-4">👨‍🍳 Kitchen Printer</h2>
        <p className="text-sm text-gray-500 mb-4">Prints order tickets for kitchen staff</p>
        <div className="space-y-4">
          <input type="text" defaultValue="Kitchen Printer" placeholder="Printer Name" className="input-field" />
          
          <div>
            <label className="text-sm font-semibold text-gray-700 mb-2 block">Connection Type</label>
            <div className="flex gap-2">
              {['network', 'usb', 'serial'].map(type => (
                <button
                  key={type}
                  onClick={() => setKitchenType(type)}
                  className={`px-4 py-2 rounded-lg text-sm font-semibold capitalize transition-all ${
                    kitchenType === type ? 'bg-[#E74C3C] text-white' : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
                  }`}
                >
                  {type}
                </button>
              ))}
            </div>
          </div>

          {kitchenType === 'network' && (
            <div className="grid grid-cols-3 gap-4">
              <div className="col-span-2">
                <input type="text" defaultValue="192.168.1.101" placeholder="IP Address" className="input-field" />
              </div>
              <div>
                <input type="number" defaultValue="9100" placeholder="Port" className="input-field" />
              </div>
            </div>
          )}

          <div className="flex items-center gap-4">
            <select className="input-field w-auto">
              <option>80mm</option>
              <option>58mm</option>
            </select>
            <label className="flex items-center gap-2 text-sm">
              <input type="checkbox" defaultChecked className="w-4 h-4 rounded accent-[#E74C3C]" />
              Auto Print
            </label>
          </div>

          <button className="flex items-center gap-2 py-2 px-4 rounded-lg border border-[#E74C3C] text-[#E74C3C] text-sm font-semibold hover:bg-[#E74C3C] hover:text-white transition-all">
            <Printer size={16} />
            Test Kitchen Print
          </button>
        </div>
      </div>

      {/* Save Button */}
      <button className="btn-primary w-full flex items-center justify-center gap-2 py-4 text-lg">
        <Save size={20} />
        SAVE SETTINGS
      </button>
    </div>
  );
}