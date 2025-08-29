import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/features/meters/provider/contract_list.dart';
import 'package:openmeter/features/meters/provider/contracts_meter_type.dart';
import 'package:openmeter/features/meters/provider/details_meter/cost/meter_cost_provider.dart';
import 'package:openmeter/features/meters/widgets/details_meter/costs/cost_card.dart';
import 'package:openmeter/features/meters/widgets/details_meter/costs/cost_headline.dart';
import 'package:openmeter/features/meters/widgets/details_meter/costs/select_contract_card.dart';

import '../provider/details_meter/current_details_meter.dart';

class CostView extends ConsumerWidget {
  const CostView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailsMeter = ref.watch(currentDetailsMeterProvider);

    final meter = detailsMeter.meter;

    final costProvider =
        ref.watch(meterCostProviderProvider(meter, detailsMeter.entries));

    return costProvider.when(
      data: (meterCosts) {
        final contractsProvider =
            ref.watch(contractsMeterTypeProvider(detailsMeter.meter.typ));

        return contractsProvider.when(
          data: (contracts) {
            if (contracts.isEmpty) {
              return Container();
            }

            if (contracts.length == 1 && meterCosts == null) {
              ref
                  .read(meterCostProviderProvider(
                          detailsMeter.meter, detailsMeter.entries)
                      .notifier)
                  .createMeterCosts(contracts[0], null, null);
            }

            return ProviderScope(
              overrides: [
                contractsForMeterProvider.overrideWithValue(contracts),
              ],
              child: Column(
                children: [
                  CostHeadline(meterCost: meterCosts),
                  if (contracts.length > 1 && meterCosts == null)
                    SelectContractCard(),
                  if (meterCosts != null) CostCard(meterCosts),
                ],
              ),
            );
          },
          error: (error, stackTrace) => throw error,
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      error: (error, stackTrace) => throw error,
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
