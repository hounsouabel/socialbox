import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
        title: Text("Amis", style: TextStyle(color: isDarkMode ? Colors.black : Colors.white),),
      ),
      body: Column(
        children: [
          // Appbar search
          Container(
            padding: const EdgeInsets.fromLTRB(
              16.0,
              0,
              16.0,
              16.0,
            ),
            color: Colors.pink,
            child: Form(
              child: TextFormField(
                autofocus: true,
                textInputAction: TextInputAction.search,
                onChanged: (value) {
                  // search logic
                },
                style: TextStyle(color: Colors.black), // Forcer la couleur du texte à noir
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  prefixIcon: Icon(
                    Icons.search,
                    color: const Color(0xFF1D1D35).withOpacity(0.64),
                  ),
                  hintText: "Rechercher",
                  hintStyle: TextStyle(
                    color: const Color(0xFF1D1D35).withOpacity(0.64),
                  ),
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0 * 1.5,
                      vertical: 16.0
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                ),
              ),
            ),
          ),
          const Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                children: [
                  RecentSearchContacts(),
                  SizedBox(height: 16.0),
                  // you can show suggested style for search result
                  SuggestedContacts()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SuggestedContacts extends StatelessWidget {
  const SuggestedContacts({super.key});

  @override
  Widget build(BuildContext context) {
    final titleSmall = Theme.of(context).textTheme.titleSmall;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "Suggested",
            style: titleSmall?.copyWith(
              color: titleSmall?.color?.withOpacity(0.32),
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        ...List.generate(
          demoContactsImage.length,
              (index) => ListTile(
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0 / 2
            ),
            leading: CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage(demoContactsImage[index]),
            ),
            title: const Text("Jenny Wilson"),
            onTap: () {},
          ),
        ),
      ],
    );
  }
}

class RecentSearchContacts extends StatelessWidget {
  const RecentSearchContacts({super.key});

  @override
  Widget build(BuildContext context) {
    final titleSmall = Theme.of(context).textTheme.titleSmall;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recherche récente",
            style: titleSmall?.copyWith(
              color: titleSmall?.color?.withOpacity(0.32),
            ),
          ),
          const SizedBox(height: 16.0),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: Stack(
              children: [
                ...List.generate(
                  demoContactsImage.length + 1,
                      (index) => Positioned(
                    left: index * 48,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 4,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: index < demoContactsImage.length
                          ? CircleAvatar(
                        radius: 26,
                        backgroundImage: AssetImage(demoContactsImage[index]),
                      )
                          : const RoundedCounter(total: 35),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RoundedCounter extends StatelessWidget {
  final int total;

  const RoundedCounter({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    final titleMedium = Theme.of(context).textTheme.titleMedium;
    return Container(
      height: 52,
      width: 52,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF2E2F45)
            : const Color(0xFFEBFAF3),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          "$total+",
          style: titleMedium,
        ),
      ),
    );
  }
}

final List<String> demoContactsImage = [
  'assets/story2.jpg',
  'assets/story10.jpg',
  'assets/story4.jpg',
  'assets/story8.jpg',
  'assets/story9.jpg',
];