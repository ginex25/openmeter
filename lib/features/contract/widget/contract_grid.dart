import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/core/enums/font_size_value.dart';
import 'package:openmeter/core/model/contract_dto.dart';
import 'package:openmeter/core/provider/theme_changer.dart';
import 'package:openmeter/features/contract/provider/contract_list_provider.dart';
import 'package:openmeter/features/contract/provider/selected_contract_count.dart';
import 'package:openmeter/features/contract/view/details_contract.dart';
import 'package:provider/provider.dart' as p;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'contract_card.dart';

class ContractGrid extends ConsumerStatefulWidget {
  const ContractGrid({super.key});

  @override
  ConsumerState createState() => _ContractGridState();
}

class _ContractGridState extends ConsumerState<ContractGrid> {
  int _pageIndex = 0;
  final _pageController = PageController(initialPage: 0, keepPage: true);

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int hasSelectedItems = ref.watch(selectedContractCountProvider);

    final contractsProvider = ref.watch(contractListProvider);

    final themeProvider = p.Provider.of<ThemeChanger>(context);

    return contractsProvider.when(
      data: (data) {
        if (data == null || data.$1.isEmpty) {
          return const Center(
            child: Text(
              'Es wurden noch keine Verträge erstellt. \n Drücke jetzt auf das Plus um ein Vertrag zu erstellen.',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          );
        }

        if (_pageController.positions.isNotEmpty) {
          int currentPage = _pageController.page! > 0.5 ? 1 : 0;

          if (_pageIndex != currentPage && _pageController.page! < 1.0) {
            _pageIndex = 0;
          }
        }

        final List first = data.$1;
        final List second = data.$2;

        double height = 180;

        bool isLargeText = themeProvider.getFontSizeValue == FontSizeValue.large
            ? true
            : false;

        if (first.length == 1 && second.isEmpty) {
          if (isLargeText) {
            height = 190;
          } else {
            height = 180;
          }
        } else {
          if (isLargeText) {
            height = 400;
          } else {
            height = 370;
          }
        }

        return Column(
          children: [
            SizedBox(
              height: height,
              child: PageView.builder(
                controller: _pageController,
                physics: const AlwaysScrollableScrollPhysics(),
                onPageChanged: (value) {
                  setState(() {
                    _pageIndex = value;
                  });
                },
                itemCount: first.length,
                itemBuilder: (context, index) {
                  ContractDto contract1 = first.elementAt(index);
                  ContractDto? contract2;

                  if (index < second.length) {
                    contract2 = second.elementAt(index);
                  }

                  return Column(
                    children: [
                      GestureDetector(
                        onLongPress: () {
                          ref
                              .read(contractListProvider.notifier)
                              .toggleState(contract1);
                        },
                        onTap: () {
                          // TODO: add if condition: only if Rooms arent selected
                          if (hasSelectedItems > 0) {
                            ref
                                .read(contractListProvider.notifier)
                                .toggleState(contract1);
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DetailsContract(contract: contract1)),
                            );
                          }
                        },
                        child: ContractCard(
                          contractDto: contract1,
                        ),
                      ),
                      if (contract2 != null)
                        GestureDetector(
                          onLongPress: () {
                            ref
                                .read(contractListProvider.notifier)
                                .toggleState(contract2!);
                          },
                          onTap: () {
                            // TODO: add if condition: only if Rooms arent selected
                            if (hasSelectedItems > 0) {
                              ref
                                  .read(contractListProvider.notifier)
                                  .toggleState(contract2!);
                            } else {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DetailsContract(contract: contract2!)),
                              );
                            }
                          },
                          child: ContractCard(contractDto: contract2),
                        ),
                    ],
                  );
                },
              ),
            ),
            AnimatedSmoothIndicator(
              activeIndex: _pageIndex,
              count: first.length,
              effect: WormEffect(
                activeDotColor: Theme.of(context).primaryColor,
                dotHeight: 10,
                dotWidth: 10,
              ),
            ),
          ],
        );
      },
      error: (error, stackTrace) => throw error,
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
