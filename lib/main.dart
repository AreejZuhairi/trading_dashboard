import 'package:flutter/material.dart';

import 'mock_data.dart';

void main() => runApp(const TradingDashboardApp());

const navy = Color(0xFF14243A);
const muted = Color(0xFF8290A3);
const canvas = Color(0xFFF4F6F9);
const green = Color(0xFF15966A);
const red = Color(0xFFE4555D);

class TradingDashboardApp extends StatelessWidget {
  const TradingDashboardApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Trading Dashboard',
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: canvas,
          colorScheme: ColorScheme.fromSeed(seedColor: navy, brightness: Brightness.light),
          fontFamily: 'Roboto',
          textTheme: Theme.of(context).textTheme.apply(bodyColor: navy, displayColor: navy),
        ),
        home: const DashboardPage(),
      );
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String timeframe = '1D';
  String tradeAction = 'Buy';

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: LayoutBuilder(builder: (context, constraints) {
            final wide = constraints.maxWidth >= 900;
            return CustomScrollView(slivers: [
              SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1440),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: wide ? 36 : 20, vertical: 22),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        _Header(wide: wide),
                        const SizedBox(height: 26),
                        _PortfolioCard(wide: wide),
                        const SizedBox(height: 24),
                        _TradeCard(
                          action: tradeAction,
                          onActionChanged: (value) => setState(() => tradeAction = value),
                        ),
                        const SizedBox(height: 24),
                        if (wide)
                          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Expanded(flex: 7, child: _PerformanceCard(selected: timeframe, onSelect: (v) => setState(() => timeframe = v))),
                            const SizedBox(width: 20),
                            Expanded(flex: 5, child: _MarketCard()),
                          ])
                        else ...[
                          _PerformanceCard(selected: timeframe, onSelect: (v) => setState(() => timeframe = v)),
                          const SizedBox(height: 20),
                          _MarketCard(),
                        ],
                        const SizedBox(height: 20),
                        if (wide)
                          Row(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                            Expanded(child: _WatchlistCard()),
                            SizedBox(width: 20),
                            Expanded(child: _TransactionsCard()),
                          ])
                        else ...[
                          const _WatchlistCard(),
                          const SizedBox(height: 20),
                          const _TransactionsCard(),
                        ],
                        const SizedBox(height: 28),
                      ]),
                    ),
                  ),
                ),
              ),
            ]);
          }),
        ),
      );
}

class _TradeCard extends StatefulWidget {
  const _TradeCard({required this.action, required this.onActionChanged});
  final String action;
  final ValueChanged<String> onActionChanged;

  @override
  State<_TradeCard> createState() => _TradeCardState();
}

class _TradeCardState extends State<_TradeCard> {
  String symbol = 'BTC/USD';
  final quantityController = TextEditingController(text: '0.01');

  double get price => double.parse(markets
      .firstWhere((item) => item.symbol == symbol)
      .price
      .replaceAll(r'$', '')
      .replaceAll(',', ''));

  double get quantity => double.tryParse(quantityController.text) ?? 0;

  @override
  void dispose() {
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final buying = widget.action == 'Buy';
    final accent = buying ? green : red;
    return _Card(
      title: 'Trade',
      trailing: const Text('Demo order', style: TextStyle(color: muted, fontSize: 11, fontWeight: FontWeight.w600)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(color: canvas, borderRadius: BorderRadius.circular(11)),
          child: Row(children: ['Buy', 'Sell'].map((action) => Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => widget.onActionChanged(action),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(color: widget.action == action ? (action == 'Buy' ? green : red) : Colors.transparent, borderRadius: BorderRadius.circular(8)),
                child: Text(action, textAlign: TextAlign.center, style: TextStyle(color: widget.action == action ? Colors.white : muted, fontWeight: FontWeight.w700, fontSize: 13)),
              ),
            ),
          )).toList()),
        ),
        const SizedBox(height: 16),
        const Text('ASSET', style: TextStyle(fontSize: 10, color: muted, fontWeight: FontWeight.w700, letterSpacing: .8)),
        const SizedBox(height: 7),
        DropdownButtonFormField<String>(
          value: symbol,
          decoration: InputDecoration(isDense: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE5EAF0))), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12)),
          items: markets.map((item) => DropdownMenuItem(value: item.symbol, child: Text('${item.symbol} · ${item.price}', style: const TextStyle(fontSize: 12)))).toList(),
          onChanged: (value) => setState(() { if (value != null) symbol = value; }),
        ),
        const SizedBox(height: 14),
        const Text('QUANTITY', style: TextStyle(fontSize: 10, color: muted, fontWeight: FontWeight.w700, letterSpacing: .8)),
        const SizedBox(height: 7),
        TextField(
          controller: quantityController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(suffixText: symbol.contains('/') ? symbol.split('/').first : 'shares', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE5EAF0))), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12)),
        ),
        const SizedBox(height: 12),
        Row(children: [const Expanded(child: Text('Estimated total', style: TextStyle(color: muted, fontSize: 12))), Text('\$${(price * quantity).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14))]),
        const SizedBox(height: 14),
        SizedBox(width: double.infinity, child: FilledButton(
          style: FilledButton.styleFrom(backgroundColor: accent, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 13), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          onPressed: quantity > 0 ? () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${widget.action} order for $quantity $symbol placed in demo mode.'))) : null,
          child: Text('${widget.action} $symbol', style: const TextStyle(fontWeight: FontWeight.w700)),
        )),
        const SizedBox(height: 8),
        const Text('Orders are simulated and won’t be sent to a broker.', style: TextStyle(color: muted, fontSize: 10)),
      ]),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.wide});
  final bool wide;
  @override
  Widget build(BuildContext context) => Row(children: [
        Container(width: 42, height: 42, decoration: BoxDecoration(color: navy, borderRadius: BorderRadius.circular(13)), child: const Icon(Icons.candlestick_chart_rounded, color: Colors.white, size: 23)),
        const SizedBox(width: 12),
        const Expanded(child: Text('Trading Dashboard', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: -.4))),
        IconButton(onPressed: () {}, tooltip: 'Notifications', icon: const Icon(Icons.notifications_none_rounded, color: navy)),
        const SizedBox(width: 8),
        CircleAvatar(radius: 19, backgroundColor: const Color(0xFFE5EAF0), child: const Icon(Icons.person_rounded, color: navy, size: 21)),
      ]);
}

class _PortfolioCard extends StatelessWidget {
  const _PortfolioCard({required this.wide});
  final bool wide;
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: navy, borderRadius: BorderRadius.circular(16)),
        child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('TOTAL BALANCE', style: TextStyle(color: Colors.white.withValues(alpha: .65), fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.1)),
            const SizedBox(height: 9),
            const FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft, child: Text('\$24,850.50', style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w700, letterSpacing: -.8))),
            const SizedBox(height: 16),
            Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.trending_up_rounded, size: 17, color: Color(0xFF54D6A2)),
              const SizedBox(width: 5),
              const Text('+\$428.75', style: TextStyle(color: Color(0xFF54D6A2), fontSize: 15, fontWeight: FontWeight.w700)),
              const SizedBox(width: 8),
              Text('Today', style: TextStyle(color: Colors.white.withValues(alpha: .62), fontSize: 13)),
              const SizedBox(width: 10),
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: const Color(0xFF234B48), borderRadius: BorderRadius.circular(20)), child: const Text('+1.76%', style: TextStyle(color: Color(0xFF75E0B4), fontSize: 12, fontWeight: FontWeight.w700))),
            ]),
          ])),
          if (wide) ...[
            const SizedBox(width: 28),
            Container(width: 1, height: 75, color: Colors.white.withValues(alpha: .14)),
            const SizedBox(width: 30),
            const _BalanceStat(label: 'INVESTED', value: '\$18,420.00'),
            const SizedBox(width: 38),
            const _BalanceStat(label: 'AVAILABLE', value: '\$6,430.50'),
            const SizedBox(width: 22),
          ],
          if (wide) Container(width: 46, height: 46, decoration: BoxDecoration(color: Colors.white.withValues(alpha: .09), borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.arrow_outward_rounded, color: Colors.white)),
        ]),
      );
}

class _BalanceStat extends StatelessWidget {
  const _BalanceStat({required this.label, required this.value});
  final String label, value;
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: TextStyle(color: Colors.white.withValues(alpha: .58), fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1)), const SizedBox(height: 8), Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16))]);
}

class _Card extends StatelessWidget {
  const _Card({required this.title, required this.child, this.trailing});
  final String title;
  final Widget child;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE9EDF2))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [Expanded(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))), ?trailing]),
          const SizedBox(height: 18),
          child,
        ]),
      );
}

class _PerformanceCard extends StatelessWidget {
  const _PerformanceCard({required this.selected, required this.onSelect});
  final String selected;
  final ValueChanged<String> onSelect;
  @override
  Widget build(BuildContext context) => _Card(
        title: 'Portfolio performance',
        trailing: Row(
          children: timeframes.map((item) => Padding(
            padding: const EdgeInsets.only(left: 3),
            child: InkWell(
              onTap: () => onSelect(item),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
                decoration: BoxDecoration(
                  color: selected == item ? const Color(0xFFEAF0F7) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(item, style: TextStyle(color: selected == item ? navy : muted, fontSize: 11, fontWeight: FontWeight.w700)),
              ),
            ),
          )).toList(),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [const Text('\$24,850.50', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700, letterSpacing: -.5)), const SizedBox(width: 9), const Padding(padding: EdgeInsets.only(bottom: 3), child: Text('+1.76%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: green)))]),
          const SizedBox(height: 12),
          SizedBox(height: 185, width: double.infinity, child: CustomPaint(painter: _ChartPainter(points: chartData[selected]!, line: const Color(0xFF3277D3), grid: const Color(0xFFEEF1F5)))),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: chartLabels[selected]!.map((label) => Text(label, style: const TextStyle(fontSize: 10, color: muted))).toList()),
        ]),
      );
}

class _ChartPainter extends CustomPainter {
  _ChartPainter({required this.points, required this.line, required this.grid});
  final List<double> points;
  final Color line, grid;
  @override
  void paint(Canvas canvas, Size size) {
    const left = 4.0, right = 4.0, top = 8.0, bottom = 8.0;
    final chart = Rect.fromLTRB(left, top, size.width - right, size.height - bottom);
    final gridPaint = Paint()..color = grid..strokeWidth = 1;
    for (var i = 0; i < 4; i++) { final y = chart.top + chart.height * i / 3; canvas.drawLine(Offset(chart.left, y), Offset(chart.right, y), gridPaint); }
    final min = points.reduce((a, b) => a < b ? a : b) - 4;
    final max = points.reduce((a, b) => a > b ? a : b) + 4;
    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final x = chart.left + chart.width * i / (points.length - 1);
      final y = chart.bottom - ((points[i] - min) / (max - min)) * chart.height;
      if (i == 0) { path.moveTo(x, y); } else { path.lineTo(x, y); }
    }
    final fill = Path.from(path)..lineTo(chart.right, chart.bottom)..lineTo(chart.left, chart.bottom)..close();
    canvas.drawPath(fill, Paint()..shader = LinearGradient(colors: [line.withValues(alpha: .18), line.withValues(alpha: 0)], begin: Alignment.topCenter, end: Alignment.bottomCenter).createShader(chart));
    canvas.drawPath(path, Paint()..color = line..strokeWidth = 2.5..style = PaintingStyle.stroke..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round);
    final lastY = chart.bottom - ((points.last - min) / (max - min)) * chart.height;
    canvas.drawCircle(Offset(chart.right, lastY), 4, Paint()..color = line);
    canvas.drawCircle(Offset(chart.right, lastY), 7, Paint()..color = line.withValues(alpha: .16));
  }
  @override
  bool shouldRepaint(covariant _ChartPainter oldDelegate) => oldDelegate.points != points;
}

class _MarketCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) => _Card(title: 'Market overview', trailing: const Text('See all  →', style: TextStyle(color: muted, fontSize: 11, fontWeight: FontWeight.w600)), child: Column(children: markets.map((market) => Padding(padding: const EdgeInsets.only(bottom: 14), child: _MarketRow(market: market))).toList()));
}

class _MarketRow extends StatelessWidget {
  const _MarketRow({required this.market});
  final MarketItem market;
  @override
  Widget build(BuildContext context) {
    final positive = market.change >= 0;
    return Row(children: [
      Container(width: 36, height: 36, decoration: BoxDecoration(color: market.tint, borderRadius: BorderRadius.circular(12)), child: Center(child: Text(market.mark, style: TextStyle(color: market.color, fontWeight: FontWeight.w800, fontSize: 13)))),
      const SizedBox(width: 10),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(market.symbol, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)), const SizedBox(height: 3), Text(market.name, style: const TextStyle(fontSize: 10, color: muted))])),
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text(market.price, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)), const SizedBox(height: 3), Text('${positive ? '+' : ''}${market.change.toStringAsFixed(2)}%', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: positive ? green : red))]),
    ]);
  }
}

class _WatchlistCard extends StatelessWidget {
  const _WatchlistCard();
  @override
  Widget build(BuildContext context) => _Card(title: 'Watchlist', trailing: const Icon(Icons.more_horiz, color: muted), child: Column(children: watchlist.map((item) => Padding(padding: const EdgeInsets.only(bottom: 13), child: Row(children: [Text(item.icon, style: const TextStyle(fontSize: 18)), const SizedBox(width: 11), Expanded(child: Text(item.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))), Text(item.price, style: const TextStyle(fontSize: 12, color: muted, fontWeight: FontWeight.w600)), const SizedBox(width: 12), SizedBox(width: 65, height: 28, child: CustomPaint(painter: _MiniChartPainter(item.positive ? green : red, item.positive)))]))).toList()));
}

class _MiniChartPainter extends CustomPainter {
  _MiniChartPainter(this.color, this.rising);
  final Color color; final bool rising;
  @override
  void paint(Canvas canvas, Size size) {
    final points = rising ? [.72, .55, .66, .33, .42, .2, .29, .08] : [.2, .38, .26, .57, .48, .77, .62, .9];
    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final p = Offset(size.width * i / (points.length - 1), size.height * points[i]);
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    canvas.drawPath(path, Paint()..color = color..strokeWidth = 1.8..style = PaintingStyle.stroke..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round);
  }
  @override
  bool shouldRepaint(covariant _MiniChartPainter oldDelegate) => oldDelegate.color != color;
}

class _TransactionsCard extends StatelessWidget {
  const _TransactionsCard();
  @override
  Widget build(BuildContext context) => _Card(title: 'Recent transactions', trailing: const Text('View all  →', style: TextStyle(color: muted, fontSize: 11, fontWeight: FontWeight.w600)), child: Column(children: transactions.map((tx) => Padding(padding: const EdgeInsets.only(bottom: 14), child: Row(children: [Container(width: 34, height: 34, decoration: BoxDecoration(color: tx.buy ? const Color(0xFFE8F5EF) : const Color(0xFFFFEEEE), borderRadius: BorderRadius.circular(11)), child: Icon(tx.buy ? Icons.south_west_rounded : Icons.north_east_rounded, size: 16, color: tx.buy ? green : red)), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('${tx.action} ${tx.asset}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)), const SizedBox(height: 3), Text(tx.date, style: const TextStyle(fontSize: 10, color: muted))])), Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text(tx.amount, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)), const SizedBox(height: 3), Text(tx.units, style: const TextStyle(fontSize: 10, color: muted))])]))).toList()));
}
