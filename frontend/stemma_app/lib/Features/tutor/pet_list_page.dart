import 'package:flutter/material.dart';
import 'package:stemma_app/core/constants/app_colors.dart';
import 'package:stemma_app/core/widgets/primary_button.dart';
import 'package:stemma_app/Features/Pet/cadastrar_pet_page.dart';
import 'package:stemma_app/Core/Widgets/BarraInferiorPet.dart';

class PetListPage extends StatefulWidget {
  const PetListPage({super.key});

  @override
  State<PetListPage> createState() => _PetListPageState();
}

class _PetListPageState extends State<PetListPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _pets = []; 

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        title: const Text(
          'Pets',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryGreen,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                print('Buscando por: $value');
              },
              decoration: InputDecoration(
                hintText: 'Pesquisar pet pelo nome',
                hintStyle: const TextStyle(color: AppColors.textGrey),
                prefixIcon: const Icon(Icons.search, color: AppColors.primaryGreen),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: _pets.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhum pet encontrado.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textGrey,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    itemCount: _pets.length,
                    itemBuilder: (context, index) {
                      return const Card(
                        color: Colors.white,
                        elevation: 0,
                        margin: EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          title: Text('Nome do Pet'),
                          subtitle: Text('Tutor'),
                        ),
                      );
                    },
                  ),
          ),

          Padding(
            padding: const EdgeInsets.all(24.0),
            child: PrimaryButton(
              text: '+ Adicionar pet',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CadastrarPetPage(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BarraInferiorPet(abaAtiva: 0),
    );
  }
}