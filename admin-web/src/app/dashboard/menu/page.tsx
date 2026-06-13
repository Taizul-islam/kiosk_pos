'use client';

import { useState } from 'react';
import { demoCategories, demoProducts } from '@/lib/demo-data';
import { Category, Product } from '@/types';
import { formatCurrency } from '@/lib/utils';
import { Search, Plus, Edit2, Trash2, Check, X, UtensilsCrossed } from 'lucide-react';

export default function MenuPage() {
  const [activeTab, setActiveTab] = useState<'categories' | 'products'>('categories');
  const [searchQuery, setSearchQuery] = useState('');
  const [categories, setCategories] = useState<Category[]>(demoCategories);
  const [products, setProducts] = useState<Product[]>(demoProducts);

  // Dialog states
  const [showCategoryDialog, setShowCategoryDialog] = useState(false);
  const [showProductDialog, setShowProductDialog] = useState(false);
  const [editingCategory, setEditingCategory] = useState<Category | null>(null);
  const [editingProduct, setEditingProduct] = useState<Product | null>(null);

  // Form states
  const [categoryName, setCategoryName] = useState('');
  const [productName, setProductName] = useState('');
  const [productCategory, setProductCategory] = useState('Meat');
  const [productPrice, setProductPrice] = useState('');
  const [productDescription, setProductDescription] = useState('');
  const [productAvailable, setProductAvailable] = useState(true);

  const filteredProducts = products.filter((p) => {
    if (!searchQuery) return true;
    const q = searchQuery.toLowerCase();
    return p.name.toLowerCase().includes(q) || p.categoryName.toLowerCase().includes(q);
  });

  const getCategoryColor = (name: string): string => {
    switch (name) {
      case 'Meat': return '#E74C3C';
      case 'Fish & Chips': return '#3498DB';
      case 'Sides': return '#F39C12';
      case 'Drinks': return '#9B59B6';
      case 'Desserts': return '#E91E63';
      default: return '#FF6B35';
    }
  };

  // ============ CATEGORY CRUD ============
  const openAddCategory = () => {
    setEditingCategory(null);
    setCategoryName('');
    setShowCategoryDialog(true);
  };

  const openEditCategory = (cat: Category) => {
    setEditingCategory(cat);
    setCategoryName(cat.name);
    setShowCategoryDialog(true);
  };

  const saveCategory = () => {
    if (!categoryName.trim()) return;
    if (editingCategory) {
      setCategories(prev => prev.map(c => c.id === editingCategory.id ? { ...c, name: categoryName, slug: categoryName.toLowerCase().replace(/\s+/g, '-') } : c));
    } else {
      const newCat: Category = {
        id: Math.max(...categories.map(c => c.id), 0) + 1,
        name: categoryName,
        slug: categoryName.toLowerCase().replace(/\s+/g, '-'),
        displayOrder: categories.length + 1,
        isActive: true,
      };
      setCategories(prev => [...prev, newCat]);
    }
    setShowCategoryDialog(false);
  };

  const deleteCategory = (id: number) => {
    if (confirm('Delete this category?')) {
      setCategories(prev => prev.filter(c => c.id !== id));
    }
  };

  // ============ PRODUCT CRUD ============
  const openAddProduct = () => {
    setEditingProduct(null);
    setProductName('');
    setProductCategory('Meat');
    setProductPrice('');
    setProductDescription('');
    setProductAvailable(true);
    setShowProductDialog(true);
  };

  const openEditProduct = (prod: Product) => {
    setEditingProduct(prod);
    setProductName(prod.name);
    setProductCategory(prod.categoryName);
    setProductPrice(prod.basePrice.toString());
    setProductDescription(prod.description || '');
    setProductAvailable(prod.isAvailable);
    setShowProductDialog(true);
  };

  const saveProduct = () => {
    if (!productName.trim() || !productPrice.trim()) return;
    const price = parseFloat(productPrice);
    if (isNaN(price)) return;

    if (editingProduct) {
      setProducts(prev => prev.map(p => p.id === editingProduct.id ? {
        ...p,
        name: productName,
        categoryName: productCategory,
        basePrice: price,
        description: productDescription,
        isAvailable: productAvailable,
      } : p));
    } else {
      const newProd: Product = {
        id: Math.max(...products.map(p => p.id), 0) + 1,
        categoryId: categories.find(c => c.name === productCategory)?.id || 1,
        categoryName: productCategory,
        name: productName,
        description: productDescription,
        basePrice: price,
        isAvailable: productAvailable,
        modifierGroupIds: [],
      };
      setProducts(prev => [...prev, newProd]);
    }
    setShowProductDialog(false);
  };

  const toggleAvailability = (productId: number) => {
    setProducts(prev => prev.map(p => p.id === productId ? { ...p, isAvailable: !p.isAvailable } : p));
  };

  const deleteProduct = (productId: number) => {
    if (confirm('Delete this product?')) {
      setProducts(prev => prev.filter(p => p.id !== productId));
    }
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Menu Management</h1>
          <p className="text-gray-500 mt-1">{categories.length} categories • {products.length} products</p>
        </div>
        <button
          onClick={activeTab === 'categories' ? openAddCategory : openAddProduct}
          className="bg-[#FF6B35] hover:bg-[#E55A2B] text-white font-semibold py-2.5 px-6 rounded-xl transition-all duration-200 shadow-md hover:shadow-lg flex items-center gap-2"
        >
          <Plus size={18} />
          {activeTab === 'categories' ? 'Add Category' : 'Add Product'}
        </button>
      </div>

      {/* Tabs */}
      <div className="flex gap-1 bg-gray-100 p-1 rounded-xl w-fit">
        <button
          onClick={() => setActiveTab('categories')}
          className={`px-5 py-2 rounded-lg text-sm font-semibold transition-all ${activeTab === 'categories' ? 'bg-white text-gray-900 shadow-sm' : 'text-gray-500 hover:text-gray-700'}`}
        >
          Categories
        </button>
        <button
          onClick={() => setActiveTab('products')}
          className={`px-5 py-2 rounded-lg text-sm font-semibold transition-all ${activeTab === 'products' ? 'bg-white text-gray-900 shadow-sm' : 'text-gray-500 hover:text-gray-700'}`}
        >
          Products
        </button>
      </div>

      {/* ============ CATEGORIES ============ */}
      {activeTab === 'categories' && (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {categories.map((cat) => {
            const productCount = products.filter(p => p.categoryName === cat.name).length;
            const color = getCategoryColor(cat.name);
            return (
              <div key={cat.id} className="bg-white rounded-2xl shadow-sm border border-gray-100 p-6 hover:shadow-md transition-all">
                <div className="flex items-center gap-4">
                  <div className="w-14 h-14 rounded-2xl flex items-center justify-center flex-shrink-0" style={{ backgroundColor: `${color}20` }}>
                    <UtensilsCrossed size={24} style={{ color }} />
                  </div>
                  <div className="flex-1">
                    <h3 className="text-lg font-bold text-gray-900">{cat.name}</h3>
                    <p className="text-sm text-gray-500">{productCount} products</p>
                  </div>
                  <div className="flex gap-2">
                    <button onClick={() => openEditCategory(cat)} className="p-2 rounded-lg bg-blue-50 text-blue-600 hover:bg-blue-100">
                      <Edit2 size={16} />
                    </button>
                    <button onClick={() => deleteCategory(cat.id)} className="p-2 rounded-lg bg-red-50 text-red-600 hover:bg-red-100">
                      <Trash2 size={16} />
                    </button>
                  </div>
                </div>
              </div>
            );
          })}
        </div>
      )}

      {/* ============ PRODUCTS ============ */}
      {activeTab === 'products' && (
        <>
          <div className="relative">
            <Search size={18} className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" />
            <input
              type="text"
              placeholder="Search products..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="w-full px-4 py-3 pl-10 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-[#FF6B35]"
            />
          </div>

          <div className="space-y-2">
            {filteredProducts.map((product) => (
              <div key={product.id} className={`bg-white rounded-2xl shadow-sm border border-gray-100 p-4 flex items-center gap-4 hover:shadow-md transition-all ${!product.isAvailable ? 'opacity-60 border-red-200' : ''}`}>
                <div className="w-12 h-12 rounded-xl flex items-center justify-center flex-shrink-0" style={{ backgroundColor: `${getCategoryColor(product.categoryName)}20` }}>
                  <UtensilsCrossed size={20} style={{ color: getCategoryColor(product.categoryName) }} />
                </div>
                <div className="flex-1">
                  <div className="flex items-center gap-2">
                    <h3 className="font-bold text-gray-900">{product.name}</h3>
                    {!product.isAvailable && <span className="px-2 py-0.5 rounded-full text-xs font-bold bg-red-100 text-red-600">UNAVAILABLE</span>}
                  </div>
                  <div className="flex items-center gap-3 text-sm text-gray-500 mt-0.5">
                    <span className="px-2 py-0.5 rounded-md bg-gray-100">{product.categoryName}</span>
                    <span className="font-bold text-[#FF6B35]">{formatCurrency(product.basePrice)}</span>
                  </div>
                </div>
                <div className="flex items-center gap-2">
                  <button onClick={() => toggleAvailability(product.id)} className={`p-2 rounded-lg ${product.isAvailable ? 'bg-green-50 text-green-600 hover:bg-green-100' : 'bg-red-50 text-red-600 hover:bg-red-100'}`}>
                    {product.isAvailable ? <Check size={18} /> : <X size={18} />}
                  </button>
                  <button onClick={() => openEditProduct(product)} className="p-2 rounded-lg bg-blue-50 text-blue-600 hover:bg-blue-100">
                    <Edit2 size={18} />
                  </button>
                  <button onClick={() => deleteProduct(product.id)} className="p-2 rounded-lg bg-red-50 text-red-600 hover:bg-red-100">
                    <Trash2 size={18} />
                  </button>
                </div>
              </div>
            ))}
          </div>
        </>
      )}

      {/* ============ ADD/EDIT CATEGORY DIALOG ============ */}
      {showCategoryDialog && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50">
          <div className="bg-white rounded-2xl p-6 w-full max-w-md mx-4">
            <h2 className="text-xl font-bold mb-4">{editingCategory ? 'Edit Category' : 'Add Category'}</h2>
            <input
              type="text"
              placeholder="Category Name"
              value={categoryName}
              onChange={(e) => setCategoryName(e.target.value)}
              className="w-full px-4 py-3 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-[#FF6B35] mb-4"
              autoFocus
            />
            <div className="flex gap-3">
              <button onClick={() => setShowCategoryDialog(false)} className="flex-1 py-2.5 px-6 rounded-xl border border-gray-300 text-gray-600 font-semibold hover:bg-gray-50 transition-all">
                Cancel
              </button>
              <button onClick={saveCategory} className="flex-1 bg-[#FF6B35] hover:bg-[#E55A2B] text-white font-semibold py-2.5 px-6 rounded-xl transition-all">
                {editingCategory ? 'Save' : 'Add'}
              </button>
            </div>
          </div>
        </div>
      )}

      {/* ============ ADD/EDIT PRODUCT DIALOG ============ */}
      {showProductDialog && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50">
          <div className="bg-white rounded-2xl p-6 w-full max-w-md mx-4 max-h-[90vh] overflow-y-auto">
            <h2 className="text-xl font-bold mb-4">{editingProduct ? 'Edit Product' : 'Add Product'}</h2>
            
            <label className="block text-sm font-semibold text-gray-700 mb-1">Product Name *</label>
            <input
              type="text"
              placeholder="Enter product name"
              value={productName}
              onChange={(e) => setProductName(e.target.value)}
              className="w-full px-4 py-3 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-[#FF6B35] mb-3"
            />

            <label className="block text-sm font-semibold text-gray-700 mb-1">Category</label>
            <select
              value={productCategory}
              onChange={(e) => setProductCategory(e.target.value)}
              className="w-full px-4 py-3 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-[#FF6B35] mb-3"
            >
              {categories.map(c => (
                <option key={c.id} value={c.name}>{c.name}</option>
              ))}
            </select>

            <label className="block text-sm font-semibold text-gray-700 mb-1">Price *</label>
            <input
              type="number"
              step="0.01"
              placeholder="0.00"
              value={productPrice}
              onChange={(e) => setProductPrice(e.target.value)}
              className="w-full px-4 py-3 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-[#FF6B35] mb-3"
            />

            <label className="block text-sm font-semibold text-gray-700 mb-1">Description</label>
            <textarea
              placeholder="Enter description"
              value={productDescription}
              onChange={(e) => setProductDescription(e.target.value)}
              rows={3}
              className="w-full px-4 py-3 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-[#FF6B35] mb-3"
            />

            <label className="flex items-center gap-2 mb-4">
              <input
                type="checkbox"
                checked={productAvailable}
                onChange={(e) => setProductAvailable(e.target.checked)}
                className="w-4 h-4 rounded accent-[#FF6B35]"
              />
              <span className="text-sm font-semibold text-gray-700">Available for ordering</span>
            </label>

            <div className="flex gap-3">
              <button onClick={() => setShowProductDialog(false)} className="flex-1 py-2.5 px-6 rounded-xl border border-gray-300 text-gray-600 font-semibold hover:bg-gray-50 transition-all">
                Cancel
              </button>
              <button onClick={saveProduct} className="flex-1 bg-[#00B894] hover:bg-[#00A37E] text-white font-semibold py-2.5 px-6 rounded-xl transition-all">
                {editingProduct ? 'Save Changes' : 'Add Product'}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}