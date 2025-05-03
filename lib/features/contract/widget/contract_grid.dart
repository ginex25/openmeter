import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/core/theme/model/theme_model.dart';
import 'package:openmeter/core/theme/provider/theme_mode_provider.dart';
import 'package:openmeter/features/contract/model/contract_dto.dart';
import 'package:openmeter/features/contract/provider/contract_list_provider.dart';
import 'package:openmeter/features/contract/provider/search_contract_provider.dart';
import 'package:openmeter/features/contract/provider/selected_contract_count.dart';
import 'package:openmeter/features/contract/view/details_contract.dart';
import 'package:openmeter/features/room/provider/selected_room_count_provider.dart';
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

  Widget _contractGrid(List<ContractDto> first, List<ContractDto> second, String emptyText) {
    if (first.isEmpty) {
      return Center(
        child: Text(
          emptyText,
          style: Theme.of(context).textTheme.labelMedium,
          textAlign: TextAlign.center,
        ),
      );
    }

    final int hasSelectedItems = ref.watch(selectedContractCountProvider);
    final int roomSelectedCount = ref.watch(selectedRoomCountProvider);

    double height = 180;

    final ThemeModel theme = ref.watch(themeModeProviderProvider);

    bool isLargeText = theme.isLargeText;

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
                      if (roomSelectedCount > 0) {
                        return;
                      }

                      ref.read(contractListProvider.notifier).toggleState(contract1);
                    },
                    onTap: () {
                      if (roomSelectedCount > 0) {
                        return;
                      }

                      if (hasSelectedItems > 0) {
                        ref.read(contractListProvider.notifier).toggleState(contract1);
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            return DetailsContractView(
                              contractId: contract1.id!,
                            );
                          }),
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
                        if (roomSelectedCount > 0) {
                          return;
                        }

                        ref.read(contractListProvider.notifier).toggleState(contract2!);
                      },
                      onTap: () {
                        if (roomSelectedCount > 0) {
                          return;
                        }

                        if (hasSelectedItems > 0) {
                          ref.read(contractListProvider.notifier).toggleState(contract2!);
                        } else {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) {
                              return DetailsContractView(contractId: contract2!.id!);
                            }),
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
  }

  @override
  Widget build(BuildContext context) {
    final (List<ContractDto>, List<ContractDto>)? searchContract = ref.watch(searchContractProvider);

    if (searchContract != null) {
      return _contractGrid(searchContract.$1, searchContract.$2, 'Es wurden keine Verträge gefunden.');
    }

    final contractsProvider = ref.watch(contractListProvider);

    return contractsProvider.when(
      data: (data) {
        if (_pageController.positions.isNotEmpty) {
          int currentPage = _pageController.page! > 0.5 ? 1 : 0;

          if (_pageIndex != currentPage && _pageController.page! < 1.0) {
            _pageIndex = 0;
          }
        }

        final List<ContractDto> first = data?.$1 ?? [];
        final List<ContractDto> second = data?.$2 ?? [];

        return _contractGrid(first, second, 'Es wurden noch keine Verträge erstellt. \n Drücke jetzt auf das Plus um ein Vertrag zu erstellen.');
      },
      error: (error, stackTrace) => throw error,
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
