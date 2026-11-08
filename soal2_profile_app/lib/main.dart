import 'package:flutter/material.dart';

// Notifier global untuk mengubah tema secara dinamis (Point 6)
final ValueNotifier<ThemeMode> themeModeNotifier =
    ValueNotifier(ThemeMode.light);

void main() {
  runApp(const MyApp());
}

// Model data profil agar mudah diperbarui (Point 3)
class UserProfile {
  String name;
  String nim;
  String prodi;
  String email;
  String phone;
  String github;

  UserProfile({
    required this.name,
    required this.nim,
    required this.prodi,
    required this.email,
    required this.phone,
    required this.github,
  });

  UserProfile copyWith({
    String? name,
    String? nim,
    String? prodi,
    String? email,
    String? phone,
    String? github,
  }) {
    return UserProfile(
      name: name ?? this.name,
      nim: nim ?? this.nim,
      prodi: prodi ?? this.prodi,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      github: github ?? this.github,
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp(
          title: 'Profil Zacky',
          debugShowCheckedModeBanner: false,
          // Tema Terang Kustom (Point 6)
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.teal,
              brightness: Brightness.light,
            ),
            cardTheme: CardTheme(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          // Tema Gelap Kustom (Point 6)
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.teal,
              brightness: Brightness.dark,
            ),
            cardTheme: CardTheme(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          themeMode: currentMode,
          home: const LoginPage(),
        );
      },
    );
  }
}

// ==========================================
// 1. HALAMAN LOGIN
// ==========================================
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login berhasil! Selamat datang.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainHomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.lock_person_rounded,
                    size: 80,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Selamat Datang',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Silakan masuk ke aplikasi profil',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username / NIM',
                      hintText: 'Masukkan username atau NIM',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Username / NIM wajib diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Masukkan kata sandi',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Password wajib diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _handleLogin,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Masuk',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 2. MAIN HOME SCREEN (Scaffold Lengkap)
// Drawer, BottomNavigationBar, FloatingActionButton (Point 5)
// ==========================================
class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;

  // Data profil mahasiswa
  UserProfile _userProfile = UserProfile(
    name: 'Zacky Zalfa Fahrur Rozy',
    nim: '1124160218',
    prodi: 'Teknik Informatika',
    email: 'zackyzalfa6@gmail.com',
    phone: '081234567890',
    github: 'https://github.com/inizayzay',
  );

  // Navigasi ke Halaman Edit Profil (Point 3)
  Future<void> _navigateToEditProfile() async {
    final updatedData = await Navigator.push<UserProfile>(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(currentProfile: _userProfile),
      ),
    );

    if (updatedData != null) {
      setState(() {
        _userProfile = updatedData;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil berhasil diperbarui!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final pages = [
      ProfileView(profile: _userProfile),
      const AboutMeView(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_currentIndex == 0 ? 'Profil Mahasiswa' : 'Tentang Saya'),
        actions: [
          // Switch cepat Mode Gelap / Terang di AppBar (Point 6)
          IconButton(
            tooltip: isDarkMode ? 'Beralih ke Mode Terang' : 'Beralih ke Mode Gelap',
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              themeModeNotifier.value =
                  isDarkMode ? ThemeMode.light : ThemeMode.dark;
            },
          ),
        ],
      ),
      // 1. DRAWER (Point 5)
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                child: Text(
                  'ZZ',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              accountName: Text(_userProfile.name),
              accountEmail: Text(_userProfile.email),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profil'),
              selected: _currentIndex == 0,
              onTap: () {
                setState(() => _currentIndex = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Tentang Saya'),
              selected: _currentIndex == 1,
              onTap: () {
                setState(() => _currentIndex = 1);
                Navigator.pop(context);
              },
            ),
            const Divider(),
            // Switch Mode Gelap di Drawer (Point 6)
            SwitchListTile(
              title: const Text('Mode Gelap'),
              subtitle: const Text('Ubah tema aplikasi'),
              secondary: Icon(
                isDarkMode ? Icons.dark_mode : Icons.light_mode,
              ),
              value: isDarkMode,
              onChanged: (bool value) {
                themeModeNotifier.value =
                    value ? ThemeMode.dark : ThemeMode.light;
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Keluar', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: pages[_currentIndex],
      // 2. FLOATING ACTION BUTTON (Point 5)
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton.extended(
              onPressed: _navigateToEditProfile,
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profil'),
            )
          : null,
      // 3. BOTTOM NAVIGATION BAR (Point 5)
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
          NavigationDestination(
            icon: Icon(Icons.info_outline),
            selectedIcon: Icon(Icons.info),
            label: 'Tentang Saya',
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 3. TAMPILAN PROFIL & KONTAK (Point 2)
// ==========================================
class ProfileView extends StatelessWidget {
  final UserProfile profile;

  const ProfileView({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: double.infinity),
            // Kepala Profil
            CircleAvatar(
              radius: 52,
              backgroundColor: colorScheme.primaryContainer,
              child: Text(
                'ZZ',
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              profile.name,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'NIM: ${profile.nim}',
              style: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              profile.prodi,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.secondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Bagian Kontak dengan Card + ListTile (Point 2)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Informasi Kontak',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.email_outlined, color: colorScheme.primary),
                    title: const Text('Email'),
                    subtitle: Text(profile.email),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.phone_outlined, color: colorScheme.primary),
                    title: const Text('Nomor HP'),
                    subtitle: Text(profile.phone),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.code_outlined, color: colorScheme.primary),
                    title: const Text('Akun GitHub'),
                    subtitle: Text(profile.github),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80), // Memberi ruang untuk FAB
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 4. HALAMAN EDIT PROFIL (Point 3)
// ==========================================
class EditProfilePage extends StatefulWidget {
  final UserProfile currentProfile;

  const EditProfilePage({super.key, required this.currentProfile});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _prodiController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _githubController;

  @override
  void initState() {
    super.initState();
    // Nilai awal dari data saat ini (Point 3)
    _nameController = TextEditingController(text: widget.currentProfile.name);
    _prodiController = TextEditingController(text: widget.currentProfile.prodi);
    _emailController = TextEditingController(text: widget.currentProfile.email);
    _phoneController = TextEditingController(text: widget.currentProfile.phone);
    _githubController =
        TextEditingController(text: widget.currentProfile.github);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _prodiController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _githubController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final updatedProfile = widget.currentProfile.copyWith(
        name: _nameController.text.trim(),
        prodi: _prodiController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        github: _githubController.text.trim(),
      );

      // Navigator.pop kembali dengan data baru (Point 3)
      Navigator.pop(context, updatedProfile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Validasi: Nama wajib diisi (Point 3)
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Lengkap *',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _prodiController,
                  decoration: const InputDecoration(
                    labelText: 'Program Studi',
                    prefixIcon: Icon(Icons.school),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Validasi: Email valid (Point 3)
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email *',
                    hintText: 'contoh@domain.com',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email wajib diisi';
                    }
                    final emailRegex = RegExp(
                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                    if (!emailRegex.hasMatch(value.trim())) {
                      return 'Format email tidak valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Validasi: Nomor HP hanya angka 10-13 digit (Point 3)
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Nomor HP *',
                    hintText: 'Contoh: 081234567890',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nomor HP wajib diisi';
                    }
                    final phoneRegex = RegExp(r'^[0-9]{10,13}$');
                    if (!phoneRegex.hasMatch(value.trim())) {
                      return 'Nomor HP harus berupa 10–13 digit angka';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _githubController,
                  decoration: const InputDecoration(
                    labelText: 'Akun GitHub',
                    hintText: 'https://github.com/username',
                    prefixIcon: Icon(Icons.code),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),

                FilledButton.icon(
                  onPressed: _saveProfile,
                  icon: const Icon(Icons.save),
                  label: const Text('Simpan Perubahan'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 5. HALAMAN TENTANG SAYA (Point 4)
// Minimal 3 keahlian/hobi dan riwayat pendidikan (ListView)
// ==========================================
class AboutMeView extends StatelessWidget {
  const AboutMeView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.all(20.0),
      children: [
        // Bagian 1: Keahlian / Hobi (Minimal 3 item)
        Text(
          'Keahlian & Hobi',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: colorScheme.primaryContainer,
                  child: Icon(Icons.phone_android, color: colorScheme.primary),
                ),
                title: const Text('Flutter & Mobile Development'),
                subtitle: const Text(
                    'Mengembangkan aplikasi mobile Android & iOS dengan Flutter.'),
              ),
              const Divider(height: 1),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: colorScheme.secondaryContainer,
                  child:
                      Icon(Icons.code_rounded, color: colorScheme.secondary),
                ),
                title: const Text('Web & Backend Development'),
                subtitle: const Text('REST API, PHP, Laravel, dan MySQL.'),
              ),
              const Divider(height: 1),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: colorScheme.tertiaryContainer,
                  child: Icon(Icons.palette_outlined,
                      color: colorScheme.tertiary),
                ),
                title: const Text('UI/UX Design'),
                subtitle: const Text(
                    'Merancang antarmuka aplikasi yang responsif dan rapi di Figma.'),
              ),
              const Divider(height: 1),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: colorScheme.surfaceVariant,
                  child: const Icon(Icons.sports_esports_outlined),
                ),
                title: const Text('Gaming & Reading Tech Articles'),
                subtitle: const Text(
                    'Mengikuti tren teknologi terkini dan bermain game strategi.'),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Bagian 2: Riwayat Pendidikan
        Text(
          'Riwayat Pendidikan',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: colorScheme.primaryContainer,
                  child: Icon(Icons.school, color: colorScheme.primary),
                ),
                title: const Text('S1 Teknik Informatika'),
                subtitle: const Text('Perguruan Tinggi • 2024 - Sekarang'),
              ),
              const Divider(height: 1),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: colorScheme.secondaryContainer,
                  child: Icon(Icons.history_edu, color: colorScheme.secondary),
                ),
                title: const Text('SMA / SMK'),
                subtitle: const Text('Jurusan IPA / Rekayasa Perangkat Lunak • 2021 - 2024'),
              ),
              const Divider(height: 1),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: colorScheme.tertiaryContainer,
                  child: Icon(Icons.menu_book, color: colorScheme.tertiary),
                ),
                title: const Text('Sekolah Menengah Pertama (SMP)'),
                subtitle: const Text('2018 - 2021'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
