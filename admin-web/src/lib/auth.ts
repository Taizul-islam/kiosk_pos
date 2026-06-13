'use client';

import { User } from '@/types';
import { demoUsers } from './demo-data';

const STORAGE_KEY = 'burger_house_user';

export function login(pin: string): User | null {
  const user = demoUsers.find(u => u.pin === pin && u.isActive);
  if (user) {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(user));
  }
  return user || null;
}

export function logout(): void {
  localStorage.removeItem(STORAGE_KEY);
}

export function getCurrentUser(): User | null {
  if (typeof window === 'undefined') return null;
  const stored = localStorage.getItem(STORAGE_KEY);
  if (!stored) return null;
  try {
    return JSON.parse(stored) as User;
  } catch {
    return null;
  }
}

export function isAdmin(): boolean {
  return getCurrentUser()?.role === 'admin';
}

export function isManager(): boolean {
  const role = getCurrentUser()?.role;
  return role === 'manager' || role === 'admin';
}