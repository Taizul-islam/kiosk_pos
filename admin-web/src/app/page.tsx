'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { login } from '@/lib/auth';
import { Store, ArrowRight } from 'lucide-react';

export default function LoginPage() {
  const router = useRouter();
  const [pin, setPin] = useState('');
  const [error, setError] = useState('');
  const [isLoading, setIsLoading] = useState(false);

  const handleNumber = (num: string) => {
    if (pin.length < 4) {
      const newPin = pin + num;
      setPin(newPin);
      setError('');
      if (newPin.length === 4) {
        handleLogin(newPin);
      }
    }
  };

  const handleDelete = () => {
    setPin(prev => prev.slice(0, -1));
    setError('');
  };

  const handleClear = () => {
    setPin('');
    setError('');
  };

  const handleLogin = async (pinToUse: string) => {
    setIsLoading(true);
    await new Promise(resolve => setTimeout(resolve, 400));
    const user = login(pinToUse);
    if (user) {
      router.push('/dashboard');
    } else {
      setError('Invalid PIN. Please try again.');
      setPin('');
      setIsLoading(false);
    }
  };

  const keys = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
    ['⌫', '0', '✕'],
  ];

  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-gray-900 via-gray-800 to-gray-900">
      <div className="w-full max-w-md mx-4">
        {/* Logo & Title */}
        <div className="text-center mb-10">
          <div className="inline-flex items-center justify-center w-24 h-24 rounded-3xl bg-[#FF6B35] shadow-lg shadow-[#FF6B35]/30 mb-6">
            <Store className="w-12 h-12 text-white" />
          </div>
          <h1 className="text-4xl font-bold text-white mb-2 tracking-tight">BURGER HOUSE</h1>
          <p className="text-gray-400 text-lg">Admin Dashboard</p>
        </div>

        {/* PIN Display */}
        <div className="bg-white/5 backdrop-blur-sm rounded-2xl p-8 border border-white/10">
          <div className="flex justify-center gap-4 mb-8">
            {[0, 1, 2, 3].map((i) => (
              <div
                key={i}
                className={`w-5 h-5 rounded-full border-2 transition-all duration-300 ${
                  i < pin.length
                    ? 'bg-[#FF6B35] border-[#FF6B35] scale-110'
                    : 'bg-transparent border-gray-500'
                } ${error ? 'border-red-500 bg-red-500/20' : ''}`}
              />
            ))}
          </div>

          {error && (
            <p className="text-red-400 text-center mb-4 text-sm">{error}</p>
          )}

          {/* Keypad */}
          <div className="space-y-3">
            {keys.map((row, rowIndex) => (
              <div key={rowIndex} className="flex justify-center gap-3">
                {row.map((key) => (
                  <button
                    key={key}
                    onClick={() => {
                      if (isLoading) return;
                      if (key === '⌫') handleDelete();
                      else if (key === '✕') handleClear();
                      else handleNumber(key);
                    }}
                    disabled={isLoading}
                    className={`w-20 h-16 rounded-xl text-2xl font-semibold transition-all duration-200 ${
                      key === '⌫' || key === '✕'
                        ? 'bg-gray-700 text-gray-400 hover:bg-gray-600'
                        : 'bg-white text-gray-900 hover:bg-gray-100 shadow-md hover:shadow-lg'
                    } active:scale-95 disabled:opacity-50`}
                  >
                    {key === '⌫' ? (
                      <span className="text-xl">⌫</span>
                    ) : key === '✕' ? (
                      <span className="text-xl">✕</span>
                    ) : (
                      key
                    )}
                  </button>
                ))}
              </div>
            ))}
          </div>
        </div>

        <p className="text-center text-gray-500 text-sm mt-6">
          Admin Dashboard • Manager • Cashier
        </p>
      </div>
    </div>
  );
}