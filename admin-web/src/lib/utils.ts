export function formatCurrency(amount: number): string {
  return `$${amount.toFixed(2)}`;
}

export function getTimeAgo(date: Date): string {
  const diff = Date.now() - date.getTime();
  const minutes = Math.floor(diff / 60000);
  if (minutes < 1) return 'Just now';
  if (minutes < 60) return `${minutes}m ago`;
  const hours = Math.floor(minutes / 60);
  return `${hours}h ago`;
}

export function getStatusColor(status: string): string {
  switch (status) {
    case 'pending': return '#F39C12';
    case 'preparing': return '#3498DB';
    case 'ready': return '#00B894';
    case 'completed': return '#6B7280';
    default: return '#6B7280';
  }
}

export function getNextStatus(status: string): string {
  switch (status) {
    case 'pending': return 'Start Preparing';
    case 'preparing': return 'Mark Ready';
    case 'ready': return 'Complete';
    default: return '';
  }
}