import 'package:cripto_exchange/models/coin.dart';
import 'package:cripto_exchange/pages/coin_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../repository/coinRepository.dart';
import '../repository/favorites_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final table = CoinRepository.table;
  List<Coin> selectedCoin = [];
  //FavoritesRepository favoritesRepository = FavoritesRepository();

  dynamicAppBar() {
    if (selectedCoin.isNotEmpty) {
      return AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              setState(() {
                selectedCoin = [];
              });
            }),
        title: Text('Moedas selecioandas: ${selectedCoin.length}'),
      );
    } else {
      return AppBar(title: const Text("Home Page"));
    }
  }

  Widget build(BuildContext context) {
    FavoritesRepository favoritesRepository = Provider.of<FavoritesRepository>(context);
    
    return Scaffold(
        appBar: dynamicAppBar(),
        body: ListView.separated(
            itemBuilder: (BuildContext content, int index) {
              return ListTile(
                title: Row(children: [
                  Text(table[index].name),
                  if (favoritesRepository.favoritesCoinList
                      .contains(table[index]))
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                    )
                ]),
                leading: IconButton(
                    icon: selectedCoin.contains(table[index])
                        ? const CircleAvatar(child: Icon(Icons.check))
                        : SizedBox(
                            child: Image.asset(table[index].image),
                          ),
                    onPressed: () {
                      setState(() {
                        if (selectedCoin.contains(table[index])) {
                          selectedCoin.remove(table[index]);
                        } else {
                          selectedCoin.add(table[index]);
                        }
                      });
                    }),
                trailing: Text(table[index].value),
                selected: selectedCoin.contains(table[index]),
                onTap: () {
                  Navigator.pushNamed(context, "/coinDetails",
                      arguments: CoinDetailsParams(
                          coin: table[index],
                          name: table[index].name,
                          value: table[index].value,
                          image: table[index].image
                        ));
                },
              );
            },
            separatorBuilder: (_, __) => const Divider(),
            itemCount: table.length),
        floatingActionButton: Container(
          margin: const EdgeInsets.only(bottom: 40),
          child: selectedCoin.isNotEmpty
              ? ElevatedButton.icon(
                  icon: const Icon(Icons.star),
                  label: const Text("Favorite"),
                  onPressed: () {
                    favoritesRepository.addFavoriteCoin(selectedCoin);
                    setState(() {
                      selectedCoin = [];
                    });
                  },
                )
              : null,
        ));
  }
}
