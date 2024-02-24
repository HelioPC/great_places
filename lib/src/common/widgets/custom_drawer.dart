import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:great_places/src/features/auth/data/firebase_auth_repository.dart';

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authProvider = ref.watch(authRepositoryProvider);
    final user = authProvider.currentUser;
    final profileImage = user?.profileImage != null
        ? NetworkImage(user!.profileImage!)
        : const AssetImage('assets/images/profileImage.jpeg');

    return Drawer(
      child: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            SizedBox(
              height: 250,
              child: user == null
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : UserAccountsDrawerHeader(
                      margin: const EdgeInsets.all(0),
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/images/drawer_bg.jpeg'),
                        ),
                      ),
                      currentAccountPictureSize: const Size.square(90),
                      currentAccountPicture: CircleAvatar(
                        backgroundImage: profileImage as ImageProvider,
                      ),
                      accountName: Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      accountEmail: Text(
                        user.email,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                onTap: () async {
                  await ref.read(authRepositoryProvider).signOut();
                },
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
