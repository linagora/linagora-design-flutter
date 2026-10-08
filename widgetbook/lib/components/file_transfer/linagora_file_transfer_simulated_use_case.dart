import 'dart:async';

import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Simulated transfer', type: LinagoraFileTransferDialog)
Widget linagoraFileTransferSimulatedUseCase(BuildContext context) {
  final layout = context.knobs.object.dropdown<LinagoraFileTransferLayout>(
    label: 'Layout',
    options: LinagoraFileTransferLayout.values,
    initialOption: LinagoraFileTransferLayout.wide,
    labelBuilder: (value) => value.name,
  );
  final count = context.knobs.int.slider(
    label: 'Files',
    initialValue: 3,
    min: 1,
    max: 6,
  );
  return _SimulatedTransfer(layout: layout, count: count);
}

enum _Phase { running, done, cancelled }

class _Transfer {
  final String name;
  double? progress;
  _Phase phase = _Phase.running;
  int ticks = 0;

  _Transfer(this.name);

  /// The first file shows an indeterminate bar for 1.5 s, like a bridge upload.
  void advance(bool indeterminateFirst) {
    ticks++;
    if (indeterminateFirst && ticks < 15) return;
    final next = (progress ?? 0) + 0.02;
    progress = next;
    if (next >= 1) phase = _Phase.done;
  }

  String statusLabel() => switch (phase) {
        _Phase.running => '332M',
        _Phase.done => 'Done',
        _Phase.cancelled => 'Cancelled',
      };
}

class _SimulatedTransfer extends StatefulWidget {
  final LinagoraFileTransferLayout layout;
  final int count;

  const _SimulatedTransfer({required this.layout, required this.count});

  @override
  State<_SimulatedTransfer> createState() => _SimulatedTransferState();
}

class _SimulatedTransferState extends State<_SimulatedTransfer> {
  late List<_Transfer> _transfers = _create();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) => _tick());
  }

  @override
  void didUpdateWidget(_SimulatedTransfer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.count != widget.count) _restart();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  List<_Transfer> _create() => List.generate(
        widget.count,
        (i) => _Transfer('Screenshot 2025-01-27 at 16.11.26 #${i + 1}.png'),
      );

  void _tick() {
    if (!mounted || !_anyRunning) return;
    setState(() {
      for (var i = 0; i < _transfers.length; i++) {
        final transfer = _transfers[i];
        if (transfer.phase == _Phase.running) transfer.advance(i == 0);
      }
    });
  }

  bool get _anyRunning => _transfers.any((t) => t.phase == _Phase.running);

  void _cancel(_Transfer transfer) => setState(() {
        if (transfer.phase == _Phase.running) transfer.phase = _Phase.cancelled;
      });

  void _cancelAll() => _transfers.forEach(_cancel);

  void _restart() => setState(() => _transfers = _create());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        LinagoraFileTransferSurface(
          layout: widget.layout,
          semanticLabel: 'Attaching file',
          child: _buildDialog(),
        ),
        Positioned(
          top: 8,
          left: 8,
          child: TextButton(
            key: const ValueKey('demo_restart'),
            onPressed: _restart,
            child: const Text('Restart'),
          ),
        ),
      ],
    );
  }

  Widget _buildDialog() => LinagoraFileTransferDialog(
        layout: widget.layout,
        title: 'Attaching file',
        description: const TextSpan(
          text: 'Your file is larger than 10 MB. It will be uploaded in your '
              'Drive and added as link in your email.',
        ),
        itemCount: _transfers.length,
        itemBuilder: (_, index) => _buildRow(_transfers[index]),
        cancelLabel: 'Cancel',
        closeTooltip: 'Cancel',
        onClose: _cancelAll,
        onCancelAll: _cancelAll,
        showCancelAll: _anyRunning,
      );

  Widget _buildRow(_Transfer transfer) => LinagoraFileTransferRow(
        layout: widget.layout,
        fileName: transfer.name,
        statusLabel: transfer.statusLabel(),
        progress: transfer.phase == _Phase.cancelled ? 0 : transfer.progress,
        cancelTooltip: 'Cancel',
        onCancel: transfer.phase == _Phase.running
            ? () => _cancel(transfer)
            : null,
      );
}
