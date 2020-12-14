import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import Firebase
import FirebaseAuth

class MainActivity: FlutterActivity() {
    private val ID_CHANNEL = "com.example.four_2_ten/id"
    private lateinit var auth: FirebaseAuth
    private lateinit var id: String

    public override fun onCreate() {
        super.onCreate()
        auth = Firebase.auth
    }

    public override fun onStart() {
        super.onStart()
        // Check if user is signed in (non-null) and update UI accordingly.
        val currentUser = auth.currentUser
        updateUI(currentUser)
        auth.signInAnonymously()
                .addOnCompleteListener(this) { task ->
                    if (task.isSuccessful) {
                        // Sign in success, update UI with the signed-in user's information
                        Log.d(TAG, "signInAnonymously:success")
                        val user = auth.currentUser
                        id = user.uid
                    } else {
                        // If sign in fails, display a message to the user.
                        Log.w(TAG, "signInAnonymously:failure", task.exception)
                    }
                }
    }
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, UID_CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "getId") {
                result.success(getId())
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getId(): String {
        return id
    }
}
