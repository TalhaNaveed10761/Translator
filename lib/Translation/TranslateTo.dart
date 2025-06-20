import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_26/Ads/ReusableNativeAd.dart';
import 'package:flutter_application_26/Interstitialad.dart';
import 'package:get/get.dart';

class TranslateTo extends StatefulWidget {
  const TranslateTo({super.key});

  @override
  State<TranslateTo> createState() => _TranslateToState();
}

class _TranslateToState extends State<TranslateTo> {
  TextEditingController searchController = TextEditingController();
  final InterstitialAdController adController =
      Get.put(InterstitialAdController());
  List<dynamic> countries = [];
  bool isSearching = false;

  String? selectedLanguage;
  String? selectedFlag;
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    fetchCountries();
  }

  Future<void> fetchCountries() async {
    try {
      final response = await _dio.get('https://restcountries.com/v3.1/all');

      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;

        for (var country in data) {
          if (country['name']?['common'] == 'Pakistan') {
            country['languages'] = {'urd': 'Urdu'};
          } else if (country['name']?['common'] == 'India') {
            country['languages'] = {'hin': 'Hindi'};
          }
        }

        setState(() {
          countries = List<Map<String, dynamic>>.from(data)
              .where((country) =>
                  country['languages'] != null &&
                  !country['languages'].containsValue('Chinese') &&
                  !country['languages'].containsValue('Spanish') &&
                  !country['languages'].containsValue('Afrikaans') &&
                  !country['languages'].containsValue('Greek') &&
                  !country['languages'].containsValue('Indonesian') &&
                  !country['languages'].containsValue('Portuguese') &&
                  !country['languages'].containsValue('Macedonian') &&
                  !country['languages'].containsValue('Turkish') &&
                  !country['languages'].containsValue('Dutch') &&
                  !country['languages'].containsValue('Croatian') &&
                  !country['languages'].containsValue('German') &&
                  !country['languages'].containsValue('Georgian') &&
                  !country['languages'].containsValue('Montenegrin') &&
                  !country['languages'].containsValue('Bulgarian') &&
                  !country['languages'].containsValue('Greenlandic') &&
                  !country['languages'].containsValue('Khmer') &&
                  !country['languages'].containsValue('Icelandic') &&
                  !country['languages'].containsValue('Czech') &&
                  !country['languages'].containsValue('Bislama') &&
                  !country['languages'].containsValue('Mongolian') &&
                  !country['languages'].containsValue('Chibarwe') &&
                  !country['languages'].containsValue('Malay') &&
                  !country['languages'].containsValue('Polish') &&
                  !country['languages'].containsValue('Dzongkha') &&
                  !country['languages'].containsValue('Burmese') &&
                  !country['languages'].containsValue('Serbian') &&
                  !country['languages'].containsValue('Albanian') &&
                  !country['languages'].containsValue('Persian (Farsi)') &&
                  !country['languages'].containsValue('Maldivian') &&
                  !country['languages'].containsValue('Seychellois Creole') &&
                  !country['languages'].containsValue('Lithuanian') &&
                  !country['languages'].containsValue('Norwegian Nynorsk'))
              .toList();
        });
      } else {
        print(
            'Failed to load countries with status code: ${response.statusCode}');
        throw Exception('Failed to load countries');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print('Dio error: ${e.response?.statusCode} - ${e.response?.data}');
      } else {
        print('Dio error: ${e.message}');
      }
    } catch (e) {
      print('Error fetching countries: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        title: isSearching
            ? TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.black, fontSize: 16),
                onChanged: (value) {
                  setState(() {});
                },
              )
            : const Text(
                "TranslateTo",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4F4F4F),
                ),
              ),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              adController.onButtonClick();
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  searchController.clear();
                }
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Selected Language",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4F4F4F),
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Container(
              height: height * 0.07,
              width: width * 0.9,
              decoration: BoxDecoration(
                color: const Color(0xFF5AA587),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: selectedLanguage == null
                  ? const Text(
                      "",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          if (selectedFlag != null)
                            Image.network(
                              selectedFlag!,
                              height: height * 0.03,
                              width: width * 0.06,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.flag, color: Colors.white),
                            ),
                          const SizedBox(width: 10),
                          Text(
                            selectedLanguage!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            SizedBox(
              height: height * 0.05,
            ),
            const Text(
              "All Languages",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4F4F4F),
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            countries.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ListView(
                      children: List.generate(countries.length + 1, (index) {
                        int adjustedIndex = index > 8 ? index - 1 : index;
                        var country = countries[adjustedIndex];

                        String flag = country['flags']?['png'] ?? '';
                        String language = country['languages'] != null
                            ? country['languages'].values.first
                            : 'Unknown';

                        if (isSearching &&
                            !language.toLowerCase().contains(
                                searchController.text.toLowerCase())) {
                          return Container();
                        }

                        return GestureDetector(
                          onTap: () {
                            adController.onButtonClick();
                            setState(() {
                              selectedLanguage = language;
                              selectedFlag = flag;
                            });
                            Navigator.pop(
                                context, {'language': language, 'flag': flag});
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Container(
                              height: height * 0.07,
                              width: width * 0.9,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
                                border:
                                    Border.all(color: const Color(0xFFD5D5D5)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: height * 0.03,
                                      width: width * 0.06,
                                      child: Image.network(
                                        flag,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(Icons.flag),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width * 0.02,
                                    ),
                                    Text(
                                      language,
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
            ReusableNativeAd(
            //  adUnitId: 'ca-app-pub-3940256099942544/2247696110',
              height: height * 0.15,
              width: width * 0.9,
            ),
          ],
        ),
      ),
    );
  }
}
