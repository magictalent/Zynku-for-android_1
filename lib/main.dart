import 'package:flutter/material.dart';
import 'Pages/HomePage.dart' show HomePageWidget;
import 'Pages/AuthPage.dart' show AuthpageWidget;
import 'Pages/LoginPage.dart' show LoginPageWidget;
import 'Pages/SignupPage.dart' show CreateAccount1Widget;
import 'Pages/CreateAccount3.dart' show CreateAccount3Widget;
import 'Pages/SupplierdetailPage.dart' show SupplierdetailPageWidget;
import 'Pages/SupplierAuthPage.dart' as supplier_auth_page;
import 'Pages/VoicehelpPage.dart' show VoicepageWidget;
import 'Pages/VoiceBuilderPage.dart' show VoiceBuilderPageWidget;
import 'Pages/CategoryLoginPage.dart' show CategoryLoginPageWidget;
import 'Pages/CategorySignupPage.dart' show CategorySignupPageWidget;
import 'Pages/ListeningPage.dart' show ListeningPageWidget;
import 'Pages/SeekbuilderPage.dart' show SeekbuilderpageWidget;
import 'Pages/NewRequestJob.dart' show NewjobrequirePageWidget;
import 'Pages/PaymentPage.dart' show PaymentPageWidget;
import 'Pages/ConfirmBookingPage.dart' show ConfirmBookingWidget;
import 'Pages/PlumbingPage.dart' show PlumbingPageWidget;
import 'Pages/AcceptJobPage.dart' show SuccessfulPageWidget;
import 'Pages/BookingHistory.dart' show ReviewPageWidget;
import 'Pages/PreviousPage.dart' show FinalPageWidget;
import 'Pages/AvailbilityPage.dart' show AvailablilityPageWidget;
import 'Pages/BookingPage.dart' show BookingPageWidget;
import 'Pages/ChatsPage.dart' show ChatsPage;
import 'Pages/ProfilePage.dart' show UserdetailsWidget;
//
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VD App',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData) {
            // User is signed in, go to home page
            return HomePageWidget();
          }
          // User is not signed in, go to login page
          return LoginPageWidget();
        },
      ),
      routes: {
        '/': (context) => HomePageWidget(),
        '/auth': (context) => AuthpageWidget(),
        '/login': (context) => LoginPageWidget(),
        '/signup': (context) => CreateAccount1Widget(),
        '/customer': (context) => CreateAccount3Widget(),
        '/supplier': (context) => SupplierdetailPageWidget(),
        '/supplier-auth': (context) =>
            supplier_auth_page.SupplierAuthPageWidget(),
        '/voice-help': (context) => VoicepageWidget(),
        '/voice-builder': (context) => VoiceBuilderPageWidget(),
        '/category-login': (context) => CategoryLoginPageWidget(),
        '/category-signup': (context) => CategorySignupPageWidget(),
        '/listening': (context) => ListeningPageWidget(),
        '/seek-builder': (context) => SeekbuilderpageWidget(),
        '/new-job': (context) => NewjobrequirePageWidget(),
        '/payment': (context) => PaymentPageWidget(),
        '/confirm-booking': (context) => ConfirmBookingWidget(),
        '/plumbing': (context) => PlumbingPageWidget(),
        '/accept-job': (context) => SuccessfulPageWidget(),
        '/booking-history': (context) => ReviewPageWidget(),
        '/previous': (context) => FinalPageWidget(),
        '/availability': (context) => AvailablilityPageWidget(),
        '/chats': (context) => ChatsPage(),
        '/profile': (context) => UserdetailsWidget(),
        '/booking': (context) {
          final args =
              ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>?;
          return BookingPageWidget(customerData: args);
        },
      },
    );
  }
}

class SimpleHomePage extends StatelessWidget {
  const SimpleHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            child: Container(
              width: double.infinity,
              height: 321.12,
              decoration: const BoxDecoration(color: Colors.grey),
              child: const Center(
                child: Icon(Icons.image, size: 100, color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(75, 0, 0, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: const [
                Align(
                  alignment: AlignmentDirectional(0, -1),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                    child: Text(
                      'Hey Zynku!',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(15, 15, 0, 0),
                child: Text(
                  'One Voice, One Community.',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: SizedBox(
                  width: 300,
                  height: 60,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/auth');
                    },
                    icon: const Icon(Icons.room, size: 20),
                    label: const Text('Use my live location'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0048FB),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: SizedBox(
                  width: 300,
                  height: 60,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Button pressed
                    },
                    icon: const Icon(Icons.sticky_note_2_outlined, size: 20),
                    label: const Text('Enter address manually'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.black,
                      side: const BorderSide(color: Colors.black),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: const [
                  Align(
                    alignment: AlignmentDirectional(-1, -1),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(40, 30, 0, 0),
                      child: Text(
                        'We use your location to connect you with',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(-1, -1),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
                      child: Text(
                        'nearby services. By continuing you',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(-1, 1),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
                      child: Text(
                        'agree to our terms & privacy',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
