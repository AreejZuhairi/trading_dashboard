import 'package:flutter/material.dart';

class MarketItem {
  const MarketItem(this.symbol, this.name, this.price, this.change, this.mark, this.color, this.tint);
  final String symbol, name, price, mark;
  final double change;
  final Color color, tint;
}

class WatchItem {
  const WatchItem(this.name, this.price, this.icon, this.positive);
  final String name, price, icon;
  final bool positive;
}

class TransactionItem {
  const TransactionItem(this.action, this.asset, this.date, this.amount, this.units, this.buy);
  final String action, asset, date, amount, units;
  final bool buy;
}

const timeframes = ['1D', '1W', '1M', '1Y'];

const markets = [
  MarketItem('BTC/USD', 'Bitcoin', '\$67,482.30', 2.41, '₿', Color(0xFFB7791F), Color(0xFFFFF5E6)),
  MarketItem('ETH/USD', 'Ethereum', '\$3,512.84', 1.28, '◆', Color(0xFF526AA8), Color(0xFFEDF1FC)),
  MarketItem('AAPL', 'Apple Inc.', '\$189.84', -0.62, 'A', Color(0xFF566477), Color(0xFFF0F2F5)),
  MarketItem('TSLA', 'Tesla, Inc.', '\$248.50', -1.34, 'T', Color(0xFFD64B53), Color(0xFFFFEEEE)),
  MarketItem('NVDA', 'NVIDIA Corp.', '\$875.28', 3.87, 'N', Color(0xFF52834D), Color(0xFFEDF6EC)),
];

const watchlist = [
  WatchItem('Bitcoin', '\$67,482', '₿', true),
  WatchItem('Ethereum', '\$3,512', '◆', true),
  WatchItem('Apple', '\$189.84', '●', false),
  WatchItem('Tesla', '\$248.50', 'T', false),
  WatchItem('NVIDIA', '\$875.28', 'N', true),
];

const transactions = [
  TransactionItem('Bought', 'BTC', 'Today, 10:42 AM', '+\$1,250.00', '0.0185 BTC', true),
  TransactionItem('Sold', 'ETH', 'Today, 9:18 AM', '-\$842.50', '0.24 ETH', false),
  TransactionItem('Bought', 'AAPL', 'Yesterday, 3:26 PM', '+\$568.20', '3 shares', true),
  TransactionItem('Bought', 'TSLA', 'Yesterday, 11:04 AM', '+\$745.50', '3 shares', true),
];

const chartData = <String, List<double>>{
  '1D': [31, 34, 32, 38, 36, 42, 40, 45, 43, 49, 47, 53, 51, 58, 56, 62, 59, 67, 64, 72],
  '1W': [25, 28, 26, 35, 33, 31, 39, 37, 46, 42, 50, 48, 55, 52, 61, 58, 68, 65, 72, 78],
  '1M': [22, 29, 27, 24, 36, 32, 41, 38, 35, 47, 43, 52, 49, 57, 54, 66, 61, 70, 67, 78],
  '1Y': [15, 19, 24, 21, 32, 29, 38, 35, 46, 42, 50, 47, 60, 56, 66, 63, 74, 70, 83, 91],
};

const chartLabels = <String, List<String>>{
  '1D': ['9:00 AM', '11:00 AM', '1:00 PM', '3:00 PM', 'Now'],
  '1W': ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
  '1M': ['Sep 8', 'Sep 15', 'Sep 22', 'Sep 29', 'Oct 6'],
  '1Y': ['Nov', 'Feb', 'May', 'Aug', 'Oct'],
};
