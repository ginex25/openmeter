import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/features/meters/model/details_meter_model.dart';
import 'package:openmeter/features/meters/model/meter_dto.dart';
import 'package:openmeter/features/meters/provider/chart_has_focus.dart';
import 'package:openmeter/features/meters/provider/current_details_meter.dart';
import 'package:openmeter/features/meters/provider/details_meter_provider.dart';
import 'package:openmeter/features/meters/provider/entry_filter_provider.dart';
import 'package:openmeter/features/meters/provider/selected_entries_count.dart';
import 'package:openmeter/features/meters/provider/show_line_chart_provider.dart';
import 'package:openmeter/features/meters/view/add_meter_screen.dart';
import 'package:openmeter/features/meters/view/cost_view.dart';
import 'package:openmeter/features/meters/widgets/details_meter/charts/count_line_chart.dart';
import 'package:openmeter/features/meters/widgets/details_meter/charts/uasge_line_chart.dart';
import 'package:openmeter/features/meters/widgets/details_meter/charts/usage_bar_charts/card.dart';
import 'package:openmeter/features/meters/widgets/details_meter/entry/add_entry.dart';
import 'package:openmeter/features/meters/widgets/details_meter/entry/entry_card_list.dart';
import 'package:openmeter/features/tags/widget/horizontal_tags_list.dart';
import 'package:openmeter/shared/widgets/selected_items_bar.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DetailsMeterScreen extends ConsumerStatefulWidget {
  final int meterId;

  const DetailsMeterScreen({super.key, required this.meterId});

  @override
  ConsumerState createState() => _DetailsMeterScreenState();
}

class _DetailsMeterScreenState extends ConsumerState<DetailsMeterScreen> {
  int _activeChartWidget = 0;

  @override
  Widget build(BuildContext context) {
    final detailsProvider = ref.watch(detailsMeterProvider(widget.meterId));

    final int selectedEntriesCount = ref.watch(selectedEntriesCountProvider);

    return detailsProvider.when(
      data: (detailsMeter) {
        final bool showLineChart = ref.watch(showLineChartProvider);

        final bool chartHasFocus = ref.watch(chartHasFocusProvider);

        return ProviderScope(
          overrides: [
            currentDetailsMeterProvider.overrideWithValue(detailsMeter),
          ],
          child: Scaffold(
            appBar: selectedEntriesCount > 0
                ? _selectedAppBar(ref, selectedEntriesCount)
                : _unselectedAppBar(
                    context,
                    ref,
                    detailsMeter,
                  ),
            body: PopScope(
              canPop: selectedEntriesCount == 0,
              onPopInvokedWithResult: (bool didPop, _) async {
                if (selectedEntriesCount > 0) {
                  ref
                      .read(detailsMeterProvider(widget.meterId).notifier)
                      .removeSelectedEntitiesState();
                }
              },
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Zählernummer
                        _meterInformationWidget(context, detailsMeter.meter),
                        const Divider(),
                        HorizontalTagsList(
                          meterId: widget.meterId,
                          tags: [],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const EntryCardList(),
                        const SizedBox(
                          height: 10,
                        ),
                        if (detailsMeter.meter.lastEntry != null)
                          Column(
                            children: [
                              SizedBox(
                                height: 410,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: PageView(
                                    physics: chartHasFocus
                                        ? const NeverScrollableScrollPhysics()
                                        : null,
                                    onPageChanged: (value) {
                                      setState(() {
                                        _activeChartWidget = value;
                                      });
                                    },
                                    children: [
                                      if (!showLineChart)
                                        const UsageBarChartCard(),
                                      if (showLineChart) const UsageLineChart(),
                                      const CountLineChart(),
                                    ],
                                  ),
                                ),
                              ),
                              AnimatedSmoothIndicator(
                                activeIndex: _activeChartWidget,
                                count: 2,
                                effect: WormEffect(
                                  activeDotColor:
                                      Theme.of(context).primaryColor,
                                  dotHeight: 10,
                                  dotWidth: 10,
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(
                          height: 15,
                        ),
                        const CostView(),
                      ],
                    ),
                  ),
                  if (selectedEntriesCount > 0)
                    SelectedItemsBar(
                      buttons: [
                        TextButton(
                          onPressed: () {
                            ref
                                .read(detailsMeterProvider(widget.meterId)
                                    .notifier)
                                .deleteSelectedEntries();
                          },
                          style: ButtonStyle(
                            foregroundColor: WidgetStateProperty.all(
                              Theme.of(context).textTheme.bodyLarge!.color,
                            ),
                          ),
                          child: const Column(
                            mainAxisSize: MainAxisSize.min,
                            spacing: 5,
                            children: [
                              Icon(Icons.delete_outline, size: 28),
                              Text('Löschen'),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
      error: (error, stackTrace) => throw error,
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _meterInformationWidget(BuildContext context, MeterDto meter) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SelectableText(
            meter.note,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            meter.room?.name ?? '',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  AppBar _unselectedAppBar(
    BuildContext context,
    WidgetRef ref,
    DetailsMeterModel detailsMeter,
  ) {
    return AppBar(
      title: SelectableText(detailsMeter.meter.number),
      leading: BackButton(
        onPressed: () {
          ref.invalidate(entryFilterProvider);
          Navigator.of(context).pop();
        },
      ),
      actions: [
        const AddEntry(),
        IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AddMeterScreen(detailsMeter: detailsMeter),
                ));
          },
          icon: const Icon(Icons.edit),
          tooltip: 'Zähler bearbeiten',
        ),
      ],
    );
  }

  AppBar _selectedAppBar(WidgetRef ref, int count) {
    return AppBar(
      title: Text('$count ausgewählt'),
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          ref
              .read(detailsMeterProvider(widget.meterId).notifier)
              .removeSelectedEntitiesState();
        },
      ),
    );
  }
}
