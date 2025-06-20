import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 

class WordOfTheDay extends StatefulWidget {
  @override
  _WordOfTheDayState createState() => _WordOfTheDayState();
}

class _WordOfTheDayState extends State<WordOfTheDay> {
  late String formattedDate;
  late String wordOfTheDay;
  late String language;
  late String description;

List<Map<String, String>> words = [
  {
    'word': 'Serendipity',
    'language': 'English',
    'description': 'Lucky event or discovery'
  },
  {
    'word': 'Ephemeral',
    'language': 'English',
    'description': 'Lasting only a moment'
  },
  {
    'word': 'Quixotic',
    'language': 'English',
    'description': 'Idealistic and impractical pursuit'
  },
  {
    'word': 'Lethargy',
    'language': 'English',
    'description': 'Lack of energy or motivation'
  },
  {
    'word': 'Euphoria',
    'language': 'English',
    'description': 'Intense and overwhelming joy'
  },
  {
    'word': 'Renaissance',
    'language': 'French',
    'description': 'Revival of art and culture'
  },
  {
    'word': 'Equanimity',
    'language': 'Latin',
    'description': 'Mental composure under stress'
  },
  {
    'word': 'Ubiquitous',
    'language': 'English',
    'description': 'Appears or exists everywhere'
  },
  {
    'word': 'Melancholy',
    'language': 'English',
    'description': 'Deep, lasting sadness or sorrow'
  },
  {
    'word': 'Cacophony',
    'language': 'Greek',
    'description': 'Loud, discordant mixture of sounds'
  },
  {
    'word': 'Panacea',
    'language': 'Greek',
    'description': 'Universal remedy for problems'
  },
  {
    'word': 'Benevolent',
    'language': 'English',
    'description': 'Well-meaning and kind-hearted'
  },
  {
    'word': 'Perplexed',
    'language': 'English',
    'description': 'Completely puzzled or bewildered'
  },
  {
    'word': 'Sycophant',
    'language': 'Greek',
    'description': 'Excessively flattering for advantage'
  },
  {
    'word': 'Eloquent',
    'language': 'Latin',
    'description': 'Expresses oneself fluently and persuasively'
  },
  {
    'word': 'Resilient',
    'language': 'English',
    'description': 'Quickly recovering from adversity'
  },
  {
    'word': 'Plethora',
    'language': 'Greek',
    'description': 'Excess of something available'
  },
  {
    'word': 'Aesthetic',
    'language': 'Greek',
    'description': 'Concerned with artistic beauty'
  },
  {
    'word': 'Altruism',
    'language': 'Latin',
    'description': 'Concern for others well-being'
  },
  {
    'word': 'Nocturnal',
    'language': 'Latin',
    'description': 'Active or awake during night'
  },
  {
    'word': 'Camaraderie',
    'language': 'French',
    'description': 'Mutual trust and friendship'
  }
];


  @override
  void initState() {
    super.initState();
    formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    _setWordOfTheDay(); 
  }

 
  void _setWordOfTheDay() {
    final todayIndex = DateTime.now().day % words.length;
    wordOfTheDay = words[todayIndex]['word']!;
    language = words[todayIndex]['language']!;
    description = words[todayIndex]['description']!;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Container(
      height: height * 0.18,
      width: width * 0.9,
      decoration: BoxDecoration(
          color: Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFD5D5D5))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: height * 0.04,
            width: width * 0.9,
            decoration: const BoxDecoration(
              color: Color(0xFF5AA587),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(15),
                topLeft: Radius.circular(15),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Word of the Day",
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    formattedDate,
                    style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Row(
              children: [
                Text(
                  "$wordOfTheDay -",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF455A64),
                  ),
                ),
                Text(
                  "$language",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: Color(0xFF455A64),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              description,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF455A64),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
